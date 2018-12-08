local Draw = require('drawable.drawable')

---@class Polygon : Draw
---@field public vertexes table
local Polygon = Draw:new()

---@param mode string
---@param color Color
---@param vertexes table
---@return Polygon
function Polygon:new(mode, color, vertexes)
    newObj = {
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

---@param camera Camera
---@param x number
---@param y number
function Polygon:draw(camera, x, y)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)

    local realXCenter = self.calcX(camera, x)
    local realYCenter = self.calcY(camera, y)
    self:rotate(realXCenter, realYCenter)

    love.graphics.polygon(self.mode, self:calcRealVertexes(camera, x, y))
end

---@param camera Camera
---@param x number
---@param y number
---@return table
function Polygon:calcRealVertexes(camera, x, y)
    local realVertexes = {}
    for i = 1, self.countOfVertexes, 2 do realVertexes[i] = self.calcX(camera, x + self.vertexes[i]) end
    for i = 2, self.countOfVertexes, 2 do realVertexes[i] = self.calcY(camera, y + self.vertexes[i]) end

    return realVertexes
end

return Polygon