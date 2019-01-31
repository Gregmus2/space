local Scene = require('scenes.scene')
local Color = require('color')
local DrawObject = require('game_object.draw_object')
local Event = require('enum.event')
local Rectangle = require('drawable.rectangle')
local Polygon = require('drawable.polygon')

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

    self.objects[#self.objects + 1] = DrawObject:new(Polygon:new('line', Color:white(), { 0, 0, -1, 16, -23, 65, -28, 76, -53, 107, -62, 116, -151, 144 }), App.camera.x - 250, App.camera.y)
    self.objects[#self.objects + 1] = DrawObject:new(Polygon:new('line', Color:white(), { 0, 0, -151, 144, -209, 134, -226, 100, -229, 85, -230, 73, -228, 62 }), App.camera.x - 250, App.camera.y)
    self.objects[#self.objects + 1] = DrawObject:new(Polygon:new('line', Color:white(), { 0, 0, -228, 62, -203, 9, -182, -20, -170, -31, -126, -71, -40, -74 }), App.camera.x - 250, App.camera.y)
    self.objects[#self.objects + 1] = DrawObject:new(Polygon:new('line', Color:white(), { 0, 0, -40, -74, -33, -74, -21, -50, -7, -17 }), App.camera.x - 250, App.camera.y)

    self.objects[#self.objects + 1] = gameObject1
    self.objects[#self.objects + 1] = gameObject2

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'space')
end

return LoadScene
