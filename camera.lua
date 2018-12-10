---@class Camera
---@field public x number
---@field public y number
---@field public scale number
---@field protected default table<string, any>
local Camera = {}

---@param x number
---@param y number
---@return Camera
function Camera:new(x, y)
    newObj = {
        default = {
            x = x,
            y = y,
            scale = 1,
        }
    }
    setmetatable(newObj, self)
    self.__index = self

    newObj:reset()

    return newObj
end

---@param x number
---@param y number
function Camera:setCoords(x, y)
    self.x = x
    self.y = y
end

function Camera:reset()
    self.x = self.default.x
    self.y = self.default.y
    self.scale = self.default.scale
end

---@return table<string, any>
function Camera:getState()
    return { x = self.x, y = self.y, scale = self.scale }
end

---@param state table<string, any>
function Camera:setState(state)
    self.x = state.x or self.x
    self.y = state.y or self.y
    self.scale = state.scale or self.scale
end

---@param scale number
function Camera:addScale(scale)
    if (self.scale + scale < 0.1) then
        return
    end

    self.scale = self.scale + scale
end

return Camera