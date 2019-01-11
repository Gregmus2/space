local Scene = require('scenes.scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local Event = require('enum.event')
local Draw = require('drawable.drawable')
local ShipComponentBuilder = require('ship_component_builder')
local PolygonFactory = require('factory.polygon_factory')

---@class BuilderScene : Scene
---@field protected world World
---@field protected draggableObject PhysicalDrawObject[]
local BuilderScene = Scene:new()

---@param hero Ship
---@param prevScene Scene
function BuilderScene:load(prevScene, hero)
    self.hero = hero
    self.draggableObject = {}
    self.objects = {}
    self.world = love.physics.newWorld(0, 0, true)

    self.hero:unJoin()
    self.hero:clearVisual()
    App.camera:setCoords(self.hero:getPosition())

    local draggable = GameObjectBuilder
        :new(Draw:calcRealX(0), Draw:calcRealY(0))
        :addRectangleDraw('fill', Color:white(), 100, 100)
        :addRectanglePhysics(self.world, 100, 100, 'dynamic')
        :createGameObject()
    table.insert(self.objects, draggable)
    table.insert(self.draggableObject, draggable)

    self.objects[#self.objects + 1] = self.hero
    local engines = self.hero:getObjects()
    for _, engine in ipairs(engines) do
        self.draggableObject[#self.draggableObject + 1] = engine
    end

    self.events:addAction(Event.MOUSE,
        function(params)
            for _, go in ipairs(self.draggableObject) do
                if go.physics:getShape():testPoint(
                    Draw.calcX(go.physics:getBody():getX()),
                    Draw.calcY(go.physics:getBody():getY()),
                    0, params.x, params.y
                ) then
                    self.events:addAction(Event.MOUSE_MOVE, function(moveParams) go:setPosition(Draw:calcRealX(moveParams.x), Draw:calcRealY(moveParams.y)) end, nil, 'drag')
                    self.events:addAction(Event.WHEEL, function(wheelParams) go:forceRotate(wheelParams.y * 0.1) end, nil, 'drag')
                end
            end
        end, 1
    )
    self.events:addAction(Event.MOUSE_RELEASE,
        function(params)
            self.events:removeAction(Event.MOUSE_MOVE, nil, 'drag')
            self.events:removeAction(Event.WHEEL, nil, 'drag')
        end, 1
    )

    self.events:addAction(Event.KEY, function()
        local engine = ShipComponentBuilder:buildEngine(hero:getWorld(), prevScene, Draw:calcRealX(100), Draw:calcRealY(100), Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
        self.hero:addEngine(engine)
        table.insert(self.draggableObject, engine)
    end, 'space')

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'f')
end

function BuilderScene:sleep()
    self.hero:reJoin()
end

function BuilderScene:update(dt)
    self.world:update(dt)
end

return BuilderScene
