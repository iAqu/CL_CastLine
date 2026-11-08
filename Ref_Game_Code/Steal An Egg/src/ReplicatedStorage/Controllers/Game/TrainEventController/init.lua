-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TrainEvent = require(ReplicatedStorage.Shared.Remotes).TrainEvent
local TrainGhostVisuals = require(script.Parent.TrainGhostVisuals)
local TrainReturnPrompt = require(ReplicatedStorage.Shared.Modules.TrainReturnPrompt)
local TrainTravelTransition = require(script.Parent.TrainTravelTransition)
local Toast = require(ReplicatedStorage.Client.Notifications.Toast)
local TrainEventPresentation = require(script.Parent.TrainEventPresentation)
local TicketFlight = require(script.TicketFlight)
local GhostBoss = require(ReplicatedStorage.Shared.Util.GhostBoss)
local GhostBossFlags = require(ReplicatedStorage.Shared.Flags.GhostBossFlags)
local TrainEventFlags = require(ReplicatedStorage.Shared.Flags.TrainEventFlags)
local TrainCaptureRules = require(ReplicatedStorage.Shared.Modules.TrainCaptureRules)
local v1 = false
local v2 = Color3.fromRGB(150, 255, 120)
local v3 = Color3.fromRGB(20, 70, 10)

