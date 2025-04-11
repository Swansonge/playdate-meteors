--Hold global variables and functions
local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry


------ VARIABLES -------
--collision groups
PLAYER_GROUP = 1
BULLET_GROUP = 2
METEOR_GROUP = 3



------ FUNCTIONS -------
-- Calculate position offsets for object moving at an angle. Use formula for calculating position on a circle. 
-- INnputs:
--  angle (float) - angle of rotation of player
--  r (int) - distance from center of player that bullet will spawn from
--  cx (int) - x start point of circle
--  cy (int) - y start point of circle
-- Outputs:
--  x (int) - x offset from player
--  y (int) - y offset from player
function calcAngleOffset(angle, r, cx, cy)
    -- Since 0 is at top of circle (because of crank), formulas for finding point along circle are
    -- x = cx + r * sin(angle_rad)
    -- y = cy - r * cos(angle_rad)

    local x = math.floor(cx + r * math.sin(math.rad(angle)))
    local y  = math.floor(cy - r * math.cos(math.rad(angle)))
    return x, y
end