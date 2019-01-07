local Scene = require('scenes.scene')

---@class TestScene : Scene
local TestScene = Scene:new()

function TestScene:load()
    if self.isLoaded then
        return
    end
    self.isLoaded = true

    local img = love.graphics.newImage('particle.jpg')
    --psystem = love.graphics.newParticleSystem(img, 256)
    --psystem:setParticleLifetime(2, 5)
    --psystem:setEmissionArea('normal', 20, 5, 2.30)
    --psystem:setEmissionRate(50)
    --psystem:setSizeVariation(0)
    --psystem:setSpeed(100, 100)
    --psystem:setDirection(4.18879)
    --psystem:setSizes(0.5, 0.3, 0.1)
    --psystem:setLinearAcceleration(-100, -100, -80, -80) -- Random movement in all directions.
    --psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

    img = love.graphics.newImage('resources/particle.jpg')
    self.psystem = love.graphics.newParticleSystem(img, 8224)
    self.psystem:setParticleLifetime(2, 5)
    self.psystem:setEmissionArea('normal', 20, 5, 2.30)
    self.psystem:setEmissionRate(1000)
    self.psystem:setSizeVariation(0)
    self.psystem:setSpeed(300, 300)
    self.psystem:setDirection(4.18879)
    self.psystem:setSizes(0.5, 0.3, 0.1)
    self.psystem:setLinearAcceleration(-100, -100, -80, -80) -- Random movement in all directions.
    self.psystem:setColors(255, 0, 0, 255, 255, 122, 0, 255, 255, 255, 0, 255, 255, 255, 0, 0) -- Fade to transparency.
end

function TestScene:update(dt)
    self.psystem:update(dt)
end

function TestScene:draw()
    love.graphics.draw(self.psystem, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end

return TestScene
