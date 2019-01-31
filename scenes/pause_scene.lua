local Scene = require('scenes.scene')
local Color = require('color')
local DrawObject = require('game_object.draw_object')
local Event = require('enum.event')
local Rectangle = require('drawable.rectangle')

---@class LoadScene : Scene
local LoadScene = Scene:new()

---@param prevScene Scene
function LoadScene:load(prevScene)
    if self.isLoaded then
        return
    end
    self.isLoaded = true

    local rect = Rectangle:new('fill', Color:white(), 50, 100)
    local gameObject1 = DrawObject:new(rect, App.camera.x - 50, App.camera.y)
    local gameObject2 = DrawObject:new(rect, App.camera.x + 50, App.camera.y)

    self.objects[#self.objects + 1] = gameObject1
    self.objects[#self.objects + 1] = gameObject2

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'space')
end

return LoadScene
