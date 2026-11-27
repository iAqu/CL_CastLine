-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RequestRejoin = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestRejoin")
local n1 = 0

LocalPlayer.Idled:Connect(function(p1) -- line: 23
    -- upvalues: RequestRejoin (copy), n1 (ref)
    local v1 = tonumber(p1)

    if not (v1 and v1 < 900) then
        local elapsed = os.clock()

        if not (n1 > 0 and elapsed - n1 < 30) then
            n1 = elapsed
            RequestRejoin:FireServer()
        end
    end
end)
