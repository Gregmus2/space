local Color = require('color')
local Scroll = require('menu.scroll')

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
---@field protected scroll Scroll|nil
---@field protected offset number
local Grid = {}

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
        columnWidth = w / columns,
        offset = 0,
        scroll = Scroll:new(0, 10)
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function Grid:handleScroll()
    self.collectionLength = self.collection:getCount()
    local diff = (self.collection:getCount() / 2) * self.columnHeight - self.h
    self.scroll = Scroll:new(diff, 10)
end

function Grid:recalculateGrid()
    local firstValue = math.floor(self.offset / self.columnHeight)
    local endValue = math.ceil(self.h / self.columnHeight) + firstValue + 1
    self.grid = self.collection:chunk(self.columns, (firstValue * 2) + 1, endValue * 2)
end

---@param collection Collection
function Grid:setCollection(collection)
    self.collection = collection
    self:recalculateGrid()
end

function Grid:draw()
    if self.scroll:getCurrent() ~= self.offset then
        self.offset = self.scroll:getCurrent()
        self:recalculateGrid()
    end
    if self.collectionLength ~= self.collection:getCount() then
        self:handleScroll()
    end

    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)

    local x2 = self.x + self.w
    -- todo сжимать объект, чтобы вмещался в ячейку
    local y2 = self.y + self.h
    for i = 1, #self.grid do
        local y = (self.y - self.offset % self.columnHeight) + self.columnHeight * i
        for j, element in ipairs(self.grid[i]) do
            local elementY = y - self.columnHeight / 2
            if
                elementY - element.drawable.visibilityRadius > self.y and
                elementY + element.drawable.visibilityRadius < y2
            then
                element:setPosition(self.x + self.columnWidth * (j - 0.5), elementY)
                element:draw()
            end
        end
        if i == #self.grid then
            break;
        end

        love.graphics.line(self.x, y, x2, y)
    end

    local x = self.x + self.w / 2
    local y = #self.grid * self.columnHeight
    love.graphics.line(x, self.y, x, self.y + (y < self.h and y or self.h))
end

return Grid