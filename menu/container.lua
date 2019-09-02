local Color = require('color')
local Point = require('model.point')
local Collection = require('collection.collection')

---@class Container : MenuObject
---@field protected point Point
---@field protected area Area
---@field protected color Color
---@field protected collection Collection
---@field protected columnHeight number
local Container = {}

---@param point Point
---@param area Area
---@param color Color
---@param columnHeight number
function Container:new(point, area, color, columnHeight)
    local newObj = {
        point = point,
        area = area,
        color = color or Color:white(),
        collection = Collection:new({}),
        columnHeight = columnHeight
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param element GameObject
function Container:add(element)
    self.collection:add(element)
    self:recalculateElements()
end

---@param element GameObject
function Container:remove(element)
    self.collection:remove(element)
    self:recalculateElements()
end

---@protected
function Container:recalculateElements()
    local yOffset = self.point.y - self.area.h / 2
    for i, element in pairs(self.collection.elements) do
        local position = Point:new(self.point.x, yOffset + self.columnHeight * (i - 0.5))
        element:setPosition(position)
    end
end

function Container:draw()
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, 0.4)
    love.graphics.rectangle(
        'line',
        self.point.x - self.area.w / 2,
        self.point.y - self.area.h / 2,
        self.area.w,
        self.area.h
    )

    for _, element in ipairs(self.collection.elements) do
        element:draw()
    end
end

return Container