-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage:WaitForChild("Shared").GameConfig)
local t1 = {
    Asked = 0,
    AutoCasting = nil
}
local n1 = 0

function t1.Check(p1) -- line: 13
    -- upvalues: ReplicatedStorage (copy), GameConfig (copy), t1 (copy), n1 (ref)
    if not (GameConfig.AFK_REJOIN_SECONDS <= p1 and os.clock() - n1 > 60) then
        return
    end

    n1 = os.clock()
    t1.Asked += 1
    ReplicatedStorage.Remotes.AfkRejoin:FireServer(t1.AutoCasting ~= nil and t1.AutoCasting() == true)
end

function t1.Init() -- line: 21
    -- upvalues: Players (copy), t1 (copy)
    Players.LocalPlayer.Idled:Connect(t1.Check)
end

return t1
