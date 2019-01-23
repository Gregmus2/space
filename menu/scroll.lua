local Event = require('enum.event')

---@class Scroll
local Scroll = {}

---@param length number
---@param step number
---@return Scroll
function Scroll:new(length, step)
    local newObj = {
        length = length,
        step = step or 1,
        current = 0
    }
    setmetatable(newObj, self)
    self.__index = self

    App.scene.events:addAction(Event.WHEEL, function(params) newObj:move(params.y) end)

    return newObj
end

---@param power number @ > power > 0: down, power < 0: up
function Scroll:move(power)
    self.current = self.current + self.step * -power
    if self.current > self.length then
        self.current = self.length
    end
    if self.current < 0 then
        self.current = 0
    end
end

---@return number
function Scroll:getCurrent()
    return self.current
end

return Scroll