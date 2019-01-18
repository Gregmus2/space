local GameObject = require('game_object.game_object')

---@class Core : GameObject
---@field public drawable Draw
---@field public fixture Fixture
---@field protected rotateSpeed number
local Core = GameObject:new()

---@param drawable Draw
---@param fixture Fixture
---@param rotateSpeed number
function Core:new(drawable, fixture, rotateSpeed)
    local newObj = {
        drawable = drawable,
        fixture = fixture,
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