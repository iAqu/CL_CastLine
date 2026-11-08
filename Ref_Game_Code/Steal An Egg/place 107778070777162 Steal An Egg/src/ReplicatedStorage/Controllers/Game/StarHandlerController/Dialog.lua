-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local MenuNavigation = require(ReplicatedStorage.Client.MenuNavigation)
local MessageTyper = require(ReplicatedStorage.Client.UI.MessageTyper)
local Tabs = require(ReplicatedStorage.Client.Tabs)
local Trove = require(ReplicatedStorage.Packages.Trove)
local v1 = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local t1 = {
    Enum.KeyCode.One,
    Enum.KeyCode.Two,
    Enum.KeyCode.Three,
    Enum.KeyCode.Four
}
local LocalPlayer = Players.LocalPlayer
local t2 = {}

t2.__index = t2

local function templates() -- line: 59
    -- upvalues: ReplicatedStorage (copy)
    local Npcs = ReplicatedStorage.Assets.UI.Npcs

    return Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
end

local function rootPart() -- line: 66
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function stripScripts(p1) -- line: 72
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BaseScript") then
            descendant:Destroy()
        end
    end
end

local function popIn(p2, p3) -- line: 80
    -- upvalues: TweenService (copy), v3 (copy)
    local UIScale = p2:FindFirstChildOfClass("UIScale")

    if UIScale == nil then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = p2
    end

    UIScale.Scale = 0.6
    p3:Add(TweenService:Create(UIScale, v3, {
        Scale = 1
    })):Play()
end

local function sizeFor(p4, p5) -- line: 91
    local Size = p4.Size
    local v4 = if #p5 > 45 then 2 else 1

    return UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * v4, Size.Y.Offset)
end

local function keepReadable(p6, p7, p8) -- line: 97
    -- upvalues: RunService (copy), Workspace (copy)
    return RunService.RenderStepped:Connect(function() -- line: 98
        -- upvalues: p6 (copy), p7 (copy), p8 (copy), Workspace (copy)
        local CurrentCamera = Workspace.CurrentCamera
        local Adornee = p6.Adornee
        local v5

        if not (Adornee and Adornee:IsA("Attachment")) then
            local BasePart = if Adornee then Adornee:IsA("BasePart") else nil

            if Adornee and BasePart then
                v5 = Adornee.Position
            end
        else
            v5 = Adornee.WorldPosition
        end

        if CurrentCamera ~= nil and v5 ~= nil then
            local v7 = math.max(1, (CurrentCamera.CFrame.Position - v5).Magnitude / 17)
            local v8 = p7()

            p6.Size = UDim2.new(v8.X.Scale * v7, v8.X.Offset, v8.Y.Scale * v7, v8.Y.Offset)
            p6.StudsOffset = p8 * v7
        end
    end)
end

