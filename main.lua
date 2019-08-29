require('app')
require('utils.string')
require('utils.table')
require('utils.oop')
require('utils.math')
require('lib.tesound')
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
    -- todo стоит ли так нагружать update ?
    local actions = App.scene.events:findActions(Event.UPDATE) or App.events:findActions(Event.UPDATE)
    triggerEvent(actions, {dt = dt})

    App.update(dt)
    TEsound.cleanup()
end

function love.mousepressed(x, y, button)
    local actions = App.scene.events:findActions(Event.MOUSE, button) or App.events:findActions(Event.MOUSE, button)
    triggerEvent(actions, {x = x, y = y})
end

function love.mousereleased(x, y, button)
    local actions = App.scene.events:findActions(Event.MOUSE_RELEASE, button) or App.events:findActions(Event.MOUSE_RELEASE, button)
    triggerEvent(actions, {x = x, y = y})

    App.scene.menu:mouseRelease(x, y)
end

function love.wheelmoved(x, y)
    local actions = App.scene.events:findActions(Event.WHEEL) or App.events:findActions(Event.WHEEL)
    triggerEvent(actions, {x = x, y = y})
end

function love.keypressed(_, scancode)
    local actions = App.scene.events:findActions(Event.KEY, scancode) or App.events:findActions(Event.KEY, scancode)
    triggerEvent(actions)
end

function love.mousemoved(x, y)
    local actions = App.scene.events:findActions(Event.MOUSE_MOVE) or App.events:findActions(Event.MOUSE_MOVE)
    triggerEvent(actions, {x = x, y = y})
end

function love.keyreleased(_, scancode)
    local actions = App.scene.events:findActions(Event.KEY_RELEASE, scancode) or App.events:findActions(Event.KEY_RELEASE, scancode)
    triggerEvent(actions)
end

function love.draw()
    App.draw()
    App.scene:draw()
end