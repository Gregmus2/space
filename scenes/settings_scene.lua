local Scene = require('scenes.scene')
local Grid = require('menu.grid')
local Collection = require('collection.collection')
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

    local grid = Grid:new(Point:new(App.camera.point.x / 2, App.camera.point.y / 2), Area:new(400, 500), 1, 100)
    local elements = Collection:new({})
    grid:setCollection(elements)
    self.menu:addElement(grid)

    local slider = Slider:new(Point:new(0, 0), 300, {'1024*768', '768*664', '445*21'}, Color:white())
    elements:add(slider)

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'escape', 'menu')
end

return SettingsScene