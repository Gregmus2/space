local Scene = require('scenes.scene')
local Color = require('color')
local Draw = require('drawable.drawable')
local ShipComponentBuilder = require('ship_component_builder')
local PolygonFactory = require('factory.polygon_factory')
local Collection = require('collection.collection')
local Grid = require('menu.grid')

---@class TestScene : Scene
local TestScene = Scene:new()

function TestScene:load(prevScene)
    self:createMenu()
    self:createWorld()

    local engines = {}
    for i = 1, 20 do
        engines[i] = ShipComponentBuilder:buildEngine(self.world, prevScene, Draw:calcRealX(100), Draw:calcRealY(100), Color:new(math.random(), math.random(), math.random()), PolygonFactory.generateRocket(20, 40, 10), 0.1, 1500)
    end
    local grid = Grid:new(App.camera.x, App.camera.y, 400, 500, 2, 100)
    local collection = Collection:new(engines)
    grid:setCollection(collection)
    self.menu:addElement(grid)
end

return TestScene