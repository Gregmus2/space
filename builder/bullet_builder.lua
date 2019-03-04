local GameObjectBuilder = require('game_object_builder')
local Circle = require('drawable.circle')

---@class BulletBuilder
local BulletBuilder = {}

---@param x number
---@param y number
---@param radius number
---@param color Color
---@return GameObject
function BulletBuilder.buildBullet(x, y, radius, color)
    local obj = GameObjectBuilder
        :new(x, y)
        :addCirclePhysics(App.scene.world, radius, 'dynamic', 0.1, 0)
        :createGameObject()
        :addDraw(Circle:new('fill', color, radius))
    obj.fixture:getBody():setBullet(true)

    return obj
end

return BulletBuilder