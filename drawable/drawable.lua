local params = require('params')

---@class Draw
---@field public visibilityRadius number
---@field public color Color
---@field public mode string
---@field public angle number
local Draw = {}

function Draw:new()
    newObj = { angle = 0 }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param camera Camera
---@param x number
---@param y number
function Draw:draw(camera, x, y) end

---@param camera Camera
---@param x number
---@return number
---@protected
function Draw.calcX(camera, x)
    return (x - camera.x) * camera.scale + params.halfScreenW
end

---@param camera Camera
---@param y number
---@return number
---@protected
function Draw.calcY(camera, y)
    return (y - camera.y) * camera.scale + params.halfScreenH
end

---@param realXCenter number
---@param realYCenter number
---@protected
function Draw:rotate(realXCenter, realYCenter)
    love.graphics.translate(realXCenter, realYCenter)
    love.graphics.rotate(self.angle)
    love.graphics.translate(-realXCenter, -realYCenter)
end

return Draw