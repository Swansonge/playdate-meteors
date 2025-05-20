--Hold global variables and functions
local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

import "meteorSpawner"
import "gameOverScene"



------ VARIABLES -------
--collision groups
PLAYER_GROUP = 1
BULLET_GROUP = 2
METEOR_GROUP = 3

-- keep track of game options/settings. All on (true) by default
CRANK_CONTROLS = true 
MUSIC_ON = true
SFX_ON = true

-- audio
TITLE_THEME = pd.sound.fileplayer.new("music/meteors-title-theme")
MAIN_MUSIC = pd.sound.fileplayer.new("music/meteors-game-music")
MAIN_MUSIC:setVolume(0.8)
GAME_OVER_MUSIC = pd.sound.fileplayer.new("music/meteors-game-over")
SHOOT_SFX = pd.sound.sampleplayer.new("sfx/shoot")
TRANSITION_SFX = pd.sound.sampleplayer.new("sfx/transition")
METEOR_EXPLODE_SFX = pd.sound.sampleplayer.new("sfx/meteor_explode")
PLAYER_DESTROYED_SFX = pd.sound.sampleplayer.new("sfx/player_destroyed")
-- keep track of current song playing to be able to pause/unpause
CURRENT_SONG = nil
SONGS = {
    title = TITLE_THEME,
    main = MAIN_MUSIC,
    game_over = GAME_OVER_MUSIC
}


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

--called when game over is triggered
function gameOver()
    MAIN_MUSIC:stop()
    stopSpawner()
    updateHighScore()
    SCENE_MANAGER:switchScene(GameOverScene)
end

-- callback function called by menu:addCheckmarkMenuItem() in pd.gameWillPause() if checkMark is changed while using menu. call before pd.gameWillResume()
-- sets crank controls on/off
function updateCrankControls(value)
    CRANK_CONTROLS = value
    print("Crank controls changed to: ", CRANK_CONTROLS)
end

-- callback function called by menu:addCheckmarkMenuItem() in pd.gameWillPause() if checkMark is changed while using menu. call before pd.gameWillResume()
-- sets music on/off. This function will actually turn off/on music, not just set the flag.
function updateMusicOnOff(value)
    CURRENT_SONG:stop()
    MUSIC_ON = value
    if MUSIC_ON then
        CURRENT_SONG:play()
    end
    print("music turned on? ", MUSIC_ON)
end

-- callback function called by menu:addCheckmarkMenuItem() in pd.gameWillPause() if checkMark is changed while using menu. call before pd.gameWillResume()
-- sets sound effects on/off
function updateSfxOnOff(value)
    SFX_ON = value
    print("Sound effects turned on? ", SFX_ON)
end

-- save game data
function saveGameData()
    local gameData = {
        highscore = HIGH_SCORE,
        crankcontrols = CRANK_CONTROLS
    }
    pd.datastore.write(gameData)
end

-- load game data when re-opening game
function loadGameDate()
    local gameData = pd.datastore.read()
    if gameData then
        HIGH_SCORE = gameData.highscore
        CRANK_CONTROLS = gameData.crankcontrols
    end
end

-- function checks if current score is greater than saved high score.
-- If so, update high score
function updateHighScore()
    if SCORE > HIGH_SCORE then
        HIGH_SCORE = SCORE
    end
end