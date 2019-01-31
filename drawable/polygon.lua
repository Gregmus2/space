local Draw = require('drawable.drawable')

---@class Polygon : Draw
---@field public vertexes table
local Polygon = Draw:new()

---@param mode string
---@param color Color
---@param vertexes table
---@return Polygon
function Polygon:new(mode, color, vertexes)
    local newObj = {
        visibilityRadius = 0, -- todo
        mode = mode,
        color = color,
        vertexes = vertexes,
        countOfVertexes = #vertexes
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@protected
---@param x number
---@param y number
---@param realX number
---@param realY number
function Polygon:drawShape(x, y, realX, realY)
    love.graphics.polygon(self.mode, self:calcRealVertexes(x, y))
end

---@param x number
---@param y number
---@return table
function Polygon:calcRealVertexes(x, y)
    local realVertexes = {}
    for i = 1, self.countOfVertexes, 2 do realVertexes[i] = self.calcX(x + self.vertexes[i]) end
    for i = 2, self.countOfVertexes, 2 do realVertexes[i] = self.calcY(y + self.vertexes[i]) end

    return realVertexes
end

return Polygon