-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Preferences = require(ReplicatedStorage.Shared.Preferences)
local Music = ReplicatedStorage.Assets.Sounds:WaitForChild("ScrambleBoss"):WaitForChild("Music")
local v1 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local v2 = TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local t1 = {}

local function trackFor(p1) -- line: 25
    local v3 = p1:GetAttribute("Phase") or "Waiting"

    if v3 == "Defeated" then
        return nil
    end

    if v3 == "Ball" or v3 == "Human" or v3 == "Final" then
        return "PhaseThree"
    end

    if p1:GetAttribute("PhaseTwo") then
        return "PhaseTwo"
    end

    return "PhaseOne"
end

function t1.new(p2, p3, p4) -- line: 38
    -- upvalues: Debris (copy), RunService (copy), SoundService (copy), TweenService (copy), MusicDirector (copy), Preferences (copy), Music (copy), v1 (copy), v2 (copy)
    local t2 = {}
    local t3 = {}
    local t4 = {}
    local v4
    local v5 = false
    local v6 = false

    for _, child in Music:GetChildren() do
        if child:IsA("Sound") then
            local clone = child:Clone()

            t3[clone.Name] = clone.Volume
            clone.Volume = 0
            clone.Parent = SoundService
            t2[clone.Name] = clone
        end
    end

    local function fade(p5, p6, p7) -- line: 56
        -- upvalues: t4 (copy), TweenService (copy)
        local v7 = t4[p5]

        if v7 then
            v7:Cancel()
        end

        if p6 > 0 and not p5.IsPlaying then
            p5.TimePosition = 0
            p5:Play()
        end

        local tween = TweenService:Create(p5, p7, {
            Volume = p6
        })

        t4[p5] = tween
        tween.Completed:Once(function(p8) -- line: 69
            -- upvalues: p5 (copy), p6 (copy), tween (copy), t4 (copy)
            if t4[p5] == tween then
                t4[p5] = nil
            end

            if p8 == Enum.PlaybackState.Completed and p6 <= 0 then
                p5:Stop()
            end
        end)
        tween:Play()
    end

    local function apply() -- line: 80
        -- upvalues: p3 (copy), p4 (copy), t2 (copy), t3 (copy), v4 (ref), v5 (ref), v6 (ref), fade (copy), MusicDirector (copy), v1 (copy), v2 (copy)
        local v8 = p4:InArena()

        if v8 ~= v5 then
            v5 = v8
            MusicDirector.SetEventMusic(v5)
        end

        local v9

        if v6 and v5 then
            local v10 = p3:GetAttribute("Phase") or "Waiting"

            if v10 ~= "Defeated" then
                v9 = if v10 == "Ball" or v10 == "Human" or v10 == "Final" then "PhaseThree" elseif p3:GetAttribute("PhaseTwo") then "PhaseTwo" else "PhaseOne"
            end
        end

        if v9 == v4 then
            return
        end

        local v11 = v4

        v4 = v9

        local v12 = p3:GetAttribute("Phase") == "Defeated"

        for v13, v14 in t2 do
            if v13 == v9 then
                fade(v14, t3[v13], v1)
            elseif v13 == v11 then
                fade(v14, 0, if v12 then v2 else v1)
            end
        end
    end

    p2:Add(Preferences.Observe("Music", function(p9) -- line: 104
        -- upvalues: v6 (ref), apply (copy)
        v6 = p9 ~= false
        apply()
    end))
    p2:Connect(RunService.Heartbeat, apply)
    p2:Add(function() -- line: 111
        -- upvalues: t2 (copy), t4 (copy), v5 (ref), Debris (copy), TweenService (copy), MusicDirector (copy), v1 (copy)
        for _, v15 in t2 do
            local v16 = t4[v15]

            if v16 then
                v16:Cancel()
            end

            TweenService:Create(v15, v1, {
                Volume = 0
            }):Play()
            Debris:AddItem(v15, v1.Time)
        end

        if v5 then
            MusicDirector.SetEventMusic(false)
        end
    end)
    apply()
end

return t1
