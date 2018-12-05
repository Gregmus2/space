---@class GameObject
---@field public x number
---@field public y number
---@field public w number
---@field public h number
---@field public draw Drawable
local GameObject = {}

---@param x number
---@param y number
---@param w number
---@param h number
function GameObject:new(x, y, w, h)
    newObj = {
        draw = nil,
        physics = nil,
        x = x,
        y = y,
        w = w,
        h = h
    }
    self.__index = self

    return setmetatable(newObj, self)
end

function GameObject:move(dX, dY)
    self.x = self.x + dX
    self.y = self.y + dY
    self.draw:move(dX, dY)
end

---@param draw Drawable
function GameObject:setDraw(draw)
    self.draw = draw
end

return GameObject