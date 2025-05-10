-- class that handles title screen behavior

local pd <const> = playdate
local gfx <const> = pd.graphics

import "gameScene"

class('TitleScene').extends(gfx.sprite)

function TitleScene:init()
    self.animating = false

    local text = "Press A to start"
    local startImage = gfx.image.new(gfx.getTextSize(text))
    gfx.pushContext(startImage)
        gfx.drawText(text, 0 ,0)
    gfx.popContext()
    local startSprite = gfx.sprite.new(startImage)
    startSprite:moveTo(200, 120)
    startSprite:add()
    
    self:add()
end

function TitleScene:update()
    
    -- Start game from title screen
    if pd.buttonJustPressed(pd.kButtonA) then
        TITLE_THEME:stop()
        SCENE_MANAGER:switchScene(GameScene)
    end
end