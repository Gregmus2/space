local Params = require('params')

---@class BulletsConfigModel
---@field public radius number
---@field public color Color
---@field public speed number
---@field public lifetime number
local BulletsConfigModel = {}


---@param radius number
---@param color Color
---@param speed number
---@return BulletsConfigModel
function BulletsConfigModel:new(radius, color, speed, lifetime)
    local newObj = {
        radius = radius,
        color = color,
        speed = speed,
        lifetime = lifetime or Params.default.bullets_lifetime,
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

return BulletsConfigModel