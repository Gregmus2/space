local Scene = require('scenes.scene')
local FormContainer = require('menu.form_container')
local Params = require('params')
local Area = require('model.area')
local Point = require('model.point')
local Event = require('enum.event')
local Slider = require('menu.slider')
local Color = require('color')
local Config = require('config')

---@class SettingsScene : Scene
local SettingsScene = Scene:new()

function SettingsScene:load(prevScene)
    if self.isLoaded then
        return
    end
    self.isLoaded = true
    self:createMenu()

    local container = FormContainer:new(Point:new(App.camera.point.x, App.camera.point.y), Area:new(wpixels(5, true), hpixels(8, true)), 100)
    self.menu:addElement(container)

    local slider = Slider:new(Point:new(0, 0), 300, Params.resolutions, Color:white())
    container:add(slider, function()
        local values = slider:getValue():split('x')
        love.window.setMode(values[1], values[2], { msaa = Config.msaa } )
    end)

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'escape', 'menu')
end

return SettingsScene