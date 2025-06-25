-- class that handles game over screen behavior

local pd <const> = playdate
local gfx <const> = pd.graphics

import "gameScene"

class('GameOverScene').extends(gfx.sprite)

local dialogSprite

function GameOverScene:init()
    self.animating = false

    dialogSprite = gfx.sprite.new()
    self:updateText()
    dialogSprite:moveTo(200, 120)
    dialogSprite:add()
    
    self:add()

    CURRENT_SONG = SONGS.game_over
    CURRENT_SONG:play()

    CURRENT_SCENE = "GAME_OVER"
end

function GameOverScene:update()

    -- update language if option changed in the menu
    if LANGUAGE_CHANGED == 1 then
        self:updateText()
        LANGUAGE_CHANGED = 0
    end
    
    -- Start game from title screen
    if pd.buttonJustPressed(pd.kButtonA) then
        if SFX_ON then
            TRANSITION_SFX:play()
        end
        
        GAME_OVER_MUSIC:stop()
        CURRENT_SONG = SONGS.main
        CURRENT_SONG:play()

        SCENE_MANAGER:switchScene(GameScene)
        SCORE = 0
    end
end

-- function to dynamically update display language of text if option is changed in the menu
function GameOverScene:updateText()
    local gameOverText = "*" .. gfx.getLocalizedText("gameOver", GAME_LANGUAGE) .. "*"
    local scoreText = gfx.getLocalizedText("score", GAME_LANGUAGE) .. ": " .. SCORE
    local highScoreText = gfx.getLocalizedText("highScore", GAME_LANGUAGE) .. ": " .. HIGH_SCORE
    local restartText = gfx.getLocalizedText("restart", GAME_LANGUAGE)
    local dialogImage = gfx.image.new(240, 140)
    gfx.pushContext(dialogImage)
        gfx.drawLocalizedTextAligned(gameOverText, 120, 10, kTextAlignment.center)
        gfx.drawTextAligned(scoreText, 120, 40, kTextAlignment.center)
        gfx.drawTextAligned(highScoreText, 120, 70, kTextAlignment.center)
        gfx.drawTextAligned(restartText, 120, 100, kTextAlignment.center)
    gfx.popContext()
    dialogSprite:setImage(dialogImage) 
end
