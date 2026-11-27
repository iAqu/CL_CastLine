-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Parent = script.Parent
local PurchaseFX = require(Parent:WaitForChild("PurchaseFX"))
local ButtonHover = require(Parent:WaitForChild("ButtonHover"))
local PadMenu = require(Parent:WaitForChild("PadMenu"))
local ShopConfig = require(Parent:WaitForChild("ShopConfig"))
local PassPerks = require(Parent:WaitForChild("PassPerks"))
local RarityDisplay = require(Parent:WaitForChild("RarityDisplay"))
local GrowthDisplay = require(Parent:WaitForChild("GrowthDisplay"))
local Loc = require(Parent:WaitForChild("Loc"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local AquariumAction = Remotes:WaitForChild("AquariumAction")
local TelemetryReport = Remotes:WaitForChild("TelemetryReport")
local LocalPlayer = Players.LocalPlayer
local Panel = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GrowNowGui"):WaitForChild("Panel")
local Pop = Panel:WaitForChild("Pop")
local Burst = Panel:WaitForChild("Burst")
local Icon = Panel:WaitForChild("Icon")
local Stage = Panel:WaitForChild("Stage")
local PassBurst = Panel:WaitForChild("PassBurst")
local GrowBuy = Panel:WaitForChild("GrowBuy")
local PassBuy = Panel:WaitForChild("PassBuy")
local Close = Panel:WaitForChild("Close")
local v1 = utf8.char(57346)

for v2, v3 in pairs({
        GrowTitle = "GROW NOW",
        PassTitle = "-50% GROW TIME",
        Permanent = "(PERMANENT)"
    }) do
    local v4 = Panel:WaitForChild(v2)

    v4.AutoLocalize = false
    v4.Text = Loc.T(v3)
end

for _, v5 in ipairs({
        Stage,
        GrowBuy.Text,
        PassBuy.Text
    }) do
    v5.AutoLocalize = false
end

local Badge = Icon:FindFirstChild("Badge")

if Badge then
    Badge.Visible = false
end

local _ = {
    POP = 0.38,
    TWIST = -14,
    CLOSE = 0.2,
    BURST_SPIN = 40,
    BURST_FADE = 0.35
}
local v6, v7

for _, v8 in ipairs(ShopConfig.PASSES) do
    if v8.key == "Grow2x" then
        v7 = v8
        v6 = v8
    end
end

local v9 = v7 and v7.price

task.spawn(function() -- line: 74
    -- upvalues: MarketplaceService (copy), v6 (ref), v9 (ref)
    if not (v6 and v6.pass) then
        return
    end

    local GetProductInfo = MarketplaceService.GetProductInfo
    local pass = v6.pass
    local GamePass = Enum.InfoType.GamePass
    local ok, result = pcall(GetProductInfo, MarketplaceService, pass, GamePass)

    if ok and type(result) == "table" and type(result.PriceInRobux) == "number" then
        v9 = result.PriceInRobux
    end
end)

local t1 = {
    [ShopConfig.SKIP] = {},
    [ShopConfig.ORO_SKIP] = {}
}

task.spawn(function() -- line: 82
    -- upvalues: MarketplaceService (copy), t1 (copy)
    for v10, v11 in pairs(t1) do
        for v12, v13 in ipairs(v10) do
            local GetProductInfo = MarketplaceService.GetProductInfo
            local product = v13.product
            local Product = Enum.InfoType.Product
            local ok, result = pcall(GetProductInfo, MarketplaceService, product, Product)

            if ok and type(result) == "table" and type(result.PriceInRobux) == "number" then
                v11[v12] = result.PriceInRobux
            end
        end
    end
end)

local function credit(p1, p2) -- line: 91
    -- upvalues: LocalPlayer (copy)
    local gmatch = string.gmatch
    local v14 = if p2 then "InfSkipCredits" else "SkipCredits"

    for v15 in gmatch(LocalPlayer:GetAttribute(v14) or "", "%d+") do
        if p1 <= tonumber(v15) then
            return true
        end
    end

    return false
end

local function sfx(p3) -- line: 98
    -- upvalues: SoundService (copy)
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v16 = HarpoonSFX and HarpoonSFX:FindFirstChild(p3)

    if v16 then
        v16:Play()
    end
end

local t2 = {}
local t3 = nil

ButtonHover.Attach(GrowBuy, {
    shine = false,
    tile = 1,
    highlight = true,
    highlightFade = 0.8,
    highlightCorner = 0.25,
    corner = 0.25
})
ButtonHover.Attach(PassBuy, {
    shine = false,
    tile = 1,
    highlight = true,
    highlightFade = 0.8,
    highlightCorner = 0.25,
    corner = 0.25
})
ButtonHover.Attach(Close, {
    shine = false,
    tile = 1,
    icon = Close:FindFirstChild("X")
})

local function close() -- line: 112
    -- upvalues: TelemetryReport (copy), t3 (ref)
    local t4 = t3

    if t4 and not t4.done then
        TelemetryReport:FireServer("grownow", "close")
        t4.done = true
    end
end

Close.Activated:Connect(function() -- line: 118
    -- upvalues: ButtonHover (copy), TelemetryReport (copy), Close (copy), t3 (ref)
    ButtonHover.Press(Close)

    local t5 = t3

    if not t5 or t5.done then
        return
    end

    TelemetryReport:FireServer("grownow", "close")
    t5.done = true
end)
GrowBuy.Activated:Connect(function() -- line: 122
    -- upvalues: PurchaseFX (copy), ButtonHover (copy), AquariumAction (copy), GrowBuy (copy), t3 (ref)
    ButtonHover.Press(GrowBuy)

    local t6 = t3

    if t6 and not t6.done then
        AquariumAction:FireServer("Skip", t6.e.id)

        if PurchaseFX.Buy(t6.e.product) then
            t6.buying = "grow"
        end
    end
end)
PassBuy.Activated:Connect(function() -- line: 130
    -- upvalues: PurchaseFX (copy), ButtonHover (copy), PassBuy (copy), v6 (ref), t3 (ref)
    ButtonHover.Press(PassBuy)

    local t7 = t3

    if t7 and not t7.done and v6 and PurchaseFX.BuyPass(v6.pass) then
        t7.buying = "pass"
    end
end)
Remotes:WaitForChild("PurchaseGranted").OnClientEvent:Connect(function(p4, p5) -- line: 136
    -- upvalues: t3 (ref)
    local t8 = t3

    if t8 and not t8.done and (p4 == "Skip" and t8.buying == "grow" or p4 == "Pass" and type(p5) == "table" and p5.key == "Grow2x") then
        t8.done = true
    end
end)

function t2.Busy() -- line: 143
    -- upvalues: t3 (ref)
    return t3 ~= nil
end

local function show(p6) -- line: 145
    -- upvalues: TweenService (copy), RunService (copy), SoundService (copy), ButtonHover (copy), PadMenu (copy), RarityDisplay (copy), GrowthDisplay (copy), TelemetryReport (copy), Panel (copy), Pop (copy), Burst (copy), Icon (copy), Stage (copy), PassBurst (copy), GrowBuy (copy), PassBuy (copy), Close (copy), v1 (copy), v9 (ref), t3 (ref), close (copy)
    if t3 then
        return
    end

    local t9 = {
        done = false,
        e = p6
    }

    t3 = t9
    TelemetryReport:FireServer("grownow", "show")

    local host = p6.host and p6.host:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 151
        -- upvalues: p6 (copy), TelemetryReport (copy), t3 (ref)
        if p6.host.Visible then
            return
        end

        local t10 = t3

        if t10 then
            if t10.done then
                return
            end

            TelemetryReport:FireServer("grownow", "close")
            t10.done = true
        end
    end)

    Icon.Image = p6.icon or ""
    Icon.ImageRectOffset = p6.rect and p6.rect[1] or Vector2.zero
    Icon.ImageRectSize = p6.rect and p6.rect[2] or Vector2.zero

    local v19 = RarityDisplay[p6.rarity]

    Burst.ImageColor3 = v19 and v19.color or Color3.new(1, 1, 1)
    Burst.ImageTransparency = 0.35
    Stage.Text = GrowthDisplay.stages[p6.nextStage] and GrowthDisplay.Span(p6.nextStage, true, p6.nextInf) or ""
    GrowBuy.Text.Text = v1 .. " " .. tostring(p6.price or "?")
    PassBuy.Text.Text = v1 .. " " .. tostring(v9 or "?")
    Pop.Scale = 0
    Panel.Rotation = -14
    Panel.Visible = true

    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local PanelOpen = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelOpen")

    if PanelOpen then
        PanelOpen:Play()
    end

    local v23 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    TweenService:Create(Pop, v23, {
        Scale = 1
    }):Play()
    TweenService:Create(Panel, v23, {
        Rotation = 0
    }):Play()

    local connection = RunService.RenderStepped:Connect(function(p7) -- line: 172
        -- upvalues: Burst (copy), PassBurst (copy)
        Burst.Rotation = (Burst.Rotation + 40 * p7) % 360
        PassBurst.Rotation = (PassBurst.Rotation - 40 * p7) % 360
    end)

    ButtonHover.Sparkle(PassBuy, function() -- line: 176
        -- upvalues: t9 (copy), t3 (ref)
        if t3 == t9 then
            return not t9.done
        end

        return false
    end)
    PadMenu.Open(Panel, close, {
        first = GrowBuy,
        closeButton = Close
    })
    task.spawn(function() -- line: 178
        -- upvalues: t9 (copy), host (copy), connection (copy), TweenService (copy), SoundService (copy), PadMenu (copy), Panel (copy), Pop (copy), t3 (ref)
        while not t9.done do
            task.wait()
        end

        PadMenu.Close(Panel)

        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local PanelClose = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelClose")

        if PanelClose then
            PanelClose:Play()
        end

        local tween = TweenService:Create(Pop, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0
        })

        tween:Play()
        tween.Completed:Wait()
        connection:Disconnect()

        if host then
            host:Disconnect()
        end

        Panel.Visible = false
        t3 = nil
    end)
