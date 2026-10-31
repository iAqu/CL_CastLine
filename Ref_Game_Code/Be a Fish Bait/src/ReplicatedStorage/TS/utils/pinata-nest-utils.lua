-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local specialEvents = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "special-events").specialEvents
local rollPinataBossDifficultyForSlot = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "pinata-boss-utils").rollPinataBossDifficultyForSlot

return {
    pinataWhirlpoolSpinWindowSeconds = 8,
    getNextPinataBossSchedule = function(p1, p2, p3) -- getNextPinataBossSchedule | line: 21
        -- upvalues: specialEvents (copy), rollPinataBossDifficultyForSlot (copy)
        local cooldown = specialEvents.PinataBoss.cooldown

        if p2 then
            return {
                isLive = true,
                timeRemaining = 0,
                difficulty = rollPinataBossDifficultyForSlot(p2.startTimestamp, cooldown),
                slotStart = p2.startTimestamp
            }
        end

        local v1 = if p3 == nil then p1 else p3

        return {
            isLive = false,
            difficulty = rollPinataBossDifficultyForSlot(v1, cooldown),
            slotStart = v1,
            timeRemaining = math.max(0, v1 - p1)
        }
    end
}
