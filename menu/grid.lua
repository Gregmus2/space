local Rectangle = require('drawable.rectangle')
local Color = require('color')
local MenuObject = require('menu.menu')

---@class Grid : MenuObject
---@field protected x number
---@field protected y number
---@field protected w number
---@field protected h number
---@field protected color Color
---@field protected collection Collection
---@field protected grid GameObject[][]
---@field protected columns number
---@field protected columnHeight number
---@field protected columnWidth number
---@field protected collectionLength number
local Grid = MenuObject:new()

---@param x number
---@param y number
---@param w number
---@param h number
---@param color Color
---@param columns number
function Grid:new(x, y, w, h, columns, columnHeight, color)
    local newObj = {
        x = x - w / 2,
        y = y - h / 2,
        w = w,
        h = h,
        columns = columns,
        columnHeight = columnHeight,
        color = color or Color:white(),
        grid = {},
        collectionLength = 0,
        columnWidth = w / columns
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function Grid:recalculateGrid()
    self.grid = self.collection:chunk(self.columns)
    self.collectionLength = self.collection:getCount()
end

---@param collection Collection
function Grid:setCollection(collection)
    self.collection = collection
    self:recalculateGrid()
end

function Grid:draw()
    if self.collectionLength ~= self.collection:getCount() then
        self:recalculateGrid()
    end

    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)

    local x2 = self.x + self.w
    -- todo сжимать объект, чтобы вмещался в ячейку
    for i, row in ipairs(self.grid) do
        local y = self.y + self.columnHeight * i
        love.graphics.line(self.x, y, x2, y)

        for j, element in ipairs(row) do
            element:setPosition(self.x + self.columnWidth * (j - 0.5), y - self.columnHeight / 2)
        end
    end

    local x = self.x + self.w / 2
    local y = #self.grid * self.columnHeight
    love.graphics.line(x, self.y, x, self.y + (y < self.h and y or self.h))
end

return Grid