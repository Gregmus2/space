local PhysicalDrawObject = require('game_object.physical_draw_object')
local Params = require('params')
local Draw = require('drawable.drawable')

---@class Engine : PhysicalDrawObject
---@field public drawable Draw
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
---@field protected particle ParticleSystem
---@field protected joint Joint
local Engine = PhysicalDrawObject:new()

---@param drawable Draw
---@param physics Fixture
---@param speed number
function Engine:new(drawable, physics, speed, particle)
    local newObj = {
        drawable = drawable,
        physics = physics,
        speed = speed,
        particle = particle
    }
    physics:getBody():setFixedRotation(false)

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
    self.physics:getBody():applyForce(math.cos(self.physics:getBody():getAngle()) * dSpeed, math.sin(self.physics:getBody():getAngle()) * dSpeed)

    self.particle:setDirection(self.physics:getBody():getAngle() - 3.14159)
    self.particle:moveTo(self:getPosition())
end

function Engine:draw()
    love.graphics.draw(self.particle, Draw.calcX(0), Draw.calcY(0), 0, App.camera.scale, App.camera.scale)

    local x, y = self:getPosition()
    local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(x, y, self.physics:getBody():getAngle())
    end
end

function Engine:resetParticles()
    self.particle:reset()
end

return Engine