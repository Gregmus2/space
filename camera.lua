---@class Camera
---@field public x number
---@field public y number
---@field public scale number
local Camera = {}

---@param x number
---@param y number
---@return Camera
function Camera:new(x, y)
    newObj = { x = x, y = y, scale = 1, object = nil }
    self.__index = self

    return setmetatable(newObj, self)
end

---@param object GameObject
function Camera:assignObject(object)
    self.object = object
end

---@param dX number
---@param dY number
function Camera:move(dX, dY)
    self.x = self.x + dX
    self.y = self.y + dY
    self.object.x = self.object.x + dX
    self.object.y = self.object.y + dY
end

---@param scale number
function Camera:addScale(scale)
    if (self.scale + scale < 0.1) then
        return
    end

    self.scale = self.scale + scale
end

return Camera