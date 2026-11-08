-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local HalloweenDimension = require(ReplicatedStorage.Shared.Util.HalloweenDimension)
local ManorInterior = require(ReplicatedStorage.Shared.Util.ManorInterior)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Sounds = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("HalloweenDimension"):WaitForChild("Sounds")
local Inside = ManorInterior.Attributes.Inside
local Attributes, PlayerAttributes = HalloweenDimension.Attributes, HalloweenDimension.PlayerAttributes
local ArenaName = PumpkinBossState.ArenaName
local Phase = PumpkinBossState.Attributes.Phase
local Phases = PumpkinBossState.Phases
local t1 = {
    PumpkinBossPhase1 = "rbxassetid://103655777684859",
    PumpkinBossPhase2 = "rbxassetid://79213406918674"
}
local t2 = {
    [Phases.BruteIntro] = "PumpkinBossPhase1",
    [Phases.Brute] = "PumpkinBossPhase1",
    [Phases.BruteDown] = "PumpkinBossPhase1",
    [Phases.KingIntro] = "PumpkinBossPhase2",
    [Phases.King] = "PumpkinBossPhase2",
    [Phases.Shield] = "PumpkinBossPhase2",
    [Phases.Stunned] = "PumpkinBossPhase2",
    [Phases.Defeated] = "PumpkinBossPhase2"
}

