local params = require('params')
local Point = require('model.point')

---@class Draw
---@field public visibilityRadius number
---@field public color Color
---@field public mode string
---@field public shader string
local Draw = {}

function Draw:new()
    local newObj = {}
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param point Point
---@param angle number
function Draw:draw(point, angle)
    love.graphics.push()
    love.graphics.setShader(self.shader)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)

    local realPoint = Point:new(
        self.calcX(point.x),
        self.calcY(point.y)
    )
    self:rotate(realPoint, angle)

    self:drawShape(point, realPoint)
    love.graphics.setShader()
    love.graphics.pop()
end

---@protected
---@param point Point
---@param realPoint Point
function Draw:drawShape(point, realPoint) end

---@param x number
---@return number
function Draw.calcX(x)
    return (x - App.camera.point.x) * App.camera.scale + params.halfScreenW
end

---@param y number
---@return number
function Draw.calcY(y)
    return (y - App.camera.point.y) * App.camera.scale + params.halfScreenH
end

function Draw:calcRealX(x)
    return (x - params.halfScreenW) * App.camera.scale + App.camera.point.x
end

function Draw:calcRealY(y)
    return (y - params.halfScreenH) * App.camera.scale + App.camera.point.y
end

---@param realPoint Point
---@param angle number
---@protected
function Draw:rotate(realPoint, angle)
    love.graphics.translate(realPoint.x, realPoint.y)
    love.graphics.rotate(angle)
    love.graphics.translate(-realPoint.x, -realPoint.y)
end

return Draw