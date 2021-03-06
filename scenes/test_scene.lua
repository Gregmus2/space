local Scene = require('scenes.scene')
local Color = require('color')
local Draw = require('drawable.drawable')
local ShipComponentBuilder = require('ship_component_builder')
local PolygonFactory = require('factory.polygon_factory')
local Collection = require('collection.collection')
local Grid = require('menu.grid')
local Point = require('model.point')
local Area = require('model.area')
local Params = require('params')
local Event = require('enum.event')

---@class TestScene : Scene
local TestScene = Scene:new()

function TestScene:load(prevScene)
    self:createMenu()
    self:createWorld()

    local engines = {}
    for i = 1, 20 do
        engines[i] = ShipComponentBuilder:buildEngine(self.world, prevScene, Point:new(Draw:calcRealX(100), Draw:calcRealY(100)), Color:new(math.random(), math.random(), math.random()), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
    end
    local grid = Grid:new(Point:new(App.camera.point.x / 2, App.camera.point.y / 2), Area:new(400, 500), 2, 100)
    local collection = Collection:new(engines)
    grid:setCollection(collection)
    self.menu:addElement(grid)

    self.events:addAction(Event.KEY, function() App.changeScene(Params.default.scene) end, 'escape', 'menu')
end

return TestScene