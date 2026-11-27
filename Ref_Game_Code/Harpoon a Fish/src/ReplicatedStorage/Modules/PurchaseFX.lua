-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local MarketplaceService = game:GetService("MarketplaceService")
local ContentProvider = game:GetService("ContentProvider")
local PanelFocus = require(script.Parent:WaitForChild("PanelFocus"))
local LocalPlayer = Players.LocalPlayer
local ShopFX = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ShopFX")
local Glow = ShopFX:WaitForChild("Glow")
local ImageColor3 = Glow.ImageColor3
local Rainbow = ShopFX:WaitForChild("Rainbow")
local UIGradient = Rainbow:WaitForChild("UIGradient")
local t1 = {
    FEEL = {
        GLOW_OPEN = 0.3,
        GLOW_BREATHE = 0.5,
        GLOW_BREATH = 1.6,
        RAINBOW_ON = 0.12,
        RAINBOW_LAP = 2.2,
        WAIT = 25,
        FLASH_IN = 0.12,
        FLASH_OUT = 1.3
    }
}
local FEEL = t1.FEEL
local t2 = {
    buy = { 77120543307812, 0.6 },
    success = { 129840040992692, 0.6 }
}

local function sound(p1) -- line: 48
    -- upvalues: SoundService (copy)
    local Sound = Instance.new("Sound")

    Sound.SoundId = "rbxassetid://" .. p1[1]
    Sound.Volume = p1[2]
    Sound.Parent = SoundService

    return Sound
end

local buy = t2.buy
local Sound = Instance.new("Sound")

Sound.SoundId = "rbxassetid://" .. buy[1]
Sound.Volume = buy[2]
Sound.Parent = SoundService

local success = t2.success
local Sound2 = Instance.new("Sound")

Sound2.SoundId = "rbxassetid://" .. success[1]
Sound2.Volume = success[2]
Sound2.Parent = SoundService
task.spawn(function() -- line: 57
    -- upvalues: ContentProvider (copy), Glow (copy), Rainbow (copy), Sound (copy), Sound2 (copy)
    ContentProvider:PreloadAsync({
        Sound,
        Sound2,
        Glow,
        Rainbow
    })
end)

local function sfx(p2) -- line: 58
    -- upvalues: SoundService (copy)
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v1 = HarpoonSFX and HarpoonSFX:FindFirstChild(p2)

    if v1 then
        v1:Play()
    end
end

