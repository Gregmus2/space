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
---@param trigger string
---@param action Action
function EventCollection:addEvent(event, trigger, action)
    if self.events[event] == nil then
        self.events[event] = {}
    end

    self.events[event][trigger] = action
end

---@param event string @ EventCollection.EVENT_TYPE.*
---@param trigger string
---@return Action|nil
function EventCollection:findAction(event, trigger)
    return self.events[event] and self.events[event][trigger]
end

return EventCollection