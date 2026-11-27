-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TableConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("TableConfig"))
local TableDisplay = require(ReplicatedStorage.Modules:WaitForChild("TableDisplay"))
local PenConfig = require(ReplicatedStorage.Modules:WaitForChild("PenConfig"))
local Format = require(ReplicatedStorage.Modules:WaitForChild("Format"))
local ShopConfig = require(ReplicatedStorage.Modules:WaitForChild("ShopConfig"))
local PurchaseFX = require(ReplicatedStorage.Modules:WaitForChild("PurchaseFX"))
local InputMode = require(ReplicatedStorage.Modules:WaitForChild("InputMode"))
local PadWorldPrompt = require(ReplicatedStorage.Modules:WaitForChild("PadWorldPrompt"))
local v1 = utf8.char(57346)
local t1 = {}

task.spawn(function() -- line: 61
    -- upvalues: ShopConfig (copy), t1 (copy)
    local MarketplaceService = game:GetService("MarketplaceService")

    for _, v2 in ipairs({
            ShopConfig.TABLES,
            ShopConfig.AQUARIUM
        }) do
        for _, v3 in pairs(v2) do
            local GetProductInfo = MarketplaceService.GetProductInfo
            local product = v3.product
            local Product = Enum.InfoType.Product
            local ok, result = pcall(GetProductInfo, MarketplaceService, product, Product)

            if ok and result and type(result.PriceInRobux) == "number" then
                t1[v3.product] = result.PriceInRobux
            end
        end
    end
end)

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Plots = workspace:WaitForChild("Plots")

local function signOf(p1, p2) -- line: 76
    local v4 = p1:FindFirstChild(p2)
    local Sign = v4 and v4:FindFirstChild("Sign")
    local SignPart = Sign and Sign:FindFirstChild("SignPart")

    return Sign, SignPart and SignPart:FindFirstChild("SurfaceGui")
end

local function setFree(p3, p4, p5) -- line: 91
    local Title = p3:FindFirstChild("Title")
    local Cash = p3:FindFirstChild("Cash")
    local Robux = p3:FindFirstChild("Robux")

    if not (Title and Cash) then
        return
    end

    if p3:GetAttribute("BaseTitle") == nil then
        p3:SetAttribute("BaseTitle", Title.Text)
        p3:SetAttribute("BaseCashPos", Cash.Position)
    end

    if not p4 or not p5 then
        Title.Text = p3:GetAttribute("BaseTitle")
    else
        Title.Text = p5
    end

    local BaseCashPos = p3:GetAttribute("BaseCashPos")
    local v5 = if p4 then UDim2.new((1 - Cash.Size.X.Scale) / 2, 0, BaseCashPos.Y.Scale, BaseCashPos.Y.Offset) else nil

    Cash.Position = if p4 and v5 then v5 else BaseCashPos

    if Robux then
        Robux.Visible = not p4
    end
end

local function render(p6, p7, p8, p9) -- line: 104
    -- upvalues: Format (copy), v1 (copy), t1 (copy), setFree (copy)
    local Level = p6:FindFirstChild("Level")
    local Cash = p6:FindFirstChild("Cash")
    local Price = Cash and Cash:FindFirstChild("Price")

    if Level and Price then
        local v6 = p8.config.UpgradeCost(p7)
        local v7 = p8.icon and Cash:FindFirstChild("Icon")

        if p8.tutorial then
            setFree(p6, p9, p8.tutorial.title)
        end

        local Robux = p6:FindFirstChild("Robux")

        if Robux and p8.robux then
            local v8 = p8.robux[p7 + 1]
            local Amount = Robux:FindFirstChild("Amount")

            if Amount and v8 then
                Amount.Text = v1 .. " " .. (t1[v8.product] or v8.price)
            end

            if not p9 then
                Robux.Visible = v8 ~= nil
            end
        end

        if p9 and p8.tutorial.current then
            Level.Text = ("Level %d"):format(p7)
            Price.Text = "FREE"

            if v7 then
                v7.Image = p8.icon(p7)
            end
        elseif not p9 or not v6 then
            if v6 then
                Level.Text = ("Level %d > Level %d"):format(p7, p7 + 1)
                Price.Text = Format.money(v6)

                if v7 then
                    v7.Image = p8.icon(p7 + 1)
                end
            else
                Level.Text = "MAX LEVEL " .. p7
                Price.Text = "[MAX]"

                if v7 then
                    v7.Image = p8.icon(p7)
                end
            end
        else
            Level.Text = ("Level %d > Level %d"):format(p7, p7 + 1)
            Price.Text = "FREE"

            if v7 then
                v7.Image = p8.icon(p7 + 1)
            end
        end
    end
