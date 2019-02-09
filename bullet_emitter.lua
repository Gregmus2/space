---@class BulletEmitter
---@field protected x number
---@field protected y number
---@field protected angle number
---@field protected creationPeriod number
---@field protected timer number
---@field protected bulletPrototype GameObject
---@field protected bullets GameObject[]
local BulletEmitter = {}

---@param x number
---@param y number
---@param angle number
---@param bulletsPerSec number
---@param bullet GameObject
function BulletEmitter:new(x, y, angle, bulletsPerSec, bullet)
    local newObj = {
        x = x,
        y = y,
        angle = angle,
        creationPeriod = 1 / bulletsPerSec,
        timer = 1 / bulletsPerSec,
        bulletPrototype = bullet,
        bullets = {}
    }

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param x number
---@param y number
function BulletEmitter:setPosition(x, y)
    self.x, self.y = x, y
end

---@param angle number
function BulletEmitter:setAngle(angle)
    self.angle = angle
end

function BulletEmitter:start()
    self.timer = self.creationPeriod
    self.shooting = true
end

function BulletEmitter:stop()
    self.shooting = false
end

---@param dt number
function BulletEmitter:update(dt)
    if not self.shooting then return end
    self.timer = self.timer + dt
    if self.timer >= self.creationPeriod then
        ---@type GameObject
        local bullet = table.deepCopy(self.bulletPrototype, 3) -- deep: gameObject -> fixture -> body !> world
        bullet:setPosition(self.x + math.cos(self.angle) * 30, self.y + math.sin(self.angle) * 30)
        --bullet:setAngle(self.angle)
        -- todo if world wouldn't has the new bullet, we need to add bullet to world with BodyList
        bullet:move(50, 0)
        self.bullets[#self.bullets + 1] = bullet
    end
end

function BulletEmitter:draw()
    for _, bullet in ipairs(self.bullets) do
        bullet:draw()
    end
end

return BulletEmitter