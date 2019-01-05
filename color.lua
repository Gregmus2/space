---@class Color
---@field public r number
---@field public g number
---@field public b number
local Color = {}

---@param r number
---@param g number
---@param b number
function Color:new(r, g ,b)
    local newObj = { r = r, g = g, b = b }
    self.__index = self

    return setmetatable(newObj, self)
end

function Color:blue()
    return Color:new(0, 0, 1)
end

function Color:red()
    return Color:new(1, 0, 0)
end

function Color:white()
    return Color:new(1, 1, 1)
end

return Color