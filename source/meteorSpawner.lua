-- Script for spawning meteors randomly 
-- Based off code by squidgod: https://github.com/SquidGodDev/InvadersTutorial/blob/main/enemySpawner.lua

local pd <const> = playdate
local gfx <const> = pd.graphics

import "meteor"

local spawnTimer

-- create timer object responsible for delaying spawn of meteors
function createTimer()
    local spawnTime = math.random(500, 700)
    spawnTimer = pd.timer.performAfterDelay(spawnTime, function ()
        createTimer()
        spawnMeteor()
    end)
end

-- create meteor object
function spawnMeteor()
    -- meteors can either come from one of the four sides of the screen. Side is chosen randomly on spawn.
    local spawnSide = math.random(4)
    local spawnX, spawnY, spawnAngle = getSpawnPosAngle(spawnSide)
    Meteor(2, 8, spawnAngle, spawnX, spawnY)
end

function startSpawner()
    math.randomseed(pd.getSecondsSinceEpoch())
    createTimer()
    printTable(pd.timer.allTimers())
end

function stopSpawner()
    if spawnTimer then
        spawnTimer:remove()
    end
end

-- clear all meteors from the screen
function clearMeteors()
    local allSprites = gfx.sprite.getAllSprites()
    for index, sprite in ipairs(allSprites) do
        if sprite:isa(Meteor) then
            sprite:remove()
        end
    end
end

-- Given the side of the screen the meteor will spawn on, get the spawn position and angle of travel
-- angle of travel is opposite the side of the screen where the meteor spawns
-- Inputs:
--  spawnside (int) - int from 1 to 4 denoting which side of the screen the meteor will spawn on
--      1 = top, 2 = right, 3 = bottom, 4 = left
-- Outputs:
--  spawnX (int) - x position of spawn
--  spawnY (int) - y position of spawn
--  spawnAngle (int) - meteor's angle fo travel
function getSpawnPosAngle(spawnSide)

    -- angle is in 180 degree arc spread across center of current side
    if spawnSide == 1 then
        -- top side angle is from Playdate's degrees 90 to 270
        local spawnAngle = math.random(90, 270)
        local spawnX = math.random(10, 390)
        local spawnY = 10
        return spawnX, spawnY, spawnAngle

    elseif spawnSide == 2 then
        -- right side angle is from Playdate's degrees 180 to 0 (-180 to 0)
        local spawnAngle = math.random(-180, 0)
        local spawnX = 390
        local spawnY = math.random(10, 230)
        return spawnX, spawnY, spawnAngle

    elseif spawnSide == 3 then
        -- right side angle is from Playdate's degrees 270 to 90 (-90 to 90)
        local spawnAngle = math.random(-90, 90)
        local spawnX = math.random(10, 390)
        local spawnY = 230
        return spawnX, spawnY, spawnAngle

    elseif spawnSide == 4 then
        -- right side angle is from Playdate's degrees 0 to 180
        local spawnAngle = math.random(0, 180)
        local spawnX = 10
        local spawnY = math.random(10, 230)
        return spawnX, spawnY, spawnAngle
    end
end