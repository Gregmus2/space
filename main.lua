require('app')
require('utils.string')
require('utils.table')
local Event = require('enum.event')

---@param actions function[]
---@param params table|nil
local function triggerEvent(actions, params)
    if actions == nil then return end
    for _, action in pairs(actions) do
        action(params)
    end
end

function love.load()
    App.load()
    App.scene:load()
end

function love.update(dt)
    local actions = App.scene.events:findActions(Event.UPDATE)
    triggerEvent(actions, {dt = dt})

    App.update(dt)
end

function love.mousepressed(x, y, button)
    local actions = App.scene.events:findActions(Event.MOUSE, button)
    triggerEvent(actions, {x = x, y = y})
end

function love.mousereleased(x, y, button)
    local actions = App.scene.events:findActions(Event.MOUSE_RELEASE, button)
    triggerEvent(actions, {x = x, y = y})

    App.scene.menu:mouseRelease(x, y)
end

function love.wheelmoved(x, y)
    local actions = App.scene.events:findActions(Event.WHEEL)
    triggerEvent(actions, {x = x, y = y})
end

function love.keypressed(key)
    local actions = App.scene.events:findActions(Event.KEY, key)
    triggerEvent(actions)
end

function love.mousemoved(x, y)
    local actions = App.scene.events:findActions(Event.MOUSE_MOVE)
    triggerEvent(actions, {x = x, y = y})
end

function love.keyreleased(key)
    local actions = App.scene.events:findActions(Event.KEY_RELEASE, key)
    triggerEvent(actions)
end

function love.draw()
    App.scene:draw()
end