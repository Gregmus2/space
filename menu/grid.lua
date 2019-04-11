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
---@field protected canvas Canvas
local Grid = {}

---@param x number
---@param y number
---@param w number
---@param h number
---@param color Color
---@param columns number
function Grid:new(x, y, w, h, columns, columnHeight, color)
    x, y, w, h = math.ceil(x), math.ceil(y), math.ceil(w), math.ceil(h)

    local newObj = {
        x = x,
        y = y,
        w = w,
        h = h,
        columns = columns,
        columnHeight = columnHeight,
        color = color or Color:white(),
        grid = {},
        collectionLength = 0,
        columnWidth = w / columns,
        offset = 0,
        scroll = Scroll:new(0, 10),
        canvas = love.graphics.newCanvas(w, h)
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function Grid:update()
    local isCollectionChanged = self.collectionLength ~= self.collection:getCount()
    local isScrollChanged = self.scroll:getCurrent() ~= self.offset
    if not isCollectionChanged and not isScrollChanged then
        return
    end

    if isCollectionChanged then
        self:recreateScroll()
    end

    self.offset = self.scroll:getCurrent()
    self:recalculateGrid()
    self:renderCanvas()
end

---@private
function Grid:recreateScroll()
    self.collectionLength = self.collection:getCount()
    local diff = (self.collection:getCount() / 2) * self.columnHeight - self.h
    self.scroll = Scroll:new(diff, 10)
end

---@private
function Grid:recalculateGrid()
    local firstValue = math.floor(self.offset / self.columnHeight)
    local endValue = math.ceil(self.h / self.columnHeight) + firstValue + 1
    self.grid = self.collection:chunk(self.columns, (firstValue * 2) + 1, endValue * 2)
end

---@param collection Collection
function Grid:setCollection(collection)
    self.collection = collection
    self:recalculateGrid()
    self:renderCanvas()
end

---@private
function Grid:renderCanvas()
    love.graphics.setCanvas(self.canvas) -- set canvas layout
    love.graphics.clear() -- clear previous graphics

    local relativeX = 0;
    local relativeY = 0;
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.rectangle('line', relativeX, relativeY, self.w, self.h) -- render frame

    local x2 = relativeX + self.w -- right edge
    -- todo сжимать объект, чтобы вмещался в ячейку
    for i = 1, #self.grid do
        local y = (relativeY - self.offset % self.columnHeight) + self.columnHeight * i
        for j, element in ipairs(self.grid[i]) do
            local elementY = y - self.columnHeight / 2
            element:setPosition(relativeX + self.columnWidth * (j - 0.5), elementY)
            element:draw()
        end
        if i == #self.grid then -- without last element
            break;
        end

        love.graphics.setColor(self.color.r, self.color.g, self.color.b)
        love.graphics.line(relativeX, y, x2, y) -- horizontal line every stage
    end

    local x = relativeX + self.w / 2
    local y = #self.grid * self.columnHeight
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.line(x, relativeY, x, relativeY + (y < self.h and y or self.h)) -- vertical line

    love.graphics.setCanvas() -- set default layout
end

function Grid:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied") -- need to call before canvas rendering
    love.graphics.draw(self.canvas, self.x, self.y)
    love.graphics.setBlendMode("alpha", "alphamultiply") -- reset
end

return Grid