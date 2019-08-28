local Scene = require('scenes.scene')
local BuilderScene = require('scenes.builder_scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local PolygonFactory = require('factory.polygon_factory')
local ShipComponentBuilder = require('ship_component_builder')
local Event = require('enum.event')
local Ship = require('ship_components.ship')
local Polygon = require('drawable.polygon')
local BulletEmitter = require('bullet_emitter')
local BulletsConfigModel = require('model.bullets_config_model')
local Params = require('params')
local Point = require('model.point')

---@class SpaceScene : Scene
---@field protected hero Ship
---@field protected cameraState table<string, any>
local SpaceScene = Scene:new()

SpaceScene.isLoaded = false

function SpaceScene:load(prevScene)
    if self.isLoaded then
        self:awake()

        return
    end

    self.isLoaded = true
    self:createWorld()
    self:createMenu()

    for _ = 0, 15 do
        local color = Color:new(love.math.random(), love.math.random(), love.math.random())
        local vertexes = PolygonFactory.generateRandomConvex(15, 30, 500)
        local polygon = Polygon:new('fill', color, vertexes)

        local go = GameObjectBuilder:new(
            Point:new(
                love.math.random(0, 5000),
                love.math.random(0, 5000)
            )
        )
            :addPolygonPhysics(self.world, vertexes, 'dynamic', 0.1)
            :createGameObject()
            :addDraw(polygon)
        self:addVisible(go)
    end

    local center = App.camera.point:clone()
    local core = ShipComponentBuilder:buildCore(self.world, center, Color:white(), PolygonFactory.generateRectangle(50, 50), 0.1, 1000)
    local engine = ShipComponentBuilder:buildEngine(self.world, self, center:clone(0, -35), Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
    local engine2 = ShipComponentBuilder:buildEngine(self.world, self, center:clone(0, 35), Color:red(), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
    local bulletEmitter = BulletEmitter:new(5, BulletsConfigModel:new(5, Color:white(), 50))
    local reactor = ShipComponentBuilder:buildReactor(self.world, center:clone(-40), Color:blue(), PolygonFactory.generateRectangle(30, 30), 0.1, 10, 1)
    local weapon = ShipComponentBuilder:buildWeapon(self.world, self, center:clone(50), Color:blue(), PolygonFactory.generateRocket(10, 30, 5), 0.1, bulletEmitter)
    self.hero = Ship:new(core, {engine, engine2}, {weapon, reactor}, self.events)
    self:addUpdatable(self.hero)
    self:addVisible(self.hero)


    self.events:longUpdate(Event.KEY, Event.KEY_RELEASE, function(params) self.hero:rotate(params.dt, 1) end, 'd')
    self.events:longUpdate(Event.KEY, Event.KEY_RELEASE, function(params) self.hero:move(params.dt, 1) end, 'w')
    self.events:longUpdate(Event.KEY, Event.KEY_RELEASE, function(params) self.hero:rotate(params.dt, -1) end, 'a')
    self.events:longUpdate(Event.KEY, Event.KEY_RELEASE, function(params) self.hero:move(params.dt, -1) end, 's')

    self.events:addAction(Event.WHEEL, function(params) App.camera:addScale(params.y * 0.1) end)

    self.events:addAction(Event.KEY, function() App.changeScene(Params.default.scene) end, 'escape', 'menu')
    self.events:addAction(Event.KEY, function() App.changeSceneWithParam(BuilderScene, self.hero) end, 'f')
end

function SpaceScene:sleep()
    self.cameraState = App.camera:getState()
end

function SpaceScene:awake()
    App.camera:setState(self.cameraState)
end

---@param dt number
function SpaceScene:update(dt)
    self:updateElements(dt)
    App.camera:setCoords(self.hero:getPosition())
end

return SpaceScene
