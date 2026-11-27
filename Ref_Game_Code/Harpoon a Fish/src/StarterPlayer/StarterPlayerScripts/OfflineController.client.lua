-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local SoundService = game:GetService("SoundService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local RewardScreen = require(Modules:WaitForChild("RewardScreen"))
local PurchaseFX = require(Modules:WaitForChild("PurchaseFX"))
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local PadMenu = require(Modules:WaitForChild("PadMenu"))
local ShopConfig = require(Modules:WaitForChild("ShopConfig"))
local Format = require(Modules:WaitForChild("Format"))
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local OfflineEarnings = Remotes:WaitForChild("OfflineEarnings")
local PurchaseGranted = Remotes:WaitForChild("PurchaseGranted")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Panel = PlayerGui:WaitForChild("WelcomeBackGui"):WaitForChild("Panel")
local Pop = Panel:WaitForChild("Pop")
local Burst = Panel:WaitForChild("Burst")
local Amount = Panel:WaitForChild("Amount")
local Away = Panel:WaitForChild("Away")
local Keep = Panel:WaitForChild("Keep")
local X10 = Panel:WaitForChild("X10")
local v1 = utf8.char(57346)

Panel.Visible = false

local _ = {
    POP = 0.38,
    TWIST = -14,
    CLOSE = 0.2,
    BURST_SPIN = 40
}

local function sfx(p1) -- line: 58
    -- upvalues: SoundService (copy)
    local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
    local v2 = HarpoonSFX and HarpoonSFX:FindFirstChild(p1)

    if v2 then
        v2:Play()
    end
end

local v3 = false

Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 67
    -- upvalues: v3 (ref)
    v3 = true
end)
Remotes:WaitForChild("HarpoonExit").OnClientEvent:Connect(function() -- line: 68
    -- upvalues: v3 (ref)
    v3 = false
end)

