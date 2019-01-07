local Event = require('enum.event')

---@class EventCollection
---@field protected events table<string, table<string, Action>>
local EventCollection = {}

---@return EventCollection
function EventCollection:new()
    local newObj = { events = {} }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param event string @ enum.event
---@param action function
---@param trigger string|nil
---@param uniq string|nil
function EventCollection:addAction(event, action, trigger, uniq)
    self.events[event] = self.events[event] or {}
    local target
    if trigger ~= nil then
        self.events[event][trigger] = self.events[event][trigger] or {}
        target = self.events[event][trigger]
    else
        target = self.events[event]
    end
    target[uniq or #target + 1] = action
end

---@param event string @ enum.event
---@param trigger string|nil
---@return Action[]|nil
function EventCollection:findActions(event, trigger)
    if trigger then
        return self.events[event] and self.events[event][trigger]
    else
        return self.events[event]
    end
end

---@param event string @ enum.event
---@param trigger string
---@param uniq string
function EventCollection:removeAction(event, trigger, uniq)
    self:findActions(event, trigger)[uniq] = nil
end

---@param startEvent string @ enum.event
---@param endEvent string @ enum.event
---@param action function
---@param trigger string|nil
function EventCollection:longUpdate(startEvent, endEvent, action, trigger)
    local uniq = love.math.random()
    self:addAction(
        startEvent,
        function()
            self:addAction(Event.UPDATE, action, nil, uniq)
        end, trigger
    )

    self:addAction(
        endEvent,
        function()
            self:removeAction(Event.UPDATE, nil, uniq)
        end, trigger
    )
end

return EventCollection