-- class that handles game over screen behavior

local pd <const> = playdate
local gfx <const> = pd.graphics

import "gameScene"
import "scoreDisplay"

class('GameOverScene').extends(gfx.sprite)

function GameOverScene:init()
    self.animating = false

    local gameOverText = "*GAME OVER*"
    local scoreText = "Score: " .. SCORE
    local restartText = "Press A to restart"
    local dialogImage = gfx.image.new(240, 140)
    gfx.pushContext(dialogImage)
        gfx.drawTextAligned(gameOverText, 120, 10, kTextAlignment.center)
        gfx.drawTextAligned(scoreText, 120, 40, kTextAlignment.center)
        gfx.drawTextAligned(restartText, 120, 70, kTextAlignment.center)
    gfx.popContext()
    local dialogSprite = gfx.sprite.new(dialogImage)
    dialogSprite:moveTo(200, 120)
    dialogSprite:add()
    
    self:add()
end

function GameOverScene:update()
    
    -- Start game from title screen
    if pd.buttonJustPressed(pd.kButtonA) then
        print('pressed the button')
        SCENE_MANAGER:switchScene(GameScene)
    end
end

function GameOverScene:clearGame()

end