return {
    Start = function() -- Start | line: 26
        -- upvalues: Players (copy), ReplicatedStorage (copy), RunService (copy), Workspace (copy), UserInputService (copy), ContextActionService (copy), TrainEvent (copy), TrainGhostVisuals (copy), TrainReturnPrompt (copy), TrainTravelTransition (copy), Toast (copy), TrainEventPresentation (copy), TicketFlight (copy), GhostBoss (copy), GhostBossFlags (copy), TrainEventFlags (copy), TrainCaptureRules (copy), v1 (ref), v2 (copy), v3 (copy)
        if v1 then
            return
        end

        v1 = true

        local LocalPlayer = Players.LocalPlayer

        require(script.Parent.TrainServerTravel).Start()
        TrainGhostVisuals.Start()
        TrainTravelTransition.Start()
        TrainEventPresentation.Start()
        TicketFlight.Start()

        local ScreenGui = Instance.new("ScreenGui")

        ScreenGui.Name = "TrainEventJourney"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.DisplayOrder = 40

        local Frame = Instance.new("Frame")

        Frame.AnchorPoint = Vector2.new(0.5, 0)
        Frame.Position = UDim2.new(0.5, 0, 0, 12)
        Frame.Size = UDim2.new(0.85, 0, 0, 160)
        Frame.BackgroundColor3 = Color3.fromRGB(29, 24, 43)
        Frame.BackgroundTransparency = 0.08
        Frame.Parent = ScreenGui

        local UISizeConstraint = Instance.new("UISizeConstraint")

        UISizeConstraint.MaxSize = Vector2.new(430, 310)
        UISizeConstraint.Parent = Frame

        local UICorner = Instance.new("UICorner")

        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Frame

        local function label(p1, p2, p3) -- line: 36
            -- upvalues: Frame (copy)
            local TextLabel = Instance.new("TextLabel")

            TextLabel.BackgroundTransparency = 1
            TextLabel.Position = UDim2.new(0, 12, 0, p1)
            TextLabel.Size = UDim2.new(1, -24, 0, p2)
            TextLabel.TextColor3 = Color3.fromRGB(233, 215, 255)
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextSize = p3
            TextLabel.TextWrapped = true
            TextLabel.Parent = Frame

            return TextLabel
        end

        local v4 = label(8, 28, 20)
        local v5 = label(38, 25, 16)
        local v6 = label(66, 44, 13)

        v6.TextColor3 = v2

        local v7 = label(112, 38, 14)

        v7.Size = UDim2.new(1, -24, 0, 38)

        local Frame2 = Instance.new("Frame")

        Frame2.Name = "VacuumCaptureHUD"
        Frame2.BackgroundTransparency = 1
        Frame2.AnchorPoint = Vector2.new(0, 0.5)
        Frame2.Position = UDim2.new(0.5, 90, 0.5, 0)
        Frame2.Size = UDim2.fromOffset(120, 160)
        Frame2.Visible = false
        Frame2.Parent = ScreenGui

        local v8 = label(152, 40, 14)

        v8.Name = "CaptureTarget"
        v8.Parent = Frame2
        v8.AnchorPoint = Vector2.new(0.5, 1)
        v8.Position = UDim2.fromOffset(10, -8)
        v8.Size = UDim2.fromOffset(150, 32)
        v8.TextStrokeTransparency = 0.25
        v8.TextStrokeColor3 = Color3.new(0, 0, 0)

        local Frame3 = Instance.new("Frame")

        Frame3.Name = "GhostCaptureProgress"
        Frame3.Position = UDim2.fromOffset(0, 0)
        Frame3.Size = UDim2.fromOffset(20, 128)
        Frame3.BackgroundColor3 = Color3.fromRGB(64, 54, 83)
        Frame3.Parent = Frame2

        local Frame4 = Instance.new("Frame")

        Frame4.Name = "Fill"
        Frame4.AnchorPoint = Vector2.new(0, 1)
        Frame4.Position = UDim2.fromScale(0, 1)
        Frame4.Size = UDim2.fromScale(1, 0)
        Frame4.BackgroundColor3 = Color3.fromRGB(182, 114, 255)
        Frame4.BorderSizePixel = 0
        Frame4.Parent = Frame3
        Frame4.BackgroundColor3 = v2

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Percent"
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.fromOffset(-20, 132)
        TextLabel.Size = UDim2.fromOffset(60, 24)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 16
        TextLabel.TextColor3 = v2
        TextLabel.TextStrokeTransparency = 0.2
        TextLabel.Parent = Frame2

        local v9 = {
            Phase = "Home",
            ArrivalOpen = false,
            DepartureAt = 0,
            ReturnAt = 0
        }
        local v10
        local n1 = 0
        local v11 = false
        local v12 = false
        local v13 = nil
        local t2 = {}
        local n2 = 0
        local n3 = 0
        local clone
        local v14 = false
        local v15 = false
        local n4 = (-1e999)
        local v16 = RaycastParams.new()

        v16.FilterType = Enum.RaycastFilterType.Exclude
        v16.RespectCanCollide = true

        local function ghostInReach(p4) -- line: 72
            -- upvalues: LocalPlayer (copy), v10 (ref), v12 (ref), v16 (copy), Players (copy), Workspace (copy), TrainEventFlags (copy), TrainCaptureRules (copy)
            local TrainGhostVisuals = Workspace:FindFirstChild("TrainGhostVisuals")

            if TrainGhostVisuals then
                local t3 = {
                    TrainGhostVisuals
                }

                for _, player in Players:GetPlayers() do
                    if player.Character then
                        table.insert(t3, player.Character)
                    end
                end

                v16.FilterDescendantsInstances = t3

                local Position = p4.Position
                local LookVector = p4.CFrame.LookVector
                local v17 = TrainEventFlags.VacuumReachStuds:Get()
                local v18 = TrainEventFlags.VacuumConeDegrees:Get()
                local v19 = TrainEventFlags.VacuumCloseRangeStuds:Get()
                local v20 = TrainEventFlags.VacuumVerticalToleranceStuds:Get()
                local v21 = v12 and v10 and v10.TargetId
                local v22 = typeof(v21) == "string" and TrainGhostVisuals:FindFirstChild(v21)

                if v22 and v22:IsA("Model") and (v22:GetPivot().Position - Position).Magnitude <= v17 * 1.15 then
                    return true
                end

                for _, child in TrainGhostVisuals:GetChildren() do
                    if child:IsA("Model") and child:GetAttribute("TrainGhost") == true and child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
                        local Position2 = child:GetPivot().Position

                        if TrainCaptureRules.InCaptureCone(Position, LookVector, Position2, v17, v18, v19, v20) and Workspace:Raycast(Position, Position2 - Position, v16) == nil then
                            return true
                        end
                    end
                end
            end

            return false
        end

        local function apply(p5) -- line: 92
            -- upvalues: LocalPlayer (copy), v6 (copy), v9 (ref), v10 (ref), n1 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy), Toast (copy), TrainEventPresentation (copy), v2 (copy), v3 (copy)
            if typeof(p5) ~= "table" then
                return
            end

            v9 = p5
            v10 = p5.Invasion
            TrainEventPresentation.Update(p5)

            if v9.Phase ~= "Town" or v10 and v10.Phase ~= "Active" then
                v14 = false

                local v23 = v14
                local v24 = if not v23 then v15 else nil

                if v23 or v24 then
                    v24 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                end

                if not v24 then
                    v14 = false
                end

                if v12 ~= v24 then
                    v12 = v24
                    TrainGhostVisuals.SetInput(v24)
                    TrainEvent.Suction:FireServer(v24)
                end
            end

            if typeof(p5.Message) ~= "string" then
                return
            end

            local v25 = string.sub(p5.Message, 1, 20) == "The train is leaving"
            local Character = LocalPlayer.Character

            if v25 and (not Character or Character:GetAttribute("TrainEventInForgottenTown") ~= true) then
                return
            end

            v6.Text = p5.Message
            n1 = os.clock() + 5

            local v26 = p5.Message == "You need a Train Pass." or p5.Message == "Hold your pass in your hand!" or p5.Message == "You need a Train Pass to board the train!"

            if v26 or string.sub(p5.Message, 1, 8) == "Captured" or string.sub(p5.Message, 1, 17) == "Vacuum collected!" or v25 then
                Toast.Show({
                    Lane = "Feed",
                    Seconds = 3,
                    Text = p5.Message,
                    Color = if v26 then Color3.fromRGB(255, 100, 100) else v2,
                    StrokeColor = if v26 then Color3.fromRGB(80, 15, 15) else v3
                })
            end
        end

        local t5 = {}

        local function button(p6, p7, p8, p9) -- line: 107
            -- upvalues: LocalPlayer (copy), Frame (copy), v6 (copy), v9 (ref), v10 (ref), n1 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), t5 (copy), TrainEvent (copy), TrainGhostVisuals (copy)
            local TextButton = Instance.new("TextButton")

            TextButton.Name = p6
            TextButton.Position = UDim2.new(p8, 4, 0, 116)
            TextButton.Size = UDim2.new(p9, -8, 0, 36)
            TextButton.BackgroundColor3 = Color3.fromRGB(115, 68, 174)
            TextButton.TextColor3 = Color3.new(1, 1, 1)
            TextButton.Font = Enum.Font.GothamBold
            TextButton.TextSize = 14
            TextButton.Text = p7
            TextButton.Parent = Frame
            t5[p6] = TextButton
            TextButton.Activated:Connect(function() -- line: 110
                -- upvalues: p6 (copy), LocalPlayer (copy), v6 (copy), v9 (ref), v10 (ref), n1 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
                if v11 then
                    return
                end

                v11 = true

                if p6 == "Return" then
                    v14 = false

                    local v28

                    if v14 then
                        v28 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                    else
                        v28 = v15

                        if v28 then
                            v28 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                        end
                    end

                    if not v28 then
                        v14 = false
                    end

                    if v12 ~= v28 then
                        v12 = v28
                        TrainGhostVisuals.SetInput(v28)
                        TrainEvent.Suction:FireServer(v28)
                    end
                end

                local function v35() -- line: 113
                    -- upvalues: p6 (copy), TrainEvent (copy)
                    return TrainEvent.Action:InvokeServer(p6)
                end

                local v36, _, v37 = pcall(v35)

                v11 = false

                if typeof(v37) == "string" then
                    v6.Text = v37
                    n1 = os.clock() + 5
                elseif not v36 then
                    v6.Text = "Please try again."
                    n1 = os.clock() + 5
                end
            end)

            return TextButton
        end

        button("Station", "Go to Station", 0, 1)
        UserInputService.WindowFocusReleased:Connect(function() -- line: 120
            -- upvalues: LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
            v14 = false

            local v38 = v14
            local v39 = if not v38 then v15 else nil

            if v38 or v39 then
                v39 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
            end

            if not v39 then
                v14 = false
            end

            if v12 == v39 then
                return
            end

            v12 = v39
            TrainGhostVisuals.SetInput(v39)
            TrainEvent.Suction:FireServer(v39)
        end)

        local function bind(p10) -- line: 121
            -- upvalues: LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), t2 (copy), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
            if not p10:IsA("Tool") or p10:GetAttribute("GhostVacuum") ~= true or t2[p10] then
                return
            end

            local t6 = {}

            t2[p10] = t6

            local function refresh() -- line: 125
                -- upvalues: p10 (copy), LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
                if p10.Parent == LocalPlayer.Character then
                    v13 = p10
                elseif v13 == p10 then
                    v14 = false

                    local v40

                    if v14 then
                        v40 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                    else
                        v40 = v15

                        if v40 then
                            v40 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                        end
                    end

                    if not v40 then
                        v14 = false
                    end

                    if v12 ~= v40 then
                        v12 = v40
                        TrainGhostVisuals.SetInput(v40)
                        TrainEvent.Suction:FireServer(v40)
                    end

                    v13 = nil
                end
            end

            table.insert(t6, p10.Equipped:Connect(refresh))
            table.insert(t6, p10.Unequipped:Connect(function() -- line: 130
                -- upvalues: p10 (copy), LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
                if v13 ~= p10 then
                    return
                end

                v14 = false

                local v48

                if v14 then
                    v48 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                else
                    v48 = v15

                    if v48 then
                        v48 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                    end
                end

                if not v48 then
                    v14 = false
                end

                if v12 ~= v48 then
                    v12 = v48
                    TrainGhostVisuals.SetInput(v48)
                    TrainEvent.Suction:FireServer(v48)
                end

                v13 = nil
            end))
            table.insert(t6, p10.Activated:Connect(function() -- line: 131
                -- upvalues: p10 (copy), LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
                v13 = p10
                v14 = true

                local v56 = v14
                local v57 = if not v56 then v15 else nil

                if v56 or v57 then
                    v57 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                end

                if not v57 then
                    v14 = false
                end

                if v12 == v57 then
                    return
                end

                v12 = v57
                TrainGhostVisuals.SetInput(v57)
                TrainEvent.Suction:FireServer(v57)
            end))
            table.insert(t6, p10.Deactivated:Connect(function() -- line: 132
                -- upvalues: LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
                v14 = false

                local v59 = v14
                local v60 = if not v59 then v15 else nil

                if v59 or v60 then
                    v60 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                end

                if not v60 then
                    v14 = false
                end

                if v12 == v60 then
                    return
                end

                v12 = v60
                TrainGhostVisuals.SetInput(v60)
                TrainEvent.Suction:FireServer(v60)
            end))
            table.insert(t6, p10.AncestryChanged:Connect(function() -- line: 133
                -- upvalues: p10 (copy), t6 (copy), LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), t2 (copy), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
                if p10.Parent == LocalPlayer.Character then
                    v13 = p10
                elseif v13 == p10 then
                    v14 = false

                    local v62

                    if v14 then
                        v62 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                    else
                        v62 = v15

                        if v62 then
                            v62 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                        end
                    end

                    if not v62 then
                        v14 = false
                    end

                    if v12 ~= v62 then
                        v12 = v62
                        TrainGhostVisuals.SetInput(v62)
                        TrainEvent.Suction:FireServer(v62)
                    end

                    v13 = nil
                end

                if not p10:IsDescendantOf(game) then
                    for _, v69 in t6 do
                        v69:Disconnect()
                    end

                    t2[p10] = nil
                end
            end))

            local v70 = false
            local v71 = false
            local v72 = false
            local v73 = false
            local v74 = false

            if p10.Parent == LocalPlayer.Character then
                v74 = true
            else
                v70 = true
            end

            if v70 then
                if v13 == p10 then
                    v71 = true
                else
                    v74 = false
                end
            end

            v70 = false

            if v71 then
                v14 = false

                if v14 then
                    v72 = true
                else
                    v70 = true
                end
            end

            v71 = false

            local v75

            if v70 then
                local v76 = v15

                if v76 then
                    v72 = true
                else
                    v75 = v76
                    v71 = true
                end
            end

            v70 = false

            if v72 then
                if v9.Phase == "Town" then
                    v70 = true
                else
                    v75 = false
                    v71 = true
                end
            end

            v72 = false

            if v70 then
                if v13 ~= nil then
                    v72 = true
                else
                    v75 = false
                    v71 = true
                end
            end

            v70 = false

            if v72 then
                if v13.Parent == LocalPlayer.Character then
                    v70 = true
                else
                    v75 = false
                    v71 = true
                end
            end

            v72 = false

            if v70 then
                if v10 ~= nil then
                    v72 = true
                else
                    v75 = false
                    v71 = true
                end
            end

            v70 = false

            if v72 then
                if v10.Phase == "Active" then
                    v73 = true
                else
                    v70 = true
                end
            end

            if v70 then
                v75 = false
                v71 = true
            end

            v70 = false

            if v73 then
                v75 = true
                v71 = true
            end

            v73 = false

            if v71 then
                if v75 then
                    v70 = true
                else
                    v73 = true
                end
            end

            v71 = false

            if v73 then
                v14 = false
                v70 = true
            end

            v73 = false

            if v70 then
                if v12 == v75 then
                    v71 = true
                else
                    v73 = true
                end
            end

            if v73 then
                v12 = v75
                TrainGhostVisuals.SetInput(v75)
                v71 = true
                TrainEvent.Suction:FireServer(v75)
            end

            if v71 then
                v13 = nil
                v74 = false
            end

            if v74 then
                v13 = p10
            end
        end

        local function trackCharacter(p11) -- line: 139
            -- upvalues: LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), bind (copy), TrainEvent (copy), TrainGhostVisuals (copy)
            v14 = false

            local v77 = v14
            local v78 = if not v77 then v15 else nil

            if v77 or v78 then
                v78 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
            end

            if not v78 then
                v14 = false
            end

            if v12 ~= v78 then
                v12 = v78
                TrainGhostVisuals.SetInput(v78)
                TrainEvent.Suction:FireServer(v78)
            end

            v13 = nil

            for _, child in p11:GetChildren() do
                bind(child)
            end

            p11.ChildAdded:Connect(bind)
        end

        LocalPlayer.CharacterAdded:Connect(trackCharacter)

        if LocalPlayer.Character then
            trackCharacter(LocalPlayer.Character)
        end

        task.spawn(function() -- line: 146
            -- upvalues: LocalPlayer (copy), bind (copy)
            local Backpack = LocalPlayer:WaitForChild("Backpack")

            for _, child in Backpack:GetChildren() do
                bind(child)
            end

            Backpack.ChildAdded:Connect(bind)
        end)
        ContextActionService:BindAction("TrainVacuumTrigger", function(_, p13) -- line: 150
            -- upvalues: LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
            local v79 = false
            local v80 = false
            local v81 = false
            local v82 = false
            local v83 = false
            local v84 = false

            if v13 then
                v79 = true
            else
                v84 = true
            end

            if v79 then
                if v9.Phase == "Town" then
                    v80 = true
                else
                    v84 = true
                end
            end

            v79 = false

            if v80 then
                if p13 == Enum.UserInputState.Begin then
                    v81 = true
                else
                    v79 = true
                end
            end

            v80 = false

            if v79 then
                if p13 == Enum.UserInputState.End then
                    v82 = true
                else
                    v80 = true
                end
            end

            v79 = false

            if v80 then
                if p13 == Enum.UserInputState.Cancel then
                    v82 = true
                else
                    v84 = false
                end
            end

            v80 = false

            if v82 then
                v14 = false

                if v14 then
                    v79 = true
                else
                    v80 = true
                end
            end

            v82 = false

            local v85

            if v80 then
                local v86 = v15

                if v86 then
                    v79 = true
                else
                    v85 = v86
                    v82 = true
                end
            end

            v80 = false

            if v79 then
                if v9.Phase == "Town" then
                    v80 = true
                else
                    v85 = false
                    v82 = true
                end
            end

            v79 = false

            if v80 then
                if v13 ~= nil then
                    v79 = true
                else
                    v85 = false
                    v82 = true
                end
            end

            v80 = false

            if v79 then
                if v13.Parent == LocalPlayer.Character then
                    v80 = true
                else
                    v85 = false
                    v82 = true
                end
            end

            v79 = false

            if v80 then
                if v10 ~= nil then
                    v79 = true
                else
                    v85 = false
                    v82 = true
                end
            end

            v80 = false

            if v79 then
                if v10.Phase == "Active" then
                    v83 = true
                else
                    v80 = true
                end
            end

            if v80 then
                v85 = false
                v82 = true
            end

            v80 = false

            if v83 then
                v85 = true
                v82 = true
            end

            v83 = false

            if v82 then
                if v85 then
                    v80 = true
                else
                    v83 = true
                end
            end

            v82 = false

            if v83 then
                v14 = false
                v80 = true
            end

            v83 = false

            if v80 then
                if v12 == v85 then
                    v84 = false
                else
                    v83 = true
                end
            end

            v80 = false

            if v83 then
                v12 = v85
                TrainGhostVisuals.SetInput(v85)
                v84 = false
                TrainEvent.Suction:FireServer(v85)
            end

            v83 = false

            if v81 then
                v14 = true

                if v14 then
                    v80 = true
                else
                    v83 = true
                end
            end

            v81 = false

            local v87

            if v83 then
                local v88 = v15

                if v88 then
                    v80 = true
                else
                    v87 = v88
                    v81 = true
                end
            end

            v83 = false

            if v80 then
                if v9.Phase == "Town" then
                    v83 = true
                else
                    v87 = false
                    v81 = true
                end
            end

            v80 = false

            if v83 then
                if v13 ~= nil then
                    v80 = true
                else
                    v87 = false
                    v81 = true
                end
            end

            v83 = false

            if v80 then
                if v13.Parent == LocalPlayer.Character then
                    v83 = true
                else
                    v87 = false
                    v81 = true
                end
            end

            v80 = false

            if v83 then
                if v10 ~= nil then
                    v80 = true
                else
                    v87 = false
                    v81 = true
                end
            end

            v83 = false

            if v80 then
                if v10.Phase == "Active" then
                    v82 = true
                else
                    v83 = true
                end
            end

            if v83 then
                v87 = false
                v81 = true
            end

            v83 = false

            if v82 then
                v87 = true
                v81 = true
            end

            v82 = false

            if v81 then
                if v87 then
                    v83 = true
                else
                    v82 = true
                end
            end

            if v82 then
                v14 = false
                v83 = true
            end

            v82 = false

            if v83 then
                if v12 == v87 then
                    v84 = false
                else
                    v82 = true
                end
            end

            if v82 then
                v12 = v87
                TrainGhostVisuals.SetInput(v87)
                v84 = false
                TrainEvent.Suction:FireServer(v87)
            end

            if not v84 then
                return Enum.ContextActionResult.Sink
            end

            return Enum.ContextActionResult.Pass
        end, false, Enum.KeyCode.ButtonR2)

        local t7 = {}
        local Part, clone2, v89

        local function trackPrompt(p14) -- line: 157
            -- upvalues: t7 (copy)
            if p14:IsA("ProximityPrompt") and p14:GetAttribute("TrainEventAction") then
                t7[p14] = true
            end
        end

        local Part2, clone3, v90

        local function updateBoardingPrompt() -- line: 161
            -- upvalues: LocalPlayer (copy), v9 (ref), v11 (ref), t7 (copy), Part2 (ref), clone3 (ref), v90 (ref), Workspace (copy), TrainEvent (copy), TrainReturnPrompt (copy), Toast (copy)
            local v91

            for v92 in t7 do
                if v92.Parent and v92.Name == "TrainBoard" and not v92:GetAttribute("TrainLocalBoarding") then
                    v91 = v92
                    break
                end
            end

            if v91 ~= v90 then
                if Part2 then
                    Part2:Destroy()
                end

                Part2 = nil
                clone3 = nil
                v90 = v91

                if v91 then
                    Part2 = Instance.new("Part")
                    Part2.Name = "TrainBoardingPromptAnchor"
                    Part2.Size = Vector3.new(1, 1, 1)
                    Part2.Transparency = 1
                    Part2.Anchored = true
                    Part2.CanCollide = false
                    Part2.CanTouch = false
                    Part2.CanQuery = false
                    clone3 = v91:Clone()
                    clone3.Name = "TrainBoardingMoving"
                    clone3:SetAttribute("TrainLocalBoarding", true)
                    clone3.Enabled = false

                    local clone = clone3

                    clone.KeyboardKeyCode = Enum.KeyCode.E
                    clone3.ClickablePrompt = true
                    clone3.Parent = Part2
                    Part2.Parent = Workspace
                    clone3.Triggered:Connect(function() -- line: 177
                        -- upvalues: v9 (ref), v11 (ref), TrainEvent (copy), Toast (copy)
                        if v11 or not v9.ArrivalOpen or v9.Phase ~= "Home" then
                            return
                        end

                        v11 = true

                        local function v93() -- line: 181
                            -- upvalues: TrainEvent (copy)
                            return TrainEvent.Action:InvokeServer("Board")
                        end

                        local v94, v95, v96 = pcall(v93)

                        v11 = false

                        if not v94 or not v95 then
                            local Show = Toast.Show
                            local t9 = {
                                Lane = "Feed",
                                Seconds = 3
                            }

                            if typeof(v96) ~= "string" then
                                v96 = "Boarding could not finish. Please try again."
                            end

                            t9.Text = v96
                            t9.Color = Color3.fromRGB(255, 100, 100)
                            t9.StrokeColor = Color3.fromRGB(80, 15, 15)
                            Show(t9)
                        end
                    end)
                end
            end

            if not (clone3 and Part2 and v91) then
                return
            end

            v91.Enabled = false

            local v97 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local BoardRailStart = v91:GetAttribute("BoardRailStart")
            local BoardRailEnd = v91:GetAttribute("BoardRailEnd")

            clone3.ActionText = "Board Train"
            clone3.ObjectText = "Phantom Express"

            local clone = clone3

            clone.MaxActivationDistance = v91.MaxActivationDistance

            if not v97 or typeof(BoardRailStart) ~= "Vector3" or typeof(BoardRailEnd) ~= "Vector3" then
                clone3.Enabled = false

                return
            end

            local Part = Part2

            Part.Position = TrainReturnPrompt.ClosestPoint(v97.Position, BoardRailStart, BoardRailEnd)

            local clone2 = clone3

            if v9.ArrivalOpen == true and v9.Phase == "Home" then
                clone2.Enabled = (v97.Position - Part2.Position).Magnitude <= v91.MaxActivationDistance
            else
                clone2.Enabled = false
            end
        end

        script.Destroying:Connect(function() -- line: 201
            -- upvalues: Part2 (ref)
            if Part2 then
                Part2:Destroy()
            end
        end)

        local function updateReturnPrompt() -- line: 203
            -- upvalues: LocalPlayer (copy), v6 (copy), v9 (ref), v10 (ref), n1 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), t7 (copy), Part (ref), clone2 (ref), v89 (ref), Workspace (copy), TrainEvent (copy), TrainGhostVisuals (copy), TrainReturnPrompt (copy)
            local v98

            for v99 in t7 do
                if v99.Parent and v99.Name == "TrainReturn" and v99:GetAttribute("TrainEventRequiredPhase") == "Town" and not v99:GetAttribute("TrainLocalReturn") then
                    v98 = v99
                    break
                end
            end

            if v98 ~= v89 then
                if Part then
                    Part:Destroy()
                end

                Part = nil
                clone2 = nil
                v89 = v98

                if v98 then
                    Part = Instance.new("Part")
                    Part.Name = "TrainReturnPromptAnchor"
                    Part.Size = Vector3.new(1, 1, 1)
                    Part.Transparency = 1
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.CanTouch = false
                    Part.CanQuery = false
                    clone2 = v98:Clone()
                    clone2:SetAttribute("TrainLocalReturn", true)
                    clone2.Enabled = false

                    local clone = clone2

                    clone.KeyboardKeyCode = Enum.KeyCode.E
                    clone2.ClickablePrompt = true
                    clone2.Parent = Part
                    Part.Parent = Workspace
                    clone2.Triggered:Connect(function() -- line: 218
                        -- upvalues: LocalPlayer (copy), v6 (copy), v9 (ref), v10 (ref), n1 (ref), v11 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy)
                        local v100, v101

                        if v11 then
                            v101 = true
                        elseif v9.Phase == "Town" then
                            v11 = true
                            v14 = false

                            if v14 then
                                v100 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                            else
                                v100 = v15

                                if v100 then
                                    v100 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                                end
                            end

                            v101 = false
                        else
                            v101 = true
                        end

                        if v101 then
                            return
                        end

                        if not v100 then
                            v14 = false
                        end

                        if v12 ~= v100 then
                            v12 = v100
                            TrainGhostVisuals.SetInput(v100)
                            TrainEvent.Suction:FireServer(v100)
                        end

                        local function v108() -- line: 221
                            -- upvalues: TrainEvent (copy)
                            return TrainEvent.Action:InvokeServer("Return")
                        end

                        local v109, _, v110 = pcall(v108)

                        v11 = false

                        if typeof(v110) == "string" then
                            v6.Text = v110
                            n1 = os.clock() + 5
                        elseif not v109 then
                            v6.Text = "Please try again."
                            n1 = os.clock() + 5
                        end
                    end)
                end
            end

            if not (clone2 and Part and v98) then
                return
            end

            v98.Enabled = false

            local v111 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local ReturnRailStart = v98:GetAttribute("ReturnRailStart")
            local ReturnRailEnd = v98:GetAttribute("ReturnRailEnd")

            if not v111 or typeof(ReturnRailStart) ~= "Vector3" or typeof(ReturnRailEnd) ~= "Vector3" then
                clone2.Enabled = false

                return
            end

            local Part2 = Part

            Part2.Position = TrainReturnPrompt.ClosestPoint(v111.Position, ReturnRailStart, ReturnRailEnd)

            local clone = clone2

            if v9.Phase == "Town" then
                clone.Enabled = (v111.Position - Part.Position).Magnitude <= v98.MaxActivationDistance
            else
                clone.Enabled = false
            end
        end

        script.Destroying:Connect(function() -- line: 237
            -- upvalues: Part (ref)
            if Part then
                Part:Destroy()
            end
        end)
        Workspace.DescendantAdded:Connect(function(p15) -- line: 238
            -- upvalues: trackPrompt (copy)
            if p15:IsA("ProximityPrompt") then
                task.defer(trackPrompt, p15)
            end
        end)

        for _, descendant in Workspace:GetDescendants() do
            if descendant:IsA("ProximityPrompt") and descendant:GetAttribute("TrainEventAction") then
                t7[descendant] = true
            end
        end

        local GhostVacuum, v112

        Frame.Visible = false
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        TrainEvent.State.OnClientEvent:Connect(apply)
        TrainEvent.CaptureState.OnClientEvent:Connect(function(p16) -- line: 243
            -- upvalues: LocalPlayer (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), v14 (ref), v15 (ref), TrainEvent (copy), TrainGhostVisuals (copy), TrainEventPresentation (copy)
            local v113, v114

            if v9.Phase == "Town" then
                v10 = p16
                TrainEventPresentation.UpdateInvasion(p16)

                if p16.Phase == "Active" then
                    v114 = true
                else
                    v14 = false

                    if v14 then
                        v113 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                    else
                        v113 = v15

                        if v113 then
                            v113 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                        end
                    end

                    v114 = false
                end
            else
                v114 = true
            end

            if v114 then
                return
            end

            if not v113 then
                v14 = false
            end

            if v12 == v113 then
                return
            end

            v12 = v113
            TrainGhostVisuals.SetInput(v113)
            TrainEvent.Suction:FireServer(v113)
        end)

        local function clock(p17) -- line: 244
            -- upvalues: Workspace (copy)
            local v123 = math.max(0, (math.ceil((p17 or 0) - Workspace:GetServerTimeNow())))

            return string.format("%02d:%02d", math.floor(v123 / 60), v123 % 60)
        end

        local function bossSuction() -- line: 248
            -- upvalues: LocalPlayer (copy), ReplicatedStorage (copy), GhostBoss (copy), GhostBossFlags (copy)
            if LocalPlayer:GetAttribute(GhostBoss.SuckingAttribute) ~= true then
                return nil
            end

            local v125 = ReplicatedStorage:FindFirstChild(GhostBoss.StateName)

            if not v125 then
                return nil
            end

            local v127 = math.max(tonumber(v125:GetAttribute(GhostBoss.Attributes.MaxHealth)) or 1, 1)
            local v128 = tonumber(v125:GetAttribute(GhostBoss.Attributes.Health)) or v127

            return GhostBoss.CaptureProgress(math.clamp(v128 / v127, 0, 1), GhostBossFlags.CaptureHealthFraction:Get())
        end

        RunService.RenderStepped:Connect(function(p18) -- line: 255
            -- upvalues: LocalPlayer (copy), v8 (copy), Frame3 (copy), Frame4 (copy), TextLabel (copy), v9 (ref), v10 (ref), v12 (ref), v13 (ref), n2 (ref), n3 (ref), clone (ref), v14 (ref), v15 (ref), n4 (ref), ghostInReach (copy), updateBoardingPrompt (copy), updateReturnPrompt (copy), bossSuction (copy), TrainEvent (copy), TrainGhostVisuals (copy)
            updateReturnPrompt()
            updateBoardingPrompt()

            local v130 = bossSuction()

            if not v130 then
                v130 = if not (v10 and v10.Target) then 0 else math.clamp(v10.Progress or 0, 0, 1)
            end

            if v130 == 0 then
                n2 = 0
            else
                n2 += (v130 - n2) * (1 - math.exp(-18 * p18))
            end

            Frame4.Size = UDim2.fromScale(1, n2)
            Frame3:SetAttribute("ServerProgress", v130)
            TextLabel.Text = tostring((math.floor(v130 * 100))) .. "%"

            if clone and clone.Parent then
                clone.GhostCaptureProgress.Fill.Size = Frame4.Size
                clone.Percent.Text = TextLabel.Text
                clone.CaptureTarget.Text = v8.Text
            end

            local v137 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local v138 = false

            if v137 and v137:IsA("BasePart") and v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active" then
                if ghostInReach(v137) then
                    n4 = os.clock()
                end

                v138 = os.clock() - n4 <= 0.3
            end

            if v138 ~= v15 then
                v15 = v138

                local v139

                if v14 then
                    v139 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                else
                    v139 = v15

                    if v139 then
                        v139 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                    end
                end

                if not v139 then
                    v14 = false
                end

                if v12 ~= v139 then
                    v12 = v139
                    TrainGhostVisuals.SetInput(v139)
                    TrainEvent.Suction:FireServer(v139)
                end
            end

            if v12 then
                if not v13 or v13.Parent ~= LocalPlayer.Character then
                    v14 = false

                    local v146 = v14
                    local v147

                    if v146 then
                        v147 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                    else
                        v147 = v15

                        if v147 then
                            v147 = v9.Phase == "Town" and v13 ~= nil and v13.Parent == LocalPlayer.Character and v10 ~= nil and v10.Phase == "Active"
                        end
                    end

                    if not v147 then
                        v14 = false
                    end

                    if v12 ~= v147 then
                        v12 = v147
                        TrainGhostVisuals.SetInput(v147)
                        TrainEvent.Suction:FireServer(v147)
                    end
                elseif os.clock() >= n3 then
                    n3 = os.clock() + 0.25
                    TrainEvent.Suction:FireServer(true)
                end
            end
        end)
        RunService.Heartbeat:Connect(function() -- line: 281
            -- upvalues: LocalPlayer (copy), Frame (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), Frame2 (copy), v8 (copy), Frame3 (copy), v9 (ref), v10 (ref), n1 (ref), v12 (ref), clone (ref), t5 (copy), t7 (copy), GhostVacuum (ref), v112 (ref), bossSuction (copy), Workspace (copy), UserInputService (copy), GhostBoss (copy)
            local v154 = v9.ArrivalOpen and v9.DepartureAt > Workspace:GetServerTimeNow()
            local v155 = v9.Phase == "Town"

            Frame.Size = UDim2.new(0.85, 0, 0, if v155 then if UserInputService.TouchEnabled then 200 else 156 elseif v154 and v9.Phase == "Home" and v9.Prototype == true and not v9.AtStation then 160 else 112)
            Frame.Visible = false
            v4.Text = v155 and "GHOST INVASION" or "PHANTOM EXPRESS"

            local v157 = v9.AtStation == true
            local Station = t5.Station

            if v154 then
                if v9.Phase == "Home" and v9.Prototype == true then
                    Station.Visible = not v157
                else
                    Station.Visible = false
                end
            else
                Station.Visible = v154
            end

            for v158 in t7 do
                if v158.Parent then
                    local TrainEventAction = v158:GetAttribute("TrainEventAction")

                    if not v158:GetAttribute("TrainLocalBoarding") then
                        if v158.Name == "TrainBoard" or v158.Name == "TrainCancel" then
                            v158.Enabled = false
                        elseif TrainEventAction == "HandIn" then
                            if v154 then
                                if v9.Phase ~= "Home" or v9.StationAvailable == false then
                                    v158.Enabled = false
                                else
                                    v158.Enabled = not v9.AccessUnlocked
                                end
                            else
                                v158.Enabled = v154
                            end
                        elseif TrainEventAction == "Board" then
                            if v154 then
                                if v9.Phase == "Home" then
                                    v158.Enabled = v9.StationAvailable ~= false
                                else
                                    v158.Enabled = false
                                end
                            else
                                v158.Enabled = v154
                            end
                        elseif TrainEventAction == "Return" then
                            if not v158:GetAttribute("TrainLocalReturn") then
                                if v158.Name ~= "TrainReturn" or v158:GetAttribute("TrainLocalReturn") then
                                    v158.Enabled = v9.Phase == v158:GetAttribute("TrainEventRequiredPhase")
                                else
                                    v158.Enabled = false
                                end
                            end
                        elseif TrainEventAction == "OpenSoulShop" then
                            v158.Enabled = v155 and v9.TravelBusy ~= true
                        elseif TrainEventAction == "PickupVacuum" then
                            if v155 then
                                if v9.TravelBusy == true or v10 == nil then
                                    v158.Enabled = false
                                else
                                    v158.Enabled = not v10.VacuumOwned
                                end
                            else
                                v158.Enabled = v155
                            end
                        end
                    end
                else
                    t7[v158] = nil
                end
            end

            local TrainEventRuntime = Workspace:FindFirstChild("TrainEventRuntime")
            local GhostVacuum2 = TrainEventRuntime and TrainEventRuntime:FindFirstChild("GhostVacuum")

            if GhostVacuum2 and GhostVacuum2:IsA("Model") then
                if GhostVacuum ~= GhostVacuum2 then
                    GhostVacuum = GhostVacuum2
                    v112 = GhostVacuum2:GetPivot()
                end

                local v161 = v155 and v10 ~= nil and v10.VacuumOwned == true

                for _, descendant in GhostVacuum2:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = v161 and 1 or 0
                    elseif descendant:IsA("BillboardGui") then
                        descendant.Enabled = not v161
                    end
                end

                if v112 then
                    local v162 = if not v155 or v161 then v112 else v112 * CFrame.new(0, math.sin(os.clock() * 1.8) * 0.35, 0) * CFrame.Angles(0, os.clock() * 0.6, 0)

                    GhostVacuum2:PivotTo(v162)
                end
            end

            local v165 = v155 and v9.TravelBusy ~= true and v10 ~= nil and not v10.VacuumOwned
            local PickupGlow = GhostVacuum2 and GhostVacuum2:FindFirstChild("PickupGlow")

            if PickupGlow and PickupGlow:IsA("Highlight") then
                PickupGlow.Enabled = v165
            end

            local GhostVacuumRing = TrainEventRuntime and TrainEventRuntime:FindFirstChild("GhostVacuumRing")

            if GhostVacuumRing then
                for _, descendant in GhostVacuumRing:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = v165 and 0 or 1
                    end
                end
            end

            v7.Visible = v155

            local v166

            if v155 then
                if v10 ~= nil then
                    if v10.VacuumEquipped == true and v10.Phase == "Active" then
                        v166 = v12

                        if not v166 then
                            v166 = v10.Holding == true or v10.Target ~= nil
                        end
                    else
                        v166 = false
                    end
                else
                    v166 = false
                end
            else
                v166 = v155
            end

            Frame2.Visible = v166

            local v167 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("TrainVacuumBackpack")
            local v168 = v167 and v167:FindFirstChildWhichIsA("BillboardGui", true)

            if clone and (not clone.Parent or clone.Parent ~= v168) then
                clone:Destroy()
                clone = nil
            end

            if v168 and not clone then
                clone = Frame2:Clone()
                clone.Name = "TrainCaptureProgress"
                clone.AnchorPoint = Vector2.new(0.5, 0.5)
                clone.Position = UDim2.fromScale(0.5, 0.5)
                clone.Parent = v168
            end

            if clone then
                clone.Visible = Frame2.Visible
                Frame2.Visible = false
            end

            v8.Visible = true
            Frame3.Visible = true

            local CurrentCamera = Workspace.CurrentCamera

            Frame2.Position = if UserInputService.TouchEnabled then UDim2.fromScale(0.7, 0.44) else UDim2.new(0.5, math.clamp((CurrentCamera and CurrentCamera.ViewportSize.X or 1000) * 0.08, 48, 110), 0.5, 0)

            if v155 and v10 then
                local v171

                if v10.Phase == "Warmup" then
                    local v174 = math.max(0, (math.ceil((v10.StartsAt or 0) - Workspace:GetServerTimeNow())))

                    v171 = "Invasion starts in " .. string.format("%02d:%02d", math.floor(v174 / 60), v174 % 60)
                elseif v10.Phase == "Active" then
                    local v178 = math.max(0, (math.ceil((v10.EndsAt or 0) - Workspace:GetServerTimeNow())))

                    v171 = "Invasion ends in " .. string.format("%02d:%02d", math.floor(v178 / 60), v178 % 60)
                else
                    local v180 = string.lower(v10.Phase)
                    local v183 = math.max(0, (math.ceil((v9.ReturnAt or 0) - Workspace:GetServerTimeNow())))

                    v171 = "Invasion " .. v180 .. " • return in " .. string.format("%02d:%02d", math.floor(v183 / 60), v183 % 60)
                end

                v5.Text = v171
                v7.Text = ("Captured %* • Souls this visit %*\nSaved Souls %*%*"):format(v10.Captured, v10.VisitSouls, v10.SavedSouls, v10.Practice and " • PRACTICE: rewards not saved" or "")
                v8.Text = if bossSuction() then GhostBoss.DisplayName elseif v10.Interrupted then "Suction interrupted!" else v10.Target or "Aim at a ghost"
            else
                local v186 = v9
                local v187

                if v186.Phase == "Departing" then
                    v187 = "Travelling to Forgotten Town…"
                elseif v9.Phase == "Returning" then
                    v187 = "Returning to Halloween…"
                elseif v154 then
                    local v189 = v9
                    local v192 = math.max(0, (math.ceil((v189.DepartureAt or 0) - Workspace:GetServerTimeNow())))

                    v187 = "Boarding closes in " .. string.format("%02d:%02d", math.floor(v192 / 60), v192 % 60)
                else
                    v187 = ""
                end

                v5.Text = v187
            end

            if v154 and v9.Phase == "Home" and os.clock() > n1 then
                v6.Text = if v157 then if v9.AccessUnlocked then "Use the Board Train prompt before departure." else "Use Board Train with your Train Pass to unlock permanent access." elseif v9.Prototype then "The test station is away from spawn. Use Go to Station." else "Go to the Halloween station to board."
            end
        end)
        task.spawn(function() -- line: 342
            -- upvalues: ScreenGui (copy), apply (copy), TrainEvent (copy)
            while ScreenGui.Parent do
                local function v195() -- line: 343
                    -- upvalues: TrainEvent (copy)
                    return TrainEvent.Action:InvokeServer("Status")
                end

                local v196, v197, v198 = pcall(v195)

                if v196 and v197 then
                    apply(v198)
                end

                task.wait(3)
            end
        end)
    end
}
