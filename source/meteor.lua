local pd <const> = playdate
local gfx <const> = pd.graphics

class('Meteor').extends(gfx.sprite)

function Meteor:init(speed, size, angle, scoreMult, x, y)

    self.speed = speed
    self.angle = angle
    self.size = size * 2
    --default value from spawner is 1. Worth more then meteor splits
    self.scoreMult = scoreMult
    -- indicates direction of movement
    self.dir = 1

    -- draw meteor as circle
    local meteorImage = gfx.image.new(self.size * 2, self.size *2)
    gfx.pushContext(meteorImage)
        gfx.drawCircleAtPoint(self.size, self.size, self.size)
    gfx.popContext()
    self:setImage(meteorImage)

    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(METEOR_GROUP)
    self:setCollidesWithGroups({PLAYER_GROUP, BULLET_GROUP, METEOR_GROUP})

    self:moveTo(x, y)
    self:add()
end

function Meteor:update()

    local x, y = calcAngleOffset(self.angle, self.speed, 0, 0)
    local newX = self.x + x * self.dir
    local newY = self.y + y * self.dir
    local actualX, actualY, collisions, length = self:moveWithCollisions(newX, newY)

    -- handle collisions
    if length > 0 then
        for index, collision in ipairs(collisions) do
            local collidedObject = collision['other']
            if collidedObject:isa(Player) then
                collidedObject:remove()

                setShakeAmount(5)
                self:remove()
                -- TRIGGER GAME OVVER!!

            elseif collidedObject:isa(Bullet) then
                self:split()
                setShakeAmount(2)
                self:remove()

            elseif collidedObject:isa(Meteor) then
                -- reverse direction of movement
                self.dir *= -1

            end
        end
        
    end

    -- delete when out of bounds 
    if (actualX > 410) or (actualX < -10) or (actualY > 250) or (actualY < -10) then
        self:remove()
    end
    
end

-- Method to be called when meteor needs to be split in 2. Called when collides with bullet.
-- Create the 2 meteors perpendicular to angle of travel of meteor
function Meteor:split()

    -- use parameters from big meteor to create parameters for smaller meteors
    local newSpeed = self.speed + 1
    local newSize = self.size / 4
    local newAngle1 = self.angle - 90
    local newAngle2 = self.angle + 90

    if newSize >= 1 then
        -- create smaller meteors
        Meteor(newSpeed, newSize, newAngle1, self.scoreMult*2, self.x, self.y)
        Meteor(newSpeed, newSize, newAngle2, self.scoreMult*2, self.x, self.y)
    end

    -- remove big meteor
    self:remove()

end


--collisionResponse callback for sprite. Called by moveWithCollisions()
--if colliding with another meteor, bounce. If colliding with another object, freeze (object will be removed)
function Meteor:collisionResponse(other)
    if other:isa(Meteor) then
        return "bounce"
    else
        return "bounce"
    end

end