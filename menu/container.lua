local Color = require('color')

---@class Container : MenuObject
---@field protected x number
---@field protected y number
---@field protected w number
---@field protected h number
---@field protected color Color
---@field protected objects MenuObject[]
local Container = {}

---@param point Point
---@param area Area
---@param color Color
function Container:new(point, area, color)
    local newObj = {
        point = point,
        area = area,
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
        self.point.x - self.area.w / 2,
        self.point.y - self.area.h / 2,
        self.area.w,
        self.area.h
    )

    for _, object in ipairs(self.objects) do
        object:draw()
    end
end

return Container