---@class Point
---@field public x number
---@field public y number
local Point = {}


---@param x number
---@param y number
---@return Point
function Point:new(x, y)
    local newObj = {
        x = x,
        y = y
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

return Point