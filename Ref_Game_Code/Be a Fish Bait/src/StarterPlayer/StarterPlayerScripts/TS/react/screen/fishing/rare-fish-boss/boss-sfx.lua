-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local services = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Debris, Players, ReplicatedStorage, SoundService = services.Debris, services.Players, services.ReplicatedStorage, services.SoundService
local t1 = {
    "FishSC_Miss",
    "OkayImpact",
    "GreatImpact",
    "PerfectImpact",
    "RareFishSCFail"
}

local function destroyLegacySoundServiceSfx(p1) -- line: 9
    -- upvalues: SoundService (copy)
    for _, child in SoundService:GetChildren() do
        if child.Name == p1 and child:IsA("Sound") then
            child:Destroy()
        end
    end
end

local function getSfxTemplate(p2) -- line: 17
    -- upvalues: ReplicatedStorage (copy)
    local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild("sfx")
    end

    if Sounds ~= nil then
        Sounds = Sounds:FindFirstChild(p2)
    end

    if Sounds ~= nil and Sounds:IsA("Sound") then
        return Sounds
    end

    warn((("[RareFishBossSfx] ReplicatedStorage.Sounds.sfx.%* not found"):format(p2)))

    return nil
end

local function getSfxParent() -- line: 34
    -- upvalues: Players (copy), SoundService (copy)
    return Players.LocalPlayer:FindFirstChildOfClass("PlayerGui") or SoundService
end

local function playInstantSfx(p3, p4) -- line: 37
    -- upvalues: Debris (copy), Players (copy), SoundService (copy), destroyLegacySoundServiceSfx (copy), getSfxTemplate (copy)
    local v1 = if p4 == nil then 1 else p4

    destroyLegacySoundServiceSfx(p3)

    local v2 = getSfxTemplate(p3)

    if v2 == nil then
        return nil
    end

    local clone = v2:Clone()

    clone.TimePosition = 0
    clone.PlaybackSpeed = v1
    clone.Looped = false
    clone.Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui") or SoundService

    local connection

    connection = clone.Ended:Connect(function() -- line: 52
        -- upvalues: clone (copy), connection (ref)
        connection:Disconnect()
        clone:Destroy()
    end)
    clone:Play()
    Debris:AddItem(clone, (math.max(3, clone.TimeLength + 1)))
end

for _, v4 in t1 do
    destroyLegacySoundServiceSfx(v4)
end

return {
    playRareFishBossSfxCue = function(p5, p6) -- playRareFishBossSfxCue | line: 72
        -- upvalues: playInstantSfx (copy)
        local v5 = if p6 == nil then 1 else p6

        if p5 == "povEnter" or p5 == "promptSpawn" then
            return
        end

        if p5 == "tapPerfect" then
            playInstantSfx("PerfectImpact", v5)
        elseif p5 == "tapGreat" then
            playInstantSfx("GreatImpact", v5)
        elseif p5 == "tapOkay" then
            playInstantSfx("OkayImpact", v5)
        elseif p5 ~= "slideStart" and p5 ~= "slideMove" and p5 ~= "slideComplete" then
            if p5 == "miss" then
                playInstantSfx("FishSC_Miss", v5)
            elseif p5 ~= "fishLunge" and p5 ~= "fishRecoil" and p5 ~= "damageSpot" and p5 ~= "successSurge" and p5 == "failureEscape" then
                playInstantSfx("RareFishSCFail", v5)
            end
        end
    end,
    tapSfxCueForRating = function(p7) -- tapSfxCueForRating | line: 136
        if p7 == "perfect" then
            return "tapPerfect"
        end

        if p7 == "great" then
            return "tapGreat"
        end

        if p7 == "okay" then
            return "tapOkay"
        end

        return "miss"
    end
}
