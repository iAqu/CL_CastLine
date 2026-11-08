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

local function templates() -- line: 68
    -- upvalues: ReplicatedStorage (copy)
    local Npcs = ReplicatedStorage.Assets.UI.Npcs

    return Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
end

local function rootPart() -- line: 75
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function stripScripts(p1) -- line: 81
    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BaseScript") then
            descendant:Destroy()
        end
    end
end

local function popIn(p2, p3) -- line: 89
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

local function sizeFor(p4, p5) -- line: 100
    local Size = p4.Size
    local v4 = if #p5 > 45 then 2 else 1

    return UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * v4, Size.Y.Offset)
end

local function keepReadable(p6, p7, p8) -- line: 106
    -- upvalues: RunService (copy), Workspace (copy)
    return RunService.RenderStepped:Connect(function() -- line: 107
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

function t2.new(p9, p10, p11, p12) -- line: 128
    -- upvalues: ReplicatedStorage (copy), RunService (copy), UserInputService (copy), Workspace (copy), MessageTyper (copy), Tabs (copy), Trove (copy), LocalPlayer (copy), t2 (copy), stripScripts (copy), popIn (copy), keepReadable (copy)
    local v9 = p12 or {}
    local Npcs = ReplicatedStorage.Assets.UI.Npcs
    local Talk_UI, _, _ = Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
    local v10 = Trove.new()
    local PrimaryPart = p9.PrimaryPart
    local BoundingBox, BoundingBox2 = p9:GetBoundingBox()
    local v11 = v10:Add(Instance.new("Attachment"))

    v11.Name = "NpcSpeech"
    v11.Position = PrimaryPart.CFrame:PointToObjectSpace(BoundingBox.Position + Vector3.new(0, BoundingBox2.Y / 2, 0))
    v11.Parent = PrimaryPart

    local v13 = v10:Add(Talk_UI:Clone())

    v13.Name = "NpcSpeech"
    v13.Adornee = v11
    v13.MaxDistance = 1e999
    stripScripts(v13)

    local TextLabel = v13:FindFirstChildOfClass("TextLabel")

    TextLabel.Text = ""
    v13.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    popIn(v13, v10)

    local v14 = MessageTyper.new(TextLabel, nil, 0.035, v9.Voiced == true)

    v10:Add(function() -- line: 150
        -- upvalues: v14 (copy)
        v14:Halt()
    end)

    local v15 = setmetatable({
        Closed = false,
        _skip = false,
        _npc = p9,
        _prompt = p10,
        _anchor = v11,
        _bubble = v13,
        _label = TextLabel,
        _typer = v14,
        _trove = v10,
        _rows = {},
        _size = Talk_UI.Size,
        _onClose = p11
    }, t2)

    v10:Add(keepReadable(v13, function() -- line: 169
        -- upvalues: v15 (copy)
        return v15._size
    end, Talk_UI.StudsOffset))
    p10.Enabled = false
    v10:Add(function() -- line: 174
        -- upvalues: p10 (copy)
        p10.Enabled = true
    end)
    v10:Connect(RunService.Heartbeat, function() -- line: 178
        -- upvalues: p9 (copy), p10 (copy), v11 (copy), v15 (copy), Workspace (copy), LocalPlayer (copy)
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local Character2 = LocalPlayer.Character
        local HumanoidRootPart = Character2 and Character2:FindFirstChild("HumanoidRootPart")

        if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
            HumanoidRootPart = nil
        end

        if HumanoidRootPart == nil or Humanoid == nil or Humanoid.Health <= 0 or not p9:IsDescendantOf(Workspace) or (HumanoidRootPart.Position - v11.WorldPosition).Magnitude > p10.MaxActivationDistance + 8 then
            v15:Close()
        end
    end)
    v10:Connect(Tabs.Activated, function(p13) -- line: 193
        -- upvalues: v9 (copy), v15 (copy)
        if p13 ~= v9.KeepOpenTab then
            v15:Close()
        end
    end)
    v10:Connect(UserInputService.InputBegan, function(p14, p15) -- line: 198
        -- upvalues: v15 (copy)
        if not p15 then
            local UserInputType = p14.UserInputType

            if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p14.KeyCode == Enum.KeyCode.Space or p14.KeyCode == Enum.KeyCode.ButtonA then
                v15._skip = true
            end
        end
    end)

    return v15
end

function t2.Say(p16, p17) -- line: 215
    -- upvalues: ReplicatedStorage (copy)
    for _, v16 in p17 do
        if p16.Closed then
            return false
        end

        local Npcs = ReplicatedStorage.Assets.UI.Npcs
        local Talk_UI, _, _ = Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
        local Size = Talk_UI.Size
        local v17 = #v16 > 45 and 2 or 1

        p16._size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * v17, Size.Y.Offset)
        p16._skip = false
        p16._typer:Type(v16, p16._label.TextColor3)

        local v18 = utf8.len(v16) or #v16
        local v19 = os.clock() + v18 * 0.035

        while os.clock() < v19 and not p16._skip do
            if p16.Closed then
                break
            end

            task.wait()
        end

        if p16._skip then
            p16._typer:ShowAll(v16, p16._label.TextColor3)
            p16._skip = false
        end

        local v21 = os.clock() + math.max(1.15, #v16 * 0.022)

        while os.clock() < v21 and not p16._skip do
            if p16.Closed then
                break
            end

            task.wait()
        end
    end

    return not p16.Closed
end

function t2.Echo(p18, p19) -- line: 240
    -- upvalues: ReplicatedStorage (copy), RunService (copy), TweenService (copy), Workspace (copy), v2 (copy), LocalPlayer (copy), stripScripts (copy), popIn (copy)
    if p18.Closed then
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

    local function v22() -- line: 255
        -- upvalues: Size (copy)
        return Size
    end

    local StudsOffset = clone.StudsOffset
    local connection = RunService.RenderStepped:Connect(function() -- line: 107
        -- upvalues: clone (copy), v22 (copy), StudsOffset (copy), Workspace (copy)
        local CurrentCamera = Workspace.CurrentCamera
        local Adornee = clone.Adornee
        local v23

        if not (Adornee and Adornee:IsA("Attachment")) then
            local BasePart = if Adornee then Adornee:IsA("BasePart") else nil

            if Adornee and BasePart then
                v23 = Adornee.Position
            end
        else
            v23 = Adornee.WorldPosition
        end

        if CurrentCamera ~= nil and v23 ~= nil then
            local v25 = math.max(1, (CurrentCamera.CFrame.Position - v23).Magnitude / 17)
            local v26 = v22()

            clone.Size = UDim2.new(v26.X.Scale * v25, v26.X.Offset, v26.Y.Scale * v25, v26.Y.Offset)
            clone.StudsOffset = StudsOffset * v25
        end
    end)

    clone.Destroying:Once(function() -- line: 258
        -- upvalues: connection (copy)
        connection:Disconnect()
    end)
    clone.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    local TextLabel = clone:FindFirstChildOfClass("TextLabel")

    if TextLabel then
        TextLabel.Text = p19
        TextLabel.MaxVisibleGraphemes = -1
    end

    popIn(clone, p18._trove)
    p18._trove:Add(clone)
    task.delay(1.4, function() -- line: 269
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

        task.delay(v2.Time, function() -- line: 280
            -- upvalues: clone (copy)
            clone:Destroy()
        end)
    end)
end

function t2._clearChoices(p20) -- line: 286
    for _, v27 in p20._rows do
        v27:Destroy()
    end

    table.clear(p20._rows)
end

function t2.Ask(p21, p22) -- line: 293
    -- upvalues: HttpService (copy), ReplicatedStorage (copy), TweenService (copy), UserInputService (copy), MenuNavigation (copy), v1 (copy), v2 (copy), t1 (copy), LocalPlayer (copy), stripScripts (copy), keepReadable (copy)
    if p21.Closed then
        return nil
    end

    local Npcs = ReplicatedStorage.Assets.UI.Npcs
    local _, _, Option_UI = Npcs.Talk_UI, Npcs.Response_UI, Npcs.Option_UI
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local Billboard_UI = PlayerGui and PlayerGui:FindFirstChild("Billboard_UI")

    if Billboard_UI ~= nil and Billboard_UI:IsA("BillboardGui") then
        local v28 = p21._trove:Extend()
        local v29 = v28:Add(Billboard_UI:Clone())

        for _, child in v29:GetChildren() do
            if not child:IsA("UIListLayout") then
                child:Destroy()
            end
        end

        v29.Name = "NpcChoices"
        v29.Active = true
        v29.Enabled = true

        local Frame = Instance.new("Frame")

        Frame.Name = "Choices"
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.fromScale(1, 1)
        Frame.Parent = v29

        local UIListLayout = v29:FindFirstChildOfClass("UIListLayout")

        if UIListLayout then
            UIListLayout.Parent = Frame
        end

        v29.Parent = PlayerGui

        if v29:IsA("BillboardGui") then
            local Size, StudsOffset = v29.Size, v29.StudsOffset

            v29.MaxDistance = 1e999
            v28:Add(keepReadable(v29, function() -- line: 323
                -- upvalues: Size (copy)
                return Size
            end, StudsOffset))
        end

        local Key
        local n1 = 0
        local v30 = p21._trove:Extend()
        local t4 = {}
        local v31 = "NpcChoices:" .. HttpService:GenerateGUID(false)

        local function releaseNavigation() -- line: 332
            -- upvalues: v31 (copy), MenuNavigation (copy)
            MenuNavigation.SetOverride(v31, nil)
        end

        v30:Add(releaseNavigation)
        p21._releaseChoices = releaseNavigation

        local function pick(p23) -- line: 338
            -- upvalues: p21 (copy), p22 (copy), Key (ref), n1 (ref)
            if Key == nil and not p21.Closed then
                local v32 = p22[p23]

                if v32 ~= nil then
                    Key = v32.Key
                    n1 = p23
                end
            end
        end

        for v33, v34 in p22 do
            if p21.Closed then
                break
            end

            local clone = Option_UI:Clone()

            stripScripts(clone)
            clone.Name = ("NpcChoice%*"):format(v33)
            clone.LayoutOrder = v33

            local Frame2 = clone:FindFirstChild("Frame")
            local v35 = Frame2 and Frame2:FindFirstChild("Frame")
            local Text_Element = v35 and v35:FindFirstChild("Text_Element")
            local TextLabel2 = v35 and v35:FindFirstChild("TextLabel")

            if Text_Element then
                Text_Element.Text = v34.Text
                Text_Element:SetAttribute("Text", v34.Text)
            end

            if TextLabel2 then
                TextLabel2.Text = ("%*."):format(v33)
            end

            local ImageButton = Frame2 and Frame2:FindFirstChild("ImageButton")

            if ImageButton then
                ImageButton.ZIndex = 10
                ImageButton.Active = true
                ImageButton.Interactable = true
                ImageButton.Selectable = true
                ImageButton.LayoutOrder = v33
                ImageButton:SetAttribute("DefaultFocus", v33 == 1)
                table.insert(t4, ImageButton)
                v30:Connect(ImageButton.Activated, function() -- line: 376
                    -- upvalues: p21 (copy), p22 (copy), Key (ref), n1 (ref), v33 (copy)
                    if Key ~= nil or p21.Closed then
                        return
                    end

                    local v37 = p22[v33]

                    if v37 == nil then
                        return
                    end

                    Key = v37.Key
                    n1 = v33
                end)
                v30:Connect(ImageButton.MouseEnter, function() -- line: 379
                    -- upvalues: Option_UI (copy), clone (copy), TweenService (copy), v2 (copy)
                    TweenService:Create(clone, v2, {
                        Size = Option_UI.Size + UDim2.fromScale(0.04, 0.01)
                    }):Play()
                end)
                v30:Connect(ImageButton.MouseLeave, function() -- line: 384
                    -- upvalues: Option_UI (copy), clone (copy), TweenService (copy), v2 (copy)
                    TweenService:Create(clone, v2, {
                        Size = Option_UI.Size
                    }):Play()
                end)
            end

            local v38 = clone:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

            v38.Scale = 0
            v38.Parent = clone
            clone.Parent = Frame
            table.insert(p21._rows, clone)
            TweenService:Create(v38, v1, {
                Scale = 1
            }):Play()
            task.wait(0.07)
        end

        for v39, v40 in t4 do
            v40.NextSelectionUp = t4[math.max(1, v39 - 1)]
            v40.NextSelectionDown = t4[math.min(#t4, v39 + 1)]
            v40.NextSelectionLeft = v40
            v40.NextSelectionRight = v40
        end

        if not p21.Closed then
            MenuNavigation.SetOverride(v31, Frame, t4[1], function() -- line: 404
                -- upvalues: p21 (copy)
                p21:Close()
            end, 950, true, true)
        end

        v30:Connect(UserInputService.InputBegan, function(p24, p25) -- line: 409
            -- upvalues: p21 (copy), p22 (copy), Key (ref), n1 (ref), t1 (copy)
            if p25 then
                return
            end

            local v45 = table.find(t1, p24.KeyCode)

            if v45 and Key == nil then
                if p21.Closed then
                    return
                end

                local v46 = p22[v45]

                if v46 == nil then
                    return
                end

                Key = v46.Key
                n1 = v45
            end
        end)

        while Key == nil and not p21.Closed do
            task.wait()
        end

        v30:Destroy()
        p21._releaseChoices = nil

        for v47, v48 in p21._rows do
            local UIScale = v48:FindFirstChildOfClass("UIScale")

            if UIScale then
                TweenService:Create(UIScale, v2, {
                    Scale = v47 == n1 and 1.08 or 0
                }):Play()
            end
        end

        task.wait(v2.Time)
        p21:_clearChoices()
        v28:Destroy()

        local v49 = p22[n1]

        if v49 and v49.Echo then
            p21:Echo(v49.Echo)
            task.wait(0.35)
        end

        return Key
    end

    return nil
end

function t2.Close(p26) -- line: 443
    -- upvalues: TweenService (copy), v2 (copy)
    if p26.Closed then
        return
    end

    p26.Closed = true

    if p26._releaseChoices then
        p26._releaseChoices()
    end

    p26:_clearChoices()

    for _, descendant in p26._bubble:GetDescendants() do
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

    local _trove = p26._trove

    task.delay(v2.Time, function() -- line: 459
        -- upvalues: _trove (copy)
        _trove:Destroy()
    end)

    if p26._onClose then
        task.spawn(p26._onClose)
    end
end

return t2
