--Hold global variables and functions
local pd <const> = playdate
local gfx <const> = pd.graphics
local geom <const> = playdate.geometry

import "scripts/meteorSpawner"
import "scripts/gameOverScene"



------ VARIABLES -------
--collision groups
PLAYER_GROUP = 1
BULLET_GROUP = 2
METEOR_GROUP = 3

-- keep track of game options/settings. All on (true) by default
CRANK_CONTROLS = true 
MUSIC_ON = true
SFX_ON = true
GAME_LANGUAGE = 'en'
-- flag for keeping track of when language changes so it can be updated after exiting pause menu
LANGUAGE_CHANGED = 0
-- flag for using UI to draw crank indicator
DRAW_CRANK = 1

-- fonts
DEFAULT_FONT = playdate.graphics.font.new("fonts/Asheville-Sans-14-Light")
TITLE_FONT = playdate.graphics.font.new("fonts/Asheville-Sans-24-Light")

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

-- keep track of current scene
CURRENT_SCENE = "NIL"


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

-- callback function called by menu:addOptionMenuItem() in pd.gameWillPause() if option is changed while using menu. call before pd.gameWillResume()
-- change game language
function updateLanguage(value)
    GAME_LANGUAGE = value
    LANGUAGE_CHANGED = 1
    print("current game language " .. GAME_LANGUAGE)
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

-- callback function when the timer for crank UI has ended
function uiTimerCallback()
    DRAW_CRANK = 0
end


-- Function to calculate vertices of equilateral triangle given length of one side
-- Inputs:
--  side (int) - length of the side of triangle
-- Outputs:
--  h (int) - height of the triangle
--  x1 (int) - x position of top vertex
--  y1 (int) - y position of top vertex
--  x2 (int) - x position of bottom left vertex
--  y2 (int) - y position of bottom left vertex
--  x3 (int) - x position of bottom right vertex
--  y3 (int) - y position of bottom right vertex
function calcVertices(side)
    
    -- height of equilateral triangle: h = (1/2) * sqrt(3) * side
    local h = (1/2) * math.sqrt(3) * side
    -- make h an int to fix to pixel length
    h = math.floor(h)
    
    -- (x1,y1) is top point of (upright) triangle -> (side/2,0)
    local x1 = (side / 2)
    local y1 = 0

    -- (x2,y2) is bottom left point, offset from first vertex by -side/2 in the x and h in the y -> (0,h) 
    -- !note: positive y goings downwards on screen
    local x2 = 0
    local y2 = h

    -- (x3,y3) is bottom right point, offset from first vertex by side/2 in the x and h in the y -> (side,h)
    local x3 = side
    local y3 = h

    return h, x1, y1, x2, y2, x3, y3

end