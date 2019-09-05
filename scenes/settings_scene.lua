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

    local current_res = Config.width .. 'x' .. Config.height
    local current_resolution_index = table.find(Params.resolutions, current_res) - 1
    local slider = Slider:new(Point:new(0, 0), 300, Params.resolutions, current_resolution_index)
    container:add(slider, function()
        local values = slider:getValue():split('x')
        Config:writeConfig({
            width = values[1],
            height = values[2]
        })
        love.window.showMessageBox('info', 'Changes will accepted after restart the game', 'info')
    end)

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'escape', 'menu')
end

return SettingsScene