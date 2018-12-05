---@class DrawGenerator
local G = {}

local halfScreenW = love.graphics.getWidth() / 2;
local halfScreenH = love.graphics.getHeight() / 2;

---@param mode string
---@param color Color
---@return function
function G.generateRectangle(mode, color)
    ---@param go GameObject
    ---@param camera Camera
    return function(go, camera)
        love.graphics.setColor(color:getR(), color:getG(), color:getB())
        love.graphics.rectangle(
            mode,
            (go.x - halfScreenW - camera.x) * camera.scale + halfScreenW,
            (go.y - halfScreenH - camera.y) * camera.scale + halfScreenH,
            go.w * camera.scale,
            go.h * camera.scale
        )
    end
end

return G