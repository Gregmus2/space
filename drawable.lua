---@class Drawable
---@field public go GameObject
---@field public visibilityRadius number
---@field protected rectangleFunc function
---@field protected circleFunc function
---@field protected calcX function
---@field protected calcY function
local Drawable = {}

local halfScreenW = love.graphics.getWidth() / 2;
local halfScreenH = love.graphics.getHeight() / 2;

---@param go GameObject
---@param mode string
---@param color Color
function Drawable:rectangle(go, mode, color)
    newObj = {
        go = go,
        visibilityRadius = math.sqrt(go.w ^ 2 + go.h ^ 2) / 2,
        realX = go.x - go.w / 2,
        realY = go.y - go.h / 2
    }
    self.__index = self
    local table = setmetatable(newObj, self)
    newObj.draw = table:rectangleFunc(mode, color)
    go:setDraw(table)

    return table
end

---@param go GameObject
---@param mode string
---@param color Color
function Drawable:circle(go, mode, color)
    newObj = {
        go = go,
        visibilityRadius = go.w / 2,
        realX = go.x - go.w / 2,
        realY = go.y - go.h / 2
    }
    self.__index = self
    local table = setmetatable(newObj, self)
    newObj.draw = table:circleFunc(mode, color)
    go:setDraw(table)

    return table
end

function Drawable:move(dX, dY)
    self.realX = self.realX + dX
    self.realY = self.realY + dY
end

---@param mode string
---@param color Color
---@return function
function Drawable:rectangleFunc(mode, color)
    ---@param camera Camera
    return function(camera)
        love.graphics.setColor(color.r, color.g, color.b)
        love.graphics.rectangle(
            mode,
            self:calcX(camera),
            self:calcY(camera),
            self.go.w * camera.scale,
            self.go.h * camera.scale
        )
    end
end

---@param mode string
---@param color Color
---@return function
function Drawable:circleFunc(mode, color)
    ---@param camera Camera
    return function(camera)
        love.graphics.setColor(color.r, color.g, color.b)
        love.graphics.circle(
                mode,
                self:calcX(camera),
                self:calcY(camera),
                self.visibilityRadius * camera.scale
        )
    end
end

---@param camera Camera
---@return number
function Drawable:calcX(camera)
    return (self.realX - halfScreenW - camera.x) * camera.scale + halfScreenW
end

---@param camera Camera
---@return number
function Drawable:calcY(camera)
    return (self.realY - self.go.h / 2 - halfScreenH - camera.y) * camera.scale + halfScreenH
end

return Drawable
