-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Config = require(ReplicatedStorage.Shared.Config)
local Settings = require(script.Parent.Settings)
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local t1 = {
    scale = 1
}
local t2 = {
    error = Color3.fromRGB(255, 95, 95),
    success = Color3.fromRGB(120, 255, 120),
    purchase = Color3.fromRGB(255, 220, 80),
    cash = Color3.fromRGB(120, 255, 110),
    info = Color3.new(1, 1, 1)
}

function t1.gui(p1) -- line: 25
    -- upvalues: PlayerGui (copy)
    return PlayerGui:WaitForChild(p1)
end

function t1.tween(p2, p3, p4, p5, p6) -- line: 29
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p2, TweenInfo.new(p3, p5 or Enum.EasingStyle.Quad, p6 or Enum.EasingDirection.Out), p4)

    tween:Play()

    return tween
end

function t1.sound(p7, p8, p9, p10) -- line: 36
    -- upvalues: SoundService (copy), Config (copy), Settings (copy)
    local v1 = Config.Sounds[p7]

    if not v1 then
        return nil
    end

    local Sound = Instance.new("Sound")

    Sound.SoundId = v1
    Sound.Volume = p8 or 0.6
    Sound.PlaybackSpeed = p9 or 1
    Sound.SoundGroup = Settings.group("Sfx")
    Sound.Parent = SoundService
    Sound:Play()
    Sound.Ended:Once(function() -- line: 48
        -- upvalues: Sound (copy)
        Sound:Destroy()
    end)
    task.delay(p10 or 10, function() -- line: 51
        -- upvalues: Sound (copy)
        if Sound.Parent then
            Sound:Destroy()
        end
    end)

    return Sound
end

local function isPanelScale(p11) -- line: 67
    local Parent = p11.Parent
    local GuiObject

    if Parent ~= nil then
        if Parent.Name == "Panel" then
            GuiObject = Parent:IsA("GuiObject")

            if GuiObject then
                GuiObject = Parent.Parent ~= nil and Parent.Parent:IsA("ScreenGui")
            end
        else
            GuiObject = false
        end
    else
        GuiObject = false
    end

    return GuiObject
end

