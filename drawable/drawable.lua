local params = require('params')

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

---@param x number
---@param y number
function Draw:draw(x, y, angle)
    love.graphics.push()
    love.graphics.setShader(self.shader)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)

    local realXCenter = self.calcX(x)
    local realYCenter = self.calcY(y)
    self:rotate(realXCenter, realYCenter, angle)

    self:drawShape(x, y, realXCenter, realYCenter)
    love.graphics.setShader()
    love.graphics.pop()
end

---@protected
---@param x number
---@param y number
---@param realX number
---@param realY number
function Draw:drawShape(x, y, realX, realY) end

---@param x number
---@return number
function Draw.calcX(x)
    return (x - App.camera.x) * App.camera.scale + params.halfScreenW
end

---@param y number
---@return number
function Draw.calcY(y)
    return (y - App.camera.y) * App.camera.scale + params.halfScreenH
end

function Draw:calcRealX(x)
    return (x - params.halfScreenW) * App.camera.scale + App.camera.x
end

function Draw:calcRealY(y)
    return (y - params.halfScreenH) * App.camera.scale + App.camera.y
end

---@param realXCenter number
---@param realYCenter number
---@param angle number
---@protected
function Draw:rotate(realXCenter, realYCenter, angle)
    love.graphics.translate(realXCenter, realYCenter)
    love.graphics.rotate(angle)
    love.graphics.translate(-realXCenter, -realYCenter)
end

return Draw