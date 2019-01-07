---@class ParticlesFactory
local ParticlesFactory = {}

---@return ParticleSystem
function ParticlesFactory.getEngineFire(w, direction)
    local img = love.graphics.newImage('resources/particle.jpg')
    local particles = love.graphics.newParticleSystem(img, 5120)
    particles:setParticleLifetime(2, 5)
    particles:setEmissionArea('normal', w, 5, 0)
    particles:setEmissionRate(1000)
    particles:setSizeVariation(0)
    particles:setSpeed(300, 300)
    particles:setDirection(direction)
    particles:setSizes(0.5, 0.3, 0.1)
    particles:setLinearAcceleration(-100, -100, -80, -80)
    particles:setColors(255, 0, 0, 255, 255, 122, 0, 255, 255, 255, 0, 255, 255, 255, 0, 0)

    return particles
end

return ParticlesFactory