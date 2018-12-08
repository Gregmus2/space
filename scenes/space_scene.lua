local Scene = require('scenes.scene')
local Color = require('color')
local GameObjectFactory = require('factory.game_object_factory')
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
        local go = GameObjectFactory.generateRectangle(
            self.world,
            love.math.random(0, 5000),
            love.math.random(0, 5000),
            'fill',
            color,
            love.math.random(5, 150),
            love.math.random(5, 150),
            'dynamic',
            1
        )
        self.objects[#self.objects + 1] = go
    end

    local go2 = GameObjectFactory.generateCircle(
            self.world,
            0,
            0,
            'fill',
            Color:blue(),
            50,
            'static',
            1
    )
    self.objects[#self.objects + 1] = go2

    self.hero = GameObjectFactory.generatePolygon(
            self.world,
            self.camera.x,
            self.camera.y,
            'fill',
            Color:blue(),
            PolygonFactory.generateShip(50),
            'dynamic',
            0.1
    )
    self.objects[#self.objects + 1] = self.hero

    self.events['key']['d'] = Action:new(function(dt) self.hero:rotate(dt, 1) end, true)
    self.events['key']['w'] = Action:new(function(dt) self.hero:move(dt, 1) end, true)
    self.events['key']['a'] = Action:new(function(dt) self.hero:rotate(dt, -1) end, true)
    self.events['key']['s'] = Action:new(function(dt) self.hero:move(dt, -1) end, true)
end

---@param dt number
function SpaceScene:update(dt)
    self.world:update(dt)
    self.camera:setCoords(self.hero.physics:getBody():getPosition())
end

return SpaceScene
