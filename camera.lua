---@class Camera
---@field public point Point
---@field public scale number
---@field protected default table<string, any>
local Camera = {}

---@param point Point
---@return Camera
function Camera:new(point)
    local newObj = {
        default = {
            point = point,
            scale = 1,
        }
    }
    setmetatable(newObj, self)
    self.__index = self

    newObj:reset()

    return newObj
end

---@param point Point
function Camera:setCoords(point)
    self.point = point
end

function Camera:reset()
    self.point = self.default.point
    self.scale = self.default.scale
end

---@return table<string, any>
function Camera:getState()
    return { point = self.point, scale = self.scale }
end

---@param state table<string, any>
function Camera:setState(state)
    self.point = state.point or self.point
    self.scale = state.scale or self.scale
end

---@param scale number
function Camera:addScale(scale)
    -- todo добавить плавность масштабирования
    if (self.scale + scale < 0.1) then
        return
    end

    self.scale = self.scale + scale
end

return Camera