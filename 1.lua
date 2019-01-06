-- Object layout:
-- id = stringy-name, body = physics-body, shape = physics-shape, sprite = string-index-into-sprite-table

function love.load()
   world = love.physics.newWorld(0, 0, 1024, 600)
   world:setGravity(0, 700)
   world:setMeter(64)
   
   -- Open up a bottle of sprite(s)
   sprites = {}
   sprites["floor"] = love.graphics.newImage("floor.png")
   sprites["man"] = love.graphics.newImage("man.png")
   sprites["brick"] = love.graphics.newImage("brick.png")

   -- Manufacture some delicious objects
   objects = {}
   objects[0] = createRectangleObject("floor", 1024/2, 575, 1024, 50, 0, world, "floor")
   objects[1] = createCircleObject("man", 1024/2, 600/2, 32, 15, world, "man")
   objects[2] = createRectangleObject("brick1", 600, 500, 30, 16, 4, world, "brick")
   objects[3] = createRectangleObject("brick2", 600, 435, 30, 16, 4, world, "brick")
   objects[4] = createRectangleObject("brick3", 600, 484, 30, 16, 4, world, "brick")

   objects[2]["body"]:setFixedRotation(false)
   objects[3]["body"]:setFixedRotation(false)
   objects[4]["body"]:setFixedRotation(false)

   for id = 1, 4 do
      objects[id]["shape"]:setFriction(0.25)
   end
   objects[1]["shape"]:setFriction(0.17)

   local f = love.graphics.newFont(12)
   love.graphics.setFont(f)
   
   love.graphics.setBackgroundColor(131,192,240)
   love.graphics.setMode(1024, 600, false, true, 0)
   
end

function love.update(dt)
   world:update(dt)
   
   if love.keyboard.isDown("up") then
      objects[1]["body"]:applyForce(0, -1000)
   end
   

   if love.keyboard.isDown("right") then
      objects[1]["body"]:applyForce(300,0)
   elseif love.keyboard.isDown("left") then
      objects[1]["body"]:applyForce(-300,0)
   elseif love.keyboard.isDown("escape") then
   end
end

function love.draw()
   local boxwidth, boxheight = getBoxDims(objects[0]["shape"])
   love.graphics.print("theta", 10, 10)
   love.graphics.print(objects[3]["body"]:getAngle(), 50, 50)
   love.graphics.draw(sprites[objects[0]["sprite"]], objects[0]["body"]:getX() - boxwidth / 2, objects[0]["body"]:getY() - boxheight / 2)
   renderCircleObject(1,0)
   renderRectanlgeObject(2)
   renderRectanlgeObject(3)
   renderRectanlgeObject(4)
end

function getBoxDims(shape)
   local x1, y1, x2, y2, x3, y3, x4, y4 = shape:getBoundingBox()
   local boxwidth = x3 - x2 --calculate the width of the box
   local boxheight = (-1) * (y2 - y1) --calculate the height of the box
   return boxwidth, boxheight
end

function createRectangleObject(name, posx, posy, width, height, mass, worldT, spriteID)
   obj = {}
   obj["id"] = name
   obj["body"] = love.physics.newBody(worldT, posx, posy, mass, 0)
   obj["shape"] = love.physics.newRectangleShape(obj["body"], 0, 0, width, height, 0)
   obj["sprite"] = spriteID
   return obj
end

function createCircleObject(name, posx, posy, radius, mass, worldT, spriteID)
   obj = {}
   obj["id"] = name
   obj["body"] = love.physics.newBody(worldT, posx, posy, mass, 0)
   obj["shape"] = love.physics.newCircleShape(obj["body"], 0, 0, radius)
   obj["sprite"] = spriteID
   return obj
end

function renderRectanlgeObject(id)
   love.graphics.push()
   love.graphics.translate(objects[id]["body"]:getX(), objects[id]["body"]:getY())
   love.graphics.rotate(objects[id]["body"]:getAngle())
   local boxwidth, boxheight = getBoxDims(objects[id]["shape"])
   love.graphics.draw(sprites[objects[id]["sprite"]], -boxwidth / 2, -boxheight / 2)   
   love.graphics.pop()
end

function renderCircleObject(id, dOffset)
   if dOffset == nil then
      dOffset = 0
   end
   love.graphics.push()
   love.graphics.translate(objects[id]["body"]:getX(), objects[id]["body"]:getY())
   love.graphics.rotate(math.rad((objects[id]["body"]:getX() + dOffset) % 360))
   
   local radius = objects[id]["shape"]:getRadius()
   
   love.graphics.draw(sprites[objects[id]["sprite"]], -radius, -radius)
   love.graphics.pop()
end
