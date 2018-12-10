local MenuObject = require('menu.menu')

---@class Button : MenuObject
---@field public x number
---@field public y number
---@field protected drawObject Draw
---@field protected physics Fixture
local Button = MenuObject:new()

---@param drawObject Draw
---@param physics Fixture
function Button:new(drawObject, physics)
    newObj = {
        drawObject = drawObject,
        physics = physics,
        x = physics:getBody():getX(),
        y = physics:getBody():getY()
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function Button:draw()
    self.drawObject:draw(self.x, self.y)
end

return Button