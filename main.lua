require('app')
local Event = require('enum.event')

---@type table<string, function>
local actions = {}
---@type table<string, function>
local mouseMovedActions = {}

function love.load()
    local img = love.graphics.newImage('particle.jpg')
    --[[
        moveTo - двигаться к x, y
        pause - остановить выбрасывание частиц
        reset - удалить выпущенные частицы и сбросить таймер жизни
        setEmissionArea - спавнить только в определенной зоне. args(uniform|normal|ellipse|borderellipse|borderrectangle, отклонение x, отклонение y, угол, directionRelativeToCenter)
        setBufferSize - кол-во частиц, существующих единовременно
        setColors( r1, g1, b1, a1, r2, g2, b2, a2, ..., r8, g8, b8, a8 ) - диапазон цветов
        setDirection(radians) - направление частиц в радианах
        setEmissionRate(rate) - частиц в сек
        setEmitterLifetime(sec) - время жизни эмитера
        setInsertMode(top|bottom|random) - размещение новых частиц на z-оси
        setLinearAcceleration( xmin, ymin, xmax, ymax ) - скорость частиц (направление вперед, назад)
        setLinearDamping( min, max ) - замедление
        setOffset( x, y )
        setParticleLifetime( min sec, max sec )
        setPosition( x, y )
        setQuads( quad1, quad2, ... ) - используется для анимации. квады - это фигуры, которые будет менять частица со временем
        setRelativeRotation
        setRotation( min rad, max rad )
        setSizeVariation
        setSizes( size1, size2, ..., size8 )
        setSpeed( min, max )
        setSpin( min, max )
        setSpinVariation( variation )
        setSpread( spread radians )
        start
        stop
    --]]
    --psystem = love.graphics.newParticleSystem(img, 256)
    --psystem:setParticleLifetime(2, 5)
    --psystem:setEmissionArea('normal', 20, 5, 2.30)
    --psystem:setEmissionRate(50)
    --psystem:setSizeVariation(0)
    --psystem:setSpeed(100, 100)
    --psystem:setDirection(4.18879)
    --psystem:setSizes(0.5, 0.3, 0.1)
    --psystem:setLinearAcceleration(-100, -100, -80, -80) -- Random movement in all directions.
    --psystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.

    img = love.graphics.newImage('white.jpg')
    psystem = love.graphics.newParticleSystem(img, 8224)
    psystem:setParticleLifetime(2, 5)
    psystem:setEmissionArea('normal', 20, 5, 2.30)
    psystem:setEmissionRate(1000)
    psystem:setSizeVariation(0)
    psystem:setSpeed(300, 300)
    psystem:setDirection(4.18879)
    psystem:setSizes(0.5, 0.3, 0.1)
    psystem:setLinearAcceleration(-100, -100, -80, -80) -- Random movement in all directions.
    psystem:setColors(255, 0, 0, 255, 255, 122, 0, 255, 255, 255, 0, 255, 255, 255, 0, 0) -- Fade to transparency.

    App.load()

    App.scene:load()
end

function love.update(dt)
    psystem:update(dt)
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
    for i = 1, #App.scene.drawableObjects do
        App.scene:draw(App.scene.drawableObjects[i])
    end
    App.scene.menu:draw()

    love.graphics.draw(psystem, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end