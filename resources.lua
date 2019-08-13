require('utils.os')

---@class Resources
---@field public fonts Font[]
Resources = {
    fonts = {},
}

FONT_CASANOVA = 'CasanovaScotia.ttf';

function Resources:load()
    for i, v in ipairs(scandir('resources/fonts')) do
        self.fonts[v] = {}
    end
end

---@param name string
---@param size number
function Resources:getFont(name, size)
    if self.fonts[name][size] == nil then
        self.fonts[name][size] = love.graphics.newFont('resources/fonts/' .. name, size)
    end

    return self.fonts[name][size]
end