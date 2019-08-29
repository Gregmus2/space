---@class Point
---@field public x number
---@field public y number
local Point = {}


---@param x number
---@param y number
---@return Point
function Point:new(x, y)
    local newObj = {
        x = x or 0,
        y = y or 0
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param x number
---@param y number
function Point:diff(x, y)
    self.x, self.y = self.x - x, self.y - y
end

---@param dX number
---@param dY number
function Point:clone(dX, dY)
    return Point:new(self.x + (dX or 0), self.y + (dY or 0))
end

function Point:diffPoint(point)
    self.x, self.y = self.x - point.x, self.y - point.y
end

function Point:get()
    return self.x, self.y
end

function Point:ceil()
    self.x = math.ceil(self.x)
    self.y = math.ceil(self.y)
end

return Point