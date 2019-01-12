local Scene = require('scenes.scene')
local Color = require('color')
local Event = require('enum.event')
local Draw = require('drawable.drawable')
local ShipComponentBuilder = require('ship_component_builder')
local PolygonFactory = require('factory.polygon_factory')
local EventFactory = require('factory.event_factory')

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
    self.objects[#self.objects + 1] = self.hero
    App.camera:setCoords(self.hero:getPosition())
    table.merge(self.draggableObject, self.hero:getObjects())

    EventFactory.draggableEvent(self.events, self.draggableObject)

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
