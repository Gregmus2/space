local GameObject = require('game_object.game_object')

---@class DrawObject : GameObject
---@field protected draw Draw
---@field protected angle number
---@field protected speed number
---@field protected rotateSpeed number
local DrawObject = GameObject:new()

---@param draw Draw
---@param x number
---@param y number
function DrawObject:new(draw, x, y)
    local newObj = {
        x = x,
        y = y,
        angle = 0,
        speed = 5000,
        rotateSpeed = 5,
        draw = draw
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function DrawObject:rotate(dt, direction)
    self.angle = self.angle + self.rotateSpeed * dt * direction
    self.draw.angle = self.angle
end

return DrawObject