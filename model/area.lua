---@class Area
---@field public w number
---@field public h number
local Area = {}


---@param w number
---@param h number
---@return Area
function Area:new(w, h)
    local newObj = {
        w = w,
        h = h
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function Area:ceil()
    self.w = math.ceil(self.w)
    self.h = math.ceil(self.h)
end

function Area:get()
    return self.w, self.h
end

return Area