-- Main script for meteors game for Playdate

-- IMPORTS --
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"
import "CoreLibs/animator"

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

SCENE_MANAGER = SceneManager()

-- set up title screen
gfx.setFont(DEFAULT_FONT)
TitleScene()
CURRENT_SONG = SONGS.title
CURRENT_SONG:play()


-- runs every frame update (30 fps)
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    -- local spriteCount = gfx.sprite.spriteCount()
    -- print(spriteCount)
end


-- called when menu button is pressed, right before game is paused
-- allows user to select game options when game is paused
function pd.gameWillPause()

    local menu = pd.getSystemMenu()
    
    -- only create menuItem if it doesn't already exist
    menuItemArr = menu:getMenuItems()
    if #menuItemArr == 0 then
        local crankCheckmarkMenuItem, error = menu:addCheckmarkMenuItem("Use crank", CRANK_CONTROLS, updateCrankControls)
        local musicCheckmarkMenuItem, error = menu:addCheckmarkMenuItem("Music on", MUSIC_ON, updateMusicOnOff)
        local languageMenuItem, error = menu:addOptionsMenuItem("Language:", {"en", "jp"}, "en", updateLanguage)
    end

    -- create menu image
    local menuImage = gfx.image.new(400, 240)
    gfx.pushContext(menuImage)
        local pauseText = gfx.getLocalizedText("pause", GAME_LANGUAGE)
        local highScoreText = gfx.getLocalizedText("highScore", GAME_LANGUAGE) .. ": " .. HIGH_SCORE

        gfx.fillRect(0, 0, 200, 240)
        -- draw text as white instead of black
        gfx.setImageDrawMode( gfx.kDrawModeFillWhite)
        gfx.drawTextAligned(pauseText, 100, 100, kTextAlignment.center)
        gfx.drawTextAligned(highScoreText, 100, 130, kTextAlignment.center)
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
