---@class Action
---@field public action function
---@field public isLong boolean
---@field public isMouseMoved boolean
local Action = {}

---@param action function
---@param isLong boolean|nil
---@param noReturn boolean|nil
---@param isMouseMoved boolean|nil
function Action:new(action, isLong, noReturn, isMouseMoved)
    newObj = { isMouseMoved = isMouseMoved or false }
    newObj.isLong = isLong or false
    if isLong and noReturn ~= true then
        newObj.action = function() return action end
    else
        newObj.action = action
    end

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

return Action