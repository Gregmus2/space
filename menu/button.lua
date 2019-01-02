local Rectangle = require('drawable.rectangle')
local Color = require('color')
local MenuObject = require('menu.menu')

---@class Button : MenuObject
---@field protected x number
---@field protected y number
---@field protected w number
---@field protected h number
---@field protected color Color
---@field public action function
local Button = MenuObject:new()

---@param x number
---@param y number
---@param w number
---@param h number
---@param color Color
---@param action function
function Button:new(x, y, w, h, action, color)
    newObj = {
        x = x,
        y = y,
        w = w,
        h = h,
        color = color or Color:white(),
        action = action
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function Button:draw()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.rectangle(
        'fill',
        self.x - self.w / 2,
        self.y - self.h / 2,
        self.w,
        self.h
    )
end

---@param x number
---@param y number
---@return boolean
function Button:checkPoint(x, y)
    return
        x > self.x - self.w / 2 and
        x < self.x + self.w / 2 and
        y > self.y - self.h / 2 and
        y < self.y + self.h / 2
end

return Button