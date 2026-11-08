-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Label = "+10K Speed",
    SpeedPowerAward = 10000
}
local v1 = require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Bind("Game.Balance.GroupReward", t1, {
    SpeedPowerAward = true
}, false)

local function updateLabel() -- line: 17
    -- upvalues: v1 (copy)
    v1.Label = if v1.SpeedPowerAward == 10000 then "+10K Speed" else ("+%* Speed"):format((require(game:GetService("ReplicatedStorage").Packages.FormatNumber.Simple).FormatCompact(v1.SpeedPowerAward, ".#")))
end

v1.Label = if v1.SpeedPowerAward == 10000 then "+10K Speed" else ("+%* Speed"):format((require(game:GetService("ReplicatedStorage").Packages.FormatNumber.Simple).FormatCompact(v1.SpeedPowerAward, ".#")))
require(game:GetService("ReplicatedStorage").Shared.Flags.BalanceConfig).Changed:Connect(updateLabel)

return v1
