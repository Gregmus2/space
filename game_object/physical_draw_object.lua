local GameObject = require('game_object.game_object')

---@class PhysicalDrawObject : GameObject
---@field public drawable Draw
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
---@field protected angle number
local PhysicalDrawObject = GameObject:new()

---@param drawable Draw
---@param physics Fixture
function PhysicalDrawObject:new(drawable, physics)
    newObj = {
        drawable = drawable,
        physics = physics,
        speed = 5000,
        rotateSpeed = 5,
        angle = 0
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function PhysicalDrawObject:rotate(dt, direction)
    self.angle = self.angle + self.rotateSpeed * dt * direction
    self.drawable.angle = self.angle
    self.physics:getBody():setAngle(self.angle)
end

---@param dt number
---@param direction number
function PhysicalDrawObject:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.physics:getBody():applyForce(math.cos(self.angle) * dSpeed, math.sin(self.angle) * dSpeed)
end

---@return number, number @ x, y
function PhysicalDrawObject:getPosition()
    return self.physics:getBody():getPosition()
end

---@param x number
---@param y number
function PhysicalDrawObject:setPosition(x, y)
    return self.physics:getBody():setPosition(x, y)
end

function PhysicalDrawObject:draw(x, y)
    self.drawable:draw(x, y)
end

return PhysicalDrawObject