end

function t2.Press(p8, p9) -- line: 195
    -- upvalues: PurchaseFX (copy), ShopConfig (copy), PassPerks (copy), GrowthDisplay (copy), AquariumAction (copy), LocalPlayer (copy), t1 (copy), credit (copy), show (copy)
    if p9 and p9:GetAttribute("Infinite") and (p9:GetAttribute("Stage") or 1) >= #GrowthDisplay.stages - 1 then
        p8.nextStage = p9:GetAttribute("Stage")
        p8.nextInf = (p9:GetAttribute("Inf") or 0) + 1
    end

    local v24 = p8.left or 0
    local v25 = p8.nextInf ~= nil
    local v26, v27 = ShopConfig.SkipTier(v24, v25)

    if p8.id and not (v24 <= 0) and v26 then
        local v28 = credit(v24, v25)

        if not (v28 or PassPerks.Owns(LocalPlayer, "Grow2x")) then
            local product = v27.product
            local v29 = t1[v25 and ShopConfig.ORO_SKIP or ShopConfig.SKIP][v26] or v27.price

            p8.product = product
            p8.price = v29
            show(p8)
        else
            AquariumAction:FireServer("Skip", p8.id)

            if not v28 then
                PurchaseFX.Buy(v27.product)
            end
        end
    end
end

return t2
