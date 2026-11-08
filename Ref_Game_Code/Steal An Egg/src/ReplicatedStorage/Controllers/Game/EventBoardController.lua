-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SocialService = game:GetService("SocialService")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local EventBoardView = require(ReplicatedStorage.Shared.Modules.EventBoardView)
local Log = require(ReplicatedStorage.Packages.Log)
local PlotState = require(ReplicatedStorage.Client.PlotState)

return {
    Start = function() -- Start | line: 36
        -- upvalues: Players (copy), RunService (copy), SocialService (copy), SoundService (copy), Workspace (copy), EventBoardView (copy), Log (copy), PlotState (copy)
        local LocalPlayer = Players.LocalPlayer
        local v1 = Log.new()
        local t2 = {}
        local v2 = false
        local v3
        local Id = nil
        local TextLabel, Sound, v4, v5

        local function setShown(p1, p2) -- line: 53
            for _, descendant in p1:GetDescendants() do
                if descendant:IsA("BasePart") then
                    local BoardClear = descendant:GetAttribute("BoardClear")

                    if p2 then
                        if typeof(BoardClear) ~= "number" then
                            BoardClear = 0
                        end
                    else
                        BoardClear = 1
                    end

                    descendant.Transparency = BoardClear
                elseif descendant:IsA("SurfaceGui") or descendant:IsA("ProximityPrompt") then
                    descendant.Enabled = p2
                end
            end
        end

        local function getOwnBoard() -- line: 66
            -- upvalues: Workspace (copy), PlotState (copy)
            local v6 = PlotState.ResolveLocalSlot()

            if v6 == nil then
                return nil
            end

            local Plots = Workspace:FindFirstChild("Plots")
            local v7 = if Plots == nil then nil else Plots:FindFirstChild((tostring(v6)))
            local EventBoard = if v7 == nil then nil else v7:FindFirstChild("EventBoard")

            return if EventBoard ~= nil and EventBoard:IsA("Model") then EventBoard else nil
        end

        local function formatTimer(p3) -- line: 78
            -- upvalues: EventBoardView (copy)
            return (("NEXT UPDATE\n%*"):format((EventBoardView.Countdown(p3.StartsAt - os.time()))))
        end

        local function takeDown() -- line: 82
            -- upvalues: t2 (copy), v3 (ref), Id (ref), TextLabel (ref), Sound (ref), setShown (copy)
            for _, v8 in t2 do
                v8:Disconnect()
            end

            table.clear(t2)

            if TextLabel ~= nil then
                TextLabel:Destroy()
                TextLabel = nil
            end

            if Sound ~= nil then
                Sound:Destroy()
                Sound = nil
            end

            local v9 = v3

            if v9 ~= nil and v9.Parent ~= nil then
                setShown(v9, false)
            end

            v3 = nil
            Id = nil
        end

        local function onTriggered(p4) -- line: 106
            -- upvalues: v1 (copy), v2 (ref), takeDown (copy), SocialService (copy)
            if not v2 then
                v2 = true

                local PromptRsvpToEventAsync = SocialService.PromptRsvpToEventAsync
                local Id = p4.Id
                local ok, result = pcall(PromptRsvpToEventAsync, SocialService, Id)

                if ok then
                    local GetEventRsvpStatusAsync = SocialService.GetEventRsvpStatusAsync
                    local Id = p4.Id
                    local ok, result = pcall(GetEventRsvpStatusAsync, SocialService, Id)

                    if ok and result == Enum.RsvpStatus.Going then
                        takeDown()
                    end
                else
                    v1:AtWarning():Log((("EventBoard RSVP prompt failed: %*"):format(result)))
                end

                v2 = false
            end
        end

        local function mount(p5, p6) -- line: 127
            -- upvalues: LocalPlayer (copy), v1 (copy), t2 (copy), v3 (ref), Id (ref), TextLabel (ref), Sound (ref), v4 (ref), setShown (copy), onTriggered (copy), RunService (copy), SoundService (copy), EventBoardView (copy)
            setShown(p6, true)

            local Display = p6:FindFirstChild("Display")
            local SurfaceGui = if Display == nil then nil else Display:FindFirstChildWhichIsA("SurfaceGui")

            if SurfaceGui ~= nil then
                local v10 = SurfaceGui:FindFirstChild("Frame") or SurfaceGui
                local EventCountdown = v10:FindFirstChild("EventCountdown")

                if EventCountdown ~= nil then
                    EventCountdown:Destroy()
                end

                local TextLabel2 = Instance.new("TextLabel")

                TextLabel2.Name = "EventCountdown"
                TextLabel2.BackgroundTransparency = 1
                TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel2.Position = UDim2.fromScale(0.5, 0.5)
                TextLabel2.Size = UDim2.fromScale(0.9, 0.45)
                TextLabel2.TextScaled = true
                TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextLabel2.Text = ("NEXT UPDATE\n%*"):format((EventBoardView.Countdown(p5.StartsAt - os.time())))
                TextLabel2.ZIndex = 5

                local UIStroke = Instance.new("UIStroke")

                UIStroke.Thickness = 3
                UIStroke.Color = Color3.fromRGB(0, 0, 0)
                UIStroke.Parent = TextLabel2
                TextLabel2.Parent = v10
                TextLabel = TextLabel2
            end

            local v11 = p6:FindFirstChildWhichIsA("ProximityPrompt", true)

            if v11 ~= nil then
                v11.RequiresLineOfSight = false
                v11.MaxActivationDistance = EventBoardView.PromptDistance
                v11.HoldDuration = 0

                if p5.Title ~= "" then
                    v11.ObjectText = p5.Title
                end

                if v11.ActionText == "" then
                    v11.ActionText = "Follow Event"
                end

                table.insert(t2, v11.Triggered:Connect(function(p7) -- line: 171
                    -- upvalues: p5 (copy), LocalPlayer (copy), onTriggered (copy)
                    if p7 == LocalPlayer then
                        task.spawn(onTriggered, p5)
                    end
                end))
            else
                v1:AtWarning():Log("EventBoard has no ProximityPrompt, sign-up is display only")
            end

            if Display ~= nil and Display:IsA("BasePart") then
                local Sound2 = Instance.new("Sound")

                Sound2.Name = "EventBoardAmbience"
                Sound2.SoundId = "rbxassetid://139717384302574"
                Sound2.Looped = true
                Sound2.Volume = 0.5
                Sound2.RollOffMode = Enum.RollOffMode.Linear
                Sound2.RollOffMinDistance = 4
                Sound2.RollOffMaxDistance = 14
                Sound2.SoundGroup = SoundService:FindFirstChild("Gameplay")
                Sound2.Parent = Display
                Sound = Sound2
                table.insert(t2, RunService.Heartbeat:Connect(function() -- line: 194
                    -- upvalues: Display (copy), Sound2 (copy), LocalPlayer (copy)
                    local Character = LocalPlayer.Character
                    local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")
                    local v14 = HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") and (HumanoidRootPart.Position - Display.Position).Magnitude <= 14

                    if not v14 or Sound2.IsPlaying then
                        if not v14 and Sound2.IsPlaying then
                            Sound2:Stop()
                        end
                    else
                        Sound2:Play()
                    end
                end))
            end

            v3 = p6
            Id = p5.Id
            v4 = nil
            v1:AtInfo():Log((("EventBoard mounted for event %*"):format(p5.Id)))
        end

        local function reportBail(p8) -- line: 215
            -- upvalues: v1 (copy), v4 (ref)
            if v4 ~= p8 then
                v4 = p8
                v1:AtInfo():Log((("EventBoard hidden: %*"):format(p8)))
            end
        end

        local function isVariantServer() -- line: 223
            -- upvalues: Workspace (copy)
            return Workspace:GetAttribute("ExpandedLobbyServerGroup") == "Variant"
        end

        local function waitForVariantServer() -- line: 227
            -- upvalues: Workspace (copy)
            local v15 = os.clock() + 60

            while Workspace:GetAttribute("ExpandedLobbyServerGroup") == nil and os.clock() < v15 do
                task.wait(0.5)
            end

            return Workspace:GetAttribute("ExpandedLobbyServerGroup") == "Variant"
        end

        local function apply() -- line: 235
            -- upvalues: v1 (copy), v2 (ref), v3 (ref), Id (ref), v4 (ref), v5 (ref), getOwnBoard (copy), takeDown (copy), mount (copy), Workspace (copy), EventBoardView (copy), PlotState (copy)
            if v2 then
                return
            end

            if v3 ~= nil and v3.Parent == nil then
                takeDown()
            end

            local v16 = v5

            if Workspace:GetAttribute("ExpandedLobbyServerGroup") == "Variant" then
                if v16 ~= nil then
                    if EventBoardView.ShouldShow(v16) then
                        local v17 = v3 ~= nil

                        if v17 then
                            local Id2 = Id

                            v17 = Id2 == v16.Id
                        end

                        if not v17 then
                            local v18 = getOwnBoard()

                            if v18 ~= nil then
                                takeDown()
                                mount(v16, v18)
                            else
                                local v19 = ("no EventBoard model found on plot %*"):format((tostring(PlotState.ResolveLocalSlot())))

                                if v4 ~= v19 then
                                    v4 = v19
                                    v1:AtInfo():Log((("EventBoard hidden: %*"):format(v19)))
                                end
                            end
                        end
                    else
                        local v20 = ("event %* hidden: player is already going"):format(v16.Id)

                        if v4 ~= v20 then
                            v4 = v20
                            v1:AtInfo():Log((("EventBoard hidden: %*"):format(v20)))
                        end

                        takeDown()
                    end
                else
                    if v4 ~= "no upcoming event (none active and not yet started for this universe)" then
                        v4 = "no upcoming event (none active and not yet started for this universe)"
                        v1:AtInfo():Log("EventBoard hidden: no upcoming event (none active and not yet started for this universe)")
                    end

                    takeDown()
                end
            else
                local v21 = ("server group is %*, not Variant"):format((tostring(Workspace:GetAttribute("ExpandedLobbyServerGroup"))))

                if v4 ~= v21 then
                    v4 = v21
                    v1:AtInfo():Log((("EventBoard hidden: %*"):format(v21)))
                end

                takeDown()
            end
        end

        local function refreshUpcoming() -- line: 273
            -- upvalues: v1 (copy), v5 (ref), SocialService (copy), EventBoardView (copy)
            local function v22() -- line: 274
                -- upvalues: SocialService (copy)
                return SocialService:GetUpcomingExperienceEventsAsync()
            end

            local ok, result = pcall(v22)

            if ok then
                v5 = EventBoardView.Pick(result, os.time())

                return true
            end

            v1:AtWarning():Log((("EventBoard failed to fetch experience events: %*"):format(result)))

            return false
        end

        task.spawn(function() -- line: 290
            -- upvalues: v1 (copy), v3 (ref), TextLabel (ref), v5 (ref), waitForVariantServer (copy), apply (copy), refreshUpcoming (copy), Workspace (copy), EventBoardView (copy), PlotState (copy)
            if not waitForVariantServer() then
                v1:AtInfo():Log((("EventBoard idle, server group is %*"):format((tostring(Workspace:GetAttribute("ExpandedLobbyServerGroup"))))))

                return
            end

            PlotState.LocalPlotChanged:Connect(function() -- line: 297
                -- upvalues: apply (copy)
                apply()
            end)
            task.spawn(function() -- line: 301
                -- upvalues: apply (copy), refreshUpcoming (copy), EventBoardView (copy)
                while true do
                    local v23 = refreshUpcoming()

                    apply()
                    task.wait(if v23 then EventBoardView.RefreshSeconds else EventBoardView.RetryBackoffSeconds)
                end
            end)
            task.spawn(function() -- line: 309
                -- upvalues: TextLabel (ref), v5 (ref), EventBoardView (copy)
                while true do
                    task.wait(EventBoardView.TimerUpdateSeconds)

                    local TextLabel2 = TextLabel
                    local v24 = v5

                    if TextLabel2 ~= nil and TextLabel2.Parent ~= nil and v24 ~= nil then
                        TextLabel2.Text = ("NEXT UPDATE\n%*"):format((EventBoardView.Countdown(v24.StartsAt - os.time())))
                    end
                end
            end)
            task.spawn(function() -- line: 319
                -- upvalues: v3 (ref), v5 (ref), apply (copy)
                while true do
                    task.wait(5)

                    if v5 == nil then
                        continue
                    end

                    if v3 == nil or v3.Parent == nil then
                        apply()
                    end
                end
            end)
        end)
    end
}
