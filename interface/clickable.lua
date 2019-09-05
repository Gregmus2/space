---@class IClickable
---@field public action function
local IClickable = {}

---@param point Point
---@return boolean
function IClickable:checkPoint(point) end

return IClickable