local Scene = require('scenes.scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local Event = require('enum.event')

---@class LoadScene : Scene
local LoadScene = Scene:new()

---@param scene Scene
function LoadScene:load(scene)
    if self.isLoaded then
        return
    end
    self.isLoaded = true

    local gameObject1 = GameObjectBuilder
        :new(App.camera.x - 50, App.camera.y)
        :addRectangleDraw('fill', Color:white(), 50, 100)
        :createGameObject()

    local gameObject2 = GameObjectBuilder
        :new(App.camera.x + 50, App.camera.y)
        :addRectangleDraw('fill', Color:white(), 50, 100)
        :createGameObject()

    self.objects[#self.objects + 1] = gameObject1
    self.objects[#self.objects + 1] = gameObject2

    self.events:addAction(Event.KEY, function() App.changeScene(scene) end, 'space')
end

return LoadScene
