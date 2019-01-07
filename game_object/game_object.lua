---@class GameObject
---@field protected x number
---@field protected y number
local GameObject = {}

---@param x number
---@param y number
function GameObject:new(x, y)
    local newObj = {
        x = x,
        y = y
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function GameObject:rotate(dt, direction) end

---@param dt number
---@param direction number
function GameObject:move(dt, direction) end

---@return number, number @ x, y
function GameObject:getPosition()
    return self.x, self.y
end

---@param x number
---@param y number
function GameObject:setPosition(x, y)
    self.x, self.y = x, y
end

function GameObject:draw(x, y) end

return GameObject