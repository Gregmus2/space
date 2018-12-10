---@class EventCollection
---@field protected events table<string, table<string, Action>>
local EventCollection = {}

---@return EventCollection
function EventCollection:new()
    newObj = { events = {} }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param event string @ enum.event
---@param action Action
---@param trigger string|nil
function EventCollection:addEvent(event, action, trigger)
    if self.events[event] == nil then
        self.events[event] = {}
    end

    if trigger == nil then
        self.events[event] = action
    else
        self.events[event][trigger] = action
    end
end

---@param event string @ enum.event
---@param trigger string
---@return Action|nil
function EventCollection:findAction(event, trigger)
    if trigger == nil then
        return self.events[event]
    end

    return self.events[event] and self.events[event][trigger]
end

return EventCollection