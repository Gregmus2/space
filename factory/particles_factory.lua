---@class ParticlesFactory
local ParticlesFactory = {}

---@return ParticleSystem
function ParticlesFactory.getEngineFire(w)
    -- todo можно заменить на canvas, если это будет быстрее
    --[[
        p = graphics.newCanvas(PSIZE, PSIZE)
        p:renderTo(function()
            graphics.circle('fill', PSIZE/2, PSIZE/2, PSIZE/2-2, 100)
        end)
    ]]--
    local img = love.graphics.newImage('resources/particle.jpg')
    local particles = love.graphics.newParticleSystem(img, 5120)
    particles:setParticleLifetime(2, 5)
    particles:setEmissionArea('normal', w, w, 0)
    particles:setEmissionRate(1000)
    particles:setSizeVariation(0)
    particles:setSpeed(300, 300)
    particles:setSizes(0.5, 0.3, 0.1)
    particles:setColors(255, 0, 0, 255, 255, 122, 0, 255, 255, 255, 0, 255, 255, 255, 0, 0)

    return particles
end

return ParticlesFactory