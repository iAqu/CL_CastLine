-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local EscapeGui = PlayerGui:WaitForChild("EscapeGui")
local t1 = {
    ZOOM = 1.3,
    FOV_MAX = 120,
    BAR_LAG = 0.06,
    GLOW_ON = 0.3,
    GLOW_SOFT = 0.5,
    GLOW_BREATH = 1.6,
    GLINT_AT = 0.35,
    GLINT_EVERY = 2.6,
    FOV_IN = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    FOV_OUT = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    BAR_IN = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    BAR_OUT = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
    GLOW_IN = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    GLOW_OUT = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    GLINT = TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
}
local t2 = {
    EscapeGui:WaitForChild("GoldGlow"),
    EscapeGui:WaitForChild("GreenGlow")
}
local t3 = {
    {
        bar = EscapeGui:WaitForChild("Top"):WaitForChild("Bar"),
        home = UDim2.fromScale(0.5, 1),
        away = UDim2.fromScale(0.5, 0)
    },
    {
        bar = EscapeGui:WaitForChild("Bottom"):WaitForChild("Bar"),
        home = UDim2.fromScale(0.5, 0),
        away = UDim2.fromScale(0.5, 1)
    }
}

for _, v1 in ipairs(t3) do
    v1.glint = v1.bar:WaitForChild("Face"):WaitForChild("Glint"):WaitForChild("UIGradient")
    v1.bar.Position = v1.away
end

for _, v2 in ipairs(t2) do
    v2.ImageTransparency = 1
end

EscapeGui.Enabled = false

local Sound = Instance.new("Sound")

Sound.Name = "EscapeBanners"
Sound.SoundId = "rbxassetid://5852470908"
Sound.Volume = 0.6
Sound.Parent = SoundService
task.spawn(function() -- line: 73
    -- upvalues: ContentProvider (copy), Sound (copy)
    local function v3() -- line: 73
        -- upvalues: ContentProvider (copy), Sound (copy)
        ContentProvider:PreloadAsync({
            Sound
        })
    end

    pcall(v3)
end)

local v4 = false
local n1 = 0
local t4 = {}

local function stopTweens() -- line: 78
    -- upvalues: t4 (copy)
    for _, v5 in ipairs(t4) do
        v5:Cancel()
    end

    table.clear(t4)
end

