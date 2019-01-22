---@class Menu
---@field protected buttons Button[]
local Menu = {}

function Menu:new()
    local newObj = {
        buttons = {},
        grids = {}
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

---@param grid Grid
function Menu:addGrid(grid)
    self.grids[#self.grids + 1] = grid
end

function Menu:draw()
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
    -- todo refactoring
    for _, grid in ipairs(self.grids) do
        grid:draw()
    end
end

return Menu