local function freeMouse(p2, p3) -- line: 70
    -- upvalues: UserInputService (copy), ContextActionService (copy), LocalPlayer (copy), v3 (ref)
    if p2 then
        p3.aimFree = LocalPlayer:GetAttribute("AimFree")
        LocalPlayer:SetAttribute("AimFree", true)
        UserInputService.MouseIconEnabled = true
        ContextActionService:BindActionAtPriority("WelcomeBackFree", function() -- line: 75
            return Enum.ContextActionResult.Sink
        end, false, Enum.ContextActionPriority.High.Value + 50, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
    else
        ContextActionService:UnbindAction("WelcomeBackFree")

        if not p3.aimFree then
            LocalPlayer:SetAttribute("AimFree", nil)
        end

        UserInputService.MouseIconEnabled = not v3
    end
end

ButtonHover.Attach(Keep, {
    tile = 1,
    highlight = true,
    highlightFade = 0.8,
    highlightCorner = 0.25,
    corner = 0.25
})
ButtonHover.Attach(X10, {
    tile = 1,
    highlight = true,
    highlightFade = 0.8,
    highlightCorner = 0.25,
    corner = 0.25
})
LocalPlayer:SetAttribute("OfflinePending", true)
task.spawn(function() -- line: 89
    -- upvalues: MarketplaceService (copy), TweenService (copy), RunService (copy), UserInputService (copy), ContextActionService (copy), SoundService (copy), RewardScreen (copy), PurchaseFX (copy), ButtonHover (copy), PadMenu (copy), ShopConfig (copy), Format (copy), OfflineEarnings (copy), PurchaseGranted (copy), LocalPlayer (copy), PlayerGui (copy), Panel (copy), Pop (copy), Burst (copy), Amount (copy), Away (copy), Keep (copy), X10 (copy), v1 (copy), v3 (ref), freeMouse (copy)
    local elapsed = os.clock()

    while (PlayerGui:FindFirstChild("LoadingGui") or RewardScreen.Busy()) and os.clock() - elapsed < 90 do
        task.wait(0.25)
    end

    local InvokeServer = OfflineEarnings.InvokeServer
    local Get, Get2 = pcall(InvokeServer, OfflineEarnings, "Get")

    if Get and type(Get2) == "table" and not ((tonumber(Get2.amount) or 0) <= 0) then
        local v5 = ShopConfig.OFFLINE_X10[Get2.tier]
        local v4 = v5 and v5.price or 0
        local GetProductInfo = MarketplaceService.GetProductInfo
        local product = Get2.product
        local Product = Enum.InfoType.Product
        local ok, result = pcall(GetProductInfo, MarketplaceService, product, Product)

        if ok and type(result) == "table" and type(result.PriceInRobux) == "number" then
            v4 = result.PriceInRobux
        end

        Amount.AutoLocalize = false
        Away.AutoLocalize = false
        Amount.Text = Format.money(Get2.amount)
        Away.Text = "while you were away (" .. Format.time(Get2.secs) .. ")"

        local Price = X10:FindFirstChild("Price")

        if Price then
            Price.AutoLocalize = false
            Price.Text = v1 .. " " .. tostring(v4)
        end

        local v6 = false
        local v7 = false
        local t1 = {}

        local function keep() -- line: 116
            -- upvalues: v6 (ref), v7 (ref), ButtonHover (copy), OfflineEarnings (copy), Keep (copy)
            ButtonHover.Press(Keep)

            if v7 then
                return
            end

            v7 = true

            local InvokeServer = OfflineEarnings.InvokeServer

            pcall(InvokeServer, OfflineEarnings, "Collect")
            v6 = true
        end

        t1[#t1 + 1] = Keep.Activated:Connect(keep)
        t1[#t1 + 1] = X10.Activated:Connect(function() -- line: 124
            -- upvalues: Get2 (copy), v7 (ref), PurchaseFX (copy), ButtonHover (copy), X10 (copy)
            ButtonHover.Press(X10)

            if not v7 then
                PurchaseFX.Buy(Get2.product)
            end
        end)
        t1[#t1 + 1] = PurchaseGranted.OnClientEvent:Connect(function(p4) -- line: 129
            -- upvalues: v6 (ref), v7 (ref), PurchaseFX (copy)
            if p4 ~= "OfflineX10" or v6 then
                return
            end

            v7 = true
            PurchaseFX.Success()
            v6 = true
        end)

        local t2 = {}

        freeMouse(true, t2)
        Pop.Scale = 0
        Panel.Rotation = -14
        Panel.Visible = true

        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local PanelOpen = HarpoonSFX and HarpoonSFX:FindFirstChild("PanelOpen")

        if PanelOpen then
            PanelOpen:Play()
        end

        local v8 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        TweenService:Create(Pop, v8, {
            Scale = 1
        }):Play()
        TweenService:Create(Panel, v8, {
            Rotation = 0
        }):Play()

        local connection = RunService.RenderStepped:Connect(function(p5) -- line: 146
            -- upvalues: Burst (copy)
            Burst.Rotation = (Burst.Rotation + 40 * p5) % 360
        end)

        PadMenu.Open(Panel, keep, {
            first = Keep
        })

        while not v6 do
            task.wait()
        end

        PadMenu.Close(Panel)

        for _, v9 in ipairs(t1) do
            v9:Disconnect()
        end

        local HarpoonSFX2 = SoundService:FindFirstChild("HarpoonSFX")
        local PanelClose = HarpoonSFX2 and HarpoonSFX2:FindFirstChild("PanelClose")

        if PanelClose then
            PanelClose:Play()
        end

        local tween = TweenService:Create(Pop, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0
        })

        tween:Play()
        tween.Completed:Wait()
        connection:Disconnect()
        Panel.Visible = false
        ContextActionService:UnbindAction("WelcomeBackFree")

        if not t2.aimFree then
            LocalPlayer:SetAttribute("AimFree", nil)
        end

        UserInputService.MouseIconEnabled = not v3
    end

    LocalPlayer:SetAttribute("OfflinePending", nil)
end)
