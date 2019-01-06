local PhysicalDrawObject = require('game_object.physical_draw_object')

---@class Core : PhysicalDrawObject
---@field public drawable Draw
---@field public physics Fixture
---@field protected rotateSpeed number
local Core = PhysicalDrawObject:new()

---@param drawable Draw
---@param physics Fixture
---@param rotateSpeed number
function Core:new(drawable, physics, rotateSpeed)
    local newObj = {
        drawable = drawable,
        physics = physics,
        rotateSpeed = rotateSpeed
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function Core:move(dt, direction) end

return Core