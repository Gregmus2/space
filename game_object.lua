---@class GameObject
---@field public x number
---@field public y number
---@field public w number
---@field public h number
---@field public draw function
local GameObject = {}

---@param x number
---@param y number
---@param w number
---@param h number
function GameObject:new(x, y, w, h)
    newObj = { draw = nil, physics = nil, x = x, y = y, w = w, h = h }
    self.__index = self

    return setmetatable(newObj, self)
end

---@param drawFunc function
function GameObject:setDraw(drawFunc)
    self.draw = drawFunc
end

return GameObject