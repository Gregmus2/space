local Scene = require('scenes.scene')

---@class TestScene : Scene
local TestScene = Scene:new()

function TestScene:load()
    if self.isLoaded then
        return
    end
    self.isLoaded = true
end

return TestScene
