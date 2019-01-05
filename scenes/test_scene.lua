local Scene = require('scenes.scene')
local GameObjectBuilder = require('game_object_builder')
local Color = require('color')
local ComplicatedObject = require('game_object.complicated_object')

---@class TestScene : Scene
local TestScene = Scene:new()

function TestScene:load()
    if self.isLoaded then
        return
    end
    self.isLoaded = true

    self.world = love.physics.newWorld(0, 0, true)

    local color = Color:new(love.math.random(), love.math.random(), love.math.random())
    local gos = {
        GameObjectBuilder:new(100, 100)
                         :addRectangleDraw('fill', color, 50, 50)
                         :addRectanglePhysics(self.world, 50, 50, 'dynamic', 1)
                         :createGameObject(),
        GameObjectBuilder:new(151, 100)
                         :addRectangleDraw('fill', color, 50, 50)
                         :addRectanglePhysics(self.world, 50, 50, 'dynamic', 1)
                         :createGameObject()
        }
    local gob = ComplicatedObject:new(gos)
    self.drawableObjects[#self.drawableObjects + 1] = gob
end

---@param dt number
function TestScene:update(dt)
    self.world:update(dt)
end

return TestScene
