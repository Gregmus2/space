local GameObjectBuilder = require('game_object_builder')
local Circle = require('drawable.circle')
local Color = require('color')

---@class BulletBuilder
local BulletBuilder = {}

---@param x number
---@param y number
---@return GameObject
function BulletBuilder.buildBullet(x, y)
    return GameObjectBuilder
        :new(x, y)
        :addCirclePhysics(App.scene.world, 5, 'dynamic', 0.1, 0)
        :createGameObject()
        :addDraw(Circle:new('fill', Color:white(), 5))
end

return BulletBuilder