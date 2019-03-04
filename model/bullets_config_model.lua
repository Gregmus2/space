---@class BulletsConfigModel
---@field public radius number
---@field public color Color
---@field public speed number
local BulletsConfigModel = {}


---@param radius number
---@param color Color
---@param speed number
---@return BulletsConfigModel
function BulletsConfigModel:new(radius, color, speed)
    local newObj = {
        radius = radius,
        color = color,
        speed = speed,
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

return BulletsConfigModel