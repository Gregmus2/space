local params = require('params')

---@class Drawable
---@field public visibilityRadius number
---@field public color Color
---@field public mode string
---@field public angle number
local Drawable = {}

function Drawable:new(o)
    newObj = o or { angle = 0 }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param camera Camera
---@param x number
---@param y number
function Drawable:draw(camera, x, y) end

---@param camera Camera
---@param x number
---@return number
---@protected
function Drawable.calcX(camera, x)
    return (x - camera.x) * camera.scale + params.halfScreenW
end

---@param camera Camera
---@param y number
---@return number
---@protected
function Drawable.calcY(camera, y)
    return (y - camera.y) * camera.scale + params.halfScreenH
end

---@param realXCenter number
---@param realYCenter number
---@protected
function Drawable:rotate(realXCenter, realYCenter)
    love.graphics.translate(realXCenter, realYCenter)
    love.graphics.rotate(self.angle)
    love.graphics.translate(-realXCenter, -realYCenter)
end

return Drawable