end

local function ownerLevel(p10, p11) -- line: 138
    -- upvalues: Players (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p10:GetAttribute("OwnerUserId") or 0)

    return PlayerByUserId and PlayerByUserId:GetAttribute(p11.levelAttr) or 1
end

local function ownerFree(p12, p13) -- line: 144
    -- upvalues: Players (copy)
    local PlayerByUserId = Players:GetPlayerByUserId(p12:GetAttribute("OwnerUserId") or 0)

    if p13.tutorial == nil or PlayerByUserId == nil then
        return false
    end

    return PlayerByUserId:GetAttribute(p13.tutorial.attr) == true
end

local function canPay(p14) -- line: 150
    -- upvalues: LocalPlayer (copy)
    local Cash = LocalPlayer:GetAttribute("Cash")

    if Cash == nil then
        return true
    end

    return p14 <= Cash
end

local t2 = {
    "rbxassetid://17779566040",
    "rbxassetid://18444218362"
}
local t3 = {
    "rbxassetid://137286285649228",
    "rbxassetid://99462344391311",
    "rbxassetid://84651254035271"
}
local t4 = {
    7, -6, 5, -4, 2, -1, 0
}
local _ = {
    SPEED = 6.3,
    BLEND = 0.15
}
local _ = {
    FROM = 0.05,
    TIME = 0.4
}
local v9 = Color3.fromRGB(60, 190, 90)
local v10 = Color3.fromRGB(20, 95, 40)
local v11 = Color3.fromRGB(225, 45, 45)
local v12 = Color3.fromRGB(120, 15, 15)

local function makeSound(p15, p16) -- line: 187
    local Sound = Instance.new("Sound")

    Sound.SoundId = p15
    Sound.Volume = p16 or 1
    Sound.Parent = workspace

    return Sound
end

local t5 = {}

for _, v13 in ipairs(t2) do
    local Sound = Instance.new("Sound")

    Sound.SoundId = v13
    Sound.Volume = 1
    Sound.Parent = workspace
    table.insert(t5, Sound)
end

local Sound = Instance.new("Sound")

Sound.SoundId = "rbxassetid://106434292728423"
Sound.Volume = 1.2
Sound.Parent = workspace

local t6 = {}

for _, v14 in ipairs(t3) do
    local Sound = Instance.new("Sound")

    Sound.SoundId = v14
    Sound.Volume = 0.5
    Sound.Parent = workspace
    table.insert(t6, Sound)
end

task.spawn(function() -- line: 201
    -- upvalues: ContentProvider (copy), t5 (copy), Sound (copy), t6 (copy)
    local t7 = {
        Sound
    }

    for _, v15 in ipairs(t5) do
        table.insert(t7, v15)
    end

    for _, v16 in ipairs(t6) do
        table.insert(t7, v16)
    end

    local function v17() -- line: 205
        -- upvalues: t7 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(t7)
    end

    pcall(v17)
end)

