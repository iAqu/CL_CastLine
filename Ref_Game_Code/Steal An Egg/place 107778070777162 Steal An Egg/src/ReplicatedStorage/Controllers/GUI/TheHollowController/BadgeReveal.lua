-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local TheHollowFlags = require(ReplicatedStorage.Shared.Flags.TheHollowFlags)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Sounds = ReplicatedStorage.Assets.Sounds
local Legendary = Sounds.PrizeSounds.Legendary
local CollectSecretRing = Sounds.LightVsDarknessSounds.CollectSecretRing
local t1 = {
    [Enum.KeyCode.E] = true,
    [Enum.KeyCode.ButtonA] = true,
    [Enum.KeyCode.Space] = true
}
local v1
local v2 = false
local t2 = {}

local function template() -- line: 44
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local TheHollow = Assets and Assets:FindFirstChild("TheHollow")
    local BadgeRevealUI = TheHollow and TheHollow:FindFirstChild("BadgeRevealUI")

    return if BadgeRevealUI ~= nil and BadgeRevealUI:IsA("ScreenGui") then BadgeRevealUI else nil
end

local function tween(p1, p2, p3, p4, p5) -- line: 51
    -- upvalues: TweenService (copy)
    TweenService:Create(p1, TweenInfo.new(p2, p4 or Enum.EasingStyle.Quad, p5 or Enum.EasingDirection.Out), p3):Play()
end

