-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

game:GetService("StarterGui")

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local GUI = require(ReplicatedStorage.Client.GUI)

require(script.Parent.MountController)

local MountRace = require(ReplicatedStorage.Data.MountRace)
local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)

require(script.Parent.RaceCamera)

local RaceEffects = require(script.Parent.RaceEffects)

require(script.Parent.RaceMusic)

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SpeedLines = require(ReplicatedStorage.Client.SpeedLines)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local TrackAttributes, PlayerAttributes = MountRace.TrackAttributes, MountRace.PlayerAttributes
local v1 = Color3.fromRGB(255, 255, 255)
local v2 = Color3.fromRGB(90, 255, 110)
local v3 = UDim2.fromScale(0.5, 0.29)
local v4 = UDim2.fromScale(1.5, 1)
local v5 = UDim2.fromScale(0.5, 1)
local v6 = UDim2.fromScale(0.5, 1.08)
local v7 = UDim2.fromScale(1.3, 0.42)
local v8 = UDim2.fromScale(0.987, 0.21)
local v9 = Color3.fromRGB(255, 255, 255)
local v10 = Color3.fromRGB(0, 0, 0)
local v11 = Color3.fromRGB(255, 72, 72)
local v12 = Color3.fromRGB(70, 0, 0)
local Deny = ReplicatedStorage.Assets.MountRace.PowerUps.Sounds.Deny
local n1 = 0