local function playBuy() -- line: 207
    -- upvalues: Debris (copy), t5 (copy)
    for _, v18 in ipairs(t5) do
        local clone = v18:Clone()

        clone.Volume = 2
        clone.Parent = workspace
        clone:Play()
        Debris:AddItem(clone, 6)
    end
end

local function attach(p17) -- line: 218
    -- upvalues: Players (copy), RunService (copy), TweenService (copy), LocalPlayer (copy), PlayerGui (copy), Format (copy), PurchaseFX (copy), InputMode (copy), PadWorldPrompt (copy), v1 (copy), t1 (copy), Remotes (copy), Plots (copy), render (copy), t4 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), Sound (copy), t6 (copy), playBuy (copy)
    local v19 = Remotes:WaitForChild(p17.remote)
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "UpgradeGlow"
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = Color3.fromRGB(255, 224, 105)
    Highlight.OutlineColor = Color3.fromRGB(255, 247, 205)
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.Enabled = false
    Highlight.Parent = workspace

    local v20, v21, Cash, UIStroke
    local t8 = {}
    local n1 = 1
    local v22 = CFrame.new()
    local t9 = {}

    t9[1] = v22

    local v23 = false
    local n2 = 0
    local n3 = 0
    local n4 = 0
    local elapsed, v24, elapsed2
    local v25 = false
    local n5 = 0
    local n6 = 0
    local n7 = 0
    local n8 = 0
    local n9 = -1
    local n10 = 0
    local v26, v27

    local function cost() -- line: 243
        -- upvalues: p17 (copy), LocalPlayer (copy)
        return p17.config.UpgradeCost(LocalPlayer:GetAttribute(p17.levelAttr) or 1)
    end

    local function isFree() -- line: 246
        -- upvalues: p17 (copy), LocalPlayer (copy)
        return p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true
    end

    local function sent() -- line: 250
        -- upvalues: p17 (copy), LocalPlayer (copy)
        LocalPlayer:SetAttribute("TutorialSent", p17.tutorialEvent .. "@" .. os.clock())
    end

    local v28 = false

    local function refreshDeny() -- line: 254
        -- upvalues: p17 (copy), n7 (ref), LocalPlayer (copy)
        local v29 = p17.config.UpgradeCost(LocalPlayer:GetAttribute(p17.levelAttr) or 1)
        local v30 = false

        if p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true then
        elseif v29 then
            local Cash = LocalPlayer:GetAttribute("Cash")

            v30 = not (Cash == nil or v29 <= Cash)
        end

        n7 = v30 and 1 or 0
    end

    local function rerender() -- line: 258
        -- upvalues: p17 (copy), v21 (ref), n7 (ref), LocalPlayer (copy), render (copy)
        local v31 = p17.config.UpgradeCost(LocalPlayer:GetAttribute(p17.levelAttr) or 1)
        local v32 = false

        if p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true then
        elseif v31 then
            local Cash = LocalPlayer:GetAttribute("Cash")

            v32 = not (Cash == nil or v31 <= Cash)
        end

        n7 = v32 and 1 or 0

        if not v21 then
            return
        end

        render(v21, LocalPlayer:GetAttribute(p17.levelAttr) or 1, p17, p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true)
    end

    LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(refreshDeny)
    LocalPlayer:GetAttributeChangedSignal(p17.levelAttr):Connect(rerender)

    if p17.tutorial then
        LocalPlayer:GetAttributeChangedSignal(p17.tutorial.attr):Connect(function() -- line: 265
            -- upvalues: p17 (copy), v21 (ref), n7 (ref), v28 (ref), LocalPlayer (copy), render (copy)
            v28 = false

            local v36 = p17.config.UpgradeCost(LocalPlayer:GetAttribute(p17.levelAttr) or 1)
            local v37 = false

            if p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true then
            elseif v36 then
                local Cash = LocalPlayer:GetAttribute("Cash")

                v37 = not (Cash == nil or v36 <= Cash)
            end

            n7 = v37 and 1 or 0

            if not v21 then
                return
            end

            render(v21, LocalPlayer:GetAttribute(p17.levelAttr) or 1, p17, p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true)
        end)
    end

    local v41 = p17.config.UpgradeCost(LocalPlayer:GetAttribute(p17.levelAttr) or 1)
    local v42 = false

    if p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true then
    elseif v41 then
        local Cash = LocalPlayer:GetAttribute("Cash")

        v42 = not (Cash == nil or v41 <= Cash)
    end

    n7 = v42 and 1 or 0

    local function tryUpgrade() -- line: 273
        -- upvalues: p17 (copy), v19 (copy), elapsed (ref), v24 (ref), v28 (ref), LocalPlayer (copy), Sound (copy), playBuy (copy)
        if p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true then
            if v28 then
                return false
            end

            v28 = true
            v19:FireServer()
            LocalPlayer:SetAttribute("TutorialSent", p17.tutorialEvent .. "@" .. os.clock())
            elapsed = os.clock()
            playBuy()

            return true
        end

        local v43 = p17.config.UpgradeCost(LocalPlayer:GetAttribute(p17.levelAttr) or 1)

        if v43 then
            local Cash = LocalPlayer:GetAttribute("Cash")

            if Cash == nil or v43 <= Cash then
                v19:FireServer()
                LocalPlayer:SetAttribute("TutorialSent", p17.tutorialEvent .. "@" .. os.clock())
                elapsed = os.clock()
                playBuy()

                return true
            end

            Sound:Play()
            v24 = v24 or os.clock()
        end

        return false
    end

    local function writeDeny(p18) -- line: 297
        -- upvalues: Cash (ref), UIStroke (ref), n9 (ref), v9 (copy), v10 (copy), v11 (copy), v12 (copy)
        if not Cash then
            return
        end

        if not (math.abs(p18 - n9) < 0.004) then
            n9 = p18

            local Cash2 = Cash

            Cash2.BackgroundColor3 = v9:Lerp(v11, p18)

            if UIStroke then
                local UIStroke2 = UIStroke

                UIStroke2.Color = v10:Lerp(v12, p18)
            end
        end
    end

    local function bindMine(p19, p20) -- line: 306
        -- upvalues: p17 (copy), Highlight (copy), v20 (ref), v21 (ref), Cash (ref), UIStroke (ref), t8 (copy), n1 (ref), t9 (copy), v23 (ref), n2 (ref), n3 (ref), n4 (ref), elapsed (ref), elapsed2 (ref), v25 (ref), n5 (ref), n6 (ref), n9 (ref), v26 (ref), v27 (ref), tryUpgrade (copy), LocalPlayer (copy), PlayerGui (copy), PurchaseFX (copy), t6 (copy)
        if p20 == v21 then
            return
        end

        if v21 and v21.Parent == PlayerGui then
            v21:Destroy()
        end

        for _, v45 in ipairs(t8) do
            v45:Disconnect()
        end

        table.clear(t8)
        v25 = false
        v23 = false

        if p19 ~= v20 then
            v20 = p19
            n1 = p19:GetScale()
            t9[1] = p19:GetPivot()
            v26 = nil
            v27 = nil
            Highlight.Adornee = p19
            elapsed2 = os.clock()
        end

        v21 = p20
        Cash = p20:FindFirstChild("Cash")
        UIStroke = Cash and Cash:FindFirstChildOfClass("UIStroke")
        n9 = -1

        if not Cash then
            return
        end

        Cash.AutoButtonColor = false

        local v46 = p17.robux and p20:FindFirstChild("Robux")

        if v46 then
            local _ = {
                MOVE = 20,
                TIME = 0.6
            }
            local t10 = {}

            local function isPress(p21) -- line: 335
                if p21.UserInputType == Enum.UserInputType.MouseButton1 then
                    return true
                end

                return p21.UserInputType == Enum.UserInputType.Touch
            end

            table.insert(t8, v46.InputBegan:Connect(function(p22) -- line: 338
                -- upvalues: t10 (copy)
                if p22.UserInputType == Enum.UserInputType.MouseButton1 or p22.UserInputType == Enum.UserInputType.Touch then
                    t10[p22] = {
                        pos = p22.Position,
                        t = os.clock()
                    }
                end
            end))
            table.insert(t8, v46.InputEnded:Connect(function(p23) -- line: 341
                -- upvalues: v46 (copy), t10 (copy), p17 (copy), elapsed (ref), LocalPlayer (copy), PurchaseFX (copy)
                local v49 = t10[p23]

                t10[p23] = nil

                if v49 and (p23.UserInputType == Enum.UserInputType.MouseButton1 or p23.UserInputType == Enum.UserInputType.Touch) and not ((p23.Position - v49.pos).Magnitude > 20 or os.clock() - v49.t > 0.6) and not (p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true) and v46.Visible then
                    local v50 = p17.robux[(LocalPlayer:GetAttribute(p17.levelAttr) or 1) + 1]

                    if v50 then
                        elapsed = os.clock()
                        PurchaseFX.Buy(v50.product)
                    end
                end
            end))
        end

        table.insert(t8, Cash.MouseEnter:Connect(function() -- line: 353
            -- upvalues: v23 (ref), n2 (ref), n3 (ref), n4 (ref), t6 (copy)
            if v23 then
                return
            end

            local v52 = n2
            local elapsed = os.clock()

            v23 = true
            n3 = v52
            n4 = elapsed
            t6[math.random(#t6)]:Play()
        end))
        table.insert(t8, Cash.MouseLeave:Connect(function() -- line: 358
            -- upvalues: v23 (ref), n2 (ref), n3 (ref), n4 (ref), v25 (ref)
            v25 = false

            if not v23 then
                return
            end

            local v54 = n2
            local elapsed = os.clock()

            v23 = false
            n3 = v54
            n4 = elapsed
        end))

        local function isPress(p24) -- line: 367
            if p24.UserInputType == Enum.UserInputType.MouseButton1 then
                return true
            end

            return p24.UserInputType == Enum.UserInputType.Touch
        end

        table.insert(t8, Cash.InputBegan:Connect(function(p25) -- line: 370
            -- upvalues: p17 (copy), v25 (ref), n5 (ref), n6 (ref), tryUpgrade (copy), LocalPlayer (copy)
            if p25.UserInputType ~= Enum.UserInputType.MouseButton1 and p25.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            local v56 = p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true

            tryUpgrade()

            if v56 then
                return
            end

            v25 = true
            n5 = os.clock()
            n6 = n5 + 0.25
        end))
        table.insert(t8, Cash.InputEnded:Connect(function(p26) -- line: 379
            -- upvalues: v23 (ref), n2 (ref), n3 (ref), n4 (ref), v25 (ref)
            if p26.UserInputType ~= Enum.UserInputType.MouseButton1 and p26.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            v25 = false

            if p26.UserInputType == Enum.UserInputType.Touch and v23 then
                local v58 = n2
                local elapsed = os.clock()

                v23 = false
                n3 = v58
                n4 = elapsed
            end
        end))
    end

    local v59, v60

    local function padSync() -- line: 393
        -- upvalues: p17 (copy), v20 (ref), v23 (ref), n2 (ref), n3 (ref), n4 (ref), elapsed (ref), v25 (ref), n5 (ref), n6 (ref), tryUpgrade (copy), v59 (ref), v60 (ref), LocalPlayer (copy), Format (copy), PurchaseFX (copy), InputMode (copy), PadWorldPrompt (copy), v1 (copy), t1 (copy), t6 (copy)
        local SignPart = v20 and v20:FindFirstChild("SignPart")

        if not SignPart then
            return
        end

        if not v59 then
            v59 = PadWorldPrompt.new({
                text = "Upgrade",
                range = 16.8,
                order = 1,
                key = Enum.KeyCode.ButtonX,
                onPress = function() -- onPress | line: 398
                    -- upvalues: p17 (copy), v25 (ref), n5 (ref), n6 (ref), tryUpgrade (copy), LocalPlayer (copy)
                    local v61 = p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true

                    tryUpgrade()

                    if v61 then
                        return
                    end

                    v25 = true
                    n5 = os.clock()
                    n6 = n5 + 0.25
                end,
                onRelease = function() -- onRelease | line: 406
                    -- upvalues: v25 (ref)
                    v25 = false
                end,
                onShown = function(p27) -- onShown | line: 407
                    -- upvalues: v23 (ref), n2 (ref), n3 (ref), n4 (ref), v25 (ref), t6 (copy)
                    if p27 == v23 then
                        return
                    end

                    local v62 = n2
                    local elapsed = os.clock()

                    v23 = p27
                    n3 = v62
                    n4 = elapsed

                    if p27 then
                        t6[math.random(#t6)]:Play()
                    else
                        v25 = false
                    end
                end
            })

            if p17.robux then
                v60 = PadWorldPrompt.new({
                    text = "Upgrade",
                    range = 16.8,
                    order = 2,
                    key = Enum.KeyCode.ButtonY,
                    onPress = function() -- onPress | line: 415
                        -- upvalues: p17 (copy), elapsed (ref), LocalPlayer (copy), PurchaseFX (copy)
                        if p17.tutorial == nil or LocalPlayer:GetAttribute(p17.tutorial.attr) ~= true then
                            local v63 = p17.robux[(LocalPlayer:GetAttribute(p17.levelAttr) or 1) + 1]

                            if v63 then
                                elapsed = os.clock()
                                PurchaseFX.Buy(v63.product)
                            end
                        end
                    end
                })
            end
        end

        local v64 = LocalPlayer:GetAttribute(p17.levelAttr) or 1
        local v65 = p17.config.UpgradeCost(v64)
        local v66 = p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true
        local EggBundlePromptAt = LocalPlayer:GetAttribute("EggBundlePromptAt")
        local v67 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local v68 = typeof(EggBundlePromptAt) == "Vector3" and v67 ~= nil and (v67.Position - EggBundlePromptAt).Magnitude < (v67.Position - SignPart.Position).Magnitude
        local v69 = InputMode.Pad() and not v68
        local Set = v59.Set
        local v70 = v69 and (v66 or v65 ~= nil)
        local v71, v72

        if v66 then
            v72 = "Get FREE"
            v71 = ""
        else
            v72 = "Upgrade"

            if v65 then
                v71 = Format.money(v65)
            end

            if not v65 or not v71 then
                v71 = "MAX"
            end
        end

        Set(v70, SignPart, v72, v71)

        if not v60 then
            return
        end

        local v73 = p17.robux[v64 + 1]
        local Set2 = v60.Set
        local v74 = v69 and not v66 and v73 ~= nil
        local v75, v76

        if v73 then
            local v77 = v1 .. " " .. (t1[v73.product] or v73.price)

            if v77 then
                v75 = v77
                v76 = true
            else
                v76 = false
            end
        else
            v76 = false
        end

        if not v76 then
            v75 = ""
        end

        Set2(v74, SignPart, "Upgrade", v75)
    end

    InputMode.Changed:Connect(padSync)
    LocalPlayer:GetAttributeChangedSignal("EggBundlePromptAt"):Connect(padSync)
    LocalPlayer:GetAttributeChangedSignal(p17.levelAttr):Connect(padSync)

    if p17.tutorial then
        LocalPlayer:GetAttributeChangedSignal(p17.tutorial.attr):Connect(padSync)
    end

    local n11 = 1

    local function watchPlot(p28) -- line: 453
        -- upvalues: p17 (copy), n11 (ref)
        p28.ChildAdded:Connect(function(p29) -- line: 454
            -- upvalues: p17 (copy), n11 (ref)
            if p29.Name == p17.group then
                n11 = 1
            end
        end)
    end

    for _, child in ipairs(Plots:GetChildren()) do
        child.ChildAdded:Connect(function(p30) -- line: 454
            -- upvalues: p17 (copy), n11 (ref)
            if p30.Name == p17.group then
                n11 = 1
            end
        end)
    end

    Plots.ChildAdded:Connect(watchPlot)

    local n12 = 0

    RunService.Heartbeat:Connect(function(p31) -- line: 461
        -- upvalues: p17 (copy), Highlight (copy), v20 (ref), v21 (ref), Cash (ref), UIStroke (ref), n1 (ref), t9 (copy), v23 (ref), n2 (ref), n3 (ref), n4 (ref), elapsed (ref), v24 (ref), elapsed2 (ref), v25 (ref), n5 (ref), n6 (ref), n7 (ref), n8 (ref), n9 (ref), n10 (ref), v26 (ref), v27 (ref), v28 (ref), tryUpgrade (copy), bindMine (copy), padSync (copy), n11 (ref), n12 (ref), Players (copy), TweenService (copy), LocalPlayer (copy), PlayerGui (copy), Plots (copy), render (copy), t4 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy)
        local elapsed3 = os.clock()

        if LocalPlayer:GetAttribute("EggBundlePromptAt") ~= nil then
            n12 += p31

            if n12 >= 0.2 then
                n12 = 0
                padSync()
            end
        end

        n11 += p31

        if n11 >= 1 then
            n11 = 0

            for _, child in ipairs(Plots:GetChildren()) do
                local v78 = child:FindFirstChild(p17.group)
                local Sign = v78 and v78:FindFirstChild("Sign")
                local SignPart = Sign and Sign:FindFirstChild("SignPart")
                local v79 = SignPart and SignPart:FindFirstChild("SurfaceGui")
                local v80 = child:GetAttribute("OwnerUserId") == LocalPlayer.UserId

                if v80 then
                    if v79 then
                        v79.Adornee = v79.Parent
                        v79.ResetOnSpawn = false
                        v79.Name = "MySign_" .. p17.group
                        v79.Parent = PlayerGui
                    elseif v21 and v21.Parent == PlayerGui and Sign and v21.Adornee == Sign:FindFirstChild("SignPart") then
                        v79 = v21
                    end
                end

                if v79 then
                    local PlayerByUserId = Players:GetPlayerByUserId(child:GetAttribute("OwnerUserId") or 0)
                    local v81 = PlayerByUserId and PlayerByUserId:GetAttribute(p17.levelAttr) or 1
                    local PlayerByUserId2 = Players:GetPlayerByUserId(child:GetAttribute("OwnerUserId") or 0)

                    render(v79, v81, p17, p17.tutorial ~= nil and PlayerByUserId2 ~= nil and PlayerByUserId2:GetAttribute(p17.tutorial.attr) == true)

                    if v80 then
                        bindMine(Sign, v79)
                        padSync()
                    end
                end
            end
        end

        if not v20 then
            return
        end

        if v25 and n6 <= elapsed3 then
            local v84 = math.clamp((elapsed3 - n5 - 0.25) / 0.7, 0, 1)

            n6 = elapsed3 + 0.15 + v84 * -0.09999999999999999

            if not tryUpgrade() then
                v25 = false
            end
        end

        local v85 = if v23 then 1 else 0

        if n2 ~= v85 then
            local v86 = if v23 then 0.12 else 0.1
            local v88 = math.clamp((elapsed3 - n4) / v86, 0, 1)

            n2 = n3 + (v85 - n3) * (v23 and TweenService:GetValue(v88, Enum.EasingStyle.Back, Enum.EasingDirection.Out) or TweenService:GetValue(v88, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))

            if v88 >= 1 then
                n2 = v85
            end
        end

        local v90 = 1

        if elapsed then
            local v91 = elapsed3 - elapsed

            if v91 < 0.1 then
                v90 = 1 + 0.1499999999999999 * TweenService:GetValue(v91 / 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            elseif v91 < 0.2 then
                v90 = 1.15 + -0.1499999999999999 * TweenService:GetValue((v91 - 0.1) / 0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            else
                elapsed = nil
            end
        end

        local v92 = if not (p17.tutorial ~= nil and LocalPlayer:GetAttribute(p17.tutorial.attr) == true) or v28 then 0 else 1

        if n10 ~= v92 then
            n10 += (v92 - n10) * (1 - math.exp(-p31 / 0.15))

            if math.abs(v92 - n10) < 0.004 then
                n10 = v92
            end
        end

        local v98 = 0.5 - math.cos(elapsed3 * 6.3) * 0.5
        local v99 = n2
        local v101 = math.max(v99, n10 * v98)
        local v104 = math.max(n2, n10)
        local v105

        if elapsed2 then
            local v107 = math.min(1, (elapsed3 - elapsed2) / 0.4)

            v105 = 0.05 + 0.95 * TweenService:GetValue(v107, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

            if v107 >= 1 then
                elapsed2 = nil
            end
        else
            v105 = 1
        end

        local v108 = n1 * (v101 * 0.08000000000000007 + 1) * v90 * v105
        local v110 = 0

        if v24 then
            local v113 = math.max(1, math.floor((elapsed3 - v24) / 0.03) + 1)

            if #t4 < v113 then
                v24 = nil
            else
                v110 = t4[v113]
            end
        end

        if v110 ~= v27 then
            v27 = v110
            v20:PivotTo(t9[1] * CFrame.Angles(0, 0, (math.rad(v110))))
        end

        local v115 = v26 == nil
        local v116 = if not v115 then math.abs(v108 - v26) > 1E-04 else nil

        if v115 or v116 then
            v26 = v108
            v20:ScaleTo(v108)
        end

        if v104 > 0.002 then
            local v119 = math.sin(elapsed3 * 6.3) * 0.5 + 0.5

            Highlight.Enabled = true
            Highlight.FillTransparency = 1 - v104 * (1 - (0.85 - v119 * 0.2))
            Highlight.OutlineTransparency = 1 - v104 * (1 - (0.35 - v119 * 0.35))
        elseif Highlight.Enabled then
            Highlight.Enabled = false
        end

        if n8 ~= n7 then
            n8 += (n7 - n8) * (1 - math.exp(-p31 / 0.09))

            local v126 = n7

            if math.abs(v126 - n8) < 0.004 then
                n8 = n7
            end
        end

        local v127 = n8

        if Cash and not (math.abs(v127 - n9) < 0.004) then
            n9 = v127
            Cash.BackgroundColor3 = v9:Lerp(v11, v127)

            if UIStroke then
                UIStroke.Color = v10:Lerp(v12, v127)
            end
        end
    end)
end

local t11 = {
    {
        group = "UpgradeSign",
        levelAttr = "TableLevel",
        remote = "TableUpgrade",
        tutorialEvent = "TableBought",
        config = TableConfig,
        icon = TableDisplay.Icon,
        robux = ShopConfig.TABLES,
        tutorial = {
            attr = "TutorialFreeTable",
            title = "BUY TABLE",
            current = true
        }
    },
    {
        group = "AQUpgradeSign",
        levelAttr = "PenLevel",
        remote = "PenUpgrade",
        tutorialEvent = "PenUpgraded",
        config = PenConfig,
        robux = ShopConfig.AQUARIUM,
        tutorial = {
            attr = "TutorialFreePen"
        }
    }
}

for _, v129 in ipairs(t11) do
    attach(v129)
end
