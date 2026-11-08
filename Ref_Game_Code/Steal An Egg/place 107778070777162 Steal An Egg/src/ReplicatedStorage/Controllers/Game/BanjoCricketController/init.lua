-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Aim = require(script.Aim)
local Band = require(script.Band)
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local BanjoCricketFlags = require(ReplicatedStorage.Shared.Flags.BanjoCricketFlags)
local Bridge = require(script.Bridge)
local Dream = require(script.Dream)
local Mushrooms = require(script.Mushrooms)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Reveal = require(script.Reveal)
local Save = require(ReplicatedStorage.Shared.Save)
local Sounds = require(script.Sounds)
local Spores = require(script.Spores)
local Talk = require(script.Talk)
local Timer = require(ReplicatedStorage.Packages.Timer)

return {
    Start = function() -- Start | line: 44
        -- upvalues: Players (copy), Aim (copy), Band (copy), BanjoCricket (copy), BanjoCricketFlags (copy), Bridge (copy), Dream (copy), Mushrooms (copy), Remotes (copy), Reveal (copy), Save (copy), Sounds (copy), Spores (copy), Talk (copy), Timer (copy)
        local LocalPlayer = Players.LocalPlayer
        local v1 = Random.new()
        local v2 = "Idle"
        local n1 = 0
        local n2 = 0
        local t2
        local n3 = 0
        local n4 = 0

        local function sing(p1) -- line: 54
            -- upvalues: BanjoCricket (copy), Mushrooms (copy), Sounds (copy), Spores (copy)
            Mushrooms.Flash(p1, BanjoCricket.Timing.Note)
            Mushrooms.Move(p1, "Bounce")
            Sounds.Note(p1)
            Spores.Puff(p1)
        end

        local function mute(p2) -- line: 61
            -- upvalues: Mushrooms (copy), Sounds (copy)
            Mushrooms.Move(p2, "Squish")
            Sounds.Muted(p2)
        end

        local function predict(p3) -- line: 68
            -- upvalues: v2 (ref), t2 (ref), n3 (ref), BanjoCricket (copy), Mushrooms (copy), Sounds (copy), Spores (copy)
            local elapsed = os.clock()

            n3 = elapsed

            if v2 == "Busy" or v2 == "Showing" then
                Mushrooms.Move(p3, "Squish")
                Sounds.Muted(p3)
                t2 = {
                    Kind = "Muted",
                    Mushroom = p3,
                    At = elapsed
                }
            else
                Mushrooms.Flash(p3, BanjoCricket.Timing.Note)
                Mushrooms.Move(p3, "Bounce")
                Sounds.Note(p3)
                Spores.Puff(p3)
                t2 = {
                    Kind = "Note",
                    Mushroom = p3,
                    At = elapsed
                }
            end
        end

        local function wasPredicted(p4, p5) -- line: 80
            -- upvalues: t2 (ref)
            local t3 = t2

            if t3 == nil or t3.Kind ~= p4 or t3.Mushroom ~= p5 or os.clock() - t3.At > 1.2 then
                return false
            end

            t2 = nil

            return true
        end

        local function playback(p6) -- line: 94
            -- upvalues: v2 (ref), n1 (ref), n2 (ref), BanjoCricket (copy), Mushrooms (copy), Sounds (copy), Spores (copy)
            n1 += 1

            local v3 = n1

            v2 = "Showing"
            Mushrooms.Darken()
            Mushrooms.SetProgress(n2, true)

            local Timing = BanjoCricket.Timing
            local v4 = BanjoCricket.PlaybackSeconds(#p6)

            Sounds.Duck(v4 + 0.5)

            for v5, v6 in p6 do
                local v7 = (v5 - 1) * (Timing.Note + Timing.NoteGap)

                task.delay(v7, function() -- line: 105
                    -- upvalues: v3 (copy), v6 (copy), n1 (ref), BanjoCricket (copy), Mushrooms (copy), Sounds (copy), Spores (copy)
                    if n1 ~= v3 then
                        return
                    end

                    Mushrooms.Flash(v6, BanjoCricket.Timing.Note)
                    Mushrooms.Move(v6, "Bounce")
                    Sounds.Note(v6)
                    Spores.Puff(v6)
                end)
            end

            task.delay(v4, function() -- line: 111
                -- upvalues: v3 (copy), v2 (ref), n1 (ref), Mushrooms (copy)
                if n1 == v3 then
                    v2 = "Listening"
                    Mushrooms.Pulse()
                end
            end)
        end

        local function fail(p7) -- line: 127
            -- upvalues: v2 (ref), n1 (ref), n2 (ref), t2 (ref), BanjoCricket (copy), Mushrooms (copy), Sounds (copy), Spores (copy)
            n1 += 1

            local v8 = n1

            v2 = "Busy"
            t2 = nil
            n2 = 0
            Mushrooms.Dim()
            Mushrooms.MoveAll("Shake")
            Sounds.Fail(p7)
            Spores.Wilt()
            Mushrooms.SetProgress(n2, true)

            local WrongPause = BanjoCricket.Timing.WrongPause

            task.delay(math.max(WrongPause - 0.3, 0), function() -- line: 120
                -- upvalues: v8 (copy), n1 (ref), Mushrooms (copy)
                if n1 == v8 then
                    Mushrooms.Darken()
                end
            end)
        end

        local function clearStage(p8) -- line: 141
            -- upvalues: v2 (ref), n1 (ref), n2 (ref), BanjoCricket (copy), BanjoCricketFlags (copy), Mushrooms (copy), Reveal (copy), Sounds (copy), Spores (copy)
            n1 += 1

            local v10 = n1

            v2 = "Busy"
            n2 = p8
            Mushrooms.SetProgress(n2, true)
            Sounds.Run()
            Spores.Spiral()
            Reveal.Strain(p8 / BanjoCricketFlags.Stages:Get())
            task.delay(0.35, function() -- line: 150
                -- upvalues: v10 (copy), n1 (ref), Mushrooms (copy)
                if n1 == v10 then
                    Mushrooms.Dim()
                end
            end)

            local StagePause = BanjoCricket.Timing.StagePause

            task.delay(math.max(StagePause - 0.3, 0), function() -- line: 120
                -- upvalues: v10 (copy), n1 (ref), Mushrooms (copy)
                if n1 == v10 then
                    Mushrooms.Darken()
                end
            end)
        end

        local function onEffect(p9) -- line: 158
            -- upvalues: v2 (ref), n1 (ref), n2 (ref), t2 (ref), playback (copy), fail (copy), clearStage (copy), BanjoCricket (copy), BanjoCricketFlags (copy), Mushrooms (copy), Reveal (copy), Sounds (copy), Spores (copy)
            if p9.Kind == "Note" then
                local Mushroom = p9.Mushroom
                local t4 = t2
                local v12 = false

                if t4 ~= nil then
                    if t4.Kind ~= "Note" or t4.Mushroom ~= Mushroom or os.clock() - t4.At > 1.2 then
                    else
                        t2 = nil
                        v12 = true
                    end
                end

                if not v12 then
                    local Mushroom = p9.Mushroom

                    Mushrooms.Flash(Mushroom, BanjoCricket.Timing.Note)
                    Mushrooms.Move(Mushroom, "Bounce")
                    Sounds.Note(Mushroom)
                    Spores.Puff(Mushroom)
                end

                if v2 == "Idle" then
                    v2 = "Busy"
                end
            elseif p9.Kind == "Muted" then
                local Mushroom = p9.Mushroom
                local t5 = t2
                local v13 = false

                if t5 ~= nil then
                    if t5.Kind ~= "Muted" or t5.Mushroom ~= Mushroom or os.clock() - t5.At > 1.2 then
                    else
                        t2 = nil
                        v13 = true
                    end
                end

                if not v13 then
                    local Mushroom = p9.Mushroom

                    Mushrooms.Move(Mushroom, "Squish")
                    Sounds.Muted(Mushroom)
                end
            elseif p9.Kind == "Wrong" then
                fail(p9.Mushroom)
            elseif p9.Kind == "Playback" then
                playback(p9.Notes)
            elseif p9.Kind == "StageComplete" then
                clearStage(p9.Cleared)
            elseif p9.Kind == "Reset" then
                n1 += 1
                v2 = "Idle"
                t2 = nil
                n2 = 0
                Mushrooms.Darken()
                Mushrooms.SetProgress(n2, false)
            elseif p9.Kind == "Solved" then
                n1 += 1
                v2 = "Solved"
                n2 = BanjoCricketFlags.Stages:Get()
                Mushrooms.SetProgress(n2, true)
                Reveal.Play()
            end
        end

        local function onBump(p10) -- line: 192
            -- upvalues: v2 (ref), n3 (ref), Mushrooms (copy), Sounds (copy)
            if v2 ~= "Idle" and v2 ~= "Solved" then
                return
            end

            n3 = os.clock()
            Mushrooms.Move(p10, "Squish")
            Sounds.Soft(p10)
        end

        local function invite() -- line: 202
            -- upvalues: LocalPlayer (copy), v1 (copy), v2 (ref), n3 (ref), n4 (ref), BanjoCricketFlags (copy), Mushrooms (copy), Sounds (copy)
            local elapsed = os.clock()

            if v2 == "Idle" and not (elapsed < n4) and not (elapsed - n3 < 6) and BanjoCricketFlags.Enabled:Get() then
                local Character = LocalPlayer.Character
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") and not (Mushrooms.DistanceFrom(HumanoidRootPart.Position) > 35) then
                    local v14 = Mushrooms.RandomIndex(v1)

                    if v14 ~= nil then
                        n4 = elapsed + v1:NextNumber(4, 7)
                        Mushrooms.Move(v14, "Hop")
                        Sounds.Soft(v14, -1)
                    end
                end
            end
        end

        local function applySaved() -- line: 230
            -- upvalues: v2 (ref), n2 (ref), BanjoCricketFlags (copy), Mushrooms (copy), Reveal (copy), Save (copy), Talk (copy)
            local v15 = Save.Peek()

            if v15 == nil then
                return
            end

            local BanjoCricket = v15.BanjoCricket

            if not BanjoCricket.Solved or v2 == "Solved" then
                if not BanjoCricket.Solved and v2 == "Solved" then
                    v2 = "Idle"
                    n2 = 0
                    Mushrooms.SetProgress(n2, false)
                end
            else
                v2 = "Solved"
                n2 = BanjoCricketFlags.Stages:Get()
                Mushrooms.SetProgress(n2, true)
                Reveal.Open()
            end

            Talk.Sync(BanjoCricket.Solved, BanjoCricket.Claimed)
        end

        Mushrooms.Start(onBump)
        Reveal.Start()
        Talk.Start()
        Band.Start()
        Bridge.Start()
        Dream.Start()
        Aim.Start(predict)
        Save.WatchFields({ "BanjoCricket" }, applySaved)

        if Save.IsLoaded() then
            applySaved()
        else
            Save.Loaded:Connect(applySaved)
        end

        Remotes.BanjoCricket.Effect.OnClientEvent:Connect(onEffect)
        Remotes.BanjoCricket.Squish.OnClientEvent:Connect(function(p11) -- line: 265
            -- upvalues: Mushrooms (copy)
            Mushrooms.Squish(p11)
        end)
        Timer.Simple(0.5, invite)
    end
}
