-- Main script for meteors game for Playdate

-- IMPORTS --
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "globals"
import "player"
import "meteorSpawner"
import "screenShake"
import "scoreDisplay"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

createScoreDisplay()
PLAYER = Player(200, 120, 32)

local screenShakeSprite = ScreenShake()

startSpawner()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
end

function setShakeAmount(amount)
    screenShakeSprite:setShakeAmount(amount)
end