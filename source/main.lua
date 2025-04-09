-- Main script for meteors game for Playdate

-- IMPORTS --
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "player"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

PLAYER = Player(200, 120, 32)

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end