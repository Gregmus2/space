local PhysicalDrawObject = require('game_object.physical_draw_object')

---@class Engine : PhysicalDrawObject
---@field public drawable Draw
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
---@field protected particle ParticleSystem
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

    self.particle:moveTo(self:getPosition())
    self.particle:setDirection(self.physics:getBody():getAngle())
    self.particle:setEmissionArea('normal', 20, 5, 0)
end

return Engine