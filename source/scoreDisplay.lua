-- Script for displaying score to screen originally written by squidgod: https://github.com/SquidGodDev/InvadersTutorial/blob/main/scoreDisplay.lua
-- Edits by Swansonge

local pd <const> = playdate
local gfx <const> = pd.graphics

local scoreSprite
local score

function createScoreDisplay()
    scoreSprite = gfx.sprite.new()
    score = 0
    updateDisplay()
    scoreSprite:setCenter(0, 0)
    scoreSprite:moveTo(320, 4)

    -- make it so score display doesn't shake with screen and objects travel over it 
    scoreSprite:setIgnoresDrawOffset(true)
    scoreSprite:setZIndex(100)
    
    scoreSprite:add()
end

function updateDisplay()
    local scoreText = "Score: " .. score
    local textWidth, textHeight = gfx.getTextSize(scoreText)
    local scoreImage = gfx.image.new(textWidth, textHeight)
    gfx.pushContext(scoreImage)
        gfx.drawText(scoreText, 0, 0)
    gfx.popContext()
    scoreSprite:setImage(scoreImage)
end

function incrementScore(scoreMult)
    score += scoreMult
    updateDisplay()
end

function resetScore()
    score = 0
    updateDisplay()
end