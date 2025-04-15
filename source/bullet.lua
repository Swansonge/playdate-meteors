local pd <const> = playdate
local gfx <const> = pd.graphics

class('Bullet').extends(gfx.sprite)

-- Bullet class initialization function
-- Inputs:
--  x (int) - starting x position
--  y (int) - starting y position
--  speed (int) - how fast bullet moves each update()
--  angle (float) - angle (degrees) of travel (from player character tip) 
function Bullet:init(x, y, speed, angle)

    self.speed = speed
    self.angle = angle

    -- draw bullet
    local bulletSize = 3
    local bulletImage = gfx.image.new(bulletSize * 2, bulletSize * 2)
    gfx.pushContext(bulletImage)
        gfx.fillCircleAtPoint(bulletSize, bulletSize, bulletSize)
    gfx.popContext()
    self:setImage(bulletImage)

    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(BULLET_GROUP)
    self:setCollidesWithGroups(METEOR_GROUP)

    self:moveTo(x, y)
    self:add()
    
end

function Bullet:update()

    local x, y = calcAngleOffset(self.angle, self.speed, 0, 0)
    local newX = self.x + x
    local newY = self.y + y
    local actualX, actualY, collisions, length = self:moveWithCollisions(newX, newY)

    -- handle collisions
    if length > 0 then
        for index, collision in ipairs(collisions) do
            local collidedObject = collision['other']
            if collidedObject:isa(Meteor) then


                collidedObject:split()
                incrementScore(collidedObject.scoreMult)
                setShakeAmount(2)
            end
        end
        self:remove()
        
    -- delete when out of bounds 
    elseif (actualX > 400) or (actualX < 0) or (actualY > 240) or (actualY < 0) then
        self:remove()
    end
    
end

