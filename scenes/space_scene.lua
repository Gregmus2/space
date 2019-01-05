local Scene = require('scenes.scene')
local PauseScene = require('scenes.pause_scene')
local BuilderScene = require('scenes.builder_scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local PolygonFactory = require('factory.polygon_factory')
local Action = require('action')
local Event = require('enum.event')
local Params = require('params')
local Button = require('menu.button')

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
        self.drawableObjects[#self.drawableObjects + 1] = go
    end

    local shipVertexes = PolygonFactory.generateShip(50)
    self.hero = GameObjectBuilder
        :new(App.camera.x, App.camera.y)
        :addPolygonDraw('fill', Color:blue(), shipVertexes)
        :addPolygonPhysics(self.world, shipVertexes, 'dynamic', 0.1)
        :createGameObject()
    self.drawableObjects[#self.drawableObjects + 1] = self.hero

    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:rotate(dt, 1) end, true), 'd')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:move(dt, 1) end, true), 'w')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:rotate(dt, -1) end, true), 'a')
    self.events:addEvent(Event.KEY, Action:new(function(dt) self.hero:move(dt, -1) end, true), 's')

    self.events:addEvent(Event.WHEEL, Action:new(function(x, y) App.camera:addScale(y * 0.1) end))

    self.events:addEvent(Event.KEY, Action:new(function() App.changeSceneWithParam(PauseScene, self) end), 'space')
    self.events:addEvent(Event.KEY, Action:new(function() App.changeScene(BuilderScene) end), 'f')

    self.menu:addButton(Button:new(100, 100, 200, 50, function() print(123) end))
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

---@param go GameObject
function SpaceScene:draw(go)
    local x, y = go:getPosition()
    local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - go.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        go:draw(x, y)
    end
end

return SpaceScene