function t2.new(p9, p10, p11) -- line: 119
    -- upvalues: ReplicatedStorage (copy), RunService (copy), UserInputService (copy), Workspace (copy), MessageTyper (copy), Tabs (copy), Trove (copy), LocalPlayer (copy), t2 (copy), stripScripts (copy), popIn (copy), keepReadable (copy)
    local Npcs = ReplicatedStorage.Assets.UI.Npcs
    local Talk_UI, _, _ = Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
    local v9 = Trove.new()
    local PrimaryPart = p9.PrimaryPart
    local BoundingBox, BoundingBox2 = p9:GetBoundingBox()
    local v10 = v9:Add(Instance.new("Attachment"))

    v10.Name = "StarHandlerSpeech"
    v10.Position = PrimaryPart.CFrame:PointToObjectSpace(BoundingBox.Position + Vector3.new(0, BoundingBox2.Y / 2, 0))
    v10.Parent = PrimaryPart

    local v12 = v9:Add(Talk_UI:Clone())

    v12.Name = "StarHandlerSpeech"
    v12.Adornee = v10
    v12.MaxDistance = 1e999
    stripScripts(v12)

    local TextLabel = v12:FindFirstChildOfClass("TextLabel")

    TextLabel.Text = ""
    v12.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    popIn(v12, v9)

    local v13 = MessageTyper.new(TextLabel, nil, 0.035, true)

    v9:Add(function() -- line: 140
        -- upvalues: v13 (copy)
        v13:Halt()
    end)

    local v14 = setmetatable({
        Closed = false,
        _skip = false,
        _npc = p9,
        _prompt = p10,
        _anchor = v10,
        _bubble = v12,
        _label = TextLabel,
        _typer = v13,
        _trove = v9,
        _rows = {},
        _size = Talk_UI.Size,
        _onClose = p11
    }, t2)

    v9:Add(keepReadable(v12, function() -- line: 159
        -- upvalues: v14 (copy)
        return v14._size
    end, Talk_UI.StudsOffset))
    p10.Enabled = false
    v9:Add(function() -- line: 164
        -- upvalues: p10 (copy)
        p10.Enabled = true
    end)
    v9:Connect(RunService.Heartbeat, function() -- line: 168
        -- upvalues: p9 (copy), p10 (copy), v10 (copy), v14 (copy), Workspace (copy), LocalPlayer (copy)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local Character2 = LocalPlayer.Character
        local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart == nil or Humanoid == nil or Humanoid.Health <= 0 or not p9:IsDescendantOf(Workspace) or (HumanoidRootPart.Position - v10.WorldPosition).Magnitude > p10.MaxActivationDistance + 8 then
            v14:Close()
        end
    end)
    v9:Connect(Tabs.Activated, function(p12) -- line: 183
        -- upvalues: v14 (copy)
        if p12 ~= "StarBundles" then
            v14:Close()
        end
    end)
    v9:Connect(UserInputService.InputBegan, function(p13, p14) -- line: 188
        -- upvalues: v14 (copy)
        if not p14 then
            local UserInputType = p13.UserInputType

            if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p13.KeyCode == Enum.KeyCode.Space or p13.KeyCode == Enum.KeyCode.ButtonA then
                v14._skip = true
            end
        end
    end)

    return v14
end

