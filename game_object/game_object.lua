---@class GameObject
---@field protected x number
---@field protected y number
local GameObject = {}

---@param x number
---@param y number
function GameObject:new(x, y)
    newObj = {
        x = x,
        y = y
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function GameObject:rotate(dt, direction)
    self.angle = self.angle + self.rotateSpeed * dt * direction
end

---@param dt number
---@param direction number
function GameObject:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.x = self.x + math.cos(self.angle) * dSpeed
    self.y = self.y + math.sin(self.angle) * dSpeed
end

---@return number, number @ x, y
function GameObject:getPosition()
    return self.x, self.y
end

---@param x number
---@param y number
function GameObject:setPosition(x, y)
    self.x, self.y = x, y
end

return GameObject