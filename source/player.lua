local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

class('Player').extends(gfx.sprite)

-- Player class initialization function
-- Inputs:
--  xOffset (int) - amount of pixels in x to offset player character by
--  yOffset (int) - amount of pixels in y to offset player character by
--  side (int) - length of the side of a equilateral triangle
function Player:init(xOffset, yOffset, side)

    self.dead = false
    self.speed = 5

    -- drawing player character triangle
    self.side = side
    self.xOffset = xOffset
    self.yOffset = yOffset
    self:calcVertices()
    self.polygon = geom.polygon.new(self.x1, self.y1, self.x2, self.y2, self.x3, self.y3, self.x1, self.y1)
    self.rotateTransform = geom.affineTransform.new()
    self:moveTo(xOffset, yOffset)
    self:add()

    local playerImage = gfx.image.new(self.side, self.side)
    gfx.pushContext(playerImage)
        gfx.fillPolygon(self.polygon)
    gfx.popContext()
    self:setImage(playerImage)

    -- INITIALIZE LITTLE DOT ON TIP OF CHARACTER TO INDIOCATE DIRECTION


end


function Player:update()

    -- use crnak to rotate player
    self:setRotation(self:getRotation() + pd.getCrankChange())

end


-- Function to calculate vertices of equilateral triangle given length of one side
function Player:calcVertices()
    
    -- height of equilateral triangle: h = (1/2) * sqrt(3) * side
    self.h = (1/2) * math.sqrt(3) * self.side
    -- make h an int to fix to pixel length
    self.h = math.floor(self.h)
    
    -- (x1,y1) is top point of (upright) triangle -> (side/2,0)
    self.x1 = self.side / 2
    self.y1 = 0

    -- (x2,y2) is bottom left point, offset from first vertex by -side/2 in the x and h in the y -> (0,h) 
    -- !note: positive y goings downwards on screen
    self.x2 = 0
    self.y2 = self.h

    -- (x3,y3) is bottom right point, offset from first vertex by side/2 in the x and h in the y -> (side,h)
    self.x3 = self.side
    self.y3 = self.h

end