function t2.Say(p15, p16) -- line: 205
    -- upvalues: ReplicatedStorage (copy)
    for _, v15 in p16 do
        if p15.Closed then
            return false
        end

        local Npcs = ReplicatedStorage.Assets.UI.Npcs
        local Talk_UI, _, _ = Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
        local Size = Talk_UI.Size
        local v16 = #v15 > 45 and 2 or 1

        p15._size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * v16, Size.Y.Offset)
        p15._skip = false
        p15._typer:Type(v15, p15._label.TextColor3)

        local v17 = utf8.len(v15) or #v15
        local v18 = os.clock() + v17 * 0.035

        while os.clock() < v18 and not p15._skip do
            if p15.Closed then
                break
            end

            task.wait()
        end

        if p15._skip then
            p15._typer:ShowAll(v15, p15._label.TextColor3)
            p15._skip = false
        end

        local v20 = os.clock() + math.max(1.15, #v15 * 0.022)

        while os.clock() < v20 and not p15._skip do
            if p15.Closed then
                break
            end

            task.wait()
        end
    end

    return not p15.Closed
end

function t2.Echo(p17, p18) -- line: 230
    -- upvalues: ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), v2 (copy), LocalPlayer (copy), stripScripts (copy), popIn (copy)
    if p17.Closed then
        return
    end

    local Npcs = ReplicatedStorage.Assets.UI.Npcs
    local _, Response_UI, _ = Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
    local Character = LocalPlayer.Character
    local Head = Character and Character:FindFirstChild("Head")

    if Head == nil then
        return
    end

    local clone = Response_UI:Clone()

    stripScripts(clone)
    clone.Adornee = Head
    clone.MaxDistance = 1e999

    local Size = clone.Size

    local function v21() -- line: 245
        -- upvalues: Size (copy)
        return Size
    end

    local StudsOffset = clone.StudsOffset
    local connection = RunService.RenderStepped:Connect(function() -- line: 98
        -- upvalues: clone (copy), v21 (copy), StudsOffset (copy), Workspace (copy)
        local CurrentCamera = Workspace.CurrentCamera
        local Adornee = clone.Adornee
        local v22

        if not (Adornee and Adornee:IsA("Attachment")) then
            local BasePart = if Adornee then Adornee:IsA("BasePart") else nil

            if Adornee and BasePart then
                v22 = Adornee.Position
            end
        else
            v22 = Adornee.WorldPosition
        end

        if CurrentCamera ~= nil and v22 ~= nil then
            local v24 = math.max(1, (CurrentCamera.CFrame.Position - v22).Magnitude / 17)
            local v25 = v21()

            clone.Size = UDim2.new(v25.X.Scale * v24, v25.X.Offset, v25.Y.Scale * v24, v25.Y.Offset)
            clone.StudsOffset = StudsOffset * v24
        end
    end)

    clone.Destroying:Once(function() -- line: 248
        -- upvalues: connection (copy)
        connection:Disconnect()
    end)
    clone.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    local TextLabel = clone:FindFirstChildOfClass("TextLabel")

    if TextLabel then
        TextLabel.Text = p18
        TextLabel.MaxVisibleGraphemes = -1
    end

    popIn(clone, p17._trove)
    p17._trove:Add(clone)
    task.delay(1.4, function() -- line: 259
        -- upvalues: clone (copy), TweenService (copy), v2 (copy)
        if clone.Parent == nil then
            return
        end

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("TextLabel") then
                TweenService:Create(descendant, v2, {
                    TextTransparency = 1
                }):Play()
            elseif descendant:IsA("ImageLabel") then
                TweenService:Create(descendant, v2, {
                    ImageTransparency = 1
                }):Play()
            end
        end

        task.delay(v2.Time, function() -- line: 270
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
    end)
end

function t2._clearChoices(p19) -- line: 276
    for _, v26 in p19._rows do
        v26:Destroy()
    end

    table.clear(p19._rows)
end

function t2.Ask(p20, p21) -- line: 283
    -- upvalues: HttpService (copy), ReplicatedStorage (copy), TweenService (copy), UserInputService (copy), MenuNavigation (copy), v1 (copy), v2 (copy), t1 (copy), LocalPlayer (copy), stripScripts (copy), keepReadable (copy)
    if p20.Closed then
        return nil
    end

    local Npcs = ReplicatedStorage.Assets.UI.Npcs
    local _, _, Option_UI = Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local Billboard_UI = PlayerGui and PlayerGui:FindFirstChild("Billboard_UI")

    if Billboard_UI ~= nil and Billboard_UI:IsA("BillboardGui") then
        local v27 = p20._trove:Extend()
        local v28 = v27:Add(Billboard_UI:Clone())

        for _, child in v28:GetChildren() do
            if not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end

        v28.Name = "StarHandlerChoices"
        v28.Active = true
        v28.Enabled = true

        local Frame = Instance.new("Frame")

        Frame.Name = "Choices"
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.Parent = v28

        local UIListLayout = v28:FindFirstChildOfClass("UIListLayout")

        if UIListLayout then
            UIListLayout.Parent = Frame
        end

        v28.Parent = PlayerGui

        if v28:IsA("BillboardGui") then
            local Size, StudsOffset = v28.Size, v28.StudsOffset

            v28.MaxDistance = 1e999
            v27:Add(keepReadable(v28, function() -- line: 313
                -- upvalues: Size (copy)
                return Size
            end, StudsOffset))
        end

        local Key
        local n1 = 0
        local v29 = p20._trove:Extend()
        local t4 = {}
        local v30 = "StarHandlerChoices:" .. HttpService:GenerateGUID(false)

        local function releaseNavigation() -- line: 322
            -- upvalues: v30 (copy), MenuNavigation (copy)
            MenuNavigation.SetOverride(v30, nil)
        end

        v29:Add(releaseNavigation)
        p20._releaseChoices = releaseNavigation

        local function pick(p22) -- line: 328
            -- upvalues: p20 (copy), p21 (copy), Key (ref), n1 (ref)
            if Key == nil and not p20.Closed then
                local v31 = p21[p22]

                if v31 ~= nil then
                    Key = v31.Key
                    n1 = p22
                end
            end
        end

        for v32, v33 in p21 do
            if p20.Closed then
                break
            end

            local clone = Option_UI:Clone()

            stripScripts(clone)
            clone.Name = ("StarHandlerChoice%*"):format(v32)
            clone.LayoutOrder = v32

            local Frame2 = clone:FindFirstChild("Frame")
            local v34 = Frame2 and Frame2:FindFirstChild("Frame")
            local Text_Element = v34 and v34:FindFirstChild("Text_Element")
            local TextLabel2 = v34 and v34:FindFirstChild("TextLabel")

            if Text_Element then
                Text_Element.Text = v33.Text
                Text_Element:SetAttribute("Text", v33.Text)
            end

            if TextLabel2 then
                TextLabel2.Text = ("%*."):format(v32)
            end

            local ImageButton = Frame2 and Frame2:FindFirstChild("ImageButton")

            if ImageButton then
                ImageButton.ZIndex = 10
                ImageButton.Active = true
                ImageButton.Interactable = true
                ImageButton.Selectable = true
                ImageButton.LayoutOrder = v32
                ImageButton:SetAttribute("DefaultFocus", v32 == 1)
                table.insert(t4, ImageButton)
                v29:Connect(ImageButton.Activated, function() -- line: 366
                    -- upvalues: p20 (copy), p21 (copy), Key (ref), n1 (ref), v32 (copy)
                    if Key ~= nil or p20.Closed then
                        return
                    end

                    local v36 = p21[v32]

                    if v36 == nil then
                        return
                    end

                    Key = v36.Key
                    n1 = v32
                end)
                v29:Connect(ImageButton.MouseEnter, function() -- line: 369
                    -- upvalues: Option_UI (copy), clone (copy), TweenService (copy), v2 (copy)
                    TweenService:Create(clone, v2, {
                        Size = Option_UI.Size + UDim2.fromScale(0.04, 0.01)
                    }):Play()
                end)
                v29:Connect(ImageButton.MouseLeave, function() -- line: 374
                    -- upvalues: Option_UI (copy), clone (copy), TweenService (copy), v2 (copy)
                    TweenService:Create(clone, v2, {
                        Size = Option_UI.Size
                    }):Play()
                end)
            end

            local v37 = clone:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

            v37.Scale = 0
            v37.Parent = clone
            clone.Parent = Frame
            table.insert(p20._rows, clone)
            TweenService:Create(v37, v1, {
                Scale = 1
            }):Play()
            task.wait(0.07)
        end

        for v38, v39 in t4 do
            v39.NextSelectionUp = t4[math.max(1, v38 - 1)]
            v39.NextSelectionDown = t4[math.min(#t4, v38 + 1)]
            v39.NextSelectionLeft = v39
            v39.NextSelectionRight = v39
        end

        if not p20.Closed then
            MenuNavigation.SetOverride(v30, Frame, t4[1], function() -- line: 394
                -- upvalues: p20 (copy)
                p20:Close()
            end, 950, true, true)
        end

        v29:Connect(UserInputService.InputBegan, function(p23, p24) -- line: 399
            -- upvalues: p20 (copy), p21 (copy), Key (ref), n1 (ref), t1 (copy)
            if p24 then
                return
            end

            local v44 = table.find(t1, p23.KeyCode)

            if v44 and Key == nil then
                if p20.Closed then
                    return
                end

                local v45 = p21[v44]

                if v45 == nil then
                    return
                end

                Key = v45.Key
                n1 = v44
            end
        end)

        while Key == nil and not p20.Closed do
            task.wait()
        end

        v29:Destroy()
        p20._releaseChoices = nil

        for v46, v47 in p20._rows do
            local UIScale = v47:FindFirstChildOfClass("UIScale")

            if UIScale then
                TweenService:Create(UIScale, v2, {
                    Scale = v46 == n1 and 1.08 or 0
                }):Play()
            end
        end

        task.wait(v2.Time)
        p20:_clearChoices()
        v27:Destroy()

        local v48 = p21[n1]

        if v48 and v48.Echo then
            p20:Echo(v48.Echo)
            task.wait(0.35)
        end

        return Key
    end

    return nil
end

function t2.Close(p25) -- line: 433
    -- upvalues: TweenService (copy), v2 (copy)
    if p25.Closed then
        return
    end

    p25.Closed = true

    if p25._releaseChoices then
        p25._releaseChoices()
    end

    p25:_clearChoices()

    for _, descendant in p25._bubble:GetDescendants() do
        if descendant:IsA("TextLabel") then
            TweenService:Create(descendant, v2, {
                TextTransparency = 1
            }):Play()
        elseif descendant:IsA("ImageLabel") then
            TweenService:Create(descendant, v2, {
                ImageTransparency = 1
            }):Play()
        end
    end

    local _trove = p25._trove

    task.delay(v2.Time, function() -- line: 449
        -- upvalues: _trove (copy)
        _trove:Destroy()
    end)

    if p25._onClose then
        task.spawn(p25._onClose)
    end
end

return t2
