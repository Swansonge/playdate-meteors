local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

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
    self:moveTo(x, y)
    self:add()
    
end

function Bullet:update()

    local x, y = calcBulletOffset(self.angle, self.speed, 0, 0)
    local newX = self.x + x
    local newY = self.y + y
    local actualX, actualY, collisions, length = self:moveWithCollisions(newX, newY)

    -- handle collisions
    if length > 0 then
        -- for index, collision in ipairs(collisions) do
        --     local collidedObject = collision['other']
        --     if collidedObject:isa(Enemy) then
        --         collidedObject:remove()
        --         incrementScore()
        --         setShakeAmount(5)
        --     end
        -- end
        self:remove()

    -- delete when out of bounds 
    elseif (actualX > 400) or (actualX < 0) or (actualY > 240) or (actualY < 0) then
        self:remove()
    end
    
end

-- Calculate bullet position offsets from player. Use formula for calculating position on a circle. 
-- INnputs:
--  angle (float) - angle of rotation of player
--  r (int) - distance from center of player that bullet will spawn from
--  cx (int) - x start point of circle
--  cy (int) - y start point of circle
-- Outputs:
--  x (int) - x offset from player
--  y (int) - y offset from player
function calcBulletOffset(angle, r, cx, cy)
    -- Since 0 is at top of circle (because of crank), formulas for finding point along circle are
    -- x = cx + r * sin(angle_rad)
    -- y = cy - r * cos(angle_rad)

    local x = math.floor(cx + r * math.sin(math.rad(angle)))
    local y  = math.floor(cy - r * math.cos(math.rad(angle)))
    return x, y
end