return {
    Start = function(p1) -- Start | line: 61
        -- upvalues: Workspace (copy), Audio (copy), MusicDirector (copy), PumpkinBossState (copy), LocalPlayer (copy), Sounds (copy), Inside (copy), Attributes (copy), PlayerAttributes (copy), ArenaName (copy), Phase (copy), t1 (copy), t2 (copy)
        local t4 = {}
        local t5 = {}
        local t6 = {}
        local t7 = {}
        local v1
        local v2 = false

        local function track(p2) -- line: 69
            -- upvalues: p1 (copy), t4 (copy), t5 (copy), Audio (copy), Sounds (copy), t1 (copy)
            local v3 = t4[p2]

            if v3 ~= nil then
                return v3
            end

            local v4 = Sounds:FindFirstChild(p2)
            local v5 = t1[p2]
            local v6 = v4 ~= nil and v4:IsA("Sound")

            assert(v6 or v5 ~= nil, (("HalloweenDimension sound %* is missing"):format(p2)))

            if v6 then
                v5 = v4.SoundId
            end

            local v9 = Audio.MusicTrack({
                Looped = true,
                Name = ("Halloween%*"):format(p2),
                Source = v5
            })

            p1:Add(v9)
            t4[p2] = v9
            t5[p2] = if v6 then v4.Volume else 0.35

            return v9
        end

        local function fade(p3, p4, p5, p6) -- line: 86
            -- upvalues: t5 (copy), t6 (copy), t7 (copy), track (copy), Audio (copy)
            local v11 = track(p3)
            local v12 = if p4 then t5[p3] else 0
            local v13 = t6[v11]

            if v13 ~= nil then
                v13:Cancel()
            end

            if p4 and not v11.IsPlaying then
                if t7[v11] then
                    v11:Resume()
                else
                    v11.TimePosition = 0
                    v11:Play()
                end
            end

            t7[v11] = nil

            local v14 = Audio.FadeTo(v11, {
                Volume = v12,
                Seconds = p5 or 1.5
            })

            t6[v11] = v14
            v14.Completed:Once(function(p7) -- line: 104
                -- upvalues: p4 (copy), p6 (copy), v11 (copy), v14 (copy), t6 (copy), t7 (copy)
                if t6[v11] == v14 then
                    t6[v11] = nil

                    if p7 == Enum.PlaybackState.Completed and not p4 then
                        if p6 then
                            v11:Pause()
                            t7[v11] = true
                        else
                            v11:Stop()
                        end
                    end
                end
            end)
        end

        local v15

        local function wanted() -- line: 122
            -- upvalues: v15 (ref), Workspace (copy), PumpkinBossState (copy), LocalPlayer (copy), Inside (copy), Attributes (copy), PlayerAttributes (copy), Phase (copy), t2 (copy)
            if LocalPlayer:GetAttribute(PumpkinBossState.MemberAttribute) == true then
                local v16 = if v15 then v15:GetAttribute(Phase) else nil

                return type(v16) == "string" and t2[v16] or "DimensionMusic"
            end

            local Character = LocalPlayer.Character

            if Character ~= nil and Character:GetAttribute("TrainEventInForgottenTown") == true then
                return "ForgottenTownMusic"
            end

            if LocalPlayer:GetAttribute(Inside) == true then
                return "ManorMusic"
            end

            if LocalPlayer:GetAttribute(PlayerAttributes.Inside) ~= true then
                return nil
            end

            local Attribute = Workspace:GetAttribute(Attributes.WorldEvent)

            if type(Attribute) == "string" then
                return Attribute
            end

            return "DimensionMusic"
        end

        local function sync() -- line: 141
            -- upvalues: v1 (ref), v2 (ref), fade (copy), wanted (copy), MusicDirector (copy)
            local v17 = wanted()
            local v18 = MusicDirector.IsSuppressed()

            if v17 == v1 and v18 == v2 then
                return
            end

            local v19 = v1
            local v20 = v2

            v1 = v17
            v2 = v18
            MusicDirector.SetHalloweenDimension(v17 ~= nil)

            if v19 ~= nil and v19 ~= v17 then
                fade(v19, false)
            end

            if v17 ~= nil then
                if v18 then
                    fade(v17, false, 0.5, true)
                elseif v19 ~= v17 or v20 then
                    fade(v17, true)
                end
            end
        end

        local v21 = p1:Extend()

        local function watchCharacter(p8) -- line: 167
            -- upvalues: sync (copy), v21 (copy)
            v21:Clean()

            if p8 ~= nil then
                v21:Connect(p8:GetAttributeChangedSignal("TrainEventInForgottenTown"), sync)
            end

            sync()
        end

        local v22 = p1:Extend()

        local function bindArena(p9) -- line: 178
            -- upvalues: v15 (ref), sync (copy), v22 (copy), Phase (copy)
            v22:Clean()
            v15 = p9

            if p9 ~= nil then
                v22:Connect(p9:GetAttributeChangedSignal(Phase), sync)
            end
        end

        local v23 = Workspace:FindFirstChild(ArenaName)

        v22:Clean()
        v15 = v23

        if v23 ~= nil then
            v22:Connect(v23:GetAttributeChangedSignal(Phase), sync)
        end

        p1:Connect(Workspace.ChildAdded, function(p10) -- line: 187
            -- upvalues: v15 (ref), sync (copy), v22 (copy), ArenaName (copy), Phase (copy)
            if p10.Name ~= ArenaName then
                return
            end

            v22:Clean()
            v15 = p10

            if p10 ~= nil then
                v22:Connect(p10:GetAttributeChangedSignal(Phase), sync)
            end

            sync()
        end)
        p1:Connect(Workspace.ChildRemoved, function(p11) -- line: 193
            -- upvalues: v15 (ref), sync (copy), v22 (copy), Workspace (copy), ArenaName (copy), Phase (copy)
            if p11 ~= v15 then
                return
            end

            local v24 = Workspace:FindFirstChild(ArenaName)

            v22:Clean()
            v15 = v24

            if v24 ~= nil then
                v22:Connect(v24:GetAttributeChangedSignal(Phase), sync)
            end

            sync()
        end)
        p1:Connect(LocalPlayer.CharacterAdded, watchCharacter)
        p1:Connect(LocalPlayer:GetAttributeChangedSignal(PumpkinBossState.MemberAttribute), sync)
        p1:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Inside), sync)
        p1:Connect(LocalPlayer:GetAttributeChangedSignal(Inside), sync)
        p1:Connect(Workspace:GetAttributeChangedSignal(Attributes.WorldEvent), sync)
        p1:Connect(MusicDirector.SuppressedChanged, sync)
        p1:Add(function() -- line: 206
            -- upvalues: t6 (copy), MusicDirector (copy)
            for _, v25 in t6 do
                v25:Cancel()
            end

            MusicDirector.SetHalloweenDimension(false)
        end)

        local Character = LocalPlayer.Character

        v21:Clean()

        if Character ~= nil then
            v21:Connect(Character:GetAttributeChangedSignal("TrainEventInForgottenTown"), sync)
        end

        sync()
    end
}
