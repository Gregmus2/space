---@class Component
local Component = {}

---@param ship Ship
function Component:connect(ship) end

---@param ship Ship
function Component:disconnect(ship) end

function Component:clearVisual() end

return Component