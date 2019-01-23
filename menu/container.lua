local Color = require('color')

---@class Container : MenuObject
---@field protected x number
---@field protected y number
---@field protected w number
---@field protected h number
---@field protected color Color
---@field protected objects MenuObject[]
local Container = {}

---@param x number
---@param y number
---@param w number
---@param h number
---@param color Color
function Container:new(x, y, w, h, color)
    local newObj = {
        x = x,
        y = y,
        w = w,
        h = h,
        color = color or Color:white(),
        objects = {}
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param object MenuObject
function Container:addObject(object)
    self.objects[#self.objects + 1] = object
end

function Container:draw()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 0.4)
    love.graphics.rectangle(
        'fill',
        self.x - self.w / 2,
        self.y - self.h / 2,
        self.w,
        self.h
    )

    for _, object in ipairs(self.objects) do
        object:draw()
    end
end

return Container