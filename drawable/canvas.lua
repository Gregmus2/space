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

---@param x number
---@param y number
---@param realX number
---@param realY number
function Canvas:drawShape(x, y, realX, realY)
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.draw(self.canvas, self.point.x or realX, self.point.y or realY)
    love.graphics.setBlendMode("alpha", "alphamultiply")
end

return Canvas