local Scene = require('scenes.scene')
local PauseScene = require('scenes.pause_scene')
local BuilderScene = require('scenes.builder_scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local PolygonFactory = require('factory.polygon_factory')
local ShipComponentBuilder = require('ship_component_builder')
local Action = require('action')
local Event = require('enum.event')
local Ship = require('ship_components.ship')

---@class SpaceScene : Scene
---@field protected hero GameObject
---@field protected cameraState table<string, any>
local SpaceScene = Scene:new()

SpaceScene.isLoaded = false

function SpaceScene:load()
    if self.isLoaded then
        self:awake()

        return
    end

    self.isLoaded = true
    self.world = love.physics.newWorld(0, 0, true)

    for _ = 0, 100 do
        local color = Color:new(love.math.random(), love.math.random(), love.math.random())
        local w = love.math.random(5, 150)
        local h = love.math.random(5, 150)
        local go = GameObjectBuilder:new(
            love.math.random(0, 5000),
            love.math.random(0, 5000)
        )
            :addRectangleDraw('fill', color, w, h)
            :addRectanglePhysics(self.world, w, h, 'dynamic', 1)
            :createGameObject()
        self.objects[#self.objects + 1] = go
    end

    local core = ShipComponentBuilder:buildCore(self.world, App.camera.x, App.camera.y, Color:white(), PolygonFactory.generateRectangle(50, 50), 0.1, 1000)
    local engine = ShipComponentBuilder:buildEngine(self.world, App.camera.x, App.camera.y - 35, Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
    local engine2 = ShipComponentBuilder:buildEngine(self.world, App.camera.x, App.camera.y + 35, Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
    self.hero = Ship:new(core, {engine, engine2})
    self.objects[#self.objects + 1] = self.hero

    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:rotate(dt, 1) end, true), 'd')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:move(dt, 1) end, true), 'w')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:rotate(dt, -1) end, true), 'a')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:move(dt, -1) end, true), 's')

    self.events:addEvent(Event.WHEEL, Action:new(function(x, y) App.camera:addScale(y * 0.1) end))

    self.events:addEvent(Event.KEY, Action:new(function() App.changeSceneWithParam(PauseScene, self) end), 'space')
    self.events:addEvent(Event.KEY, Action:new(function() App.changeScene(BuilderScene) end), 'f')
end

function SpaceScene:sleep()
    self.cameraState = App.camera:getState()
end

function SpaceScene:awake()
    App.camera:setState(self.cameraState)
end

---@param dt number
function SpaceScene:update(dt)
    self.world:update(dt)
    App.camera:setCoords(self.hero:getPosition())
end

return SpaceScene
