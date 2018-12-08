local Camera = require('camera')
local Params = require('params')
local Config = require('config')
local SpaceScene = require('scenes.space_scene')
local EventCollection = require('collection.event_collection')

---@class App
---@field public camera Camera
---@field public scene Scene
---@field public events EventCollection
local App = {
    camera = nil,
    scene = SpaceScene,
    events = EventCollection:new()
}

function App:load()
    Config:load()
    love.window.setMode(Config.width, Config.height, { msaa = Config.msaa } )
    love.math.setRandomSeed(love.timer.getTime())
    love.graphics.setBackgroundColor(0.03, 0.04, 0.08)
    love.physics.setMeter(Params.worldMeter)
    Params:init()

    self.camera = Camera:new(Params.halfScreenW, Params.halfScreenH)
end

---@param scene Scene
function App:changeScene(scene)
    scene:load(App.camera)
    App.scene = scene
end

---@param dt number
function App:update(dt)
    App.scene:update(dt)
end

return App