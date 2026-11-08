-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ScrambleTradeInFlags = require(ReplicatedStorage.Shared.Flags.ScrambleTradeInFlags)
local t1 = {
    IsExpired = function() -- IsExpired | line: 10
        -- upvalues: Workspace (copy), ScrambleTradeInFlags (copy)
        local v1 = ScrambleTradeInFlags.LeavesAtUnix:Get()

        if v1 > 0 then
            return v1 <= Workspace:GetServerTimeNow()
        end

        return false
    end,
    SecondsLeft = function() -- SecondsLeft | line: 15
        -- upvalues: Workspace (copy), ScrambleTradeInFlags (copy)
        local v2 = ScrambleTradeInFlags.LeavesAtUnix:Get()

        if v2 <= 0 then
            return 0
        end

        return (math.max(math.ceil(v2 - Workspace:GetServerTimeNow()), 0))
    end,
    Text = function(p1) -- Text | line: 23
        return string.format("Leaves in %02d:%02d:%02d", p1 // 3600, p1 % 3600 // 60, p1 % 60)
    end
}

return table.freeze(t1)
