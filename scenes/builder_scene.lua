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

    self.hero:unJoin()
    self.hero:clearVisual()
    self:addVisible(self.hero)
    App.camera:setCoords(self.hero:getPosition())
    table.merge(self.draggableObjects, self.hero:getObjects())

    self.TRIGGER_DRAG_NAME = 'dragging_builder';
    self:draggableEvent();

    self.grid = Grid:new(App.camera.x / 2 * 3, App.camera.y, App.camera.x / 2.0, App.camera.y / 1.4, 2, 100)
    self.templatesCollection = Collection:new({})
    self.grid:setCollection(self.templatesCollection)
    self.menu:addElement(self.grid)

    self.events:addAction(Event.KEY, function()
        local engine = ShipComponentBuilder:buildEngine(hero:getWorld(), prevScene, Draw:calcRealX(100), Draw:calcRealY(100), Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
        self.hero:addEngine(engine)
        table.insert(self.draggableObjects, engine)
    end, 'e')
    self.events:addAction(Event.KEY, function()
        local bulletEmitter = BulletEmitter:new(5, BulletsConfigModel:new(5, Color:white(), 50))
        local weapon = ShipComponentBuilder:buildWeapon(hero:getWorld(), prevScene, Draw:calcRealX(100), Draw:calcRealY(100), Color:red(), PolygonFactory.generateRectangle(30, 10), 0.1, bulletEmitter)
        self.hero:addComponent(weapon)
        table.insert(self.draggableObjects, weapon)
    end, 'w')

    -- add templates for building parts of ship
    local d, f = ShipComponentBuilder.build(self.world, 100, 100, Color:red(), PolygonFactory.generateRocket(20, 40, 10))
    local go = GameObject:new(f):addDraw(d)
    self:addTemplate(go, function()
        local engine = ShipComponentBuilder:buildEngine(hero:getWorld(), prevScene, self.grid.x + Draw.calcX(go.fixture:getBody():getX()), self.grid.y + Draw.calcY(go.fixture:getBody():getY()), Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
        self.hero:addEngine(engine)

        return engine
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
                    self.events:addAction(Event.MOUSE_MOVE, function(moveParams) go:setPosition(Draw:calcRealX(moveParams.x), Draw:calcRealY(moveParams.y)) end, nil, self.TRIGGER_DRAG_NAME)
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
                        self.grid.x + Draw.calcX(template.fixture:getBody():getX()),
                        self.grid.y + Draw.calcY(template.fixture:getBody():getY()),
                        0, params.x, params.y
                ) then
                    local object = buildFunction()
                    table.insert(self.draggableObjects, object)

                    self.events:addAction(Event.MOUSE_MOVE, function(moveParams) object:setPosition(Draw:calcRealX(moveParams.x), Draw:calcRealY(moveParams.y)) end, nil, self.TRIGGER_DRAG_NAME)
                    self.events:addAction(Event.WHEEL, function(wheelParams) object:forceRotate(wheelParams.y * 0.1) end, nil, self.TRIGGER_DRAG_NAME)
                end
            end, 1
    )
end

function BuilderScene:sleep()
    self.hero:reJoin()
    self:reset();
end

return BuilderScene
