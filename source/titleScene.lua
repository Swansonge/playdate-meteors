-- class that handles title screen behavior

local pd <const> = playdate
local gfx <const> = pd.graphics

import "gameScene"

class('TitleScene').extends(gfx.sprite)

function TitleScene:init()
    self.animating = false

    -- draw in text
    self.textSprite = gfx.sprite.new()    
    self:updateText()
    self.textSprite:moveTo(200, 120)  
    self.textSprite:add()

    -- create image objects for "meteor"
    self.meteorSize = 30
    self.meteorImage = gfx.image.new(self.meteorSize *2, self.meteorSize *2)
    gfx.pushContext(self.meteorImage)
        gfx.fillCircleAtPoint(self.meteorSize, self.meteorSize, self.meteorSize)
    gfx.popContext()
    self.meteorSprite = gfx.sprite.new(self.meteorImage)
    self.meteorSprite:moveTo(70,125)
    self.meteorSprite:add()

    -- create image objects for "player"
    self.playerSide = 50
    local h, x1, y1, x2, y2, x3, y3 = calcVertices(self.playerSide)
    self.playerImage = gfx.image.new(self.playerSide, self.playerSide)
    gfx.pushContext(self.playerImage)
        gfx.fillTriangle(x1, y1, x2, y2, x3, y3)
    gfx.popContext()
    self.playerSprite = gfx.sprite.new(self.playerImage)
    self.playerSprite:moveTo(325,125)
    self.playerSprite:add()
    
    self:add()
end

function TitleScene:update()

    -- change display language if language option changed in the menu
    if LANGUAGE_CHANGED == 1 then
        self:updateText()
        LANGUAGE_CHANGED = 0
    end
    
    -- Start game from title screen
    if pd.buttonJustPressed(pd.kButtonA) then
        if SFX_ON then
            TRANSITION_SFX:play()
        end
        
        TITLE_THEME:stop()
        SCENE_MANAGER:switchScene(GameScene)
    end
end

-- function to update the text display of the title screen. The whole title screen is redrawn
function TitleScene:updateText()

    local titleText = gfx.getLocalizedText("meteors", GAME_LANGUAGE)
    local startText = gfx.getLocalizedText("start", GAME_LANGUAGE)

    local startTextImage = gfx.image.new(400, 240)
    gfx.pushContext(startTextImage)

        -- draw text
        gfx.setFont(TITLE_FONT)
        gfx.drawTextAligned(titleText, 200, 100, kTextAlignment.center)
        gfx.setFont(DEFAULT_FONT)
        gfx.drawTextAligned(startText, 200, 140, kTextAlignment.center)
    gfx.popContext()
    self.textSprite:setImage(startTextImage) 

end