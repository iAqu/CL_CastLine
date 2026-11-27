-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local VFXBurst = require(ReplicatedStorage.Modules:WaitForChild("VFXBurst"))
local VFX = ReplicatedStorage:WaitForChild("VFX")
local t1 = {}
local t2 = {
    "KatanaSlash",
    "WitchHex",
    "StickySplat",
    "ZeusZap",
    "NoodleSplash",
    "PlasmaSlash",
    "DrumstickChomp",
    "MeteorImpact"
}

task.spawn(function() -- line: 23
    -- upvalues: ContentProvider (copy), VFXBurst (copy), VFX (copy), t2 (copy)
    local t3 = {}

    for _, v1 in ipairs(t2) do
        local v2 = VFX:WaitForChild(v1, 10)

        if v2 then
            for _, v3 in ipairs(VFXBurst.Emitters(v2)) do
                t3[#t3 + 1] = v3
            end

            local Sound = v2:FindFirstChildOfClass("Sound")

            if Sound then
                t3[#t3 + 1] = Sound
            end
        end
    end

    local function v4() -- line: 33
        -- upvalues: t3 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(t3)
    end

    pcall(v4)
end)

function t1.Play(p1, p2) -- line: 37
    -- upvalues: Players (copy), VFXBurst (copy), VFX (copy)
    local Spear = p1 and p1:FindFirstChild("Spear")
    local HitFx = Spear and Spear:GetAttribute("HitFx")
    local v5 = HitFx and VFX:FindFirstChild(HitFx)

    if not (v5 and p2 and p2.Parent) then
        return
    end

    local Position = p2:GetPivot().Position
    local v7 = math.clamp(p2:GetExtentsSize().Magnitude / 14, 0.7, 4)
    local CurrentCamera = workspace.CurrentCamera
    local v8 = CurrentCamera and CFrame.lookAt(Position, CurrentCamera.CFrame.Position) or CFrame.new(Position)

    if Players.LocalPlayer:GetAttribute("SetReduceFx") ~= true and #VFXBurst.Emitters(v5) ~= 0 then
        VFXBurst.Play(v5, v8, v7)
    end
end

return t1
