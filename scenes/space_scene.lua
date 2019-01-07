local Scene = require('scenes.scene')
local PauseScene = require('scenes.pause_scene')
local BuilderScene = require('scenes.builder_scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local PolygonFactory = require('factory.polygon_factory')
local ShipComponentBuilder = require('ship_component_builder')
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
    local engine = ShipComponentBuilder:buildEngine(self.world, self, App.camera.x, App.camera.y - 35, Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
    local engine2 = ShipComponentBuilder:buildEngine(self.world, self, App.camera.x, App.camera.y + 35, Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
    self.hero = Ship:new(core, {engine, engine2})
    self.objects[#self.objects + 1] = self.hero


    self.events:longUpdate(Event.KEY, Event.KEY_RELEASE, function(params) self.hero:rotate(params.dt, 1) end, 'd')
    self.events:longUpdate(Event.KEY, Event.KEY_RELEASE, function(params) self.hero:move(params.dt, 1) end, 'w')
    self.events:longUpdate(Event.KEY, Event.KEY_RELEASE, function(params) self.hero:rotate(params.dt, -1) end, 'a')
    self.events:longUpdate(Event.KEY, Event.KEY_RELEASE, function(params) self.hero:move(params.dt, -1) end, 's')

    self.events:addAction(Event.WHEEL, function(params) App.camera:addScale(params.y * 0.1) end)

    self.events:addAction(Event.KEY, function() App.changeSceneWithParam(PauseScene, self) end, 'space')
    self.events:addAction(Event.KEY, function() App.changeScene(BuilderScene) end, 'f')
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
    self:updateParticles(dt)
    App.camera:setCoords(self.hero:getPosition())
end

function Scene:draw()
    for _, object in ipairs(self.objects) do
        object:draw()
    end
    self.menu:draw()
    --self:drawParticles()
end

return SpaceScene
