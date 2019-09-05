---@class IComponent
local IComponent = {}

---@param ship Ship
function IComponent:connect(ship) end

---@param ship Ship
function IComponent:disconnect(ship) end

function IComponent:clearVisual() end

return IComponent