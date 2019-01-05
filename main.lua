require('app')
local Event = require('enum.event')

---@type table<string, function>
local actions = {}
---@type table<string, function>
local mouseMovedActions = {}

function love.load()
    App.load()

    App.scene:load()
end

function love.update(dt)
    App.update(dt)

    for _,action in pairs(actions) do
        action(dt)
    end
end

function love.mousepressed(x, y, button)
    local action = App.scene.events:findAction(Event.MOUSE, button)
    if action == nil then return end

    local result = action.action(x, y)
    if action.isLong == false or result == nil then
        return
    end
    if action.isMouseMoved then
        mouseMovedActions[button] = result
    else
        actions[button] = result
    end
end

function love.mousereleased(x, y, button)
    actions[button] = nil
    mouseMovedActions[button] = nil

    App.scene.menu:mouseRelease(x, y)
end

function love.wheelmoved(x, y)
    local action = App.scene.events:findAction(Event.WHEEL)
    if action == nil then return end

    action.action(x, y)
end

function love.keypressed(key)
    local action = App.scene.events:findAction(Event.KEY, key)
    if action == nil then return end

    local result = action.action()
    if action.isLong == false or result == nil then
        return
    end
    if action.isMouseMoved then
        mouseMovedActions[key] = result
    else
        actions[key] = result
    end
end

function love.mousemoved(x, y)
    for _,action in pairs(mouseMovedActions) do
        action(x, y)
    end
end

function love.keyreleased(key)
    actions[key] = nil
    mouseMovedActions[key] = nil
end

function love.draw()
    App.scene:draw()
end