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

-- keep track of score across game
SCORE = 0
HIGH_SCORE = 0

-- load in saved data (high score and crank controls)
loadGameDate()
print("high score: " .. HIGH_SCORE)

SCENE_MANAGER = SceneManager()

TitleScene()

-- runs every frame update (30 fps)
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    -- local spriteCount = gfx.sprite.spriteCount
    -- print(spriteCount)

end


-- called when menu button is pressed, right before game is paused
-- allows user to select game options when game is paused
function pd.gameWillPause()

    local menu = pd.getSystemMenu()
    
    -- only create menuItem if it doesn't already exist
    menuItemArr = menu:getMenuItems()
    if #menuItemArr == 0 then
        local checkmarkMenuItem, error = menu:addCheckmarkMenuItem("Use crank", CRANK_CONTROLS, updateCrankControls)
    end

    -- create menu image
    local menuImage = gfx.image.new(400, 240)
    gfx.pushContext(menuImage)
        gfx.fillRect(0, 0, 200, 240)
        -- draw text as white instead of black
        gfx.setImageDrawMode( gfx.kDrawModeFillWhite)
        gfx.drawTextAligned('_Game Paused_', 100, 100, kTextAlignment.center)
        gfx.drawTextAligned('_High score: _' .. HIGH_SCORE, 100, 130, kTextAlignment.center)
        gfx.setImageDrawMode( gfx.kDrawModeCopy)
    gfx.popContext()
    pd.setMenuImage(menuImage)
    
end

-- Playdate documentation recommends saving game data before exiting the game
function pd.gameWillTerminate()
    saveGameData()
end

-- Playdate documentation recommends saving game data before console goes to sleep
function pd.deviceWillSleep()
    saveGameData()
end
