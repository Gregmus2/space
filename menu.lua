---@class Menu
---@field protected buttons Button[]
local Menu = {}

function Menu:new()
    newObj = {
        buttons = {}
    }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param x number
---@param y number
function Menu:mouseRelease(x, y)
    for _, button in ipairs(self.buttons) do
        if button:checkPoint(x, y) then
            button.action()
        end
    end
end

---@param button Button
function Menu:addButton(button)
    self.buttons[#self.buttons + 1] = button
end

function Menu:draw()
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

return Menu