local v2 = TweenInfo.new(PanelFocus.FEEL.OPEN_TIME * 0.5801025079151212, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(PanelFocus.FEEL.ZOOM_OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = false
local v5, v6

local function glowTo(p3, p4, p5) -- line: 70
    -- upvalues: TweenService (copy), Glow (copy), FEEL (copy), v5 (ref), v6 (ref)
    if v5 then
        v5:Cancel()
    end

    if v6 then
        v6:Cancel()
        v6 = nil
    end

    Glow.Visible = true
    v5 = TweenService:Create(Glow, p4, {
        ImageTransparency = p3
    })
    v5.Completed:Once(function(p6) -- line: 75
        -- upvalues: p3 (copy), p5 (copy), TweenService (copy), Glow (copy), FEEL (copy), v6 (ref)
        if p6 == Enum.PlaybackState.Completed then
            if p3 >= 1 then
                Glow.Visible = false
            elseif p5 then
                v6 = TweenService:Create(Glow, TweenInfo.new(FEEL.GLOW_BREATH, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    ImageTransparency = FEEL.GLOW_BREATHE
                })
                v6:Play()
            end
        end
    end)
    v5:Play()
end

function t1.ShopGlow(p7, p8, p9) -- line: 86
    -- upvalues: Glow (copy), ImageColor3 (copy), FEEL (copy), v2 (copy), v3 (copy), v4 (ref), v5 (ref), v6 (ref), glowTo (copy)
    v4 = p7

    if p7 then
        Glow.ImageColor3 = p9 or ImageColor3
    end

    if not p8 or p7 then
        if p7 then
            glowTo(FEEL.GLOW_OPEN, v2, true)
        else
            glowTo(1, v3)
        end
    else
        if v5 then
            v5:Cancel()
        end

        if v6 then
            v6:Cancel()
            v6 = nil
        end

        Glow.ImageTransparency = 1
        Glow.Visible = false
    end
end

local t3 = {}

local function rainbowOn() -- line: 101
    -- upvalues: TweenService (copy), Rainbow (copy), UIGradient (copy), FEEL (copy), t3 (ref)
    for _, v9 in ipairs(t3) do
        v9:Cancel()
    end

    Rainbow.Visible = true
    UIGradient.Rotation = 0
    t3 = {
        TweenService:Create(Rainbow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = FEEL.RAINBOW_ON
        }),
        TweenService:Create(UIGradient, TweenInfo.new(FEEL.RAINBOW_LAP, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360
        })
    }

    for _, v10 in ipairs(t3) do
        v10:Play()
    end
end

local function rainbowOff(p10) -- line: 111
    -- upvalues: TweenService (copy), Rainbow (copy), t3 (ref)
    for _, v11 in ipairs(t3) do
        v11:Cancel()
    end

    local tween = TweenService:Create(Rainbow, TweenInfo.new(p10 or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 1
    })

    tween.Completed:Once(function(p11) -- line: 114
        -- upvalues: Rainbow (copy)
        if p11 == Enum.PlaybackState.Completed then
            Rainbow.Visible = false
        end
    end)
    t3 = { tween }
    tween:Play()
end

local v12 = false

function t1.Rainbow(p12) -- line: 120
    -- upvalues: rainbowOn (copy), rainbowOff (copy), v12 (ref)
    v12 = p12

    if p12 then
        rainbowOn()
    else
        rainbowOff()
    end
end

local t4 = nil

function t1.Buy(p13) -- line: 126
    -- upvalues: MarketplaceService (copy), LocalPlayer (copy), Sound (copy), rainbowOn (copy), t4 (ref)
    if t4 or not p13 then
        return false
    end

    t4 = {
        id = p13
    }
    Sound:Play()
    rainbowOn()
    MarketplaceService:PromptProductPurchase(LocalPlayer, p13)

    return true
end

function t1.BuyPass(p14) -- line: 134
    -- upvalues: MarketplaceService (copy), LocalPlayer (copy), Sound (copy), rainbowOn (copy), t4 (ref)
    if t4 or not p14 then
        return false
    end

    t4 = {
        pass = true,
        id = p14
    }
    Sound:Play()
    rainbowOn()
    MarketplaceService:PromptGamePassPurchase(LocalPlayer, p14)

    return true
end

local function finished(p15, p16, p17) -- line: 143
    -- upvalues: FEEL (copy), rainbowOff (copy), v12 (ref), t4 (ref)
    if not t4 or t4.id ~= p15 or t4.pass == true ~= p16 then
        return
    end

    if p17 then
        t4.waiting = true

        local t5 = t4

        task.delay(FEEL.WAIT, function() -- line: 152
            -- upvalues: t5 (copy), rainbowOff (copy), v12 (ref), t4 (ref)
            if t4 == t5 then
                t4 = nil

                if not v12 then
                    rainbowOff(0.6)
                end
            end
        end)
    else
        t4 = nil

        if not v12 then
            rainbowOff()
        end
    end
end

MarketplaceService.PromptProductPurchaseFinished:Connect(function(p18, p19, p20) -- line: 159
    -- upvalues: LocalPlayer (copy), finished (copy)
    if p18 == LocalPlayer.UserId then
        finished(p19, false, p20)
    end
end)
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p21, p22, p23) -- line: 162
    -- upvalues: LocalPlayer (copy), finished (copy)
    if p21 == LocalPlayer then
        finished(p22, true, p23)
    end
end)

function t1.Done() -- line: 168
    -- upvalues: rainbowOff (copy), v12 (ref), t4 (ref)
    t4 = nil
    v12 = false
    rainbowOff(0.25)
end

function t1.Success() -- line: 174
    -- upvalues: SoundService (copy), FEEL (copy), Sound2 (copy), v4 (ref), glowTo (copy), rainbowOff (copy), v12 (ref), t4 (ref)
    t4 = t4 and nil
    v12 = false
    rainbowOff(0.25)
    glowTo(0, TweenInfo.new(FEEL.FLASH_IN, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
    task.delay(FEEL.FLASH_IN, function() -- line: 179
        -- upvalues: FEEL (copy), v4 (ref), glowTo (copy)
        glowTo(v4 and FEEL.GLOW_OPEN or 1, TweenInfo.new(FEEL.FLASH_OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), v4)
    end)
    Sound2:Play()

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local RevealGold = HarpoonSFX and HarpoonSFX:FindFirstChild("RevealGold")

    if RevealGold then
        RevealGold:Play()
    end
end

return t1
