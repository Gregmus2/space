local Draw = require('drawable.drawable')
local Config = require('config')

---@class Canvas : Draw
---@field protected canvas Canvas
---@field protected point Point
---@field protected bodyFunc function
local Canvas = Draw:new()

---@param point Point
---@param area Area
---@param bodyFunc function
---@return Canvas
function Canvas:new(area, bodyFunc, point)
    local newObj = {
        canvas = love.graphics.newCanvas(area.w, area.h, { msaa = Config.msaa }),
        point = point,
        bodyFunc = bodyFunc
    }

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function Canvas:snapshot()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    self.bodyFunc()
    love.graphics.setCanvas()
end

---@param point Point
---@param realPoint Point
function Canvas:drawShape(point, realPoint)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.canvas, self.point.x or realPoint.x, self.point.y or realPoint.y)
    love.graphics.setBlendMode("alpha", "alphamultiply")
end

return Canvas