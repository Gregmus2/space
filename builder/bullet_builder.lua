local GameObjectBuilder = require('game_object_builder')

---@class BulletBuilder
local BulletBuilder = {}

-- todo билдить разные типы пуль (форма)

---@param x number
---@param y number
---@return GameObject
function BulletBuilder.buildBullet(x, y, radius, draw)
    return GameObjectBuilder
        :new(x, y)
        :addCirclePhysics(App.scene.world, radius, 'dynamic', 0.1, 0)
        :createGameObject()
        :addDraw(draw)
end

return BulletBuilder