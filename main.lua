local Params = require('params')
local SpaceScene = require('scenes.space_scene')
local LoadScene = require('scenes.pause_scene')
local Action = require('action')
local App = require('app')
local Event = require('enum.event')

---@type table<string, fun(dt:number):void>
local actions = {}

function love.load()
    App:load()

    App.scene:load(App.camera)

    local changeSceneAction = Action:new(function(dt)
        if App.scene == SpaceScene then
            App:changeScene(LoadScene)
        else
            App:changeScene(SpaceScene)
        end
    end)
    App.events:addEvent(Event.KEY, 'space', changeSceneAction)
end

function love.update(dt)
    App:update(dt)

    for _,action in pairs(actions) do
        action(dt)
    end
end

function love.wheelmoved(x, y)
    -- todo добавить плавность масштабирования
    -- todo вынести в App.events
    App.camera:addScale(y * 0.1)
end

function love.keypressed(key)
    local action = App.scene.events:findAction(Event.KEY, key) or App.events:findAction(Event.KEY, key)
    if action == nil then return end

    if action.isLong then
        actions[key] = action.action
    else
        action.action()
    end
end

function love.keyreleased(key)
    if actions[key] ~= nil then
        actions[key] = nil
    end
end

function love.draw()
    -- todo вынести в App
    for i = 1, #App.scene.drawableObjects do
        local go = App.scene.drawableObjects[i]
        local x, y = go:getPosition()
        local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - go.draw.visibilityRadius
        if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
            go.draw:draw(App.camera, x, y)
        end
    end
end