local Color = require('color')
local Scroll = require('menu.scroll')
local Point = require('model.point')

---@class Grid : MenuObject
---@field protected point Point
---@field protected area Area
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

---@param point Point
---@param area Area
---@param color Color
---@param columns number
function Grid:new(point, area, columns, columnHeight, color)
    point:ceil()
    area:ceil()

    local newObj = {
        point = point,
        area = area,
        columns = columns,
        columnHeight = columnHeight,
        color = color or Color:white(),
        grid = {},
        collectionLength = 0,
        columnWidth = area.w / columns,
        offset = 0,
        scroll = Scroll:new(0, 10),
        canvas = love.graphics.newCanvas(area:get())
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
    local diff = (self.collection:getCount() / 2) * self.columnHeight - self.area.h
    self.scroll = Scroll:new(diff, 10)
end

---@private
function Grid:recalculateGrid()
    local firstValue = math.floor(self.offset / self.columnHeight)
    local endValue = math.ceil(self.area.h / self.columnHeight) + firstValue + 1
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
    love.graphics.rectangle('line', relativeX, relativeY, self.area.w, self.area.h) -- render frame

    local x2 = relativeX + self.area.w -- right edge
    -- todo сжимать объект, чтобы вмещался в ячейку
    for i = 1, #self.grid do
        local y = (relativeY - self.offset % self.columnHeight) + self.columnHeight * i
        for j, element in ipairs(self.grid[i]) do
            local elementY = y - self.columnHeight / 2
            local relative_position = Point:new(relativeX + self.columnWidth * (j - 0.5), elementY)
            element:setPosition(relative_position)
            element:draw()
            -- For internal logic of elements (if elements depends on their position)
            element:setPosition(relative_position:clone(self.point.x, self.point.y))
        end
        if i == #self.grid then -- without last element
            break;
        end

        love.graphics.setColor(self.color.r, self.color.g, self.color.b)
        love.graphics.line(relativeX, y, x2, y) -- horizontal line every stage
    end

    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    for i = 1, self.columns - 1 do
        local x = relativeX + self.columnWidth * i
        local y = #self.grid * self.columnHeight
        love.graphics.line(x, relativeY, x, relativeY + (y < self.area.h and y or self.area.h)) -- vertical line
    end

    love.graphics.setCanvas() -- set default layout
end

function Grid:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied") -- need to call before canvas rendering
    love.graphics.draw(self.canvas, self.point.x, self.point.y)
    love.graphics.setBlendMode("alpha", "alphamultiply") -- reset
end

return Grid