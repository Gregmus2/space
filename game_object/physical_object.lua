local GameObject = require('game_object.game_object')

---@class PhysicalObject : GameObject
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
---@field protected angle number
local PhysicalObject = GameObject:new()

---@param physics Fixture
function PhysicalObject:new(physics)
    local newObj = {
        angle = 0,
        speed = 5000,
        rotateSpeed = 5,
        physics = physics
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function PhysicalObject:rotate(dt, direction)
    self.angle = self.angle + self.rotateSpeed * dt * direction
    self.physics:getBody():setAngle(self.angle)
end

---@param dt number
---@param direction number
function PhysicalObject:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.physics:getBody():applyForce(math.cos(self.angle) * dSpeed, math.sin(self.angle) * dSpeed)
end

---@return number, number @ x, y
function PhysicalObject:getPosition()
    return self.physics:getBody():getPosition()
end

---@param x number
---@param y number
function PhysicalObject:setPosition(x, y)
    return self.physics:getBody():setPosition(x, y)
end


return PhysicalObject