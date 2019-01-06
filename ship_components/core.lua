local PhysicalDrawObject = require('game_object.physical_draw_object')

---@class Core : PhysicalDrawObject
---@field public drawable Draw
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
---@field protected angle number
local Core = PhysicalDrawObject:new()

---@param drawable Draw
---@param physics Fixture
function Core:new(drawable, physics)
    local newObj = {
        drawable = drawable,
        physics = physics
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function Core:move(dt, direction) end

return Core