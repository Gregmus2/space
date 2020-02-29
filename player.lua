---@class Player
---@field public money number
Player = {
    money = 300
}

function Player.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Money: ' .. Player.money, wpixels(8), 10);
end
