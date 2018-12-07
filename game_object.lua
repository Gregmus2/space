---@class GameObject
---@field public draw Drawable
---@field public physics Fixture
---@field public speed number
---@field public rotateSpeed number
local GameObject = {}

---@param draw Drawable
---@param physics Fixture
function GameObject:new(draw, physics)
    newObj = {
        draw = draw,
        physics = physics,
        speed = 5000,
        rotateSpeed = 5
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function GameObject:rotate(dt, direction)
    self.draw.angle = self.draw.angle + self.rotateSpeed * dt * direction
    self.physics:getBody():setAngle(self.draw.angle)
end

---@param dt number
---@param direction number
function GameObject:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.physics:getBody():applyForce(math.cos(self.draw.angle) * dSpeed, math.sin(self.draw.angle) * dSpeed)
end

return GameObject