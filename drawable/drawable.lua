local params = require('params')

---@class Drawable
---@field public visibilityRadius number
---@field public color Color
---@field public mode string
---@field public draw fun(camera:Camera, x:number, y:number):void
---@field protected calcX fun(camera:Camera, x:number):number
---@field protected calcY fun(camera:Camera, y:number):number
local Drawable = {}

function Drawable:new(o)
    newObj = o or {}
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
function Drawable.calcX(camera, x)
    return (x - camera.x) * camera.scale + params.halfScreenW
end

---@param camera Camera
---@param y number
---@return number
function Drawable.calcY(camera, y)
    return (y - camera.y) * camera.scale + params.halfScreenH
end

return Drawable