---@class GameObject
---@field public draw Drawable
---@field public physics Fixture
local GameObject = {}

---@param draw Drawable
---@param physics Fixture
function GameObject:new(draw, physics)
    newObj = {
        draw = draw,
        physics = physics
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

return GameObject