local Scene = require('scenes.scene')
local Color = require('color')
local Event = require('enum.event')
local Draw = require('drawable.drawable')
local ShipComponentBuilder = require('ship_component_builder')
local PolygonFactory = require('factory.polygon_factory')
local BulletEmitter = require('bullet_emitter')
local BulletsConfigModel = require('model.bullets_config_model')
local Collection = require('collection.collection')
local Grid = require('menu.grid')
local GameObject = require('game_object.game_object')
local Point = require('model.point')
local Area = require('model.area')

---@class BuilderScene : Scene
---@field protected world World
---@field protected draggableObject GameObject[]
local BuilderScene = Scene:new()

---@param hero Ship
---@param prevScene Scene
function BuilderScene:load(prevScene, hero)
    self.hero = hero
    self.draggableObjects = {}
    self:createWorld()
    self:createMenu()

    self.state = {}
    self.state.heroPoint = self.hero:getPosition()
    self.state.cameraState = App.camera:getState()

    App.camera:setCoords(Point:new(wpixels(5) * App.camera.scale, hpixels(5) * App.camera.scale))
    self.hero:setPosition(Point:new(wpixels(5) * App.camera.scale, hpixels(5) * App.camera.scale))

    self.hero:unJoin()
    self.hero:clearVisual()
    self:addVisible(self.hero)
    table.merge(self.draggableObjects, self.hero:getObjects())

    self.TRIGGER_DRAG_NAME = 'dragging_builder';
    self:draggableEvent();

    self.grid = Grid:new(Point:new(wpixels(7), hpixels(2)), Area:new(wpixels(2), hpixels(6)), 2, hpixels(0.5))
    self.templatesCollection = Collection:new({})
    self.grid:setCollection(self.templatesCollection)
    self.menu:addElement(self.grid)

    local mainPoint = Point:new(100, 100)

    -- add templates for building parts of ship
    local d, f = ShipComponentBuilder.build(self.world, mainPoint, Color:red(), PolygonFactory.generateRocket(20, 40, 10))
    f:getBody():setFixedRotation(true)
    local go = GameObject:new(f):addDraw(d)
    self:addTemplate(go, function()
        local engine = ShipComponentBuilder:buildEngine(hero:getWorld(), prevScene, Point:new(self.grid.point.x + Draw.calcX(go.fixture:getBody():getX()), self.grid.point.y + Draw.calcY(go.fixture:getBody():getY())), Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
        self.hero:addEngine(engine)

        return engine
    end)
    d, f = ShipComponentBuilder.build(self.world, mainPoint, Color:red(), PolygonFactory.generateRectangle(30, 10))
    f:getBody():setFixedRotation(true)
    go = GameObject:new(f):addDraw(d)
    self:addTemplate(go, function()
        local bulletEmitter = BulletEmitter:new(5, BulletsConfigModel:new(5, Color:white(), 50))
        local weapon = ShipComponentBuilder:buildWeapon(hero:getWorld(), prevScene, Point:new(self.grid.point.x + Draw.calcX(go.fixture:getBody():getX()), self.grid.point.y + Draw.calcY(go.fixture:getBody():getY())), Color:red(), PolygonFactory.generateRectangle(30, 10), 0.1, bulletEmitter)
        self.hero:addComponent(weapon)

        return weapon
    end)
    d, f = ShipComponentBuilder.build(self.world, mainPoint, Color:blue(), PolygonFactory.generateRectangle(25, 25))
    f:getBody():setFixedRotation(true)
    go = GameObject:new(f):addDraw(d)
    self:addTemplate(go, function()
        local reactor = ShipComponentBuilder:buildReactor(hero:getWorld(), Point:new(self.grid.point.x + Draw.calcX(go.fixture:getBody():getX()), self.grid.point.y + Draw.calcY(go.fixture:getBody():getY())), Color:blue(), PolygonFactory.generateRectangle(25, 25), 0.5, 10, 1)
        self.hero:addComponent(reactor)

        return reactor
    end)

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'f')
end

---@protected
function BuilderScene:draggableEvent()
    --[[
        TODO при mouse move нужна проверка.
        Если объект находится рядом с границей hero, то он "прилипает к границе"
        Если внутри или далеко от hero, тогда его края становятся красными (шейдеры либо просто края)
    --]]
    self.events:addAction(Event.MOUSE,
        function(params)
            ---@param go GameObject
            for _, go in ipairs(self.draggableObjects) do
                if go.fixture:getShape():testPoint(
                    Draw.calcX(go.fixture:getBody():getX()),
                    Draw.calcY(go.fixture:getBody():getY()),
                    0, params.x, params.y
                ) then
                    self.events:addAction(Event.MOUSE_MOVE, function(moveParams) go:setPosition(Point:new(Draw:calcRealX(moveParams.x), Draw:calcRealY(moveParams.y))) end, nil, self.TRIGGER_DRAG_NAME)
                    self.events:addAction(Event.WHEEL, function(wheelParams) go:forceRotate(wheelParams.y * 0.1) end, nil, self.TRIGGER_DRAG_NAME)
                end
            end
        end, 1
    )
    self.events:addAction(Event.MOUSE_RELEASE,
        function(params)
            self.events:removeAction(Event.MOUSE_MOVE, nil, self.TRIGGER_DRAG_NAME)
            self.events:removeAction(Event.WHEEL, nil, self.TRIGGER_DRAG_NAME)
        end, 1
    )
end

function BuilderScene:addTemplate(template, buildFunction)
    self.templatesCollection:add(template)
    self.events:addAction(Event.MOUSE,
            function(params)
                if template.fixture:getShape():testPoint(
                        Draw.calcX(template.fixture:getBody():getX()),
                        Draw.calcY(template.fixture:getBody():getY()),
                        0, params.x, params.y
                ) then
                    local object = buildFunction()
                    table.insert(self.draggableObjects, object)

                    self.events:addAction(Event.MOUSE_MOVE, function(moveParams) object:setPosition(Point:new(Draw:calcRealX(moveParams.x), Draw:calcRealY(moveParams.y))) end, nil, self.TRIGGER_DRAG_NAME)
                    self.events:addAction(Event.WHEEL, function(wheelParams) object:forceRotate(wheelParams.y * 0.1) end, nil, self.TRIGGER_DRAG_NAME)
                end
            end, 1
    )
end

function BuilderScene:sleep()
    self.hero:reJoin()
    self:reset();

    self.hero:setPosition(self.state.heroPoint)
    App.camera:setState(self.state.cameraState)
end

return BuilderScene
