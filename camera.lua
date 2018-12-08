---@class Camera
---@field public x number
---@field public y number
---@field public scale number
local Camera = {}

---@param x number
---@param y number
---@return Camera
function Camera:new(x, y)
    newObj = { x = x, y = y, scale = 1 }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param x number
---@param y number
function Camera:setCoords(x, y)
    self.x = x
    self.y = y
end

---@param scale number
function Camera:addScale(scale)
    if (self.scale + scale < 0.1) then
        return
    end

    self.scale = self.scale + scale
end

return Camera