local function punch(p6, p7, p8) -- line: 69
    -- upvalues: TweenService (copy)
    if p6 == nil then
        return
    end

    p6.Scale = p7

    local t3 = {
        Scale = 1
    }
    local Back = Enum.EasingStyle.Back

    TweenService:Create(p6, TweenInfo.new(p8, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t3):Play()
end

local function textAlpha(p9, p10, p11) -- line: 77
    -- upvalues: TweenService (copy)
    local UIStroke = p9:FindFirstChildOfClass("UIStroke")

    if p10 <= 0 then
        p9.TextTransparency = p11

        if UIStroke then
            UIStroke.Transparency = p11
        end
    else
        local t4 = {
            TextTransparency = p11
        }

        TweenService:Create(p9, TweenInfo.new(p10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t4):Play()

        if UIStroke then
            local t5 = {
                Transparency = p11
            }

            TweenService:Create(UIStroke, TweenInfo.new(p10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t5):Play()
        end
    end
end

local function play(p12) -- line: 92
    -- upvalues: SoundService (copy), Audio (copy)
    Audio.Play(p12, SoundService, {
        Volume = 0.6,
        SoundGroup = "SFX"
    })
end

local function racing() -- line: 96
    -- upvalues: MountRace (copy), LocalPlayer (copy)
    return LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil
end

local function bannerShown() -- line: 100
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local MountRaceUI = PlayerGui and PlayerGui:FindFirstChild("MountRaceUI")

    if MountRaceUI ~= nil and MountRaceUI:IsA("ScreenGui") and MountRaceUI.Enabled then
        local FinishBanner = MountRaceUI:FindFirstChild("FinishBanner")

        return FinishBanner ~= nil and FinishBanner:IsA("GuiObject") and FinishBanner.Visible
    end

    return false
end

local function waitUntilFree() -- line: 110
    -- upvalues: MountRace (copy), LocalPlayer (copy), bannerShown (copy)
    local v4

    while true do
        if LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) ~= nil then
            v4 = nil
            task.wait(0.25)
            continue
        end

        v4 = v4 or os.clock()

        if bannerShown() then
            if os.clock() - v4 >= 8 then
                break
            end

            task.wait(0.25)
            continue
        end

        break
    end
end

local function reveal(p13, p14) -- line: 126
    -- upvalues: ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), UserInputService (copy), Audio (copy), TheHollowFlags (copy), LocalPlayer (copy), Legendary (copy), CollectSecretRing (copy), t1 (copy), textAlpha (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local TheHollow = Assets and Assets:FindFirstChild("TheHollow")
    local BadgeRevealUI = TheHollow and TheHollow:FindFirstChild("BadgeRevealUI")

    if BadgeRevealUI == nil or not BadgeRevealUI:IsA("ScreenGui") then
        BadgeRevealUI = nil
    end

    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if BadgeRevealUI == nil or PlayerGui == nil then
        warn("TheHollow: ReplicatedStorage.Assets.TheHollow.BadgeRevealUI is missing")

        return
    end

    local v5 = p13:Add(BadgeRevealUI:Clone())
    local Reveal = v5.Reveal
    local Holder = Reveal.Holder
    local Flip, Prize = Holder.Flip, Holder.Prize
    local Title = Reveal.Title
    local HolderPosition = Holder.Position
    local Icon = p14.Icon
    local v6 = Icon ~= nil and Icon ~= ""

    Flip.Badge.Image = TheHollowFlags.BadgeRevealImage:Get()
    Reveal.Sub.Visible = false
    Prize.Icon.Image = if not v6 then "" else Icon
    Prize.Visible = false
    Reveal.Dim.BackgroundTransparency = 1
    Reveal.Rays.ImageTransparency = 1
    Reveal.Shine.ImageTransparency = 1
    Reveal.Flash.BackgroundTransparency = 1

    local Tap = Reveal.Tap
    local UIStroke = Tap:FindFirstChildOfClass("UIStroke")

    Tap.TextTransparency = 1

    if UIStroke then
        UIStroke.Transparency = 1
    end

    local UIStroke2 = Title:FindFirstChildOfClass("UIStroke")

    Title.TextTransparency = 1

    if UIStroke2 then
        UIStroke2.Transparency = 1
    end

    local Event = Reveal.Event
    local UIStroke3 = Event:FindFirstChildOfClass("UIStroke")

    Event.TextTransparency = 1

    if UIStroke3 then
        UIStroke3.Transparency = 1
    end

    local Sub = Reveal.Sub
    local UIStroke4 = Sub:FindFirstChildOfClass("UIStroke")

    Sub.TextTransparency = 1

    if UIStroke4 then
        UIStroke4.Transparency = 1
    end

    Holder.Position = UDim2.fromScale(HolderPosition.X.Scale, -0.4)
    Holder.Rotation = -25
    v5.Enabled = true
    v5.Parent = PlayerGui

    local elapsed = os.clock()

    p13:Connect(RunService.RenderStepped, function() -- line: 161
        -- upvalues: Reveal (copy), Flip (copy), elapsed (copy)
        local v7 = os.clock() - elapsed
        local v9 = math.max(0, 1 - v7 / 0.9)
        local v12 = v9 * v9 * 3.141592653589793 * 4 + math.sin(v7 * 0.9) * 0.3141592653589793

        Flip.Size = UDim2.fromScale(math.max(math.abs((math.cos(v12))), 0.02), 1)
        Flip.Position = UDim2.fromScale(0.5, math.sin(v7 * 2) * 0.012 + 0.5)
        Flip.Rotation = math.sin(v7 * 1.3) * 3
        Reveal.Rays.Rotation = v7 * 36
        Reveal.Shine.Rotation = v7 * -22
    end)

    local Dim = Reveal.Dim
    local t6 = {
        BackgroundTransparency = 0.35
    }

    TweenService:Create(Dim, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t6):Play()

    local t7 = {
        Rotation = 4,
        Position = HolderPosition
    }
    local Back = Enum.EasingStyle.Back

    TweenService:Create(Holder, TweenInfo.new(0.55, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t7):Play()
    Audio.Play(Legendary, SoundService, {
        Volume = 0.6,
        SoundGroup = "SFX"
    })
    task.wait(0.5)

    local t8 = {
        Rotation = 0
    }
    local Sine = Enum.EasingStyle.Sine

    TweenService:Create(Holder, TweenInfo.new(0.3, Sine or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t8):Play()

    local Rays = Reveal.Rays
    local t9 = {
        ImageTransparency = 0.25
    }

    TweenService:Create(Rays, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t9):Play()

    local Shine = Reveal.Shine
    local t10 = {
        ImageTransparency = 0.45
    }

    TweenService:Create(Shine, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
    task.wait(0.4)
    Audio.Play(CollectSecretRing, SoundService, {
        Volume = 0.6,
        SoundGroup = "SFX"
    })

    local UIScale = Holder:FindFirstChildOfClass("UIScale")

    if UIScale ~= nil then
        UIScale.Scale = 1.08

        local t11 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(UIScale, TweenInfo.new(0.3, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()
    end

    Reveal.Flash.BackgroundTransparency = 0.55

    local Flash = Reveal.Flash
    local t12 = {
        BackgroundTransparency = 1
    }

    TweenService:Create(Flash, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t12):Play()

    local UIStroke5 = Title:FindFirstChildOfClass("UIStroke")

    Title.TextTransparency = 0

    if UIStroke5 then
        UIStroke5.Transparency = 0
    end

    local UIScale2 = Title:FindFirstChildOfClass("UIScale")

    if UIScale2 ~= nil then
        UIScale2.Scale = 1.5

        local t13 = {
            Scale = 1
        }
        local Back = Enum.EasingStyle.Back

        TweenService:Create(UIScale2, TweenInfo.new(0.4, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t13):Play()
    end

    textAlpha(Reveal.Event, 0.3, 0)
    textAlpha(Reveal.Sub, 0.4, 0)
    task.wait(0.6)
    textAlpha(Reveal.Tap, 0.4, 0.45)

    local v19 = false

    p13:Connect(Reveal.Catch.Activated, function() -- line: 192
        -- upvalues: v19 (ref)
        v19 = true
    end)
    p13:Connect(UserInputService.InputBegan, function(p15) -- line: 195
        -- upvalues: v19 (ref), t1 (copy)
        if t1[p15.KeyCode] then
            v19 = true
        end
    end)

    local elapsed2 = os.clock()

    while not v19 and os.clock() - elapsed2 < 4 do
        task.wait()
    end

    local t14 = {
        Rotation = 15,
        Position = UDim2.fromScale(HolderPosition.X.Scale, 1.4)
    }
    local Back2 = Enum.EasingStyle.Back
    local In = Enum.EasingDirection.In

    TweenService:Create(Holder, TweenInfo.new(0.35, Back2 or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t14):Play()

    local Dim2 = Reveal.Dim
    local t15 = {
        BackgroundTransparency = 1
    }

    TweenService:Create(Dim2, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t15):Play()
    textAlpha(Title, 0.3, 1)
    textAlpha(Reveal.Event, 0.3, 1)
    textAlpha(Reveal.Sub, 0.3, 1)
    textAlpha(Reveal.Tap, 0.3, 1)

    local Rays2 = Reveal.Rays
    local t16 = {
        ImageTransparency = 1
    }

    TweenService:Create(Rays2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t16):Play()

    local Shine2 = Reveal.Shine
    local t17 = {
        ImageTransparency = 1
    }

    TweenService:Create(Shine2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t17):Play()
    task.wait(0.4)
end

function t2.Show(p16) -- line: 222
    -- upvalues: MountRace (copy), Trove (copy), LocalPlayer (copy), v1 (ref), v2 (ref), waitUntilFree (copy), reveal (copy)
    v1 = p16

    if not v2 then
        v2 = true
        task.spawn(function() -- line: 228
            -- upvalues: MountRace (copy), Trove (copy), LocalPlayer (copy), v1 (ref), v2 (ref), waitUntilFree (copy), reveal (copy)
            while v1 ~= nil do
                waitUntilFree()
                task.wait(1)

                local v20 = v1

                if LocalPlayer:GetAttribute(MountRace.PlayerAttributes.RaceId) == nil and v20 ~= nil then
                    v1 = nil

                    local v21 = Trove.new()
                    local ok, result = pcall(reveal, v21, v20)

                    v21:Destroy()

                    if not ok then
                        warn((("TheHollow: badge reveal failed: %*"):format(result)))
                    end
                end
            end

            v2 = false
        end)
    end
end

return table.freeze(t2)
