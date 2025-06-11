-- class that handles title screen behavior

local pd <const> = playdate
local gfx <const> = pd.graphics

import "gameScene"

local startSprite

class('TitleScene').extends(gfx.sprite)

function TitleScene:init()
    self.animating = false

    startSprite = gfx.sprite.new()    
    self:updateText()
    startSprite:moveTo(200, 120)  
    startSprite:add()
    
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

-- function to update the text display of the title screen
function TitleScene:updateText()

    local text = gfx.getLocalizedText("start", GAME_LANGUAGE)
    local startImage = gfx.image.new(gfx.getTextSize(text))
    gfx.pushContext(startImage)
        gfx.drawText(text, 0 ,0)
    gfx.popContext()
    startSprite:setImage(startImage) 

end