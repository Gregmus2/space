local Scene = require('scenes.scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local PolygonFactory = require('factory.polygon_factory')
local Action = require('action')

---@class SpaceScene : Scene
---@field protected hero GameObject
local SpaceScene = Scene:new()

SpaceScene.isLoaded = false

---@param camera Camera
function SpaceScene:load(camera)
    if self.isLoaded then
        return
    end

    self.isLoaded = true
    self.camera = camera
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
        :new(self.camera.x, self.camera.y)
        :addPolygonDraw('fill', Color:blue(), shipVertexes)
        :addPolygonPhysics(self.world, shipVertexes, 'dynamic', 0.1)
        :createGameObject()
    self.drawableObjects[#self.drawableObjects + 1] = self.hero

    self.events['key']['d'] = Action:new(function(dt) self.hero:rotate(dt, 1) end, true)
    self.events['key']['w'] = Action:new(function(dt) self.hero:move(dt, 1) end, true)
    self.events['key']['a'] = Action:new(function(dt) self.hero:rotate(dt, -1) end, true)
    self.events['key']['s'] = Action:new(function(dt) self.hero:move(dt, -1) end, true)
end

---@param dt number
function SpaceScene:update(dt)
    self.world:update(dt)
    self.camera:setCoords(self.hero:getPosition())
end

return SpaceScene
