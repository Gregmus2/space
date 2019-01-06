local Scene = require('scenes.scene')
local GameObjectBuilder = require('game_object_builder')
local ShipComponentBuilder = require('ship_component_builder')
local Core = require('ship_components.core')
local Engine = require('ship_components.engine')
local Ship = require('ship_components.ship')
local Color = require('color')
local Action = require('action')
local Event = require('enum.event')
local PolygonFactory = require('factory.polygon_factory')

---@class TestScene : Scene
local TestScene = Scene:new()

function TestScene:load()
    if self.isLoaded then
        return
    end
    self.isLoaded = true

    self.world = love.physics.newWorld(0, 0, true)

    local core = ShipComponentBuilder:buildCore(self.world, 100, 100, Color:white(), PolygonFactory.generateRectangle(50, 50), 0.1)
    local engine = ShipComponentBuilder:buildEngine(self.world, 100, 65, Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1)
    local engine2 = ShipComponentBuilder:buildEngine(self.world, 100, 135, Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1)
    local gob = Ship:new(core, {engine, engine2})
    self.drawableObjects[#self.drawableObjects + 1] = gob
    self.hero = gob

    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:rotate(dt, 1) end, true), 'd')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:move(dt, 1) end, true), 'w')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:rotate(dt, -1) end, true), 'a')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:move(dt, -1) end, true), 's')
end

---@param dt number
function TestScene:update(dt)
    self.world:update(dt)
end

return TestScene
