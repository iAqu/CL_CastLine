-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

return {
    new = function(p1, p2) -- new | line: 10
        -- upvalues: ContextActionService (copy), GuiService (copy), Players (copy), RunService (copy), StarterGui (copy), UserInputService (copy)
        local LocalPlayer = Players.LocalPlayer
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local t2 = {}
        local t3 = {}
        local FreecamControls = p1:WaitForChild("FreecamControls")
        local v1 = require(p1:WaitForChild("DisguiseCamera")).Start()

        local function hideUI() -- line: 19
            -- upvalues: p1 (copy), PlayerGui (copy), StarterGui (copy)
            local t4 = {}
            local t5 = {}
            local t6 = {}

            local function hide(p3) -- line: 23
                -- upvalues: t4 (copy), t5 (copy), p1 (copy)
                if not p3:IsA("ScreenGui") or p3 == p1 then
                    return
                end

                t4[p3] = p3.Enabled
                p3.Enabled = false
                table.insert(t5, p3:GetPropertyChangedSignal("Enabled"):Connect(function() -- line: 31
                    -- upvalues: p3 (copy)
                    if p3.Enabled then
                        p3.Enabled = false
                    end
                end))
            end

            for _, child in PlayerGui:GetChildren() do
                hide(child)
            end

            local connection = PlayerGui.ChildAdded:Connect(hide)

            for _, v3 in Enum.CoreGuiType:GetEnumItems() do
                if v3 ~= Enum.CoreGuiType.All then
                    local function v4() -- line: 45
                        -- upvalues: t6 (copy), v3 (copy), StarterGui (copy)
                        t6[v3] = StarterGui:GetCoreGuiEnabled(v3)
                        StarterGui:SetCoreGuiEnabled(v3, false)
                    end

                    pcall(v4)
                end
            end

            return function() -- line: 51
                -- upvalues: t4 (copy), t5 (copy), t6 (copy), connection (copy), StarterGui (copy)
                connection:Disconnect()

                for _, v5 in t5 do
                    v5:Disconnect()
                end

                for v6, v7 in t4 do
                    if v6.Parent then
                        v6.Enabled = v7
                    end
                end

                for v8, v9 in t6 do
                    local function v10() -- line: 62
                        -- upvalues: v8 (copy), v9 (copy), StarterGui (copy)
                        StarterGui:SetCoreGuiEnabled(v8, v9)
                    end

                    pcall(v10)
                end
            end
        end

        local function hideNameplates() -- line: 69
            -- upvalues: Players (copy)
            local t7 = {}
            local t8 = {}

            local function hide(p4) -- line: 72
                -- upvalues: t7 (copy)
                if t7[p4] == nil then
                    if p4:IsA("Humanoid") then
                        t7[p4] = p4.DisplayDistanceType
                        p4.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    elseif p4:IsA("BillboardGui") then
                        t7[p4] = p4.Enabled
                        p4.Enabled = false
                    end
                end
            end

            local function character(p5) -- line: 85
                -- upvalues: t7 (copy), t8 (copy), hide (copy)
                for _, descendant in p5:GetDescendants() do
                    if t7[descendant] == nil then
                        if descendant:IsA("Humanoid") then
                            t7[descendant] = descendant.DisplayDistanceType
                            descendant.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        elseif descendant:IsA("BillboardGui") then
                            t7[descendant] = descendant.Enabled
                            descendant.Enabled = false
                        end
                    end
                end

                table.insert(t8, p5.DescendantAdded:Connect(hide))
            end

            local function watch(p6) -- line: 91
                -- upvalues: t7 (copy), t8 (copy), hide (copy), character (copy)
                if p6.Character then
                    local Character = p6.Character

                    for _, descendant in Character:GetDescendants() do
                        if t7[descendant] == nil then
                            if descendant:IsA("Humanoid") then
                                t7[descendant] = descendant.DisplayDistanceType
                                descendant.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                            elseif descendant:IsA("BillboardGui") then
                                t7[descendant] = descendant.Enabled
                                descendant.Enabled = false
                            end
                        end
                    end

                    table.insert(t8, Character.DescendantAdded:Connect(hide))
                end

                table.insert(t8, p6.CharacterAdded:Connect(character))
            end

            for _, player in Players:GetPlayers() do
                if player.Character then
                    local Character = player.Character

                    for _, descendant in Character:GetDescendants() do
                        if t7[descendant] == nil then
                            if descendant:IsA("Humanoid") then
                                t7[descendant] = descendant.DisplayDistanceType
                                descendant.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                            elseif descendant:IsA("BillboardGui") then
                                t7[descendant] = descendant.Enabled
                                descendant.Enabled = false
                            end
                        end
                    end

                    table.insert(t8, Character.DescendantAdded:Connect(hide))
                end

                table.insert(t8, player.CharacterAdded:Connect(character))
            end

            table.insert(t8, Players.PlayerAdded:Connect(watch))

            return function() -- line: 101
                -- upvalues: t7 (copy), t8 (copy)
                for _, v11 in t8 do
                    v11:Disconnect()
                end

                for v12, v13 in t7 do
                    if v12.Parent then
                        if v12:IsA("Humanoid") then
                            v12.DisplayDistanceType = v13
                        elseif v12:IsA("BillboardGui") then
                            v12.Enabled = v13
                        end
                    end
                end
            end
        end

        local function freecam() -- line: 117
            -- upvalues: p1 (copy), p2 (copy), FreecamControls (copy), ContextActionService (copy), GuiService (copy), RunService (copy), UserInputService (copy)
            local v14 = assert(workspace.CurrentCamera)
            local t9 = {
                Type = v14.CameraType,
                Subject = v14.CameraSubject,
                CFrame = v14.CFrame,
                Focus = v14.Focus,
                Fov = v14.FieldOfView,
                Mouse = UserInputService.MouseBehavior,
                Icon = UserInputService.MouseIconEnabled
            }
            local CFramePosition = v14.CFrame.Position
            local v15, v16 = v14.CFrame:ToOrientation()
            local v17 = v15
            local v18 = v16
            local v19 = Vector3.new(0, 0, 0)
            local t10 = {}
            local t11 = {}
            local v20, v21 = Vector2.zero, Vector2.zero
            local n1 = 0
            local n2 = 0
            local v22
            local t12 = {}
            local SelectedObject = GuiService.SelectedObject

            GuiService.SelectedObject = nil
            FreecamControls.Visible = true
            FreecamControls.Hint.Text = UserInputService.TouchEnabled and "FREECAM  •  Drag to look" or "FREECAM  •  WASD / sticks · Q/E rise · Shift boost"

            local function action(_, p8, p9) -- line: 143
                -- upvalues: t10 (copy), v20 (ref), v21 (ref), n1 (ref), n2 (ref), p1 (copy), UserInputService (copy)
                local v23 = UserInputService:GetFocusedTextBox() ~= nil or p1.Root.Visible

                if p9.KeyCode == Enum.KeyCode.Thumbstick1 then
                    v20 = if v23 then Vector2.zero else Vector2.new(p9.Position.X, p9.Position.Y)
                elseif p9.KeyCode == Enum.KeyCode.Thumbstick2 then
                    v21 = if v23 then Vector2.zero else Vector2.new(p9.Position.X, p9.Position.Y)
                elseif p9.KeyCode == Enum.KeyCode.ButtonR2 then
                    n1 = if v23 then 0 else p9.Position.Z
                elseif p9.KeyCode == Enum.KeyCode.ButtonL2 then
                    n2 = if v23 then 0 else p9.Position.Z
                else
                    local KeyCode = p9.KeyCode
                    local v24 = not v23 and p8 ~= Enum.UserInputState.End and p8 ~= Enum.UserInputState.Cancel

                    t10[KeyCode] = v24
                end

                if v23 then
                    return Enum.ContextActionResult.Pass
                end

                return Enum.ContextActionResult.Sink
            end

            ContextActionService:BindActionAtPriority("CreatorFreecamMove", action, false, 3000, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Q, Enum.KeyCode.E, Enum.KeyCode.LeftShift, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2)

            for _, v25 in { "Forward", "Back", "Left", "Right", "Up", "Down" } do
                local v26 = FreecamControls[v25]

                table.insert(t12, v26.InputBegan:Connect(function(p10) -- line: 188
                    -- upvalues: t11 (copy), v25 (copy)
                    if p10.UserInputType == Enum.UserInputType.Touch or p10.UserInputType == Enum.UserInputType.MouseButton1 then
                        t11[v25] = true
                    end
                end))
                table.insert(t12, v26.InputEnded:Connect(function(p11) -- line: 200
                    -- upvalues: t11 (copy), v25 (copy)
                    if p11.UserInputType == Enum.UserInputType.Touch or p11.UserInputType == Enum.UserInputType.MouseButton1 then
                        t11[v25] = nil
                    end
                end))
            end

            table.insert(t12, FreecamControls.Exit.Activated:Connect(p2))
            table.insert(t12, UserInputService.InputBegan:Connect(function(p12, p13) -- line: 214
                -- upvalues: v22 (ref), p2 (copy), UserInputService (copy)
                if p13 then
                    return
                end

                if p12.UserInputType == Enum.UserInputType.Touch then
                    v22 = p12
                end

                if p12.UserInputType == Enum.UserInputType.MouseButton2 then
                    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                end

                if p12.KeyCode == Enum.KeyCode.ButtonB then
                    p2()
                end
            end))
            table.insert(t12, UserInputService.InputEnded:Connect(function(p14) -- line: 232
                -- upvalues: t9 (copy), v22 (ref), UserInputService (copy)
                if p14 == v22 then
                    v22 = nil
                end

                if p14.UserInputType == Enum.UserInputType.MouseButton2 then
                    UserInputService.MouseBehavior = t9.Mouse
                end
            end))
            table.insert(t12, UserInputService.WindowFocusReleased:Connect(function() -- line: 243
                -- upvalues: t9 (copy), t10 (copy), t11 (copy), v20 (ref), v21 (ref), n1 (ref), n2 (ref), UserInputService (copy)
                table.clear(t10)
                table.clear(t11)
                v20 = Vector2.zero
                v21 = Vector2.zero
                n1 = 0
                n2 = 0
                UserInputService.MouseBehavior = t9.Mouse
            end))
            table.insert(t12, UserInputService.InputChanged:Connect(function(p15, p16) -- line: 254
                -- upvalues: v14 (copy), v17 (ref), v18 (ref), v22 (ref), p1 (copy), UserInputService (copy)
                if p1.Root.Visible then
                    return
                end

                if p15 ~= v22 and (p15.UserInputType ~= Enum.UserInputType.MouseMovement or not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)) then
                    if not p16 and p15.UserInputType == Enum.UserInputType.MouseWheel then
                        v14.FieldOfView = math.clamp(v14.FieldOfView - p15.Position.Z * 4, 20, 100)
                    end
                else
                    v18 -= p15.Delta.X * 0.003

                    local v36 = v17

                    v17 = math.clamp(v36 - p15.Delta.Y * 0.003, -1.5, 1.5)
                end
            end))

            local function pressed(p17, p18) -- line: 282
                -- upvalues: t10 (copy), t11 (copy)
                if t10[p17] or t11[p18] then
                    return 1
                end

                return 0
            end

            local function deadzone(p19) -- line: 285
                if math.abs(p19) > 0.15 then
                    return p19
                end

                return 0
            end

            v14.CameraType = Enum.CameraType.Scriptable
            RunService:BindToRenderStep("CreatorFreecam", Enum.RenderPriority.Camera.Value + 1, function(p20) -- line: 292
                -- upvalues: v14 (copy), CFramePosition (ref), v17 (ref), v18 (ref), v19 (ref), t10 (copy), t11 (copy), v20 (ref), v21 (ref), n1 (ref), n2 (ref), p1 (copy)
                local v38 = math.min(p20, 0.1)
                local v39

                if p1.Root.Visible then
                    v39 = Vector3.new(0, 0, 0)
                else
                    local v40 = v18
                    local X = v21.X

                    if not (math.abs(X) > 0.15) then
                        X = 0
                    end

                    v18 = v40 - X * v38 * 2

                    local v41 = v17
                    local Y = v21.Y

                    if not (math.abs(Y) > 0.15) then
                        Y = 0
                    end

                    v17 = math.clamp(v41 + Y * v38 * 2, -1.5, 1.5)

                    local v44 = (if t10[Enum.KeyCode.D] or t11.Right then 1 else 0) - (if t10[Enum.KeyCode.A] or t11.Left then 1 else 0)
                    local X2 = v20.X

                    if not (math.abs(X2) > 0.15) then
                        X2 = 0
                    end

                    local v45 = v44 + X2
                    local v47 = (if t10[Enum.KeyCode.E] or t11.Up then 1 else 0) - (if t10[Enum.KeyCode.Q] or t11.Down then 1 else 0) + n1 - n2
                    local v49 = (if t10[Enum.KeyCode.S] or t11.Back then 1 else 0) - (if t10[Enum.KeyCode.W] or t11.Forward then 1 else 0)
                    local Y2 = v20.Y

                    if not (math.abs(Y2) > 0.15) then
                        Y2 = 0
                    end

                    v39 = Vector3.new(v45, v47, v49 - Y2)
                end

                if v39.Magnitude > 1 then
                    v39 = v39.Unit
                end

                local v51 = CFrame.fromOrientation(v17, v18, 0)

                v19 = v19:Lerp(v51:VectorToWorldSpace(v39) * (if t10[Enum.KeyCode.LeftShift] then 90 else 32), 1 - math.exp(-12 * v38))
                CFramePosition += v19 * v38
                v14.CFrame = CFrame.new(CFramePosition) * v51
                v14.Focus = v14.CFrame * CFrame.new(0, 0, -30)
            end)

            return function() -- line: 331
                -- upvalues: v14 (copy), t9 (copy), t12 (copy), SelectedObject (copy), FreecamControls (copy), ContextActionService (copy), GuiService (copy), RunService (copy), UserInputService (copy)
                RunService:UnbindFromRenderStep("CreatorFreecam")
                ContextActionService:UnbindAction("CreatorFreecamMove")

                for _, v55 in t12 do
                    v55:Disconnect()
                end

                FreecamControls.Visible = false

                local Type, Subject = t9.Type, t9.Subject

                v14.CameraType = Type
                v14.CameraSubject = Subject

                local CFrame, Focus, Fov = t9.CFrame, t9.Focus, t9.Fov

                v14.CFrame = CFrame
                v14.Focus = Focus
                v14.FieldOfView = Fov

                local Mouse, Icon = t9.Mouse, t9.Icon

                UserInputService.MouseBehavior = Mouse
                UserInputService.MouseIconEnabled = Icon
                GuiService.SelectedObject = if not (SelectedObject and SelectedObject.Parent) then nil else SelectedObject
            end
        end

        local function spectate(p21) -- line: 351
            -- upvalues: LocalPlayer (copy), Players (copy)
            local v56 = assert(workspace.CurrentCamera)
            local CameraSubject = v56.CameraSubject
            local PlayerByUserId = Players:GetPlayerByUserId(p21)
            local t13 = {}

            local function follow(p22) -- line: 356
                -- upvalues: v56 (copy)
                local Humanoid = p22 and p22:FindFirstChildWhichIsA("Humanoid")

                if Humanoid then
                    v56.CameraSubject = Humanoid
                end
            end

            if PlayerByUserId then
                local Character = PlayerByUserId.Character
                local Humanoid = Character and Character:FindFirstChildWhichIsA("Humanoid")

                if Humanoid then
                    v56.CameraSubject = Humanoid
                end

                table.insert(t13, PlayerByUserId.CharacterAdded:Connect(function(p23) -- line: 364
                    -- upvalues: v56 (copy)
                    p23:WaitForChild("Humanoid")

                    local Humanoid = p23 and p23:FindFirstChildWhichIsA("Humanoid")

                    if Humanoid then
                        v56.CameraSubject = Humanoid
                    end
                end))
            end

            return function() -- line: 369
                -- upvalues: v56 (copy), CameraSubject (copy), t13 (copy), LocalPlayer (copy)
                for _, v58 in t13 do
                    v58:Disconnect()
                end

                local Character = LocalPlayer.Character

                v56.CameraSubject = Character and Character:FindFirstChildWhichIsA("Humanoid") or CameraSubject
            end
        end

        local t14 = {
            hideUI = false,
            freecam = false
        }
        local v59

        local function reconcileUI() -- line: 381
            -- upvalues: hideUI (copy), t14 (copy), v59 (ref)
            if t14.hideUI or t14.freecam then
                v59 = v59 or hideUI()
            elseif v59 then
                v59()
                v59 = nil
            end
        end

        function t3.SetFreecamSettings(p24) -- line: 391
            -- upvalues: t2 (copy), FreecamControls (copy), hideUI (copy), t14 (copy), v59 (ref)
            t14.freecam = t2.freecam ~= nil and p24.HideOtherUI == true
            FreecamControls.Visible = t2.freecam ~= nil and p24.HideControls ~= true

            if t14.hideUI or t14.freecam then
                v59 = v59 or hideUI()
            elseif v59 then
                v59()
                v59 = nil
            end
        end

        function t3.Set(p25, p26, p27, p28, p29) -- line: 398
            -- upvalues: t2 (copy), FreecamControls (copy), hideUI (copy), hideNameplates (copy), freecam (copy), spectate (copy), t14 (copy), v59 (ref)
            if p25 == "hideUI" then
                t14.hideUI = p26

                if t14.hideUI or t14.freecam then
                    v59 = v59 or hideUI()
                elseif v59 then
                    v59()
                    v59 = nil
                end
            else
                if p25 == "freecam" then
                    t14.freecam = p26 and p27 == true

                    if t14.hideUI or t14.freecam then
                        v59 = v59 or hideUI()
                    elseif v59 then
                        v59()
                        v59 = nil
                    end
                end

                if t2[p25] then
                    t2[p25]()
                    t2[p25] = nil
                end

                if p26 then
                    if p25 == "freecam" then
                        t2[p25] = freecam()
                        FreecamControls.Visible = p28 ~= true
                    elseif p25 == "hideNameplates" then
                        t2[p25] = hideNameplates()
                    elseif p25 == "spectate" and p29 then
                        t2[p25] = spectate(p29)
                    end
                end
            end
        end

        function t3.Destroy() -- line: 429
            -- upvalues: t2 (copy), t3 (copy), v1 (copy), hideUI (copy), t14 (copy), v59 (ref)
            t14.hideUI = false
            t14.freecam = false

            if t14.hideUI or t14.freecam then
                v59 = v59 or hideUI()
            elseif v59 then
                v59()
                v59 = nil
            end

            for v63 in t2 do
                t3.Set(v63, false)
            end

            v1()
        end

        return t3
    end
}
