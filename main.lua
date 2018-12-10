require('app')
local Event = require('enum.event')

---@type table<string, function>
local actions = {}

function love.load()
    App.load()

    App.scene:load(App.camera)
end

function love.update(dt)
    App.update(dt)

    for _,action in pairs(actions) do
        action(dt)
    end
end

function love.wheelmoved(x, y)
    local action = App.scene.events:findAction(Event.WHEEL)
    if action == nil then return end

    action.action(x, y)
end

function love.keypressed(key)
    local action = App.scene.events:findAction(Event.KEY, key)
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
    for i = 1, #App.scene.drawableObjects do
        App.scene:draw(App.scene.drawableObjects[i])
    end
    for i = 1, #App.scene.menuObjects do
        App.scene:drawMenu(App.scene.menuObjects[i])
    end
end