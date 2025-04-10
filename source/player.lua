local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

import "bullet"

class('Player').extends(gfx.sprite)

-- Player class initialization function
-- Inputs:
--  xOffset (int) - amount of pixels in x to offset player character by
--  yOffset (int) - amount of pixels in y to offset player character by
--  side (int) - length of the side of a equilateral triangle
function Player:init(xOffset, yOffset, side)

    self.dead = false
    self.speed = 5

    -- create player character triangle
    self.side = side
    self.xOffset = xOffset
    self.yOffset = yOffset
    local hBig, x1Big, y1Big, x2Big, y2Big, x3Big, y3Big = calcVertices(self.side)
    self.h = hBig
    self.polygon = geom.polygon.new(x1Big, y1Big, x2Big, y2Big, x3Big, y3Big, x1Big, y1Big)    

    -- create small inner triangle on top of main player character
    local smallSide = math.floor(side / 3)
    local sideOffset = (self.side/2) - (smallSide/2)
    local hSmall, x1Small, y1Small, x2Small, y2Small, x3Small, y3Small = calcVertices(smallSide)
    self.hSmall = hSmall
    self.smallPolygon = geom.polygon.new(x1Small + sideOffset, y1Small, x2Small + sideOffset, y2Small, x3Small + sideOffset, y3Small, x1Small + sideOffset, y1Small)

    -- draw both triangles in one image
    local playerImage = gfx.image.new(self.side, self.side)
    gfx.lockFocus(playerImage)
        gfx.drawPolygon(self.polygon)
        gfx.fillPolygon(self.smallPolygon)
    gfx.unlockFocus()
    self:setImage(playerImage)
    self:moveTo(xOffset, yOffset)
    self:add()    

end


function Player:update()

    -- use crank to rotate player
    self:setRotation(self:getRotation() + pd.getCrankChange())     

    -- shoot bullets
    if pd.buttonJustPressed(pd.kButtonA) then

        local x, y = calcBulletOffset(self:getRotation(), (self.h / 2) - 1, 0, -h/2)
        local bulletX = self.x + x
        local bulletY = self.y + y
        Bullet(bulletX, bulletY, 5, self:getRotation())
        
    end

end


-- Function to calculate vertices of equilateral triangle given length of one side
-- Inputs:
--  side (int) - length of the side of triangle
-- Outputs:
--  h (int) - height of the triangle
--  x1 (int) - x position of top vertex
--  y1 (int) - y position of top vertex
--  x2 (int) - x position of bottom left vertex
--  y2 (int) - y position of bottom left vertex
--  x3 (int) - x position of bottom right vertex
--  y3 (int) - y position of bottom right vertex
function calcVertices(side, xOffset, yOffset)
    
    -- height of equilateral triangle: h = (1/2) * sqrt(3) * side
    h = (1/2) * math.sqrt(3) * side
    -- make h an int to fix to pixel length
    h = math.floor(h)
    
    -- (x1,y1) is top point of (upright) triangle -> (side/2,0)
    x1 = (side / 2)
    y1 = 0

    -- (x2,y2) is bottom left point, offset from first vertex by -side/2 in the x and h in the y -> (0,h) 
    -- !note: positive y goings downwards on screen
    x2 = 0
    y2 = h

    -- (x3,y3) is bottom right point, offset from first vertex by side/2 in the x and h in the y -> (side,h)
    x3 = side
    y3 = h

    return h, x1, y1, x2, y2, x3, y3

end