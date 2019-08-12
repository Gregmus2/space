local Camera = require('camera')
local Params = require('params')
local Config = require('config')
local MainMenuScene = require('scenes.main_menu_scene')
local Event = require('enum.event')
local EventCollection = require('collection.event_collection')

---@class Resources
---@field public fonts Font[]
Resources = {
    fonts = {},
}

function Resources.load()

end