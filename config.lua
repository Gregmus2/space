local Params = require('params')

---@class Config
---@field public width number
---@field public height number
---@field public msaa number
---@field public debug number
local Config = {}

local path = 'conf.txt';

function Config:load()
    local fileData
    if love.filesystem.getInfo(path) == nil then
        self:writeConfig()
        fileData = Params.default.config
    end
    fileData = fileData or self.readConfig()

    self.width = tonumber(fileData.width)
    self.height = tonumber(fileData.height)
    self.msaa = tonumber(fileData.msaa)
    self.debug = tonumber(fileData.debug)
end

function Config:writeConfig(config)
    config = config or Params.default.config
    local oldConfig = self.readConfig()
    table.mergeAssoc(oldConfig, config)
    local success, message = love.filesystem.write(path, self.tableToConfig(oldConfig))
    if success == false then
        love.window.showMessageBox("Can't write the config file", message, 'error')
    end
end

---@private
---@param configTable table<string, any>
function Config.tableToConfig(configTable)
    local config = '';
    for key, value in pairs(configTable) do
        config = config .. key .. '=' .. value .. '\n'
    end

    return config
end

---@private
---@return table<string, string>
function Config.readConfig()
    local config = {}
    for line in love.filesystem.lines(path) do
        local pos = string.find(line, '=')
        config[string.sub(line, 0, pos - 1)] = string.sub(line, pos + 1)
    end

    return config
end

return Config