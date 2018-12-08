local Scene = require('scenes.scene')

---@class LoadScene : Scene
local LoadScene = Scene:new()

---@param camera Camera
function LoadScene:load(camera)
    if self.isLoaded then
        return
    end

    self.isLoaded = true
end

return LoadScene
