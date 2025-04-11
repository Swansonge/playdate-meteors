local pd <const> = playdate
local gfx <const> = pd.graphics

class('Meteor').extends(gfx.sprite)

function Meteor:init(speed, size, angle, x, y)

    self.speed = speed
    self.angle = angle
    self.size = size * 2

    -- draw meteor as circle
    local meteorImage = gfx.image.new(self.size * 2, self.size *2)
    gfx.pushContext(meteorImage)
        gfx.drawCircleAtPoint(self.size, self.size, self.size)
    gfx.popContext()
    self:setImage(meteorImage)

    self:setCollideRect(0, 0, self:getSize())
    self:setGroups(METEOR_GROUP)
    self:setCollidesWithGroups({PLAYER_GROUP, BULLET_GROUP})

    self:moveTo(x, y)
    self:add()
end

function Meteor:update()

    local x, y = calcAngleOffset(self.angle, self.speed, 0, 0)
    local newX = self.x + x
    local newY = self.y + y
    local actualX, actualY, collisions, length = self:moveWithCollisions(newX, newY)

    -- handle collisions
    if length > 0 then
        for index, collision in ipairs(collisions) do
            local collidedObject = collision['other']
            if collidedObject:isa(Player) then
                collidedObject:remove()

                setShakeAmount(5)
                -- TRIGGER GAME OVVER!!
            end
        end
        self:remove()
    end

    -- delete when out of bounds 
    if (actualX > 410) or (actualX < -10) or (actualY > 250) or (actualY < -10) then
        self:remove()
    end
    
end