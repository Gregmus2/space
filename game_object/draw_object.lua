local GameObject = require('game_object.game_object')

---@class DrawObject : GameObject
---@field protected drawable Draw
---@field protected angle number
---@field protected speed number
---@field protected rotateSpeed number
local DrawObject = GameObject:new()

---@param drawable Draw
---@param x number
---@param y number
function DrawObject:new(drawable, x, y)
    local newObj = {
        x = x,
        y = y,
        angle = 0,
        speed = 5000,
        rotateSpeed = 5,
        drawable = drawable
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function DrawObject:rotate(dt, direction)
    self.angle = self.angle + self.rotateSpeed * dt * direction
    self.drawable.angle = self.angle
end

function DrawObject:draw(x, y)
    self.drawable:draw(x, y)
end

return DrawObject