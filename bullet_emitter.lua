local BulletBuilder = require('builder.bullet_builder')
local Collection = require('collection.collection')

---@class BulletEmitter
---@field protected x number
---@field protected y number
---@field protected angle number
---@field protected creationPeriod number
---@field protected timer number
---@field protected bullets Collection
---@field protected bulletsConfig BulletsConfigModel
local BulletEmitter = {}

---@param angle number
---@param bulletsPerSec number
function BulletEmitter:new(bulletsPerSec, bulletsConfig)
    local newObj = {
        creationPeriod = 1 / bulletsPerSec,
        timer = 1 / bulletsPerSec,
        bullets = Collection:new({}),
        emptyKeys = {},
        bulletsConfig = bulletsConfig
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
    local now = love.timer.getTime()
    ---@param bullet GameObject
    for _, bullet in ipairs(self.bullets.elements) do
        local lifetime = now - bullet.createdAt
        print(lifetime)
        if lifetime >= self.bulletsConfig.lifetime then
            bullet:destroy()
            self.bullets:remove(bullet)
        end
    end

    if not self.shooting then return end
    self.timer = self.timer + dt
    if self.timer >= self.creationPeriod then
        ---@type GameObject
        local bullet = BulletBuilder.buildBullet(
            self.x + math.cos(self.angle) * 30,
            self.y + math.sin(self.angle) * 3,
            self.bulletsConfig.radius,
            self.bulletsConfig.color
        )
        bullet:setAngle(self.angle)
        bullet:move(self.bulletsConfig.speed * dt, 1)
        bullet.createdAt = now
        self.bullets:add(bullet)
    end
end

function BulletEmitter:draw()
    ---@param bullet GameObject
    for _, bullet in ipairs(self.bullets.elements) do
        if bullet:isDestroyed() then
            self.bullets:remove(bullet)
        else
            bullet:draw()
        end
    end
end

return BulletEmitter