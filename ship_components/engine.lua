local GameObject = require('game_object.game_object')
local Params = require('params')
local Draw = require('drawable.drawable')

---@class Engine : GameObject
---@field public drawable Draw
---@field public fixture Fixture
---@field protected speed number
---@field protected particle ParticleSystem
local Engine = GameObject:new()

---@param drawable Draw
---@param fixture Fixture
---@param speed number
function Engine:new(drawable, fixture, speed, particle)
    local newObj = {
        drawable = drawable,
        fixture = fixture,
        speed = speed,
        particle = particle
    }
    fixture:getBody():setFixedRotation(false)

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function Engine:rotate(dt, direction) end

---@param dt number
---@param direction number
function Engine:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.fixture:getBody():applyForce(math.cos(self.fixture:getBody():getAngle()) * dSpeed, math.sin(self.fixture:getBody():getAngle()) * dSpeed)

    self.particle:setDirection(self.fixture:getBody():getAngle() - 3.14159)
    self.particle:moveTo(self:getPosition())
end

function Engine:draw()
    love.graphics.draw(self.particle, Draw.calcX(0), Draw.calcY(0), 0, App.camera.scale, App.camera.scale)

    local x, y = self:getPosition()
    local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(x, y, self.fixture:getBody():getAngle())
    end
end

function Engine:resetParticles()
    self.particle:reset()
end

return Engine