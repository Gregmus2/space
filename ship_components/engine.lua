local PhysicalDrawObject = require('game_object.physical_draw_object')

---@class Engine : PhysicalDrawObject
---@field public drawable Draw
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
local Engine = PhysicalDrawObject:new()

---@param drawable Draw
---@param physics Fixture
---@param speed number
function Engine:new(drawable, physics, speed)
    local newObj = {
        drawable = drawable,
        physics = physics,
        speed = speed
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