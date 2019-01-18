local Scene = require('scenes.scene')
local Color = require('color')
local Event = require('enum.event')
local Draw = require('drawable.drawable')
local ShipComponentBuilder = require('ship_component_builder')
local PolygonFactory = require('factory.polygon_factory')

---@class BuilderScene : Scene
---@field protected world World
---@field protected draggableObject GameObject[]
local BuilderScene = Scene:new()

---@param hero Ship
---@param prevScene Scene
function BuilderScene:load(prevScene, hero)
    self.hero = hero
    self.draggableObjects = {}
    self.objects = {}
    self.world = love.physics.newWorld(0, 0, true)

    self.hero:unJoin()
    self.hero:clearVisual()
    self.objects[#self.objects + 1] = self.hero
    App.camera:setCoords(self.hero:getPosition())
    table.merge(self.draggableObjects, self.hero:getObjects())

    self:draggableEvent()

    self.events:addAction(Event.KEY, function()
        local engine = ShipComponentBuilder:buildEngine(hero:getWorld(), prevScene, Draw:calcRealX(100), Draw:calcRealY(100), Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
        self.hero:addEngine(engine)
        table.insert(self.draggableObjects, engine)
    end, 'space')

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'f')
end

---@protected
function BuilderScene:draggableEvent()
    local uniqName = string.random(10)

    --[[
        TODO при mouse move нужна проверка.
        Если объект находится рядом с границей hero, то он "прилипает к границе"
        Если внутри или далеко от hero, тогда его края становятся красными (шейдеры либо просто края)
    --]]
    self.events:addAction(Event.MOUSE,
        function(params)
            ---@param go PhysicalDrawObject
            for _, go in ipairs(self.draggableObjects) do
                if go.fixture:getShape():testPoint(
                    Draw.calcX(go.fixture:getBody():getX()),
                    Draw.calcY(go.fixture:getBody():getY()),
                    0, params.x, params.y
                ) then
                    self.events:addAction(Event.MOUSE_MOVE, function(moveParams) go:setPosition(Draw:calcRealX(moveParams.x), Draw:calcRealY(moveParams.y)) end, nil, uniqName)
                    self.events:addAction(Event.WHEEL, function(wheelParams) go:forceRotate(wheelParams.y * 0.1) end, nil, uniqName)
                end
            end
        end, 1
    )
    self.events:addAction(Event.MOUSE_RELEASE,
        function(params)
            self.events:removeAction(Event.MOUSE_MOVE, nil, uniqName)
            self.events:removeAction(Event.WHEEL, nil, uniqName)
        end, 1
    )
end

function BuilderScene:sleep()
    self.hero:reJoin()
end

function BuilderScene:update(dt)
    self.world:update(dt)
end

return BuilderScene
