-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local AreaEggResetCycle = require(ReplicatedStorage.Data.AreaEggResetCycle)
local EggState = require(ReplicatedStorage.Client.EggState)
local Elapsed = require(ReplicatedStorage.Shared.Utils.Time).Elapsed
local GUI = require(ReplicatedStorage.Client.GUI)
local Hud = require(ReplicatedStorage.Client.Hud)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Sakura = require(ReplicatedStorage.Data.Sakura)
local SakuraBloomPolicy = require(ReplicatedStorage.Client.Modules.SakuraBloomPolicy)
local Save = require(ReplicatedStorage.Shared.Save)
local v1 = Color3.fromRGB(255, 64, 64)

return {
    Start = function() -- Start | line: 31
        -- upvalues: Players (copy), RunService (copy), Workspace (copy), AreaEggCycle (copy), AreaEggResetCycle (copy), EggState (copy), Elapsed (copy), GUI (copy), Hud (copy), Player (copy), Remotes (copy), Sakura (copy), SakuraBloomPolicy (copy), Save (copy), v1 (copy)
        local v2 = GUI.TutorialInstructions()

        assert(v2:IsA("ScreenGui"), "TutorialInstructions must be a ScreenGui")

        local NightTimer = Hud.Every("NightTimer")
        local NightTimerValue = Hud.Get("NightTimerValue")
        local NightTimerIcon = Hud.Get("NightTimerIcon")
        local Treadmill = Hud.Find("NightTimerValue", "Treadmill")
        local Treadmill2 = Hud.Find("NightTimerIcon", "Treadmill")
        local Image = NightTimerIcon.Image
        local v3 = if Treadmill2 == nil then "" else Treadmill2.Image
        local TextColor3 = NightTimerValue.TextColor3
        local n1 = -1
        local v4 = false
        local v5 = AreaEggCycle.PeriodIndexAt(Workspace:GetServerTimeNow())
        local v6 = false
        local v7 = false
        local Enabled = v2.Enabled
        local v8 = AreaEggCycle.IsRunning()
        local v9 = false
        local v10 = false
        local Enabled2 = v2.Enabled
        local LocalPlayer = Players.LocalPlayer
        local Bounds = Workspace:WaitForChild("World"):WaitForChild("Areas"):WaitForChild("CherryBlossom"):WaitForChild("Bounds")

        assert(Bounds:IsA("BasePart"), "CherryBlossom.Bounds must be a BasePart")

        local function getBlinkColor(p1, p2, p3) -- line: 68
            -- upvalues: AreaEggCycle (copy), v1 (copy)
            if not p2 and AreaEggCycle.IsInFinalBlink(p1) and AreaEggCycle.IsBlinkOnRedFrame(p1) then
                return v1
            end

            return p3
        end

        local function setNightTimerVisible(p4) -- line: 80
            -- upvalues: NightTimer (copy)
            for _, v11 in NightTimer do
                v11.Visible = p4
            end
        end

        local function setTimer(p5, p6) -- line: 86
            -- upvalues: NightTimer (copy), NightTimerValue (copy), Treadmill (copy)
            for _, v12 in NightTimer do
                v12.Visible = true
            end

            NightTimerValue.Text = p5
            NightTimerValue.TextColor3 = p6

            if Treadmill ~= nil then
                Treadmill.Text = p5
                Treadmill.TextColor3 = p6
            end
        end

        local function setNormalTimer(p7, p8, p9) -- line: 96
            -- upvalues: NightTimer (copy), NightTimerValue (copy), Treadmill (copy), TextColor3 (copy), AreaEggCycle (copy), v1 (copy)
            local v13 = TextColor3

            if not p8 and AreaEggCycle.IsInFinalBlink(p7) and AreaEggCycle.IsBlinkOnRedFrame(p7) then
                v13 = v1
            end

            for _, v14 in NightTimer do
                v14.Visible = true
            end

            NightTimerValue.Text = p9
            NightTimerValue.TextColor3 = v13

            if Treadmill ~= nil then
                Treadmill.Text = p9
                Treadmill.TextColor3 = v13
            end
        end

        local function setEndingSoonTimer(p10, p11, p12) -- line: 100
            -- upvalues: NightTimer (copy), NightTimerValue (copy), Treadmill (copy), AreaEggCycle (copy), v1 (copy)
            if not p11 and AreaEggCycle.IsInFinalBlink(p10) and AreaEggCycle.IsBlinkOnRedFrame(p10) then
            end

            for _, v15 in NightTimer do
                v15.Visible = true
            end

            NightTimerValue.Text = p12
            NightTimerValue.TextColor3 = v1

            if Treadmill ~= nil then
                Treadmill.Text = p12
                Treadmill.TextColor3 = v1
            end
        end

        local function isInsideCherryBlossom() -- line: 104
            -- upvalues: LocalPlayer (copy), Bounds (copy), Player (copy)
            local v16 = Player.FindPrimaryPart(LocalPlayer)

            if v16 == nil then
                return false
            end

            local v17 = Bounds.CFrame:PointToObjectSpace(v16.Position)

            if not (math.abs(v17.X) <= Bounds.Size.X / 2) then
                return false
            end

            return math.abs(v17.Z) <= Bounds.Size.Z / 2
        end

        local function isBloomUnlocked() -- line: 114
            -- upvalues: SakuraBloomPolicy (copy), Save (copy)
            local v18 = Save.IsLoaded()
            local v19 = if v18 then Save.Peek() else nil

            return SakuraBloomPolicy.HasBloomUnlocked(v18, v19)
        end

        local function refreshTimer(p13) -- line: 120
            -- upvalues: v5 (ref), NightTimer (copy), NightTimerValue (copy), NightTimerIcon (copy), Treadmill (copy), Treadmill2 (copy), Image (copy), TextColor3 (copy), n1 (ref), v4 (ref), v6 (ref), v7 (ref), Enabled (ref), v8 (ref), v9 (ref), v10 (ref), Enabled2 (ref), isInsideCherryBlossom (copy), v3 (copy), Workspace (copy), AreaEggCycle (copy), AreaEggResetCycle (copy), Elapsed (copy), Sakura (copy), SakuraBloomPolicy (copy), Save (copy), v1 (copy)
            local v20 = AreaEggCycle.IsRunning()
            local v21 = true

            if v20 == v8 then
                v21 = p13
            else
                v8 = v20
            end

            if v20 then
                local ServerTimeNow = Workspace:GetServerTimeNow()
                local v22 = AreaEggCycle.ActivePeriodIndexAt(ServerTimeNow)
                local v23 = AreaEggCycle.IsNightPhase(ServerTimeNow)
                local v25 = math.ceil((AreaEggCycle.SecondsUntilPhaseEnd(ServerTimeNow)))
                local Attribute = Workspace:GetAttribute(Sakura.Bloom.EndsAtAttribute)
                local v26 = Save.IsLoaded()
                local v27 = if v26 then Save.Peek() else nil
                local v28 = SakuraBloomPolicy.HasBloomUnlocked(v26, v27) and typeof(Attribute) == "number" and ServerTimeNow < Attribute and isInsideCherryBlossom()
                local v29 = if v28 then math.ceil(Attribute - ServerTimeNow) else v25

                if not v21 and v29 == n1 and v28 == v4 and v22 == v5 and v9 == v6 and v10 == v7 and Enabled2 == Enabled then
                    return
                end

                n1 = v29
                v4 = v28
                v5 = v22
                v6 = v9
                v7 = v10
                Enabled = Enabled2

                local v31 = if v23 then AreaEggResetCycle.SunIcon else Workspace:GetAttribute("NightIconOverride") or AreaEggResetCycle.MoonIcon
                local v32 = "in " .. Elapsed(v25)

                if v28 then
                    v32 = "ends in " .. Elapsed(v29)
                    v31 = "rbxassetid://71612969542341"
                end

                NightTimerIcon.Image = if v31 == "" then Image else v31

                if Treadmill2 ~= nil then
                    Treadmill2.Image = if v31 ~= "" then v31 elseif v3 == "" then Image else v3
                end

                local v35, v36

                if v28 or v23 then
                    v36 = true
                elseif not AreaEggCycle.IsCloseToReset(v25) or v9 or v10 or Enabled2 then
                    v36 = true
                else
                    v35 = v1

                    if AreaEggCycle.IsInFinalBlink(v25) and AreaEggCycle.IsBlinkOnRedFrame(v25) then
                        v35 = v1
                    end

                    v36 = false
                end

                if not v36 then
                    for _, v37 in NightTimer do
                        v37.Visible = true
                    end

                    NightTimerValue.Text = v32
                    NightTimerValue.TextColor3 = v35

                    if Treadmill ~= nil then
                        Treadmill.Text = v32
                        Treadmill.TextColor3 = v35
                    end
                else
                    local v38 = TextColor3

                    if not v23 and AreaEggCycle.IsInFinalBlink(v25) and AreaEggCycle.IsBlinkOnRedFrame(v25) then
                        v38 = v1
                    end

                    for _, v39 in NightTimer do
                        v39.Visible = true
                    end

                    NightTimerValue.Text = v32
                    NightTimerValue.TextColor3 = v38

                    if Treadmill ~= nil then
                        Treadmill.Text = v32
                        Treadmill.TextColor3 = v38
                    end
                end
            else
                for _, v40 in NightTimer do
                    v40.Visible = false
                end
            end
        end

        refreshTimer()
        EggState.CarryChanged:Connect(function(p14) -- line: 196
            -- upvalues: v9 (ref), refreshTimer (copy)
            v9 = p14.IsCarrying
            refreshTimer(true)
        end)
        Remotes.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(p15) -- line: 201
            -- upvalues: v10 (ref), refreshTimer (copy)
            v10 = p15 ~= nil
            refreshTimer(true)
        end)
        v2:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 206
            -- upvalues: v2 (copy), Enabled2 (ref), refreshTimer (copy)
            Enabled2 = v2.Enabled
            refreshTimer(true)
        end)
        Save.WatchFields("Sakura", function() -- line: 211
            -- upvalues: refreshTimer (copy)
            refreshTimer(true)
        end)
        RunService.Heartbeat:Connect(function(_) -- line: 213
            -- upvalues: refreshTimer (copy)
            refreshTimer()
        end)
    end
}
