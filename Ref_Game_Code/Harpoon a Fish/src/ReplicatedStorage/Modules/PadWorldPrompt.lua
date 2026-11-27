-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InputMode = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InputMode"))
local BindableEvent = Instance.new("BindableEvent")
local t1 = {}

t1.Changed = BindableEvent.Event

local _ = {
    DOWN = 0.5,
    UP = 0.2
}
local t2 = {
    ROW = 0.05,
    WIDE = 9,
    LINE = 0.55,
    LINE_STROKE = Color3.fromRGB(10, 12, 18)
}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local t3 = {}
local n1 = 0

local function anchorPos(p1) -- line: 39
    if p1 and p1.Parent then
        if p1:IsA("Attachment") then
            return p1.WorldPosition
        end

        if p1:IsA("BasePart") then
            return p1.Position
        end
    end

    return nil
end

function t1.new(p2) -- line: 46
    -- upvalues: ContextActionService (copy), InputMode (copy), BindableEvent (copy), t2 (copy), LocalPlayer (copy), PlayerGui (copy), t3 (copy), n1 (ref)
    n1 += 1

    local v1 = p2.order or 1
    local t4 = {
        wanted = false,
        shown = false,
        anchor = nil,
        key = p2.key,
        bind = "PadWorldPrompt" .. n1
    }
    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = "PadWorldPrompt"
    BillboardGui.AlwaysOnTop = true
    BillboardGui.LightInfluence = 0
    BillboardGui.ResetOnSpawn = false
    BillboardGui.Enabled = false
    BillboardGui.Parent = PlayerGui

    local v2 = InputMode.Prompt(BillboardGui, {
        height = 0.5,
        name = "Plate",
        key = p2.key,
        text = p2.text or "",
        anchor = Vector2.new(0.5, 0.5),
        position = UDim2.fromScale(0.5, 0.75)
    })

    v2.Show(true)

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Line"
    TextLabel.BackgroundTransparency = 1
    TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    TextLabel.Position = UDim2.fromScale(0.5, 0.27)
    TextLabel.Size = UDim2.fromScale(1, 0.5 * t2.LINE)
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json", Enum.FontWeight.Bold)
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.AutoLocalize = false
    TextLabel.Text = ""
    TextLabel.Visible = false

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = t2.LINE_STROKE
    UIStroke.Thickness = 0.1
    UIStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
    UIStroke.Parent = TextLabel
    TextLabel.Parent = BillboardGui

    local function fit() -- line: 80
        -- upvalues: v1 (copy), BillboardGui (copy), t2 (copy)
        local CurrentCamera = workspace.CurrentCamera
        local v3 = (CurrentCamera and CurrentCamera.ViewportSize.Y or 720) * t2.ROW * 2

        BillboardGui.Size = UDim2.fromOffset(v3 / 2 * t2.WIDE, v3)
        BillboardGui.SizeOffset = Vector2.new(0, -(v1 - 1) * 0.5)
    end

    local function setShown(p3) -- line: 86
        -- upvalues: p2 (copy), t4 (copy), BillboardGui (copy), fit (copy), ContextActionService (copy), BindableEvent (copy)
        if p3 == t4.shown then
            return
        end

        t4.shown = p3

        if p3 then
            fit()
            t4.down = false
            ContextActionService:BindActionAtPriority(t4.bind, function(_, p5, p6) -- line: 94
                -- upvalues: p2 (copy), t4 (copy)
                local Z = p6 and p6.Position.Z or 0
                local v4 = p5 == Enum.UserInputState.Begin or p5 == Enum.UserInputState.Change and Z >= 0.5
                local v5 = p5 == Enum.UserInputState.End or p5 == Enum.UserInputState.Cancel or p5 == Enum.UserInputState.Change and Z <= 0.2

                if not v4 or t4.down then
                    if v5 and t4.down then
                        t4.down = false

                        if p2.onRelease then
                            task.spawn(p2.onRelease)
                        end
                    end
                else
                    t4.down = true

                    if p2.onPress then
                        task.spawn(p2.onPress)
                    end
                end

                return Enum.ContextActionResult.Sink
            end, false, 3000, p2.key)
        else
            ContextActionService:UnbindAction(t4.bind)
            t4.down = false

            if p2.onRelease then
                task.spawn(p2.onRelease)
            end
        end

        BillboardGui.Enabled = p3

        if p2.onShown then
            task.spawn(p2.onShown, p3)
        end

        BindableEvent:Fire()
    end

    function t4.check() -- line: 120
        -- upvalues: p2 (copy), t4 (copy), BillboardGui (copy), setShown (copy), ContextActionService (copy), InputMode (copy), BindableEvent (copy), LocalPlayer (copy)
        local v6, v7

        if t4.wanted and InputMode.Pad() then
            local anchor = t4.anchor

            if anchor and anchor.Parent then
                if anchor:IsA("Attachment") then
                    local WorldPosition = anchor.WorldPosition

                    if WorldPosition then
                        v6 = WorldPosition
                        v7 = true
                    else
                        v7 = false
                    end
                elseif anchor:IsA("BasePart") then
                    local anchorPosition = anchor.Position

                    if anchorPosition then
                        v6 = anchorPosition
                        v7 = true
                    else
                        v7 = false
                    end
                else
                    v7 = false
                end
            else
                v7 = false
            end
        else
            v7 = false
        end

        if not v7 then
            v6 = nil
        end

        local Character = LocalPlayer.Character
        local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if v6 and HumanoidRootPart then
            setShown((HumanoidRootPart.Position - v6).Magnitude <= (p2.range or 12))
        else
            if t4.shown == false then
                return
            end

            t4.shown = false
            ContextActionService:UnbindAction(t4.bind)
            t4.down = false

            if p2.onRelease then
                task.spawn(p2.onRelease)
            end

            BillboardGui.Enabled = false

            if p2.onShown then
                task.spawn(p2.onShown, false)
            end

            BindableEvent:Fire()
        end
    end

    function t4.Set(p7, p8, p9, p10) -- line: 127
        -- upvalues: t4 (copy), BillboardGui (copy), v2 (copy), TextLabel (copy)
        t4.wanted = p7 == true

        if p8 and p8 ~= t4.anchor then
            t4.anchor = p8
            BillboardGui.Adornee = p8
        end

        if p9 then
            v2.Set(p9)
        end

        if p10 ~= nil then
            TextLabel.Text = p10
            TextLabel.Visible = p10 ~= ""
        end

        t4.check()
    end

    function t4.Shown() -- line: 140
        -- upvalues: t4 (copy)
        return t4.shown
    end

    t3[#t3 + 1] = t4

    return t4
end

function t1.KeyShown(p11) -- line: 145
    -- upvalues: t3 (copy)
    for _, v10 in ipairs(t3) do
        if v10.shown and v10.key == p11 then
            return true
        end
    end

    return false
end

function t1.ShownOn(p12) -- line: 152
    -- upvalues: t3 (copy)
    for _, v11 in ipairs(t3) do
        local anchor = v11.anchor

        if v11.shown and anchor and p12 and (anchor == p12 or anchor:IsDescendantOf(p12)) then
            return true
        end
    end

    return false
end

local n2 = 0

RunService.Heartbeat:Connect(function(p13) -- line: 161
    -- upvalues: t3 (copy), n2 (ref)
    n2 += p13

    if not (n2 < 0.15) then
        n2 = 0

        for _, v12 in ipairs(t3) do
            if v12.wanted or v12.shown then
                v12.check()
            end
        end
    end
end)

return t1