function t1.panelScale(p12) -- line: 72
    -- upvalues: GuiService (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize
    local Size = p12.Size
    local v2 = p12:GetAttribute("FullHeight") == true

    if v2 and not p12:GetAttribute("DesignHeight") then
        p12:SetAttribute("DesignHeight", Size.Y.Offset)
    end

    local v3 = math.max(Size.X.Offset, 1)
    local v5 = math.max(if v2 then p12:GetAttribute("DesignHeight") else Size.Y.Offset, 1)
    local v8 = math.min(ViewportSize.Y * 0.7 / v5, ViewportSize.X * 0.82 / v3)
    local Parent = p12.Parent

    if v2 and Parent and Parent:IsA("ScreenGui") then
        local Y = ViewportSize.Y

        if not Parent.IgnoreGuiInset and Parent.ScreenInsets ~= Enum.ScreenInsets.None then
            Y -= GuiService:GetGuiInset().Y
        end

        local v9 = (Y - 20) / v8

        p12.Size = UDim2.new(Size.X, UDim.new(0, (math.floor((math.max(v9, v5))))))
    end

    return v8
end

local function applyScale(p13) -- line: 96
    -- upvalues: t1 (copy)
    if not p13:IsA("UIScale") or p13.Name ~= "Scale" then
        return
    end

    local Parent = p13.Parent
    local GuiObject

    if Parent ~= nil then
        if Parent.Name == "Panel" then
            GuiObject = Parent:IsA("GuiObject")

            if GuiObject then
                GuiObject = Parent.Parent ~= nil and Parent.Parent:IsA("ScreenGui")
            end
        else
            GuiObject = false
        end
    else
        GuiObject = false
    end

    if GuiObject then
        p13.Scale = t1.panelScale(p13.Parent)
    else
        p13.Scale = t1.scale
    end
end

local t3 = {}

function t1.smallScreenBoost(p14, p15) -- line: 106
    return (p15 - 1) * math.clamp((0.8 - p14) / 0.45, 0, 1) + 1
end

function t1.onScale(p16) -- line: 111
    -- upvalues: t1 (copy), t3 (copy)
    table.insert(t3, p16)
    p16(t1.scale)
end

local function rescale() -- line: 118
    -- upvalues: PlayerGui (copy), t1 (copy), t3 (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize

    t1.scale = math.clamp(math.min(ViewportSize.Y / 1000, ViewportSize.X / 1500), 0.34, 1.25)

    for _, descendant in PlayerGui:GetDescendants() do
        if descendant:IsA("UIScale") and descendant.Name == "Scale" then
            local Parent = descendant.Parent
            local GuiObject

            if Parent ~= nil then
                if Parent.Name == "Panel" then
                    GuiObject = Parent:IsA("GuiObject")

                    if GuiObject then
                        GuiObject = Parent.Parent ~= nil and Parent.Parent:IsA("ScreenGui")
                    end
                else
                    GuiObject = false
                end
            else
                GuiObject = false
            end

            if GuiObject then
                descendant.Scale = t1.panelScale(descendant.Parent)
            else
                descendant.Scale = t1.scale
            end
        end
    end

    for _, v16 in t3 do
        task.spawn(v16, t1.scale)
    end
end

function t1.init() -- line: 129
    -- upvalues: PlayerGui (copy), applyScale (copy), rescale (copy)
    PlayerGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor
    rescale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
    PlayerGui.DescendantAdded:Connect(applyScale)
end

function t1.centre(p17) -- line: 142
    local Parent = p17.Parent

    if Parent and not p17:GetAttribute("Centred") then
        p17:SetAttribute("Centred", true)

        if Parent:FindFirstChildWhichIsA("UIGridStyleLayout") then
            local Frame = Instance.new("Frame")

            Frame.Name = p17.Name
            Frame.BackgroundTransparency = 1
            Frame.BorderSizePixel = 0
            Frame.Size = p17.Size
            Frame.LayoutOrder = p17.LayoutOrder
            Frame.Visible = p17.Visible
            Frame.ZIndex = p17.ZIndex
            Frame:SetAttribute("Centred", true)
            p17.AnchorPoint = Vector2.new(0.5, 0.5)
            p17.Position = UDim2.fromScale(0.5, 0.5)
            p17.Size = UDim2.fromScale(1, 1)
            Frame.Parent = Parent
            p17.Parent = Frame
            p17:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 163
                -- upvalues: p17 (copy), Frame (copy)
                Frame.Visible = p17.Visible
            end)
            p17:GetPropertyChangedSignal("LayoutOrder"):Connect(function() -- line: 166
                -- upvalues: p17 (copy), Frame (copy)
                Frame.LayoutOrder = p17.LayoutOrder
            end)
            p17.AncestryChanged:Connect(function() -- line: 170
                -- upvalues: p17 (copy), Frame (copy)
                if p17.Parent ~= Frame then
                    Frame:Destroy()
                end
            end)
            p17.Destroying:Connect(function() -- line: 175
                -- upvalues: Frame (copy)
                Frame:Destroy()
            end)
        else
            local AnchorPoint = p17.AnchorPoint

            if AnchorPoint ~= Vector2.new(0.5, 0.5) and p17.AutomaticSize == Enum.AutomaticSize.None and not p17:FindFirstChildWhichIsA("UIAspectRatioConstraint") and not p17:FindFirstChildWhichIsA("UISizeConstraint") then
                local v17 = Vector2.new(0.5, 0.5) - AnchorPoint
                local Size = p17.Size

                p17.AnchorPoint = Vector2.new(0.5, 0.5)
                p17.Position += UDim2.new(Size.X.Scale * v17.X, Size.X.Offset * v17.X, Size.Y.Scale * v17.Y, Size.Y.Offset * v17.Y)
            end
        end
    end
end

function t1.bindButton(p18, p19, p20) -- line: 195
    -- upvalues: t1 (copy)
    local v18 = p20 or p18
    local v19 = v18:FindFirstChild("Press") or Instance.new("UIScale")

    v19.Name = "Press"
    v19.Parent = v18

    local function squish(p21, p22, p23) -- line: 200
        -- upvalues: v18 (copy), v19 (copy), t1 (copy)
        t1.centre(v18)
        t1.tween(v19, p22, {
            Scale = p21
        }, p23)
    end

    p18.MouseEnter:Connect(function() -- line: 204
        -- upvalues: v18 (copy), v19 (copy), t1 (copy)
        t1.centre(v18)
        t1.tween(v19, 0.12, {
            Scale = 1.06
        }, nil)
    end)
    p18.MouseLeave:Connect(function() -- line: 207
        -- upvalues: v18 (copy), v19 (copy), t1 (copy)
        t1.centre(v18)
        t1.tween(v19, 0.12, {
            Scale = 1
        }, nil)
    end)
    p18.MouseButton1Down:Connect(function() -- line: 210
        -- upvalues: v18 (copy), v19 (copy), t1 (copy)
        t1.centre(v18)
        t1.tween(v19, 0.07, {
            Scale = 0.92
        }, nil)
    end)
    p18.MouseButton1Up:Connect(function() -- line: 213
        -- upvalues: v18 (copy), v19 (copy), t1 (copy)
        local Back = Enum.EasingStyle.Back

        t1.centre(v18)
        t1.tween(v19, 0.18, {
            Scale = 1
        }, Back)
    end)
    p18.Activated:Connect(function() -- line: 216
        -- upvalues: p19 (copy), t1 (copy)
        t1.sound("Click", 0.5)
        p19()
    end)
end

function t1.pop(p24, p25) -- line: 223
    -- upvalues: t1 (copy)
    t1.centre(p24)

    local v20 = p24:FindFirstChild("Pop") or Instance.new("UIScale")

    v20.Name = "Pop"
    v20.Parent = p24
    v20.Scale = p25 or 1.25
    t1.tween(v20, 0.35, {
        Scale = 1
    }, Enum.EasingStyle.Back)
end

local n1 = 0

function t1.toast(p26, p27) -- line: 233
    -- upvalues: t1 (copy), t2 (copy), n1 (ref)
    local Toasts = t1.gui("HUD"):WaitForChild("Toasts")
    local clone = Toasts.ToastTemplate:Clone()

    n1 += 1
    clone.Name = "Toast"
    clone.LayoutOrder = n1
    clone.Text = p26
    clone.TextColor3 = t2[p27 or "info"] or t2.info
    clone.Visible = true
    clone.Parent = Toasts
    t1.pop(clone, 0.4)

    local t4 = {}

    for _, child in Toasts:GetChildren() do
        if child.Name == "Toast" then
            table.insert(t4, child)
        end
    end

    if #t4 > 3 then
        table.sort(t4, function(p28, p29) -- line: 251
            return p28.LayoutOrder < p29.LayoutOrder
        end)
        t4[1]:Destroy()
    end

    task.delay(2.4, function() -- line: 256
        -- upvalues: clone (copy), t1 (copy)
        if clone.Parent then
            t1.tween(clone, 0.4, {
                TextTransparency = 1
            })
            t1.tween(clone.UIStroke, 0.4, {
                Transparency = 1
            })
            task.wait(0.4)
            clone:Destroy()
        end
    end)
end

local t5 = {}
local t6 = {}

function t1.onPanelMode(p30) -- line: 271
    -- upvalues: t6 (copy)
    table.insert(t6, p30)
end

function t1.panelMode() -- line: 275
    -- upvalues: t5 (copy)
    return next(t5) ~= nil
end

local function setPanelMode(p31) -- line: 279
    -- upvalues: PlayerGui (copy), t6 (copy)
    local Backpack = PlayerGui:FindFirstChild("Backpack")

    if Backpack then
        Backpack.Enabled = not p31
    end

    for _, v21 in t6 do
        task.spawn(v21, p31)
    end
end

function t1.openPanel(p32) -- line: 289
    -- upvalues: t1 (copy), t5 (copy), setPanelMode (copy)
    local Panel = p32:FindFirstChild("Panel")
    local v22 = t1.panelMode()

    t5[p32] = true

    if not v22 then
        setPanelMode(true)
    end

    if not p32.Enabled then
        t1.sound("CastSwing", 0.7)
    end

    p32.Enabled = true

    if not Panel then
        return
    end

    local v23 = t1.panelScale(Panel)

    Panel.Scale.Scale = v23 * 0.6
    t1.tween(Panel.Scale, 0.28, {
        Scale = v23
    }, Enum.EasingStyle.Back)
end

function t1.closePanel(p33) -- line: 307
    -- upvalues: t1 (copy), t5 (copy), setPanelMode (copy)
    local Panel = p33:FindFirstChild("Panel")

    if p33.Enabled then
        t5[p33] = nil
        t1.sound("CastSwing", 0.6, 1.1)

        if Panel then
            local v24 = t1.panelScale(Panel)

            t1.tween(Panel.Scale, 0.12, {
                Scale = v24 * 0.6
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.wait(0.12)
            Panel.Scale.Scale = v24
        end

        if not t5[p33] then
            p33.Enabled = false
        end

        if not t1.panelMode() then
            setPanelMode(false)
        end
    end
end

return t1