local function now() -- line: 78
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function formatClock(p1) -- line: 82
    local v14 = math.max(math.ceil(p1), 0)

    return string.format("%d:%02d", v14 // 60, v14 % 60)
end

local function punch(p2) -- line: 87
    -- upvalues: TweenService (copy)
    p2.Scale = 1.4
    TweenService:Create(p2, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()
end

local function paintBanner(p3, p4, p5) -- line: 94
    local Place = p3.FinishBanner.Place

    Place.TextColor3 = p4

    local UIStroke = Place:FindFirstChildOfClass("UIStroke")

    if UIStroke ~= nil then
        UIStroke.Color = p5
    end
end

local function shake(p6) -- line: 103
    local Position = p6.Position
    local elapsed = os.clock()

    task.spawn(function() -- line: 106
        -- upvalues: p6 (copy), Position (copy), elapsed (copy)
        while os.clock() - elapsed < 0.45 do
            local v15 = os.clock() - elapsed

            p6.Position = Position + UDim2.fromScale(math.sin(v15 * 55) * 0.012 * (1 - v15 / 0.45), 0)
            task.wait()
        end

        p6.Position = Position
    end)
end

local function showFinish(p7, p8, p9) -- line: 116
    -- upvalues: MountRace (copy), v9 (copy), v10 (copy), punch (copy)
    local FinishBanner = p7.FinishBanner
    local Place = p7.FinishBanner.Place

    Place.TextColor3 = v9

    local UIStroke = Place:FindFirstChildOfClass("UIStroke")

    if UIStroke ~= nil then
        UIStroke.Color = v10
    end

    FinishBanner.Place.Text = ("%*!"):format((MountRace.FormatPlace(p8)))

    local Time = FinishBanner.Time

    if p9 ~= nil then
        Time.Text = MountRace.FormatTime(p9)
    else
        Time.Text = "RACE OVER"
    end

    FinishBanner.LeaveButton.Visible = p9 ~= nil
    FinishBanner.Visible = true
    punch(FinishBanner.Punch)
end

local function showFailed(p10, p11) -- line: 126
    -- upvalues: SoundService (copy), MountRace (copy), v11 (copy), v12 (copy), Deny (copy), punch (copy)
    local FinishBanner = p10.FinishBanner
    local Place = p10.FinishBanner.Place

    Place.TextColor3 = v11

    local UIStroke = Place:FindFirstChildOfClass("UIStroke")

    if UIStroke ~= nil then
        UIStroke.Color = v12
    end

    FinishBanner.Place.Text = "DID NOT FINISH"
    FinishBanner.Time.Text = ("%* - OUT OF TIME"):format((MountRace.FormatPlace(p11)))
    FinishBanner.LeaveButton.Visible = false

    if not FinishBanner.Visible then
        local FinishBannerPosition = FinishBanner.Position
        local elapsed = os.clock()

        task.spawn(function() -- line: 106
            -- upvalues: FinishBanner (copy), FinishBannerPosition (copy), elapsed (copy)
            while os.clock() - elapsed < 0.45 do
                local v17 = os.clock() - elapsed

                FinishBanner.Position = FinishBannerPosition + UDim2.fromScale(math.sin(v17 * 55) * 0.012 * (1 - v17 / 0.45), 0)
                task.wait()
            end

            FinishBanner.Position = FinishBannerPosition
        end)
    end

    FinishBanner.Visible = true
    punch(FinishBanner.Punch)
    SoundService:PlayLocalSound(Deny)
end

return {
    Run = function(p12, p13, p14, p15, p16, p17) -- Run | line: 144
        -- upvalues: RunService (copy), SoundService (copy), UserInputService (copy), Workspace (copy), GUI (copy), MountRace (copy), MountRaceFlags (copy), RaceEffects (copy), Remotes (copy), SpeedLines (copy), LocalPlayer (copy), TrackAttributes (copy), PlayerAttributes (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), n1 (ref), punch (copy), showFinish (copy), showFailed (copy)
        local v19 = GUI.MountRaceUI()
        local Main = GUI.MountRaceBoardUI().Main
        local Timer, Countdown, LapBanner, FinishBanner = v19.Timer, v19.Countdown, v19.LapBanner, v19.FinishBanner
        local TimerPosition = Timer.Position
        local Size, TitlePosition = Timer.Title.Size, Timer.Title.Position
        local v20 = p12:Add(Main.Lap:Clone())

        v20.Name = "RaceClock"
        v20.Position = v8
        v20.Text = ""
        v20.Parent = Main

        local v21 = p12:Add(Timer.Title:Clone())

        v21.Name = "Waiting"
        v21.AnchorPoint = Vector2.new(0.5, 0)
        v21.Position = v6
        v21.Size = v7
        v21.RichText = true
        v21.Text = "Waiting for players"
        v21.Visible = false
        v21.Parent = Timer
        n1 += 1
        p12:Add(function() -- line: 175
            -- upvalues: v19 (copy), Timer (copy), Countdown (copy), LapBanner (copy), FinishBanner (copy), TimerPosition (copy), Size (copy), TitlePosition (copy)
            Timer.Visible = false
            Timer.Position = TimerPosition
            Timer.Title.Size = Size
            Timer.Title.Position = TitlePosition
            Timer.Time.Visible = true
            Timer.Shadow.Visible = true
            Countdown.Visible = false
            LapBanner.Visible = false
            FinishBanner.Visible = false
            v19.Handbrake.Visible = false
        end)

        local v22
        local v23 = false

        p12:Connect(RunService.RenderStepped, function() -- line: 191
            -- upvalues: p14 (copy), p17 (copy), Main (copy), Timer (copy), Countdown (copy), TimerPosition (copy), Size (copy), TitlePosition (copy), v20 (copy), v21 (copy), v22 (ref), v23 (ref), SoundService (copy), Workspace (copy), MountRace (copy), MountRaceFlags (copy), LocalPlayer (copy), TrackAttributes (copy), PlayerAttributes (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), punch (copy)
            local Attribute = p14:GetAttribute(TrackAttributes.Phase)
            local Attribute2 = p14:GetAttribute(TrackAttributes.JoinEndsAt)
            local Attribute3 = p14:GetAttribute(TrackAttributes.EndsAt)
            local v24 = Attribute == MountRace.Phase.Racing and type(Attribute3) == "number" and p14:GetAttribute(TrackAttributes.WaitForOthers) == true and type(LocalPlayer:GetAttribute(PlayerAttributes.FinishTime)) == "number"

            if Attribute == MountRace.Phase.Joining and type(Attribute2) == "number" then
                Timer.Title.Text = "RACE STARTS IN"

                local Time = Timer.Time
                local v27 = math.max(math.ceil(Attribute2 - Workspace:GetServerTimeNow()), 0)

                Time.Text = string.format("%d:%02d", v27 // 60, v27 % 60)
                Timer.Visible = true

                local v29 = math.floor(os.clock() / 0.45) % 4

                v21.Text = ("Waiting for players%*<font transparency=\"1\">%*</font>"):format(string.rep(".", v29), (string.rep(".", 3 - v29)))
                v21.TextTransparency = math.sin(os.clock() * 3) * 0.15 + 0.15
                v21.Visible = true
            elseif Attribute == MountRace.Phase.Racing and type(Attribute3) == "number" then
                local Title = Timer.Title

                if v24 then
                    Title.Text = string.format("Waiting for others to finish the race... (%d)", (math.max(math.ceil(Attribute3 - Workspace:GetServerTimeNow()), 0)))
                else
                    Title.Text = "RACE ENDS IN"
                end

                local Time = Timer.Time
                local v35 = math.max(math.ceil(Attribute3 - Workspace:GetServerTimeNow()), 0)

                Time.Text = string.format("%d:%02d", v35 // 60, v35 % 60)
                Timer.Visible = true
            else
                Timer.Visible = false
            end

            Timer.Time.Visible = not v24
            Timer.Shadow.Visible = not v24

            local Title = Timer.Title

            if v24 then
                Title.Size = v4
            else
                Title.Size = Size
            end

            local Title2 = Timer.Title

            if v24 then
                Title2.Position = v5
            else
                Title2.Position = TitlePosition
            end

            if Attribute ~= MountRace.Phase.Joining then
                v21.Visible = false
            end

            Timer.Shadow.Text = Timer.Time.Text
            Timer.Position = if Main.Visible then v3 else TimerPosition

            local Attribute4 = p14:GetAttribute(TrackAttributes.GoAt)
            local v37 = if type(Attribute4) == "number" then Attribute4 - Workspace:GetServerTimeNow() else 1e999
            local v38 = if type(Attribute4) == "number" then Attribute4 elseif Attribute == MountRace.Phase.Joining and type(Attribute2) == "number" then Attribute2 + MountRaceFlags.CountdownSeconds:Get() else nil

            if not v23 and v38 ~= nil then
                local v39 = v38 - Workspace:GetServerTimeNow()

                if v39 <= 0 then
                    v23 = true
                elseif v39 <= 7.5 then
                    v23 = true
                    p17:Play("PreRace", 7.5 - v39)
                end
            end

            local v40 = if v37 == 1e999 or v37 <= -0.9 then nil elseif v37 > 0 then tostring((math.ceil(v37))) else "GO!"

            Countdown.Visible = v40 ~= nil

            if v40 ~= nil and v40 ~= v22 then
                Countdown.Text = v40
                Countdown.TextColor3 = if v40 == "GO!" then v2 else v1
                punch(Countdown.Punch)
                SoundService:PlayLocalSound(if v40 == "GO!" then MountRace.Sounds.CountdownGo else MountRace.Sounds.CountdownTick)

                if v40 == "GO!" and p17.Wanted == "PreRace" then
                    p17:Play("Race")
                end
            end

            v22 = v40

            local Attribute5 = LocalPlayer:GetAttribute(PlayerAttributes.FinishTime)

            if type(Attribute5) == "number" then
                v20.Text = MountRace.FormatTime(Attribute5)
            elseif Attribute == MountRace.Phase.Racing and type(Attribute4) == "number" then
                v20.Text = MountRace.FormatTime((math.max(Workspace:GetServerTimeNow() - Attribute4, 0)))
            elseif Attribute == MountRace.Phase.Countdown then
                v20.Text = MountRace.FormatTime(0)
            elseif Attribute ~= MountRace.Phase.Results then
                v20.Text = ""
            end
        end)

        local v45 = LocalPlayer:GetAttribute(PlayerAttributes.Lap)
        local n2 = 0

        p12:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Lap), function() -- line: 278
            -- upvalues: p14 (copy), p17 (copy), LapBanner (copy), v45 (ref), n2 (ref), SoundService (copy), MountRace (copy), LocalPlayer (copy), TrackAttributes (copy), PlayerAttributes (copy), punch (copy)
            local Attribute = LocalPlayer:GetAttribute(PlayerAttributes.Lap)
            local Attribute2 = p14:GetAttribute(TrackAttributes.Laps)
            local v46 = v45

            v45 = Attribute

            local v47

            if type(Attribute) ~= "number" or type(Attribute2) ~= "number" or type(v46) ~= "number" or Attribute <= v46 then
                return
            else
                v47 = Attribute == Attribute2
            end

            LapBanner.Text = if v47 then "FINAL LAP!" else ("LAP %*/%*"):format(Attribute, Attribute2)
            LapBanner.Visible = true
            punch(LapBanner.Punch)
            SoundService:PlayLocalSound(if v47 then MountRace.Sounds.FinalLap else MountRace.Sounds.LapChime)

            if v47 then
                p17:Play("FinalLap")
            end

            n2 += 1

            local v51 = n2

            task.delay(1.8, function() -- line: 296
                -- upvalues: v51 (copy), LapBanner (copy), n2 (ref)
                if v51 == n2 then
                    LapBanner.Visible = false
                end
            end)
        end)

        local v52 = LocalPlayer:GetAttribute(PlayerAttributes.Place)
        local n3 = 0

        p12:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.Place), function() -- line: 306
            -- upvalues: p14 (copy), v52 (ref), n3 (ref), SoundService (copy), MountRace (copy), LocalPlayer (copy), TrackAttributes (copy), PlayerAttributes (copy)
            local Attribute = LocalPlayer:GetAttribute(PlayerAttributes.Place)
            local v53 = v52

            v52 = Attribute

            local v54

            if type(Attribute) ~= "number" or type(v53) ~= "number" or Attribute == v53 then
                return
            else
                v54 = p14:GetAttribute(TrackAttributes.Phase) == MountRace.Phase.Racing
            end

            local SoundService2, v56

            if v54 and LocalPlayer:GetAttribute(PlayerAttributes.FinishPlace) == nil and not (os.clock() < n3) then
                n3 = os.clock() + 0.6
                SoundService2 = SoundService
                v56 = if Attribute < v53 then MountRace.Sounds.Overtake else MountRace.Sounds.Overtaken
                SoundService2:PlayLocalSound(v56)
            end
        end)

        local function onFinishPlace() -- line: 322
            -- upvalues: p13 (copy), p16 (copy), p17 (copy), v19 (copy), LapBanner (copy), RaceEffects (copy), LocalPlayer (copy), PlayerAttributes (copy), showFinish (copy), showFailed (copy)
            local Attribute = LocalPlayer:GetAttribute(PlayerAttributes.FinishPlace)

            if type(Attribute) ~= "number" then
                return
            end

            local Attribute2 = LocalPlayer:GetAttribute(PlayerAttributes.FinishTime)

            if type(Attribute2) ~= "number" then
                Attribute2 = nil
            end

            LapBanner.Visible = false

            if Attribute2 ~= nil then
                showFinish(v19, Attribute, Attribute2)
                RaceEffects.Finish(p13, p16)
                p17:Play("Victory")
            else
                showFailed(v19, Attribute)
            end
        end

        p12:Connect(LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.FinishPlace), onFinishPlace)
        onFinishPlace()
        p12:Add(GUI.OnActivated(FinishBanner.LeaveButton, function() -- line: 340
            -- upvalues: Remotes (copy)
            Remotes.MountRace.AskLeave:FireServer()
        end))
        SpeedLines.Run(p12, v19.SpeedLines, function() -- line: 344
            -- upvalues: p15 (copy)
            return (p15:SpeedRatio() - 0.6) / 0.6
        end)

        local Handbrake = v19.Handbrake

        Handbrake.Visible = UserInputService.TouchEnabled
        p12:Connect(Handbrake.InputBegan, function(p18) -- line: 350
            -- upvalues: p15 (copy)
            if p18.UserInputType == Enum.UserInputType.Touch or p18.UserInputType == Enum.UserInputType.MouseButton1 then
                p15.Handbrake = true
            end
        end)
        p12:Connect(Handbrake.InputEnded, function(p19) -- line: 358
            -- upvalues: p15 (copy)
            if p19.UserInputType == Enum.UserInputType.Touch or p19.UserInputType == Enum.UserInputType.MouseButton1 then
                p15.Handbrake = false
            end
        end)
    end,
    ShowCompleted = function(p20) -- ShowCompleted | line: 369
        -- upvalues: GUI (copy), MountRace (copy), LocalPlayer (copy), PlayerAttributes (copy), v9 (copy), v10 (copy), n1 (ref), punch (copy), showFailed (copy)
        local v57 = GUI.MountRaceUI()

        if type(LocalPlayer:GetAttribute(PlayerAttributes.FinishTime)) == "number" then
            local FinishBanner = v57.FinishBanner
            local Place = v57.FinishBanner.Place

            Place.TextColor3 = v9

            local UIStroke = Place:FindFirstChildOfClass("UIStroke")

            if UIStroke ~= nil then
                UIStroke.Color = v10
            end

            FinishBanner.Place.Text = ("%*!"):format((MountRace.FormatPlace(p20)))
            FinishBanner.Time.Text = "RACE OVER"
            FinishBanner.LeaveButton.Visible = false
            FinishBanner.Visible = true
            punch(FinishBanner.Punch)
            v57.FinishBanner.Time.Text = "RACE COMPLETED"
        else
            showFailed(v57, p20)
        end

        n1 += 1

        local v58 = n1

        task.delay(4, function() -- line: 379
            -- upvalues: v57 (copy), v58 (copy), n1 (ref)
            if v58 == n1 then
                v57.FinishBanner.Visible = false
            end
        end)
    end
}
