local PhysicalDrawObject = require('game_object.physical_draw_object')

---@class Engine : PhysicalDrawObject
---@field public drawable Draw
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
---@field protected angle number
local Engine = PhysicalDrawObject:new()

---@param drawable Draw
---@param physics Fixture
function Engine:new(drawable, physics)
    local newObj = {
        drawable = drawable,
        physics = physics
    }
    physics:getBody():setFixedRotation(false)
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function Engine:rotate(dt, direction) end

return Engine