local Event = require('enum.event')

---@class Camera
---@field public point Point
---@field public scale number
---@field public scale_target number
---@field protected default table<string, any>
local Camera = {}

local CAMERA_SPEED = 4

---@param point Point
---@return Camera
function Camera:new(point)
    local newObj = {
        default = {
            point = point,
            scale = 1,
            scale_target = 1
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
    self.scale_target = self.default.scale_target
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
    if (self.scale_target + scale < 0.1) or (self.scale_target + scale > 3) then
        return
    end
    print(self.scale_target)
    self.scale_target = self.scale_target + scale

    App.scene.events:addAction(Event.UPDATE,
        function(params)
            local diff = self.scale_target - self.scale
            if math.abs(diff) < 0.1 then
                App.scene.events:removeAction(Event.UPDATE, nil, 'camera')
                return
            end

            self.scale = self.scale + diff * params.dt * CAMERA_SPEED
        end, nil, 'camera'
    )
end

return Camera