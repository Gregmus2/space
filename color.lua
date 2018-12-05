---@class Color
local Color = {}

---@param r number
---@param g number
---@param b number
function Color:new(r, g ,b)
    newObj = { r = r, g = g, b = b }
    self.__index = self

    return setmetatable(newObj, self)
end

function Color:blue()
    return Color:new(0, 0, 1)
end

---@return number
function Color:getR()
    return self.r;
end

---@return number
function Color:getG()
    return self.g;
end

---@return number
function Color:getB()
    return self.b;
end

return Color