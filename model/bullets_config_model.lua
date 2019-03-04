---@class BulletsConfigModel
---@field public radius number
---@field public draw Draw
---@field public speed number
local BulletsConfigModel = {}


---@param radius number
---@param draw Draw
---@param speed number
---@return BulletsConfigModel
function BulletsConfigModel:new(radius, draw, speed)
    local newObj = {
        radius = radius,
        draw = draw,
        speed = speed,
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

return BulletsConfigModel