local function play(p1, p2, p3) -- line: 82
    -- upvalues: TweenService (copy), t4 (copy)
    local tween = TweenService:Create(p1, p2, p3)

    t4[#t4 + 1] = tween
    tween:Play()

    return tween
end

local NumberValue = Instance.new("NumberValue")

NumberValue.Value = 1

local v6

local function calm() -- line: 94
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("SetReduceFx") == true
end

NumberValue.Changed:Connect(function(p4) -- line: 95
    -- upvalues: LocalPlayer (copy), t1 (copy), v6 (ref)
    if not v6 then
        return
    end

    local CurrentCamera = workspace.CurrentCamera
    local v7 = LocalPlayer:GetAttribute("SetReduceFx") == true
    local v8 = if v7 then v6 else nil

    CurrentCamera.FieldOfView = if not v7 or not v8 then math.min(t1.FOV_MAX, v6 * p4) else v8
end)

local v10 = false
local v11 = false

local function readReady() -- line: 102
    -- upvalues: LocalPlayer (copy), v10 (ref), v11 (ref)
    local LeaveReady = LocalPlayer:GetAttribute("LeaveReady")

    if LeaveReady == true then
        v11 = true
    elseif LeaveReady == false and not v11 then
        v10 = true
    end
end

LocalPlayer:GetAttributeChangedSignal("LeaveReady"):Connect(readReady)

local LeaveReady = LocalPlayer:GetAttribute("LeaveReady")

if LeaveReady == true then
    v11 = true
elseif LeaveReady == false and not v11 then
    v10 = true
end

local function canShow() -- line: 109
    -- upvalues: PlayerGui (copy), v10 (ref)
    return v10 and not PlayerGui:FindFirstChild("LoadingGui")
end

local function show() -- line: 113
    -- upvalues: TweenService (copy), LocalPlayer (copy), PlayerGui (copy), EscapeGui (copy), t1 (copy), t2 (copy), t3 (copy), Sound (copy), v4 (ref), n1 (ref), t4 (copy), NumberValue (copy), v6 (ref), v10 (ref)
    if v4 or not v10 or PlayerGui:FindFirstChild("LoadingGui") then
        return
    end

    v4 = true
    n1 += 1

    local v12 = n1

    for _, v13 in ipairs(t4) do
        v13:Cancel()
    end

    table.clear(t4)
    EscapeGui.Enabled = true
    v6 = v6 or workspace.CurrentCamera.FieldOfView
    LocalPlayer:SetAttribute("MenuZoom", true)

    local tween = TweenService:Create(NumberValue, t1.FOV_IN, {
        Value = t1.ZOOM
    })

    t4[#t4 + 1] = tween
    tween:Play()

    for _, v14 in ipairs(LocalPlayer:GetAttribute("SetReduceFx") == true and {} or t2) do
        local tween = TweenService:Create(v14, t1.GLOW_IN, {
            ImageTransparency = t1.GLOW_ON
        })

        t4[#t4 + 1] = tween
        tween:Play()
        tween.Completed:Once(function(p5) -- line: 125
            -- upvalues: v12 (copy), v14 (copy), TweenService (copy), t1 (copy), n1 (ref), t4 (copy)
            if p5 == Enum.PlaybackState.Completed and n1 == v12 then
                local tween = TweenService:Create(v14, TweenInfo.new(t1.GLOW_BREATH, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    ImageTransparency = t1.GLOW_SOFT
                })

                t4[#t4 + 1] = tween
                tween:Play()
            end
        end)
    end

    Sound.TimePosition = 0
    Sound:Play()

    for v16, v17 in ipairs(t3) do
        task.delay((v16 - 1) * t1.BAR_LAG, function() -- line: 134
            -- upvalues: v12 (copy), v17 (copy), TweenService (copy), t1 (copy), n1 (ref), t4 (copy)
            if n1 ~= v12 then
                return
            end

            local tween = TweenService:Create(v17.bar, t1.BAR_IN, {
                Position = v17.home
            })

            t4[#t4 + 1] = tween
            tween:Play()
        end)
    end

    task.spawn(function() -- line: 139
        -- upvalues: v12 (copy), TweenService (copy), t1 (copy), t3 (copy), n1 (ref)
        task.wait(t1.GLINT_AT)

        while n1 == v12 do
            for _, v18 in ipairs(t3) do
                v18.glint.Offset = Vector2.new(-1, 0)
                TweenService:Create(v18.glint, t1.GLINT, {
                    Offset = Vector2.new(1, 0)
                }):Play()
            end

            task.wait(t1.GLINT_EVERY)
        end
    end)
end

local function hide() -- line: 151
    -- upvalues: TweenService (copy), LocalPlayer (copy), EscapeGui (copy), t1 (copy), t2 (copy), t3 (copy), v4 (ref), n1 (ref), t4 (copy), NumberValue (copy), v6 (ref)
    if not v4 then
        return
    end

    v4 = false
    n1 += 1

    local v19 = n1

    for _, v20 in ipairs(t4) do
        v20:Cancel()
    end

    table.clear(t4)

    for _, v21 in ipairs(t3) do
        local tween = TweenService:Create(v21.bar, t1.BAR_OUT, {
            Position = v21.away
        })

        t4[#t4 + 1] = tween
        tween:Play()
    end

    for _, v22 in ipairs(t2) do
        local tween = TweenService:Create(v22, t1.GLOW_OUT, {
            ImageTransparency = 1
        })

        t4[#t4 + 1] = tween
        tween:Play()
    end

    local tween = TweenService:Create(NumberValue, t1.FOV_OUT, {
        Value = 1
    })

    t4[#t4 + 1] = tween
    tween:Play()
    tween.Completed:Once(function(p6) -- line: 159
        -- upvalues: v19 (copy), LocalPlayer (copy), EscapeGui (copy), n1 (ref), v6 (ref)
        if p6 ~= Enum.PlaybackState.Completed or n1 ~= v19 then
            return
        end

        if v6 then
            workspace.CurrentCamera.FieldOfView = v6
        end

        v6 = nil
        LocalPlayer:SetAttribute("MenuZoom", nil)
        EscapeGui.Enabled = false
    end)
end

GuiService.MenuOpened:Connect(show)
GuiService.MenuClosed:Connect(hide)
LocalPlayer:GetAttributeChangedSignal("Cinematic"):Connect(function() -- line: 171
    -- upvalues: LocalPlayer (copy), v10 (ref)
    if not LocalPlayer:GetAttribute("Cinematic") and LocalPlayer:GetAttribute("LeaveReady") == false then
        v10 = true
    end
end)
