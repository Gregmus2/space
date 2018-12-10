---@class Action
---@field public action function
---@field public isLong boolean
local Action = {}

---@param action function
---@param isLong boolean|nil
function Action:new(action, isLong)
    newObj = { action = action, isLong = isLong or false }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

return Action