-- Main script for meteors game for Playdate

-- IMPORTS --
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"

import "globals"
import "sceneManager"
import "titleScene"
import "gameScene"
import "gameOVerScene"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

SCENE_MANAGER = SceneManager()

TitleScene()

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    -- local spriteCount = gfx.sprite.spriteCount
    -- print(spriteCount)

end
