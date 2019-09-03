local Scene = require('scenes.scene')
local Container = require('menu.container')
local Params = require('params')
local Area = require('model.area')
local Point = require('model.point')
local Event = require('enum.event')
local Slider = require('menu.slider')
local Color = require('color')

---@class SettingsScene : Scene
local SettingsScene = Scene:new()

function SettingsScene:load(prevScene)
    if self.isLoaded then
        return
    end
    self.isLoaded = true
    self:createMenu()

    local container = Container:new(Point:new(App.camera.point.x, App.camera.point.y), Area:new(400, 500), Color:white(), 100)
    self.menu:addElement(container)

    local slider = Slider:new(Point:new(0, 0), 300, Params.resolutions, Color:white())
    container:add(slider)

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'escape', 'menu')
end

return SettingsScene