---@class MenuObject
local MenuObject = {}

---@return MenuObject
function MenuObject:new()
    local newObj = {}
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function MenuObject:draw() end

return MenuObject