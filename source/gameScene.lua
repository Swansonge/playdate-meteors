
-- The class that handles initializing everything regarding
-- the actual game scene

local pd <const> = playdate
local gfx <const> = pd.graphics

import "player"
import "meteorSpawner"
import "scoreDisplay"
import "screenShake"

class('GameScene').extends(gfx.sprite)

function GameScene:init()
    math.randomseed(pd.getSecondsSinceEpoch())
    self:setupGame()
end

-- Initial setup of game scene where main action of game takes place
function GameScene:setupGame()
    createScoreDisplay()
    Player(200, 120, 24)
    startSpawner()
    self:add()
end

function GameScene:displayResults()
    local curHeight = GET_CURRENT_HEIGHT()
    -- Taking a screenshot of the last frame of the game
    -- to have that nice fade effect
    local snapshot = gfx.getDisplayImage()
    -- Remembering to reset the draw offset, and therefore
    -- the height!
    gfx.setDrawOffset(0, 0)
    -- We can get rid of everything related to the game
    -- just by calling this, since everything is a sprite.
    -- Nice!
    gfx.sprite.removeAll()
    ResultsDisplay(self, curHeight, snapshot)
end