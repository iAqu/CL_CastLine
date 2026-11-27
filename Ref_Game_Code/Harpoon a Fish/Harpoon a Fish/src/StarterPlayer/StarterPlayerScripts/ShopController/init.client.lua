-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local TweenService, Modules, ButtonHover, PanelFocus, ShopConfig, RewardScreen, Badge, PurchaseFX, Remotes
local LocalPlayer, PlayerGui, Panel, Scale, Main, t1, Button, TopTabs, Close, GiftPicker, Odds, Toast, Loc, t2, t3, v1
local t4, watch, Sound, commas, t5, v2, v3, t6, t7, t8, t9, t10, v4, startLoops, firstBuy, showPage, PadMenu, close
local v5, close2, StarterPack, InputMode, GuiService, t11, fitStrike, FreeReward, ServerLuck, t12, setHidden, t13
local dressRestricted, t14, t15, v6, showStarter, paintPrices, deny, GiftRequest, giftAsk, hoverOf, t16, HellEggPanel
local on, v7, dress, money, key, left, v8, RarityDisplay, Visible, on2, Visible2, v9, Tiles, v10, BonePack, Buy, on3

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    TweenService = game:GetService("TweenService")

    local SoundService = game:GetService("SoundService")
    local MarketplaceService = game:GetService("MarketplaceService")
    local ContentProvider = game:GetService("ContentProvider")

    Modules = ReplicatedStorage:WaitForChild("Modules")
    ButtonHover = require(Modules:WaitForChild("ButtonHover"))
    PanelFocus = require(Modules:WaitForChild("PanelFocus"))
    ShopConfig = require(Modules:WaitForChild("ShopConfig"))

    local KeyConfig = require(Modules:WaitForChild("KeyConfig"))

    RewardScreen = require(Modules:WaitForChild("RewardScreen"))
    Badge = require(Modules:WaitForChild("Badge"))
    PurchaseFX = require(Modules:WaitForChild("PurchaseFX"))
    Remotes = ReplicatedStorage:WaitForChild("Remotes")
    LocalPlayer = Players.LocalPlayer
    PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local ShopGui = PlayerGui:WaitForChild("ShopGui")

    Panel = ShopGui:WaitForChild("Panel")
    Scale = Panel:WaitForChild("Scale")
    Main = Panel:WaitForChild("Main")

    local Pages = Main:WaitForChild("Pages")
    local t17 = {}

    for v11, v12 in ipairs({ "Popular", "Fish", "Eggs", "Harpoons", "Gamepasses", "Boosts", "Donate" }) do
        t17[v11] = Pages:WaitForChild(v12)
    end

    for _, child in ipairs(Main:WaitForChild("Stash"):GetChildren()) do
        t17[#t17 + 1] = child
    end

    local t18 = {}

    for v13, v14 in ipairs(t17) do
        t18[v14] = v13
    end

    t1 = {}

    function t1.FindFirstChild(_, p2) -- line: 94
        -- upvalues: t17 (copy)
        for _, v15 in ipairs(t17) do
            local v16 = v15:FindFirstChild(p2)

            if v16 then
                return v16
            end
        end

        return nil
    end

    function t1.WaitForChild(p3, p4) -- line: 101
        local v17 = p3:FindFirstChild(p4)
        local elapsed = os.clock()

        while not v17 and os.clock() - elapsed < 10 do
            task.wait()
            v17 = p3:FindFirstChild(p4)
        end

        if not v17 then
            error("ShopController: no card " .. p4 .. " on any page")
        end

        return v17
    end

    function t1.GetChildren(_) -- line: 110
        -- upvalues: t17 (copy)
        local t19 = {}

        for _, v18 in ipairs(t17) do
            for _, child in ipairs(v18:GetChildren()) do
                t19[#t19 + 1] = child
            end
        end

        return t19
    end

    Button = {}

    function Button.__index(_, p7) -- line: 117
        -- upvalues: t1 (ref)
        return t1:FindFirstChild(p7)
    end

    setmetatable(t1, Button)
    TopTabs = Panel:WaitForChild("TopTabs")
    Close = Main:WaitForChild("Close")
    Button = PlayerGui:WaitForChild("MenuButtons"):WaitForChild("ShopSlot"):WaitForChild("Button")
    GiftPicker = require(script:WaitForChild("GiftPicker"))
    Odds = require(script:WaitForChild("Odds"))

    local HellPanelFX = require(script:WaitForChild("HellPanelFX"))

    Toast = require(Modules:WaitForChild("Toast"))
    Loc = require(Modules:WaitForChild("Loc"))
    t2 = {
        CLAIMED_FADE = 0.4,
        PAGE_POP = 0.9,
        PAGE_STAGGER = 0.035,
        BURST_LAP = 20,
        TAB_ON = Color3.fromRGB(110, 225, 70),
        TAB_OFF = Color3.fromRGB(205, 208, 214)
    }

    local t20 = {
        shop = { 120395969868063, 0.5 }
    }

    t3 = {
        VIP = "rbxassetid://77352520735647",
        Cash2x = "rbxassetid://117252679272986",
        Luck2x = "rbxassetid://80418759118984",
        XP2x = "rbxassetid://137513422393347",
        Bag2x = "rbxassetid://76221925928537",
        Grow2x = { "rbxassetid://72293964296867", 102, 79, 308, 342 }
    }
    v1 = utf8.char(57346)

    do
        local v19 = Random.new()

        local function range(p8) -- line: 148
            -- upvalues: v19 (copy)
            return v19:NextNumber(p8[1], p8[2])
        end
    end

    Panel.Visible = false
    t4 = {
        gifting = false,
        ICON = "rbxassetid://110352012709289",
        who = LocalPlayer,
        conns = {},
        watchers = {},
        PLATE = {
            "rbxassetid://81075607380047",
            Vector2.new(153, 110),
            Vector2.new(721, 212)
        },
        INK = ShopConfig.INK.Pink,
        GLOW = Color3.fromRGB(255, 70, 190),
        TAB = Color3.fromRGB(255, 90, 200),
        price = {},
        looks = {}
    }

    function watch(p9, p10) -- line: 170
        -- upvalues: t4 (ref)
        t4.watchers[#t4.watchers + 1] = { p9, p10 }

        for _, v20 in ipairs(p9) do
            t4.conns[#t4.conns + 1] = t4.who:GetAttributeChangedSignal(v20):Connect(p10)
        end
    end

    local function sound(p11) -- line: 175
        -- upvalues: SoundService (copy)
        local Sound = Instance.new("Sound")

        Sound.SoundId = "rbxassetid://" .. p11[1]
        Sound.Volume = p11[2]
        Sound.Parent = SoundService

        return Sound
    end

    local spawn = t20.shop

    Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://" .. spawn[1]
    Sound.Volume = spawn[2]
    Sound.Parent = SoundService
    task.spawn(function() -- line: 183
        -- upvalues: ContentProvider (copy), Sound (ref)
        ContentProvider:PreloadAsync({
            Sound
        })
    end)

    do
        local function sfx(p12) -- line: 184
            -- upvalues: SoundService (copy)
            local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
            local v21 = HarpoonSFX and HarpoonSFX:FindFirstChild(p12)

            if v21 then
                v21:Play()
            end
        end
    end

    function commas(p13) -- line: 190
        return (tostring((math.floor(p13))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
    end

    local t21 = {}
    local _require, _script

    for _, child in ipairs(t1:GetChildren()) do
        _require = child:FindFirstChild("Gleam")

        if _require then
            _script = #t21 + 1
            t21[_script] = {
                gui = child,
                pop = child:WaitForChild("Pop"),
                gleam = _require:WaitForChild("UIGradient"),
                sheen = child:WaitForChild("Sheen"):WaitForChild("UIGradient"),
                key = (child.Name:match("^Key_") or child.Name:match("^Fat_") or child.Name:match("^Cash_") or child.Name:match("^Token_")) ~= nil,
                baseOffset = child.ImageRectOffset,
                baseSize = child.ImageRectSize
            }
        end
    end

    table.sort(t21, function(p14, p15) -- line: 210
        -- upvalues: t18 (copy)
        local v23 = t18[p14.gui.Parent]
        local v24 = t18[p15.gui.Parent]

        if v23 ~= v24 then
            return v23 < v24
        end

        local Scale = p14.gui.Position.Y.Scale
        local Scale2 = p15.gui.Position.Y.Scale

        if math.abs(Scale - Scale2) > 1E-04 then
            return Scale < Scale2
        end

        return p14.gui.Position.X.Scale < p15.gui.Position.X.Scale
    end)

    for _, v26 in ipairs(t21) do
        v26.enter = function() -- line: 224
            -- upvalues: v26 (copy)
            v26.hovered = true
        end

        v26.leave = function() -- line: 227
            -- upvalues: v26 (copy)
            v26.hovered = false
        end

        v26.gui.MouseEnter:Connect(v26.enter)
        v26.gui.MouseLeave:Connect(v26.leave)
    end

    t5 = {}

    do
        local _ = {
            SHIFT = 0.3,
            TIME = 3.5,
            GLOW = 0.82,
            GLOW_TIME = 4.5
        }
    end

    v2 = false
    v3 = false
    t6 = {
        card = t1:WaitForChild("ZeusBolt")
    }
    _require = require
    _script = script
    t6.Zap = _require(_script:WaitForChild("Zap"))
    t7 = {
        card = t1:WaitForChild("HydraPack")
    }
    t8 = {
        DEVIL_SWIM = {
            R = 110,
            SPEED = 60,
            BOB = 1,
            BOB_T = 3.4,
            LOOK = 0.3,
            LOOK_T = 10,
            SIDE = 43,
            UP = 10,
            AHEAD = 50,
            AIM = 4,
            FOV = 40
        }
    }

    function t8.devilRun(p16) -- line: 256
        -- upvalues: ReplicatedStorage (copy), ShopConfig (ref), LocalPlayer (ref), t8 (ref)
        local DEVIL_SWIM, devil = t8.DEVIL_SWIM, t8.devil
        local View = devil and devil:FindFirstChild("View")

        if not View then
            return
        end

        local function anat(p17, p18) -- line: 260
            -- upvalues: DEVIL_SWIM (copy)
            local v31 = Vector3.new(DEVIL_SWIM.R * math.cos(p17), DEVIL_SWIM.BOB * math.sin(p18 * 2 * 3.141592653589793 / DEVIL_SWIM.BOB_T), DEVIL_SWIM.R * math.sin(p17))

            return CFrame.fromMatrix(v31, Vector3.new(-math.sin(p17), 0, (math.cos(p17))), (Vector3.new(0, 1, 0)))
        end

        if not t8.devilModel then
            local ShopPreviews = ReplicatedStorage:FindFirstChild("ShopPreviews")
            local v34 = ShopPreviews and ShopPreviews:FindFirstChild(ShopConfig.DEVILSHARK.fish)
            local AnatomyInverse = v34 and v34:GetAttribute("AnatomyInverse")

            if typeof(AnatomyInverse) ~= "CFrame" then
                return
            end

            local t23 = {}
            local t24 = {
                fightHooked = function() -- fightHooked | line: 270
                    return false
                end,
                attr = function(p19, p20) -- attr | line: 270
                    return p19:GetAttribute(p20)
                end,
                renderLag = function() -- renderLag | line: 271
                    return 0
                end
            }
            local Drivers = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("FishRenderController"):WaitForChild("Drivers")

            require(Drivers:WaitForChild("FishWave"))(t23, t24)
            require(Drivers:WaitForChild("SharkSwim"))(t23, t24)

            local clone = v34:Clone()

            clone:SetAttribute("PassCruise", true)
            t8.devilModel = clone
            t8.devilAi = AnatomyInverse
            t8.devilDrivers = t23
            t8.devilTheta = 0
            t8.devilT = 0

            local v39 = Vector3.new(DEVIL_SWIM.R * 1, DEVIL_SWIM.BOB * math.sin(0 / DEVIL_SWIM.BOB_T), DEVIL_SWIM.R * 0)

            clone:PivotTo(CFrame.fromMatrix(v39, Vector3.new(-0, 0, 1), (Vector3.new(0, 1, 0))) * AnatomyInverse)
            clone.Parent = View:FindFirstChildOfClass("WorldModel")
            t8.devilState = t23.SharkSwim.register(clone)

            if not t8.devilState then
                return
            end

            t8.devilCam = Instance.new("Camera")
            t8.devilCam.FieldOfView = DEVIL_SWIM.FOV
            t8.devilCam.Parent = View
            View.CurrentCamera = t8.devilCam
        end

        if not t8.devilConn and t8.devilState then
            local RenderStepped = game:GetService("RunService").RenderStepped

            t8.devilConn = RenderStepped:Connect(function(p21) -- line: 288
                -- upvalues: p16 (copy), DEVIL_SWIM (copy), devil (copy), anat (copy), t8 (ref)
                if not p16() then
                    t8.devilConn:Disconnect()
                    t8.devilConn = nil

                    return
                end

                local Y = devil.AbsolutePosition.Y
                local devilParent = devil.Parent

                if devil.Visible and devilParent.Visible and not (Y + devil.AbsoluteSize.Y < devilParent.AbsolutePosition.Y) and not (devilParent.AbsolutePosition.Y + devilParent.AbsoluteWindowSize.Y < Y) then
                    local v40 = math.min(p21, 0.05)

                    t8.devilT += v40
                    t8.devilTheta += v40 * DEVIL_SWIM.SPEED / DEVIL_SWIM.R

                    local v41 = anat(t8.devilTheta, t8.devilT)

                    t8.devilModel:PivotTo(v41 * t8.devilAi)
                    t8.devilDrivers.SharkSwim.update(t8.devilState, v40)

                    local RightVector, UpVector = v41.RightVector, v41.UpVector
                    local v43 = CFrame.fromAxisAngle(UpVector, DEVIL_SWIM.LOOK * math.sin(t8.devilT * 2 * 3.141592653589793 / DEVIL_SWIM.LOOK_T)):VectorToWorldSpace(RightVector:Cross(UpVector) * DEVIL_SWIM.SIDE + RightVector * DEVIL_SWIM.AHEAD) + UpVector * DEVIL_SWIM.UP

                    t8.devilCam.CFrame = CFrame.lookAt(v41.Position + v43, v41.Position + RightVector * DEVIL_SWIM.AIM)
                end
            end)
        end
    end

    t8.WRAITH_SWIM = {
        R = 50,
        SPEED = 40,
        BOB = 0.6,
        BOB_T = 3.2,
        LOOK = 0.3,
        LOOK_T = 10,
        SIDE = 15.5,
        UP = 2,
        AHEAD = 12,
        AIM = 1.8,
        DROP = 2.6,
        FOV = 40
    }

    function t8.wraithRun(p22) -- line: 322
        -- upvalues: ReplicatedStorage (copy), ShopConfig (ref), LocalPlayer (ref), t8 (ref)
        local WRAITH_SWIM, wraith = t8.WRAITH_SWIM, t8.wraith
        local View = wraith and wraith:FindFirstChild("View")

        if not View then
            return
        end

        local function anat(p23, p24) -- line: 326
            -- upvalues: WRAITH_SWIM (copy)
            local v48 = Vector3.new(WRAITH_SWIM.R * math.cos(p23), WRAITH_SWIM.BOB * math.sin(p24 * 2 * 3.141592653589793 / WRAITH_SWIM.BOB_T), WRAITH_SWIM.R * math.sin(p23))

            return CFrame.fromMatrix(v48, Vector3.new(-math.sin(p23), 0, (math.cos(p23))), (Vector3.new(0, 1, 0)))
        end

        if not t8.wraithModel then
            local ShopPreviews = ReplicatedStorage:FindFirstChild("ShopPreviews")
            local v51 = ShopPreviews and ShopPreviews:FindFirstChild(ShopConfig.WRAITH.fish)
            local AnatomyInverse = v51 and v51:GetAttribute("AnatomyInverse")

            if typeof(AnatomyInverse) ~= "CFrame" then
                return
            end

            local t25 = {}
            local t26 = {
                fightHooked = function() -- fightHooked | line: 336
                    return false
                end,
                attr = function(p25, p26) -- attr | line: 336
                    return p25:GetAttribute(p26)
                end,
                renderLag = function() -- renderLag | line: 337
                    return 0
                end
            }
            local Drivers = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("FishRenderController"):WaitForChild("Drivers")

            require(Drivers:WaitForChild("FishWave"))(t25, t26)
            require(Drivers:WaitForChild("SharkSwim"))(t25, t26)

            local WraithSwim = Drivers:FindFirstChild("WraithSwim")

            if WraithSwim then
                require(WraithSwim)(t25, t26)
            end

            local v52 = t25.WraithSwim or t25.SharkSwim
            local clone = v51:Clone()

            clone:SetAttribute("PassCruise", true)
            t8.wraithModel = clone
            t8.wraithAi = AnatomyInverse
            t8.wraithDriver = v52
            t8.wraithTheta = 0
            t8.wraithT = 0

            local v57 = Vector3.new(WRAITH_SWIM.R * 1, WRAITH_SWIM.BOB * math.sin(0 / WRAITH_SWIM.BOB_T), WRAITH_SWIM.R * 0)

            clone:PivotTo(CFrame.fromMatrix(v57, Vector3.new(-0, 0, 1), (Vector3.new(0, 1, 0))) * AnatomyInverse)
            clone.Parent = View:FindFirstChildOfClass("WorldModel")
            t8.wraithState = v52.register(clone)

            if not t8.wraithState then
                return
            end

            t8.wraithCam = Instance.new("Camera")
            t8.wraithCam.FieldOfView = WRAITH_SWIM.FOV
            t8.wraithCam.Parent = View
            View.CurrentCamera = t8.wraithCam
        end

        if not t8.wraithConn and t8.wraithState then
            local RenderStepped = game:GetService("RunService").RenderStepped

            t8.wraithConn = RenderStepped:Connect(function(p27) -- line: 357
                -- upvalues: p22 (copy), WRAITH_SWIM (copy), wraith (copy), anat (copy), t8 (ref)
                if not p22() then
                    t8.wraithConn:Disconnect()
                    t8.wraithConn = nil

                    return
                end

                local Y = wraith.AbsolutePosition.Y
                local wraithParent = wraith.Parent

                if wraith.Visible and wraithParent.Visible and not (Y + wraith.AbsoluteSize.Y < wraithParent.AbsolutePosition.Y) and not (wraithParent.AbsolutePosition.Y + wraithParent.AbsoluteWindowSize.Y < Y) then
                    local v58 = math.min(p27, 0.05)

                    t8.wraithT += v58
                    t8.wraithTheta += v58 * WRAITH_SWIM.SPEED / WRAITH_SWIM.R

                    local v59 = anat(t8.wraithTheta, t8.wraithT)

                    t8.wraithModel:PivotTo(v59 * t8.wraithAi)
                    t8.wraithDriver.update(t8.wraithState, v58)

                    local RightVector, UpVector = v59.RightVector, v59.UpVector
                    local v61 = CFrame.fromAxisAngle(UpVector, WRAITH_SWIM.LOOK * math.sin(t8.wraithT * 2 * 3.141592653589793 / WRAITH_SWIM.LOOK_T)):VectorToWorldSpace(RightVector:Cross(UpVector) * WRAITH_SWIM.SIDE + RightVector * WRAITH_SWIM.AHEAD) + UpVector * WRAITH_SWIM.UP

                    t8.wraithCam.CFrame = CFrame.lookAt(v59.Position + v61, v59.Position + RightVector * WRAITH_SWIM.AIM - UpVector * WRAITH_SWIM.DROP)
                end
            end)
        end
    end

    t8.MUMMY_SWIM = t8.WRAITH_SWIM

    function t8.mummyRun(p28) -- line: 382
        -- upvalues: ReplicatedStorage (copy), ShopConfig (ref), LocalPlayer (ref), t8 (ref)
        local MUMMY_SWIM, mummy = t8.MUMMY_SWIM, t8.mummy
        local View = mummy and mummy:FindFirstChild("View")

        if not View then
            return
        end

        local function anat(p29, p30) -- line: 386
            -- upvalues: MUMMY_SWIM (copy)
            local v66 = Vector3.new(MUMMY_SWIM.R * math.cos(p29), MUMMY_SWIM.BOB * math.sin(p30 * 2 * 3.141592653589793 / MUMMY_SWIM.BOB_T), MUMMY_SWIM.R * math.sin(p29))

            return CFrame.fromMatrix(v66, Vector3.new(-math.sin(p29), 0, (math.cos(p29))), (Vector3.new(0, 1, 0)))
        end

        if not t8.mummyModel then
            local ShopPreviews = ReplicatedStorage:FindFirstChild("ShopPreviews")
            local v69 = ShopPreviews and ShopPreviews:FindFirstChild(ShopConfig.MUMMY.fish)
            local AnatomyInverse = v69 and v69:GetAttribute("AnatomyInverse")

            if typeof(AnatomyInverse) ~= "CFrame" then
                return
            end

            local t27 = {}
            local t28 = {
                fightHooked = function() -- fightHooked | line: 396
                    return false
                end,
                attr = function(p31, p32) -- attr | line: 396
                    return p31:GetAttribute(p32)
                end,
                renderLag = function() -- renderLag | line: 397
                    return 0
                end
            }
            local Drivers = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("FishRenderController"):WaitForChild("Drivers")

            require(Drivers:WaitForChild("FishWave"))(t27, t28)
            require(Drivers:WaitForChild("EelSwim"))(t27, t28)

            local EelSwim = t27.EelSwim
            local clone = v69:Clone()

            clone:SetAttribute("PassCruise", true)
            t8.mummyModel = clone
            t8.mummyAi = AnatomyInverse
            t8.mummyDriver = EelSwim
            t8.mummyTheta = 0
            t8.mummyT = 0

            local v74 = Vector3.new(MUMMY_SWIM.R * 1, MUMMY_SWIM.BOB * math.sin(0 / MUMMY_SWIM.BOB_T), MUMMY_SWIM.R * 0)

            clone:PivotTo(CFrame.fromMatrix(v74, Vector3.new(-0, 0, 1), (Vector3.new(0, 1, 0))) * AnatomyInverse)
            clone.Parent = View:FindFirstChildOfClass("WorldModel")
            t8.mummyState = EelSwim.register(clone)

            if not t8.mummyState then
                return
            end

            t8.mummyCam = Instance.new("Camera")
            t8.mummyCam.FieldOfView = MUMMY_SWIM.FOV
            t8.mummyCam.Parent = View
            View.CurrentCamera = t8.mummyCam
        end

        if not t8.mummyConn and t8.mummyState then
            local RenderStepped = game:GetService("RunService").RenderStepped

            t8.mummyConn = RenderStepped:Connect(function(p33) -- line: 415
                -- upvalues: p28 (copy), MUMMY_SWIM (copy), mummy (copy), anat (copy), t8 (ref)
                if not p28() then
                    t8.mummyConn:Disconnect()
                    t8.mummyConn = nil

                    return
                end

                local Y = mummy.AbsolutePosition.Y
                local mummyParent = mummy.Parent

                if mummy.Visible and mummyParent.Visible and not (Y + mummy.AbsoluteSize.Y < mummyParent.AbsolutePosition.Y) and not (mummyParent.AbsolutePosition.Y + mummyParent.AbsoluteWindowSize.Y < Y) then
                    local v75 = math.min(p33, 0.05)

                    t8.mummyT += v75
                    t8.mummyTheta += v75 * MUMMY_SWIM.SPEED / MUMMY_SWIM.R

                    local v76 = anat(t8.mummyTheta, t8.mummyT)

                    t8.mummyModel:PivotTo(v76 * t8.mummyAi)
                    t8.mummyDriver.update(t8.mummyState, v75)

                    local RightVector, UpVector = v76.RightVector, v76.UpVector
                    local v78 = CFrame.fromAxisAngle(UpVector, MUMMY_SWIM.LOOK * math.sin(t8.mummyT * 2 * 3.141592653589793 / MUMMY_SWIM.LOOK_T)):VectorToWorldSpace(RightVector:Cross(UpVector) * MUMMY_SWIM.SIDE + RightVector * MUMMY_SWIM.AHEAD) + UpVector * MUMMY_SWIM.UP

                    t8.mummyCam.CFrame = CFrame.lookAt(v76.Position + v78, v76.Position + RightVector * MUMMY_SWIM.AIM - UpVector * MUMMY_SWIM.DROP)
                end
            end)
        end
    end

    t8.swims = {}
    t8.SWIM_DRIVERS = {
        "FishWave",
        "EelSwim",
        "HydraSwim",
        "EelDart",
        "TyloSwim",
        "BoneSwim",
        "MawSwim",
        "SharkSwim",
        "AnglerSwim",
        "MawSnap"
    }

    function t8.swimRun(p34, p35) -- line: 445
        -- upvalues: ReplicatedStorage (copy), LocalPlayer (ref), t8 (ref)
        local MUMMY_SWIM = t8.MUMMY_SWIM
        local v79 = t8.swims[p34]
        local v80 = v79 and v79.card
        local View = v80 and v80:FindFirstChild("View")

        if not View then
            return
        end

        local function anat(p36, p37) -- line: 450
            -- upvalues: MUMMY_SWIM (copy)
            local v85 = Vector3.new(MUMMY_SWIM.R * math.cos(p36), MUMMY_SWIM.BOB * math.sin(p37 * 2 * 3.141592653589793 / MUMMY_SWIM.BOB_T), MUMMY_SWIM.R * math.sin(p36))

            return CFrame.fromMatrix(v85, Vector3.new(-math.sin(p36), 0, (math.cos(p36))), (Vector3.new(0, 1, 0)))
        end

        if not v79.model then
            local ShopPreviews = ReplicatedStorage:FindFirstChild("ShopPreviews")
            local v88 = ShopPreviews and ShopPreviews:FindFirstChild(v79.fish)
            local AnatomyInverse = v88 and v88:GetAttribute("AnatomyInverse")

            if typeof(AnatomyInverse) ~= "CFrame" then
                return
            end

            if not t8.swimDrivers then
                local t29 = {}
                local t30 = {
                    fightHooked = function() -- fightHooked | line: 461
                        return false
                    end,
                    attr = function(p38, p39) -- attr | line: 461
                        return p38:GetAttribute(p39)
                    end,
                    renderLag = function() -- renderLag | line: 462
                        return 0
                    end
                }
                local Drivers = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("FishRenderController"):WaitForChild("Drivers")

                for _, v89 in ipairs(t8.SWIM_DRIVERS) do
                    local v90 = Drivers:FindFirstChild(v89)

                    if v90 then
                        require(v90)(t29, t30)
                    end
                end

                t8.swimDrivers = t29
            end

            local v91 = t8.swimDrivers[v88:GetAttribute("ProceduralAnim") or ""]

            if not v91 then
                return
            end

            local clone = v88:Clone()

            clone:SetAttribute("PassCruise", true)
            v79.model = clone
            v79.ai = AnatomyInverse
            v79.driver = v91
            v79.theta = 0
            v79.t = 0

            local v96 = Vector3.new(MUMMY_SWIM.R * 1, MUMMY_SWIM.BOB * math.sin(0 / MUMMY_SWIM.BOB_T), MUMMY_SWIM.R * 0)

            clone:PivotTo(CFrame.fromMatrix(v96, Vector3.new(-0, 0, 1), (Vector3.new(0, 1, 0))) * AnatomyInverse)
            clone.Parent = View:FindFirstChildOfClass("WorldModel")

            local register = v91.register
            local ok, result = pcall(register, clone)

            if not ok then
                warn("[ShopController] " .. tostring(v79.fish) .. " preview: " .. tostring(result))
            end

            v79.state = if not ok or not result then nil else result

            if not v79.state then
                return
            end

            v79.cam = Instance.new("Camera")
            v79.cam.FieldOfView = MUMMY_SWIM.FOV
            v79.cam.Parent = View
            View.CurrentCamera = v79.cam
            v79.state.cam = v79.cam
        end

        if not v79.conn and v79.state then
            v79.conn = game:GetService("RunService").RenderStepped:Connect(function(p40) -- line: 490
                -- upvalues: p35 (copy), MUMMY_SWIM (copy), v79 (copy), v80 (copy), anat (copy)
                if not p35() then
                    v79.conn:Disconnect()
                    v79.conn = nil

                    return
                end

                local Y = v80.AbsolutePosition.Y
                local Parent = v80.Parent

                if v80.Visible and Parent.Visible and not (Y + v80.AbsoluteSize.Y < Parent.AbsolutePosition.Y) and not (Parent.AbsolutePosition.Y + Parent.AbsoluteWindowSize.Y < Y) then
                    local v97 = math.min(p40, 0.05)

                    v79.t += v97
                    v79.theta += v97 * MUMMY_SWIM.SPEED / MUMMY_SWIM.R

                    local v98 = anat(v79.theta, v79.t)

                    v79.model:PivotTo(v98 * v79.ai)
                    v79.driver.update(v79.state, v97)

                    local RightVector, UpVector = v98.RightVector, v98.UpVector
                    local v100 = CFrame.fromAxisAngle(UpVector, MUMMY_SWIM.LOOK * math.sin(v79.t * 2 * 3.141592653589793 / MUMMY_SWIM.LOOK_T)):VectorToWorldSpace(RightVector:Cross(UpVector) * MUMMY_SWIM.SIDE + RightVector * MUMMY_SWIM.AHEAD) + UpVector * MUMMY_SWIM.UP

                    v79.cam.CFrame = CFrame.lookAt(v98.Position + v100, v98.Position + RightVector * MUMMY_SWIM.AIM - UpVector * MUMMY_SWIM.DROP)
                end
            end)
        end
    end

    t8.ORO_RING_LAP = 24

    function t8.oroRun() -- line: 511
        -- upvalues: TweenService (ref), t1 (ref), t5 (ref), t8 (ref)
        local Oroborus = t1:FindFirstChild("Oroborus")
        local Ring = Oroborus and Oroborus:FindFirstChild("Ring")

        if not Ring then
            return
        end

        local v101 = TweenService:Create(Ring, TweenInfo.new(t8.ORO_RING_LAP, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = Ring.Rotation - 360
        })

        v101:Play()
        t5[#t5 + 1] = v101
    end

    t8.MIME_SWAY = 7
    t8.MIME_BEAT = 1.1

    function t8.mimeRun() -- line: 526
        -- upvalues: TweenService (ref), ShopConfig (ref), t1 (ref), t5 (ref), t8 (ref)
        for _, v102 in ipairs({
                ShopConfig.MIME,
                ShopConfig.HOTDOG,
                ShopConfig.JESTER
            }) do
            local v103 = t1:FindFirstChild(v102.card)
            local Fish = v103 and v103:FindFirstChild("Fish")

            if Fish then
                Fish.Rotation = -t8.MIME_SWAY

                local v104 = TweenService:Create(Fish, TweenInfo.new(t8.MIME_BEAT, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    Rotation = t8.MIME_SWAY
                })

                v104:Play()
                t5[#t5 + 1] = v104
            end
        end
    end

    t9 = {
        card = t1:FindFirstChild("HellEgg"),
        Hellfire = require(script:WaitForChild("Hellfire"))
    }

    function t9.loops() -- line: 549
        -- upvalues: TweenService (ref), t9 (ref)
        local card = t9.card
        local HellHydra = card:WaitForChild("Tiles"):WaitForChild("HellHydra")
        local t31 = {}
        local Clip = HellHydra:WaitForChild("Clip")
        local Rays = Clip:WaitForChild("Rays")
        local SecretAura = card:WaitForChild("SecretAura")
        local Rainbow = HellHydra:WaitForChild("Edge"):WaitForChild("Rainbow")
        local UIGradient = Clip:WaitForChild("Shine"):WaitForChild("UIGradient")

        UIGradient.Offset = Vector2.new(-1, 0)

        local function forever(p41) -- line: 559
            return TweenInfo.new(p41, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
        end

        for _, v105 in ipairs({
                TweenService:Create(Rays, forever(6), {
                    Rotation = Rays.Rotation + 360
                }),
                TweenService:Create(SecretAura, forever(16), {
                    Rotation = SecretAura.Rotation - 360
                }),
                TweenService:Create(SecretAura, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                    ImageTransparency = 0.65
                }),
                TweenService:Create(Rainbow, forever(2.5), {
                    Rotation = Rainbow.Rotation + 360
                }),
                TweenService:Create(UIGradient, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, false, 1.6), {
                    Offset = Vector2.new(1, 0)
                })
            }) do
            t31[#t31 + 1] = v105
        end

        return t31
    end

    t10 = {
        STROKE = 0.13,
        SHINE_LAP = 1.4,
        FILL = Color3.fromRGB(176, 92, 255),
        SHINE = Color3.fromRGB(255, 240, 255),
        INK = Color3.fromRGB(34, 0, 72)
    }
    t10.seq = ColorSequence.new({
        ColorSequenceKeypoint.new(0, t10.FILL),
        ColorSequenceKeypoint.new(0.4, t10.FILL),
        ColorSequenceKeypoint.new(0.5, t10.SHINE),
        ColorSequenceKeypoint.new(0.6, t10.FILL),
        ColorSequenceKeypoint.new(1, t10.FILL)
    })
    v4 = 0

    function startLoops() -- line: 580
        -- upvalues: TweenService (ref), t17 (copy), t1 (ref), HellPanelFX (copy), t2 (ref), t5 (ref), t6 (ref), t8 (ref), t9 (ref), t10 (ref), v4 (ref)
        v4 += 1

        local v106 = v4
        local v107 = TweenInfo.new(t2.BURST_LAP, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)

        for _, child in ipairs(t1:GetChildren()) do
            if not child:IsA("GuiObject") or child.Visible then
                for _, v111 in ipairs({
                        "Burst",
                        "NextBurst"
                    }) do
                    local v112 = child:FindFirstChild(v111)

                    if v112 then
                        local t33 = {
                            Rotation = v112.Rotation + 360
                        }
                        local v113 = TweenService:Create(v112, v107, t33)

                        v113:Play()
                        t5[#t5 + 1] = v113
                    end
                end
            end
        end

        t6.Zap.Run(t6.card, t6.card.Art, t6.card.Burst, function() -- line: 599
            -- upvalues: v106 (copy), v4 (ref)
            return v106 == v4
        end)

        if t6.owner then
            t6.Zap.Run(t6.owner, t6.owner.Art, t6.owner.Burst, function() -- line: 603
                -- upvalues: v106 (copy), v4 (ref)
                return v106 == v4
            end, {
                sheet = "rbxassetid://139140257819422",
                pace = 1.6,
                storm = { 2, 3 }
            })
        end

        t8.devilRun(function() -- line: 607
            -- upvalues: v106 (copy), v4 (ref)
            return v106 == v4
        end)
        t8.wraithRun(function() -- line: 609
            -- upvalues: v106 (copy), v4 (ref)
            return v106 == v4
        end)
        t8.mummyRun(function() -- line: 611
            -- upvalues: v106 (copy), v4 (ref)
            return v106 == v4
        end)

        for v114 in pairs(t8.swims) do
            t8.swimRun(v114, function() -- line: 614
                -- upvalues: v106 (copy), v4 (ref)
                return v106 == v4
            end)
        end

        t8.oroRun()
        t8.mimeRun()

        local HellEggPanel = t1:FindFirstChild("HellEggPanel")

        if HellEggPanel then
            HellPanelFX.Run(HellEggPanel, function() -- line: 623
                -- upvalues: HellEggPanel (copy)
                return HellEggPanel.Parent.Visible
            end, function() -- line: 623
                -- upvalues: v106 (copy), v4 (ref)
                return v106 == v4
            end)
        end

        local VoidsparkEggPanel = t1:FindFirstChild("VoidsparkEggPanel")
        local v115 = VoidsparkEggPanel and VoidsparkEggPanel:FindFirstChild("Tiles") and VoidsparkEggPanel.Tiles:FindFirstChild("Dreadspark")

        if v115 then
            t6.Zap.Run(v115, v115.Icon, nil, function() -- line: 630
                -- upvalues: v106 (copy), v4 (ref)
                return v106 == v4
            end, {
                sheet = "rbxassetid://79920431476722",
                z = 10,
                shown = function() -- shown | line: 631
                    -- upvalues: VoidsparkEggPanel (copy)
                    return VoidsparkEggPanel.Visible and VoidsparkEggPanel.Parent.Visible
                end
            })
        end

        for _, v117 in ipairs(t6.baitBundles or {}) do
            for _, descendant in ipairs(v117:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant:GetAttribute("Flashy") and descendant:FindFirstChild("Grad") and descendant.Visible then
                    descendant.Grad.Offset = Vector2.new(-1, 0)

                    local v118 = TweenService:Create(descendant.Grad, TweenInfo.new(t10.SHINE_LAP, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                        Offset = Vector2.new(1, 0)
                    })

                    v118:Play()
                    t5[#t5 + 1] = v118
                end
            end
        end

        if VoidsparkEggPanel and VoidsparkEggPanel:FindFirstChild("Tiles") then
            for _, descendant in ipairs(VoidsparkEggPanel.Tiles:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant:GetAttribute("Flashy") and descendant:FindFirstChild("Grad") then
                    descendant.Grad.Offset = Vector2.new(-1, 0)

                    local v119 = TweenService:Create(descendant.Grad, TweenInfo.new(t10.SHINE_LAP, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                        Offset = Vector2.new(1, 0)
                    })

                    v119:Play()
                    t5[#t5 + 1] = v119
                end
            end

            for _, descendant in ipairs(VoidsparkEggPanel.Tiles:GetDescendants()) do
                local v120 = descendant:IsA("ImageLabel") and descendant:GetAttribute("Lap")

                if v120 then
                    local v121 = TweenInfo.new(math.abs(v120), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
                    local t35 = {
                        Rotation = descendant.Rotation + (v120 > 0 and -360 or 360)
                    }
                    local v122 = TweenService:Create(descendant, v121, t35)

                    v122:Play()
                    t5[#t5 + 1] = v122
                end
            end
        end

        if t9.card then
            for _, v123 in ipairs(t9.loops()) do
                v123:Play()
                t5[#t5 + 1] = v123
            end

            t9.Hellfire.Run(t9.card, {
                t9.card.SecretFire,
                t9.card.Tiles.HellHydra.BottomFire
            }, function() -- line: 674
                -- upvalues: v106 (copy), v4 (ref)
                return v106 == v4
            end)
        end

        if t6.bonePackLoop then
            t6.bonePackLoop()
        end

        local v124 = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.25, 1),
            NumberSequenceKeypoint.new(0.5, 0.82),
            NumberSequenceKeypoint.new(0.75, 1),
            NumberSequenceKeypoint.new(1, 1)
        })

        local function drift(p42, p43, p44, p45) -- line: 688
            -- upvalues: v106 (copy), TweenService (ref), t5 (ref), v4 (ref)
            p42.Offset = p43

            local v125 = TweenService:Create(p42, TweenInfo.new(p45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Offset = p44
            })

            t5[#t5 + 1] = v125
            task.delay(math.random() * p45, function() -- line: 692
                -- upvalues: v125 (copy), v106 (copy), v4 (ref)
                if v106 == v4 then
                    v125:Play()
                end
            end)
        end

        for _, v126 in ipairs(t17) do
            for _, child in ipairs(v126:GetChildren()) do
                if not child:IsA("GuiObject") or child.Visible then
                    local Backdrop = child:FindFirstChild("Backdrop")

                    if Backdrop and Backdrop:IsA("UIGradient") and Backdrop.Enabled then
                        drift(Backdrop, Vector2.new(-0.3, 0), Vector2.new(0.3, 0), 3.5)
                    end

                    local Sheen = child:FindFirstChild("Sheen")

                    Sheen = Sheen and Sheen:FindFirstChildOfClass("UIGradient")

                    if Sheen then
                        Sheen.Transparency = v124
                        drift(Sheen, Vector2.new(0.55, 0), Vector2.new(-0.55, 0), 4.5)
                    end
                end
            end
        end
    end

    do
        local function stopLoops() -- line: 713
            -- upvalues: t5 (ref), v4 (ref)
            v4 += 1

            for _, v127 in ipairs(t5) do
                v127:Pause()
            end

            table.clear(t5)
        end
    end

    local ShopSeen = Remotes:WaitForChild("ShopSeen")
    local t36 = {
        Popular = "Popular",
        Fish = "Fish",
        Eggs = "Eggs",
        Harpoons = "Harpoons",
        Gamepasses = "Gamepasses",
        Boosts = "Boosts"
    }
    local v128
    local v129 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local v130 = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    function firstBuy(p46) -- line: 730
        -- upvalues: Pages (copy)
        local v131 = Pages:FindFirstChild(p46)

        if not v131 then
            return nil
        end

        local Buy1, Scale

        for _, child in ipairs(v131:GetChildren()) do
            if child:IsA("GuiObject") and child.Visible and (not Scale or child.Position.Y.Scale < Scale) then
                local child2

                for _, child in ipairs(child:GetChildren()) do
                    if child:IsA("GuiButton") and child.Name:match("^Buy%d*$") and (not child2 or child.Position.X.Scale < child2.Position.X.Scale) then
                        child2 = child
                    end
                end

                local Buy1_2 = child:FindFirstChild("Buy1")

                if not Buy1_2 or not Buy1_2:IsA("GuiButton") then
                    Buy1_2 = child2
                end

                if Buy1_2 then
                    Buy1 = Buy1_2
                    Scale = child.Position.Y.Scale
                end
            end
        end

        return Buy1
    end

    function showPage(p47, p48) -- line: 751
        -- upvalues: TweenService (ref), t17 (copy), TopTabs (ref), t2 (ref), t21 (copy), t36 (copy), v128 (ref), v129 (copy), v130 (copy)
        local v132 = p47 ~= v128

        for _, v133 in ipairs(t17) do
            local v134 = v133.Name == p47

            v133.Visible = v134

            if v134 and (p48 or v132) then
                v133.CanvasPosition = Vector2.zero
            end

            local v135 = t36[v133.Name] and TopTabs:FindFirstChild(t36[v133.Name])

            if v135 then
                local t37 = {
                    ImageColor3 = v134 and t2.TAB_ON or t2.TAB_OFF
                }

                TweenService:Create(v135, v129, t37):Play()
            end
        end

        v128 = p47

        if not p48 and v132 then
            for _, v136 in ipairs(t17) do
                if v136.Name == p47 then
                    for _, child in ipairs(v136:GetChildren()) do
                        local Pop = child:FindFirstChild("Pop")

                        if Pop and Pop:IsA("UIScale") and not child:FindFirstChild("Gleam") then
                            Pop.Scale = t2.PAGE_POP
                            TweenService:Create(Pop, v130, {
                                Scale = 1
                            }):Play()
                        end
                    end
                end
            end

            local n1 = 0

            for _, v137 in ipairs(t21) do
                if v137.gui.Parent.Name == p47 and v137.gui.Visible then
                    v137.pop.Scale = t2.PAGE_POP
                    task.delay(n1 * t2.PAGE_STAGGER, function() -- line: 778
                        -- upvalues: v137 (copy), TweenService (ref), v130 (copy)
                        TweenService:Create(v137.pop, v130, {
                            Scale = 1
                        }):Play()
                    end)
                    n1 += 1
                end
            end
        end
    end

    PadMenu = require(Modules:WaitForChild("PadMenu"))

    local v139

    do
        local function openAt(p49) -- line: 791
            -- upvalues: GiftPicker (ref), v2 (ref), v3 (ref), showPage (ref), v139 (ref)
            if not v3 and not v2 and not GiftPicker.IsOpen() then
                showPage(p49, true)
                v139()
            end
        end
    end

    v139 = function() -- line: 796
        -- upvalues: TweenService (ref), PanelFocus (ref), LocalPlayer (ref), Panel (ref), Scale (ref), Close (ref), GiftPicker (ref), t4 (ref), Sound (ref), v2 (ref), v3 (ref), startLoops (ref), ShopSeen (copy), v128 (ref), firstBuy (ref), PadMenu (ref), close (ref)
        if v3 or v2 or GiftPicker.IsOpen() then
            return
        end

        v3 = true
        v2 = true
        LocalPlayer:SetAttribute("ShopOpen", true)
        PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
        Sound:Play()
        PanelFocus.MakeWay(function() -- line: 803
            -- upvalues: GiftPicker (ref), t4 (ref), v2 (ref)
            return v2 or GiftPicker.IsOpen() or t4.gifting
        end)
        Scale.Scale = PanelFocus.FEEL.FROM
        Panel.Visible = true
        PanelFocus.Focus(true)
        startLoops()
        ShopSeen:FireServer()

        local v140 = TweenService:Create(Scale, PanelFocus.popIn, {
            Scale = 1
        })

        v140.Completed:Once(function() -- line: 810
            -- upvalues: v3 (ref)
            v3 = false
        end)
        v140:Play()
        PadMenu.Open(Panel, function() -- line: 812
            -- upvalues: close (ref)
            if close then
                close()
            end
        end, {
            closeButton = Close,
            first = function() -- first | line: 814
                -- upvalues: v128 (ref), firstBuy (ref)
                return (firstBuy(v128))
            end
        })
    end

    function close2() -- line: 817
        -- upvalues: TweenService (ref), PanelFocus (ref), PurchaseFX (ref), LocalPlayer (ref), Panel (ref), Scale (ref), GiftPicker (ref), Odds (ref), t4 (ref), t5 (ref), v2 (ref), v3 (ref), v4 (ref), PadMenu (ref), v5 (ref)
        if v3 or not v2 then
            return
        end

        v3 = true
        v2 = false
        LocalPlayer:SetAttribute("ShopOpen", nil)
        GiftPicker.Close(true)
        t4.Confirm.Close(true)
        PadMenu.Close(Panel)
        PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
        PanelFocus.Focus(false)
        PurchaseFX.ShopGlow(false)
        v4 += 1

        for _, v141 in ipairs(t5) do
            v141:Pause()
        end

        table.clear(t5)
        Odds.Hide(true)

        local v142 = TweenService:Create(Scale, PanelFocus.popOut, {
            Scale = 0
        })

        v142.Completed:Once(function() -- line: 831
            -- upvalues: PanelFocus (ref), Panel (ref), t4 (ref), v3 (ref), v5 (ref)
            Panel.Visible = false

            if t4.gifting then
                v5()
            end

            PanelFocus.GiveBack()
            task.delay(PanelFocus.FEEL.BUTTON_IN, function() -- line: 835
                -- upvalues: v3 (ref)
                v3 = false
            end)
        end)
        v142:Play()
    end

    close = close2
    LocalPlayer:GetAttributeChangedSignal("OpenAchievements"):Connect(function() -- line: 841
        -- upvalues: LocalPlayer (ref), close2 (ref)
        if LocalPlayer:GetAttribute("OpenAchievements") then
            close2()
        end
    end)
    Button.Activated:Connect(function() -- line: 844
        -- upvalues: GiftPicker (ref), v2 (ref), v3 (ref), showPage (ref), v139 (ref)
        if v3 or v2 or GiftPicker.IsOpen() then
            return
        end

        showPage("Popular", true)
        v139()
    end)
    PlayerGui:WaitForChild("MenuButtons"):WaitForChild("FatBoost"):WaitForChild("ShopButton").Activated:Connect(function() -- line: 846
        -- upvalues: GiftPicker (ref), v2 (ref), v3 (ref), showPage (ref), v139 (ref)
        if v3 or v2 or GiftPicker.IsOpen() then
            return
        end

        showPage("Boosts", true)
        v139()
    end)

    do
        local Plus = PlayerGui:WaitForChild("HUD"):WaitForChild("Fat"):WaitForChild("Icon"):WaitForChild("Plus")

        Plus.Activated:Connect(function() -- line: 849
            -- upvalues: ButtonHover (ref), GiftPicker (ref), v2 (ref), v3 (ref), showPage (ref), v139 (ref), Plus (copy)
            ButtonHover.Press(Plus)

            if v3 or v2 or GiftPicker.IsOpen() then
                return
            end

            showPage("Boosts", true)
            v139()
        end)
    end

    Close.Activated:Connect(close2)
    LocalPlayer:GetAttributeChangedSignal("OpenShopTokens"):Connect(function() -- line: 856
        -- upvalues: TweenService (ref), PanelFocus (ref), LocalPlayer (ref), Scale (ref), Pages (copy), GiftPicker (ref), v2 (ref), v3 (ref), v128 (ref), showPage (ref), v139 (ref)
        if not LocalPlayer:GetAttribute("OpenShopTokens") then
            return
        end

        LocalPlayer:SetAttribute("OpenShopTokens", nil)

        if not v3 and not v2 and not GiftPicker.IsOpen() then
            showPage("Boosts", true)
            v139()
        end

        local Boosts = Pages:FindFirstChild("Boosts")
        local TokensHeader = Boosts and Boosts:FindFirstChild("TokensHeader")

        if TokensHeader then
            task.delay(PanelFocus.FEEL.OPEN_TIME + 0.05, function() -- line: 863
                -- upvalues: Boosts (copy), TokensHeader (copy), TweenService (ref), Scale (ref), v2 (ref), v128 (ref)
                if v2 and v128 == "Boosts" then
                    local v143 = math.max(Scale.Scale, 0.01)
                    local v144 = (TokensHeader.AbsolutePosition.Y - Boosts.AbsolutePosition.Y) / v143 + Boosts.CanvasPosition.Y - 0.04 * Boosts.AbsoluteSize.Y / v143
                    local v146 = math.max(0, Boosts.AbsoluteCanvasSize.Y / v143 - Boosts.AbsoluteSize.Y / v143)

                    TweenService:Create(Boosts, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        CanvasPosition = Vector2.new(0, (math.clamp(v144, 0, v146)))
                    }):Play()

                    local Token_1 = Boosts:FindFirstChild("Token_1")
                    local GuiService = game:GetService("GuiService")

                    if GuiService.SelectedObject and Token_1 and Token_1:FindFirstChild("Buy") then
                        GuiService.SelectedObject = Token_1.Buy
                    end
                end
            end)
        end
    end)
    ButtonHover.Attach(Close, {
        shine = false,
        tile = 1,
        icon = Close:FindFirstChild("X")
    })
    Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 879
        -- upvalues: PanelFocus (ref), PurchaseFX (ref), LocalPlayer (ref), Panel (ref), GiftPicker (ref), Odds (ref), t4 (ref), t5 (ref), v2 (ref), v3 (ref), v4 (ref), PadMenu (ref), v5 (ref)
        if not (v2 or GiftPicker.IsOpen()) then
            return
        end

        v2 = false
        v3 = false
        LocalPlayer:SetAttribute("ShopOpen", nil)
        PadMenu.Close(Panel)
        GiftPicker.Close(true)
        t4.Confirm.Close(true)
        Odds.Hide(true)
        PanelFocus.Focus(false, true)
        PurchaseFX.ShopGlow(false, true)
        v4 += 1

        for _, v147 in ipairs(t5) do
            v147:Pause()
        end

        table.clear(t5)
        Panel.Visible = false

        if t4.gifting then
            v5()
        end

        PanelFocus.GiveBackRight()
    end)
    StarterPack = t1:WaitForChild("StarterPack")
    InputMode = require(Modules:WaitForChild("InputMode"))
    GuiService = game:GetService("GuiService")

    do
        local ContextActionService = game:GetService("ContextActionService")
        local t38 = {
            "Popular",
            "Fish",
            "Harpoons",
            "Eggs",
            "Gamepasses",
            "Boosts"
        }

        local function highlightFirst(p50) -- line: 904
            -- upvalues: v2 (ref), firstBuy (ref), InputMode (ref), GuiService (ref)
            if InputMode.Pad() then
                task.defer(function() -- line: 906
                    -- upvalues: p50 (copy), v2 (ref), firstBuy (ref), GuiService (ref)
                    local v148 = v2 and firstBuy(p50)

                    if v148 then
                        GuiService.SelectedObject = v148
                    end
                end)
            end
        end

        for v149, v150 in pairs(t36) do
            local v151 = TopTabs:WaitForChild(v150)

            ButtonHover.Attach(v151, {
                tile = 1,
                iconTilt = 20,
                highlight = true,
                highlightCorner = 0.135,
                highlightFade = 0.8,
                buttonScale = 1.03,
                icon = v151:WaitForChild("Icon")
            })
            v151.Activated:Connect(function() -- line: 916
                -- upvalues: ButtonHover (ref), v2 (ref), firstBuy (ref), showPage (ref), InputMode (ref), GuiService (ref), v151 (copy), v149 (copy)
                ButtonHover.Press(v151)
                showPage(v149)

                if InputMode.Pad() then
                    task.defer(function() -- line: 906
                        -- upvalues: v2 (ref), firstBuy (ref), GuiService (ref), v149 (copy)
                        local v152 = v2 and firstBuy(v149)

                        if v152 then
                            GuiService.SelectedObject = v152
                        end
                    end)
                end
            end)
        end

        showPage("Popular", true)

        local function bumper(_, p52, p53) -- line: 924
            -- upvalues: ButtonHover (ref), TopTabs (ref), v2 (ref), v3 (ref), t36 (copy), v128 (ref), firstBuy (ref), showPage (ref), InputMode (ref), GuiService (ref), t38 (copy)
            if p52 ~= Enum.UserInputState.Begin then
                return Enum.ContextActionResult.Sink
            end

            local v153, v154

            if not v2 or v3 then
                return Enum.ContextActionResult.Sink
            else
                v153 = table.find(t38, v128) or 1
                v154 = if p53.KeyCode == Enum.KeyCode.ButtonL1 then -1 else 1
            end

            local v158 = math.clamp(v153 + v154, 1, #t38)

            if v158 ~= v153 then
                local v159 = t38[v158]

                ButtonHover.Press(TopTabs:WaitForChild(t36[v159]))
                showPage(v159)

                if InputMode.Pad() then
                    task.defer(function() -- line: 906
                        -- upvalues: v159 (copy), v2 (ref), firstBuy (ref), GuiService (ref)
                        local v160 = v2 and firstBuy(v159)

                        if v160 then
                            GuiService.SelectedObject = v160
                        end
                    end)
                end
            end

            return Enum.ContextActionResult.Sink
        end

        local function bindBumpers() -- line: 937
            -- upvalues: LocalPlayer (ref), ContextActionService (copy), bumper (copy)
            if LocalPlayer:GetAttribute("ShopOpen") then
                ContextActionService:BindActionAtPriority("ShopTabBumpers", bumper, false, Enum.ContextActionPriority.High.Value + 10, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
            else
                ContextActionService:UnbindAction("ShopTabBumpers")
            end
        end

        LocalPlayer:GetAttributeChangedSignal("ShopOpen"):Connect(bindBumpers)

        local t39 = {}

        for _, v161 in ipairs({
                {
                    t38[1],
                    Enum.KeyCode.ButtonL1,
                    0.02
                },
                {
                    t38[#t38],
                    Enum.KeyCode.ButtonR1,
                    0.98
                }
            }) do
            local v162 = TopTabs:WaitForChild(t36[v161[1]])
            local ImageLabel = Instance.new("ImageLabel")

            ImageLabel.Name = "PadBumper"
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
            ImageLabel.Position = UDim2.fromScale(v161[3], 0.85)
            ImageLabel.Size = UDim2.fromScale(1, 0.6)
            ImageLabel.ZIndex = 12

            local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

            UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
            UIAspectRatioConstraint.Parent = ImageLabel
            ImageLabel.Parent = v162
            t39[#t39 + 1] = {
                gui = ImageLabel,
                key = v161[2]
            }
        end

        local function dressBumpers() -- line: 963
            -- upvalues: InputMode (ref), t39 (copy)
            local v163 = InputMode.Pad()

            for _, v164 in ipairs(t39) do
                v164.gui.Visible = v163

                if v163 then
                    v164.gui.Image = InputMode.Icon(v164.key) or ""
                end
            end
        end

        InputMode.Changed:Connect(dressBumpers)
        dressBumpers()
    end

    local Rewards = StarterPack:WaitForChild("Rewards")
    local t40 = {
        Rewards:WaitForChild("Keys"),
        Rewards:WaitForChild("BonusKeys"),
        Rewards:WaitForChild("ExtraKeys")
    }
    local t41 = {
        Rewards:WaitForChild("XP"),
        t40[1],
        t40[2],
        t40[3]
    }
    local t42 = {}

    for v165, v166 in ipairs(t41) do
        t42[v165] = {
            v166.Position,
            v166.Size
        }
    end

    local t43 = {
        0.335, 0.45, 0.565, 0.68
    }
    local t44 = {
        Blue = "rbxassetid://102479163199552",
        Green = "rbxassetid://94864243096531",
        Purple = "rbxassetid://111497243137583",
        Red = "rbxassetid://83320718791398",
        Orange = "rbxassetid://85175878291521",
        Pink = "rbxassetid://133612926596312",
        Black = "rbxassetid://111894070943908",
        Rainbow = "rbxassetid://95521428082005"
    }

    t11 = {
        WHITE = "rbxassetid://71040818695903"
    }

    do
        local function c(p54, p55, p56) -- line: 999
            return Color3.fromRGB(p54, p55, p56)
        end

        local function g3(p57, p58, p59) -- line: 1000
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, p57),
                ColorSequenceKeypoint.new(0.5, p58),
                ColorSequenceKeypoint.new(1, p59)
            })
        end

        t11.GRAD = {
            Blue = g3(Color3.fromRGB(50, 150, 255), Color3.fromRGB(80, 215, 255), c(150, 120, 255)),
            Green = g3(Color3.fromRGB(30, 170, 60), Color3.fromRGB(100, 225, 70), c(215, 250, 100)),
            Purple = g3(Color3.fromRGB(130, 50, 255), Color3.fromRGB(220, 80, 230), c(255, 150, 200)),
            Crimson = g3(Color3.fromRGB(210, 30, 60), Color3.fromRGB(255, 80, 90), c(255, 160, 90)),
            Orange = g3(Color3.fromRGB(255, 80, 20), Color3.fromRGB(255, 150, 30), c(255, 225, 70)),
            Pink = g3(Color3.fromRGB(255, 70, 160), Color3.fromRGB(200, 80, 255), c(110, 130, 255)),
            Fire = g3(Color3.fromRGB(170, 15, 25), Color3.fromRGB(250, 80, 30), c(255, 180, 50)),
            Teal = g3(Color3.fromRGB(10, 130, 90), Color3.fromRGB(40, 200, 160), c(80, 170, 255))
        }
    end

    t11.STARTER = {
        Blue = t11.GRAD.Blue,
        Green = t11.GRAD.Green,
        Purple = t11.GRAD.Purple,
        Red = t11.GRAD.Crimson,
        Orange = t11.GRAD.Orange,
        Pink = t11.GRAD.Pink
    }

    function t11.Face(p60, p61, p62) -- line: 1017
        -- upvalues: t11 (ref)
        local Backdrop = p60:FindFirstChild("Backdrop")

        if p61 then
            p60.Image = t11.WHITE

            if not Backdrop then
                Backdrop = Instance.new("UIGradient")
                Backdrop.Name = "Backdrop"
                Backdrop.Rotation = 25
                Backdrop.Parent = p60
            end

            Backdrop.Color = p61
            Backdrop.Enabled = true
        else
            p60.Image = p62

            if Backdrop then
                Backdrop.Enabled = false
            end
        end
    end

    local UIStroke = StarterPack:FindFirstChildOfClass("UIStroke")
    local Off = StarterPack:WaitForChild("Off")

    Off.AutoLocalize = false

    local t45 = { StarterPack:WaitForChild("Title") }

    for _, v167 in ipairs(t41) do
        t45[#t45 + 1] = v167:WaitForChild("Label")
        t45[#t45 + 1] = v167:WaitForChild("Amount")
    end

    local function dressInk(p63) -- line: 1044
        -- upvalues: t45 (copy)
        if not p63 then
            return
        end

        for _, v168 in ipairs(t45) do
            local UIStroke = v168:FindFirstChildOfClass("UIStroke")
            local UIGradient = v168:FindFirstChildOfClass("UIGradient")

            if UIStroke then
                UIStroke.Color = p63.stroke
            end

            if UIGradient then
                local grad, rot = p63.grad, p63.rot

                UIGradient.Color = grad
                UIGradient.Rotation = rot
            end
        end
    end

    local function keyArt(p64, p65) -- line: 1052
        -- upvalues: KeyConfig (copy)
        local v169 = KeyConfig.KEYS[p65]

        if not v169 then
            return
        end

        p64.Image = v169.image
        p64.ImageRectOffset = Vector2.new(v169.rect[1], v169.rect[2])
        p64.ImageRectSize = Vector2.new(v169.rect[3] - v169.rect[1], v169.rect[4] - v169.rect[2])
    end

    function fitStrike(p66) -- line: 1059
        local v170 = p66.Label.TextBounds.X / math.max(1, p66.AbsoluteSize.X)

        p66.Strike.Size = UDim2.fromScale(math.max(0.2, v170 * 1.12), p66.Strike.Size.Y.Scale)
    end

    FreeReward = t1:WaitForChild("FreeReward")
    ServerLuck = t1:WaitForChild("ServerLuck")

    local t46 = {}

    do
        local AspectRatio = Panel:WaitForChild("UIAspectRatioConstraint").AspectRatio
        local v172

        for _, v173 in ipairs(t17) do
            v172 = v173.Size.Y.Scale / (v173.Size.X.Scale * AspectRatio)

            local t47 = {
                baked = {},
                H = math.max(v173:GetAttribute("H") or 0, v172),
                win = v172,
                rows = {},
                followers = {}
            }

            for _, child in ipairs(v173:GetChildren()) do
                if child:IsA("GuiObject") then
                    if child:GetAttribute("Follow") then
                        t47.followers[#t47.followers + 1] = child
                    else
                        t47.baked[child] = {
                            child.Position,
                            child.Size
                        }
                    end
                end
            end

            function t47.top(p67) -- line: 1088
                -- upvalues: t47 (copy)
                return (t47.baked[p67][1].Y.Scale - p67.AnchorPoint.Y * t47.baked[p67][2].Y.Scale) * t47.H
            end

            function t47.bottom(p68) -- line: 1089
                -- upvalues: t47 (copy)
                return (t47.baked[p68][1].Y.Scale + (1 - p68.AnchorPoint.Y) * t47.baked[p68][2].Y.Scale) * t47.H
            end

            v172 = {}

            local cards

            for v175 in pairs(t47.baked) do
                local v177 = math.floor(t47.top(v175) * 10000 + 0.5)

                v172[v177] = v172[v177] or {
                    top = t47.top(v175),
                    cards = {}
                }
                cards = v172[v177].cards
                table.insert(cards, v175)
            end

            for _, v178 in pairs(v172) do
                t47.rows[#t47.rows + 1] = v178
            end

            v172 = 0
            table.sort(t47.rows, function(p69, p70) -- line: 1097
                return p69.top < p70.top
            end)

            for v179 in pairs(t47.baked) do
                cards = t47.bottom
                v172 = math.max(v172, cards(v179))
            end

            t47.margin = t47.H - v172
            t47.NH = t47.H
            t46[v173] = t47
        end

        local function fitCanvas(p71) -- line: 1107
            -- upvalues: Scale (ref), t46 (copy)
            local Scale2 = Scale.Scale

            if Scale2 < 0.05 then
                return
            end

            p71.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(t46[p71].NH * p71.AbsoluteSize.X / Scale2)))
        end

        for _, v181 in ipairs(t17) do
            v172 = v181:GetPropertyChangedSignal("AbsoluteSize")
            v172:Connect(function() -- line: 1113
                -- upvalues: Scale (ref), t46 (copy), v181 (copy)
                local Scale2 = Scale.Scale

                if Scale2 < 0.05 then
                    return
                end

                v181.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(t46[v181].NH * v181.AbsoluteSize.X / Scale2)))
            end)
            v172 = Scale.Scale

            if not (v172 < 0.05) then
                v181.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(t46[v181].NH * v181.AbsoluteSize.X / v172)))
            end
        end
    end

    do
        local GuiService = game:GetService("GuiService")
        local v184

        GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function() -- line: 1126
            -- upvalues: TweenService (ref), Scale (ref), t18 (copy), GuiService (copy), v184 (ref)
            local SelectedObject = GuiService.SelectedObject
            local v185 = SelectedObject
            local Parent
            local v186 = SelectedObject
            local Parent2

            while true do
                if v186 and v186.Parent then
                    if not (t18[v186.Parent] and v186.Parent:IsA("ScrollingFrame")) then
                        v186 = v186.Parent
                        v185 = v186
                        continue
                    end

                    local Parent3 = v186.Parent

                    Parent2 = Parent3
                    Parent = Parent3
                else
                    Parent2 = nil
                end

                break
            end

            if Parent2 then
                task.defer(function() -- line: 1134
                    -- upvalues: SelectedObject (copy), v185 (ref), Parent (ref), TweenService (ref), Scale (ref), GuiService (copy), v184 (ref)
                    if GuiService.SelectedObject == SelectedObject and v185.Parent then
                        local v187 = math.max(Scale.Scale, 0.05)
                        local v188 = Parent.AbsoluteSize.Y / v187
                        local Y = Parent.CanvasPosition.Y
                        local v189 = (v185.AbsolutePosition.Y - Parent.AbsolutePosition.Y) / v187 + Y
                        local v190 = v189 + v185.AbsoluteSize.Y / v187
                        local v191 = v188 * 0.03
                        local v195 = math.clamp(if v188 <= v190 - v189 + 2 * v191 or v189 - v191 < Y then v189 - v191 elseif v190 + v191 > Y + v188 then v190 + v191 - v188 else Y, 0, (math.max(0, Parent.CanvasSize.Y.Offset - v188)))

                        if math.abs(v195 - Y) < 1 then
                            return
                        end

                        if v184 then
                            v184:Cancel()
                        end

                        v184 = TweenService:Create(Parent, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            CanvasPosition = Vector2.new(Parent.CanvasPosition.X, v195)
                        })
                        v184:Play()
                    end
                end)
            end
        end)
    end

    t12 = {}

    local t48 = {}

    local function relayout(p72) -- line: 1159
        -- upvalues: Scale (ref), t46 (copy), t12 (ref), t48 (copy)
        local v197 = t46[p72]
        local H = v197.H
        local t49 = {}

        for v198, v199 in ipairs(v197.rows) do
            local v200 = true

            for _, v201 in ipairs(v199.cards) do
                if not t12[v201] then
                    v200 = false
                    break
                end
            end

            if v200 and v197.rows[v198 + 1] then
                t49[#t49 + 1] = {
                    v199.top,
                    v197.rows[v198 + 1].top - v199.top
                }
            end
        end

        local function shiftOf(p73) -- line: 1170
            -- upvalues: t49 (copy)
            local n2 = 0

            for _, v202 in ipairs(t49) do
                if v202[1] < p73 - 1E-06 then
                    n2 += v202[2]
                end
            end

            return n2
        end

        local n3 = 0

        for v203 in pairs(v197.baked) do
            if not t12[v203] then
                local v204 = v197.bottom(v203)
                local v205 = v197.top(v203)
                local n4 = 0

                for _, v206 in ipairs(t49) do
                    if v206[1] < v205 - 1E-06 then
                        n4 += v206[2]
                    end
                end

                n3 = math.max(n3, v204 - n4)
            end
        end

        local v209 = math.max(n3 + v197.margin, v197.win)

        for _, v210 in ipairs(v197.rows) do
            local top = v210.top
            local n5 = 0

            for _, v211 in ipairs(t49) do
                if v211[1] < top - 1E-06 then
                    n5 += v211[2]
                end
            end

            local t50 = {}

            for _, v212 in ipairs(v210.cards) do
                if not t12[v212] then
                    t50[#t50 + 1] = v212
                end
            end

            for _, v213 in ipairs(v210.cards) do
                local v214 = v197.baked[v213]
                local v215 = if #v210.cards > 1 and #t50 == 1 and t50[1] == v213 then 0.4965 else v214[1].X.Scale

                v213.Position = UDim2.fromScale(v215, (v214[1].Y.Scale * H - n5) / v209)
                v213.Size = UDim2.fromScale(v214[2].X.Scale, v214[2].Y.Scale * H / v209)
            end
        end

        for v216 in pairs(t48) do
            v216.Visible = not t12[v216]
        end

        for _, v217 in ipairs(v197.followers) do
            local v218 = p72:FindFirstChild(v217:GetAttribute("Follow"))

            if v218 then
                v217.Position = UDim2.fromScale(v218.Position.X.Scale + (v217:GetAttribute("FX") - 0.5) * v218.Size.X.Scale, v218.Position.Y.Scale + (v217:GetAttribute("FY") - 0.5) * v218.Size.Y.Scale)
                v217.Size = UDim2.fromScale(v217:GetAttribute("FW") * v218.Size.X.Scale, v217:GetAttribute("FH") * v218.Size.Y.Scale)
                v217.Visible = v218.Visible
            end
        end

        v197.NH = v209

        local Scale2 = Scale.Scale

        if Scale2 < 0.05 then
            return
        end

        p72.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(t46[p72].NH * p72.AbsoluteSize.X / Scale2)))
    end

    function setHidden(p74) -- line: 1208
        -- upvalues: t12 (ref), t48 (copy), relayout (copy)
        local t51 = {}

        for v220, v221 in pairs(p74) do
            t48[v220] = true

            if t12[v220] == true ~= v221 then
                t12[v220] = v221 or nil
                t51[v220.Parent] = true
            end
        end

        for v222 in pairs(t51) do
            relayout(v222)
        end
    end

    do
        local function noPaidRandom() -- line: 1221
            -- upvalues: LocalPlayer (ref), t4 (ref)
            if LocalPlayer:GetAttribute("NoPaidRandom") == true then
                return true
            end

            return t4.gifting and t4.who:GetAttribute("NoPaidRandom") == true
        end
    end

    t13 = {
        StarterPack:WaitForChild("Buy"),
        ServerLuck:WaitForChild("Buy"),
        t1:WaitForChild("Luck2x"):WaitForChild("Buy")
    }

    for _, v223 in ipairs(ShopConfig.KEYS) do
        t13[#t13 + 1] = t1:WaitForChild(v223.card):WaitForChild("Buy")
    end

    function dressRestricted() -- line: 1231
        -- upvalues: LocalPlayer (ref), t2 (ref), t4 (ref), t13 (ref)
        if LocalPlayer:GetAttribute("NoPaidRandom") ~= true and (not t4.gifting or t4.who:GetAttribute("NoPaidRandom") ~= true) then
            return
        end

        for _, v224 in ipairs(t13) do
            local Price = v224:FindFirstChild("Price")

            if Price then
                Price.Text = "RESTRICTED"
            end

            if v224:IsA("ImageButton") then
                v224.ImageTransparency = t2.CLAIMED_FADE

                local Icon = v224:FindFirstChild("Icon")

                if Icon then
                    Icon.ImageTransparency = t2.CLAIMED_FADE
                end
            else
                v224.BackgroundTransparency = t2.CLAIMED_FADE

                if Price then
                    Price.TextTransparency = t2.CLAIMED_FADE
                end
            end
        end
    end

    t14 = {}
    t15 = {}

    do
        local function priceOf(p75) -- line: 1249
            -- upvalues: t14 (ref)
            return t14[p75] or p75.price
        end
    end

    function showStarter() -- line: 1251
        -- upvalues: TweenService (ref), ShopConfig (ref), Loc (ref), v1 (ref), t4 (ref), StarterPack (ref), Rewards (copy), t40 (copy), t41 (copy), t42 (copy), t43 (copy), t44 (copy), t11 (ref), UIStroke (copy), Off (copy), dressInk (copy), keyArt (copy), setHidden (ref), dressRestricted (ref), t14 (ref), v6 (ref)
        local v225 = (t4.who:GetAttribute("StarterBought") or 0) + 1
        local v226 = ShopConfig.Starter(v225)

        setHidden({
            [StarterPack] = v226 == nil
        })

        if not v226 or v225 == v6 then
            return
        end

        local v227 = v6 == nil

        v6 = v225
        t11.Face(StarterPack, t11.STARTER[v226.ink], t44[v226.ink] or "rbxassetid://102479163199552")

        if UIStroke and ShopConfig.INK[v226.ink] then
            UIStroke.Color = ShopConfig.INK[v226.ink].stroke
        end

        StarterPack.Title.Text = "Key Bundle " .. v225
        dressInk(ShopConfig.INK[v226.ink])
        Rewards.XP.Amount.Text = "+" .. tostring((math.floor(v226.xp))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

        for v229, v230 in ipairs(t40) do
            local v231 = v226.keys[v229]

            v230.Visible = v231 ~= nil

            if v231 then
                v230.Label.Text = v231[1] .. " Keys"
                v230.Amount.Text = "+" .. v231[2]
                keyArt(v230.Icon, v231[1])
            end
        end

        local v232 = #v226.keys >= 3

        for v233, v234 in ipairs(t41) do
            if v232 then
                v234.Position = UDim2.fromScale(t43[v233], t42[v233][1].Y.Scale)
                v234.Size = UDim2.fromScale(0.11, t42[v233][2].Y.Scale)
            else
                local v235 = t42[v233][1]
                local v236 = t42[v233][2]

                v234.Position = v235
                v234.Size = v236
            end

            v234.Label.Size = UDim2.fromScale(v232 and 0.95 or 1, v234.Label.Size.Y.Scale)
        end

        local Price = StarterPack.Buy.Price
        local v238 = math.floor(t14[v226] or v226.price)

        Price.Text = v1 .. " " .. tostring(v238):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

        local v239 = t14[v226] or v226.price
        local v240 = ShopConfig.OffOf(v226, v239)

        Off.Visible = v240 > 0
        Off.Text = Loc.F("shop.off", "{n}% Off", {
            n = v240
        })

        if not v227 then
            local Pop = StarterPack:WaitForChild("Pop")

            Pop.Scale = 0.85
            TweenService:Create(Pop, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end

        dressRestricted()
    end

    watch({ "StarterBought" }, showStarter)
    showStarter()

    do
        local function passPrice(p76) -- line: 1305
            -- upvalues: t4 (ref), t14 (ref)
            if t4.gifting then
                return t4.price[p76] or p76.price
            end

            return t14[p76] or p76.price
        end
    end

    function paintPrices() -- line: 1309
        -- upvalues: ShopConfig (ref), t1 (ref), Loc (ref), v1 (ref), t4 (ref), StarterPack (ref), Off (copy), ServerLuck (ref), dressRestricted (ref), t14 (ref)
        local v241 = ShopConfig.Starter((t4.who:GetAttribute("StarterBought") or 0) + 1)

        if v241 then
            local Price = StarterPack.Buy.Price
            local v243 = math.floor(t14[v241] or v241.price)

            Price.Text = v1 .. " " .. tostring(v243):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

            local v244 = t14[v241] or v241.price
            local v245 = ShopConfig.OffOf(v241, v244)

            Off.Visible = v245 > 0
            Off.Text = Loc.F("shop.off", "{n}% Off", {
                n = v245
            })
        end

        local Price = ServerLuck.Buy.Price
        local SERVER_LUCK = ShopConfig.SERVER_LUCK
        local v247 = math.floor(t14[SERVER_LUCK] or SERVER_LUCK.price)

        Price.Text = v1 .. " " .. tostring(v247):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

        for _, v248 in ipairs({
                ShopConfig.PASSES,
                ShopConfig.KEYS
            }) do
            for _, v249 in ipairs(v248) do
                local v250 = t1:FindFirstChild(v249.card)

                v250 = v250 and v250:FindFirstChild("Buy") and v250.Buy:FindFirstChild("Price")

                if v250 and (v248 ~= ShopConfig.PASSES or not t4.who:GetAttribute(ShopConfig.PassAttr(v249.key))) then
                    local v253

                    if v248 == ShopConfig.PASSES then
                        v253 = if t4.gifting then t4.price[v249] else t14[v249]
                        v253 = v253 or v249.price

                        if not v253 then
                            v253 = t14[v249]
                            v253 = v253 or v249.price
                        end
                    else
                        v253 = t14[v249]
                        v253 = v253 or v249.price
                    end

                    local v254 = math.floor(v253)

                    v250.Text = v1 .. " " .. tostring(v254):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                end
            end
        end

        dressRestricted()
    end

    task.spawn(function() -- line: 1330
        -- upvalues: MarketplaceService (copy), ShopConfig (ref), t4 (ref), t14 (ref), t15 (ref), paintPrices (ref)
        for _, v255 in ipairs({
                ShopConfig.STARTER,
                ShopConfig.PASSES,
                ShopConfig.KEYS,
                ShopConfig.TOKENS,
                ShopConfig.FAT_LADDER,
                ShopConfig.FAT_TIME,
                ShopConfig.CASH_TIME,
                { ShopConfig.SERVER_LUCK },
                ShopConfig.LIMITED,
                { ShopConfig.HYDRA },
                ShopConfig.HYDRA_UPS,
                ShopConfig.POTION_PACK,
                ShopConfig.BAIT_BUNDLES,
                ShopConfig.BONE_PACK,
                { ShopConfig.ULTIMATE },
                ShopConfig.HELL_EGG,
                ShopConfig.VOID_EGG,
                ShopConfig.MASSIVE_EGG,
                ShopConfig.AURORA_EGG,
                { ShopConfig.CASH4 }
            }) do
            for _, v256 in ipairs(v255) do
                local product = v256.product
                local Product = Enum.InfoType.Product

                if v256.pass then
                    product = v256.pass
                    Product = Enum.InfoType.GamePass
                end

                local GetProductInfo = MarketplaceService.GetProductInfo
                local ok, result = pcall(GetProductInfo, MarketplaceService, product, Product)

                if ok and result and type(result.PriceInRobux) == "number" then
                    t14[v256] = result.PriceInRobux
                end
            end
        end

        for _, v257 in pairs(ShopConfig.TABLES) do
            local GetProductInfo = MarketplaceService.GetProductInfo
            local product = v257.product
            local Product = Enum.InfoType.Product
            local ok, result = pcall(GetProductInfo, MarketplaceService, product, Product)

            if ok and result and type(result.PriceInRobux) == "number" then
                t14[v257] = result.PriceInRobux
            end
        end

        for _, v258 in ipairs(ShopConfig.PASSES) do
            if v258.gift then
                local GetProductInfo = MarketplaceService.GetProductInfo
                local gift = v258.gift
                local Product = Enum.InfoType.Product
                local ok, result = pcall(GetProductInfo, MarketplaceService, gift, Product)

                if ok and result and type(result.PriceInRobux) == "number" then
                    t4.price[v258] = result.PriceInRobux
                end
            end
        end

        paintPrices()

        for _, v259 in ipairs(t15) do
            v259()
        end
    end)

    local t52 = {}
    local t53 = {}

    function deny(p77) -- line: 1360
        -- upvalues: TweenService (ref), t52 (copy), t53 (copy)
        if t53[p77] == nil then
            t53[p77] = p77.Rotation
        end

        local v260 = t53[p77]

        if t52[p77] then
            t52[p77]:Cancel()
        end

        p77.Rotation = v260

        local v261 = TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 3, true)
        local v262 = TweenService:Create(p77, v261, {
            Rotation = v260 + 6
        })

        t52[p77] = v262
        v262.Completed:Once(function() -- line: 1368
            -- upvalues: p77 (copy), v260 (copy), v262 (copy), t52 (copy)
            if t52[p77] == v262 then
                t52[p77] = nil
                p77.Rotation = v260
            end
        end)
        v262:Play()
    end

    do
        local function buy(p78, p79) -- line: 1374
            -- upvalues: ButtonHover (ref), PurchaseFX (ref)
            ButtonHover.Press(p78)
            PurchaseFX.Buy(p79)
        end
    end

    GiftRequest = Remotes:WaitForChild("GiftRequest")

    local t54 = {
        stale = "They already have that!",
        gone = "They left the game!",
        slow = "Slow down!",
        busy = "Try again in a moment!",
        invalid = "You can't gift that!"
    }

    do
        local function blocked(p80, p81) -- line: 1387
            -- upvalues: ButtonHover (ref), LocalPlayer (ref), Toast (ref), t4 (ref), deny (ref)
            if LocalPlayer:GetAttribute("NoPaidRandom") ~= true and (not t4.gifting or t4.who:GetAttribute("NoPaidRandom") ~= true) then
                return false
            end

            if p81 then
                ButtonHover.Press(p80)
            end

            deny(p80)
            Toast.Show("This is restricted for your account!", "", nil, Toast.RED, "deny")

            return true
        end
    end

    function giftAsk(p82, p83, p84, p85) -- line: 1394
        -- upvalues: PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), GiftRequest (ref), t54 (copy)
        local InvokeServer = GiftRequest.InvokeServer
        local UserId = t4.who.UserId
        local ok, result = pcall(InvokeServer, GiftRequest, "Ask", UserId, p83, p84)

        if ok and result == p85 then
            PurchaseFX.Buy(p85)

            return
        end

        deny(p82)

        local Show = Toast.Show

        if not ok or not result then
            result = "busy"
        end

        Show(t54[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
    end

    t4.Confirm = require(script:WaitForChild("GiftConfirm"))
    t4.squares = {}
    t4.items = {}

    function t4.itemOf(p86) -- line: 1421
        -- upvalues: MarketplaceService (copy), t4 (ref)
        local v263 = t4.items[p86]

        if v263 then
            return v263
        end

        local GetProductInfo = MarketplaceService.GetProductInfo
        local Product = Enum.InfoType.Product
        local ok, result = pcall(GetProductInfo, MarketplaceService, p86, Product)
        local v264 = if ok and type(result) == "table" and result then result else {}
        local v266 = tostring(v264.Name or ""):gsub("^Gift%s+", ""):gsub("%s*%[(%d+)%]%s*$", " x%1"):gsub("%s*%b[]%s*$", "")
        local v267 = tonumber(v264.IconImageAssetId)
        local t55 = {
            name = v266
        }
        local v268, v269

        if v267 and v267 > 0 then
            local v270 = "rbxassetid://" .. v267

            if v270 then
                v268 = v270
                v269 = true
            else
                v269 = false
            end
        else
            v269 = false
        end

        t55.icon = if not v269 then t4.ICON else v268
        t4.items[p86] = t55

        return t55
    end

    function t4.squarePress(p87, p88) -- line: 1435
        -- upvalues: Players (copy), ButtonHover (ref), PurchaseFX (ref), GiftPicker (ref), Toast (ref), t4 (ref), v2 (ref), v3 (ref), deny (ref), GiftRequest (ref), t54 (copy)
        if not v3 and v2 and not t4.gifting and not GiftPicker.IsOpen() and not t4.Confirm.IsOpen() then
            ButtonHover.Press(p87)
            GiftPicker.Open(function(p89) -- line: 1438
                -- upvalues: p87 (copy), p88 (copy), Players (copy), PurchaseFX (ref), GiftPicker (ref), Toast (ref), t4 (ref), v2 (ref), deny (ref), GiftRequest (ref), t54 (copy)
                GiftPicker.Close()

                local v271, v272, v273 = p88(p89)

                if v273 then
                    local v274 = t4.itemOf(v273)

                    if p89.Parent == Players and v2 then
                        t4.Confirm.Open(p89, v274, function() -- line: 1448
                            -- upvalues: p89 (copy), v271 (copy), v272 (copy), v273 (copy), p87 (copy), Players (copy), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), GiftRequest (ref), t54 (copy)
                            t4.Confirm.Close()

                            if p89.Parent ~= Players then
                                Toast.Show("They left the game!", "", nil, Toast.RED, "deny")

                                return
                            end

                            local InvokeServer = GiftRequest.InvokeServer
                            local UserId = p89.UserId
                            local ok, result = pcall(InvokeServer, GiftRequest, "Ask", UserId, v271, v272)

                            if ok and result == v273 then
                                PurchaseFX.Buy(v273)

                                return
                            end

                            deny(p87)

                            local Show = Toast.Show

                            if not ok or not result then
                                result = "busy"
                            end

                            Show(t54[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                        end, function() -- line: 1458
                            -- upvalues: t4 (ref)
                            t4.Confirm.Close()
                        end)
                    end
                else
                    deny(p87)
                    Toast.Show("They already have that!", "", nil, Toast.RED, "deny")
                end
            end, function() -- line: 1459
                -- upvalues: GiftPicker (ref)
                GiftPicker.Close()
            end)
        end
    end

    t4.CORNER_TOP = 0.05

    function t4.square(p90, p91) -- line: 1462
        -- upvalues: ButtonHover (ref), ShopGui (copy), t4 (ref)
        if p90 and p90:GetAttribute("GiftSquare") == true then
            local clone = ShopGui:WaitForChild("GiftSquare"):Clone()

            if p90:GetAttribute("GiftSquareSide") == "Right" then
                clone.AnchorPoint = Vector2.new(0, 0.5)
                clone.Position = UDim2.new(1.04, 0, 0.5, 0)
            elseif p90:GetAttribute("GiftSquareSide") == "Above" then
                clone.AnchorPoint = Vector2.new(1, 1)
                clone.Position = UDim2.new(1, 0, -0.25, 0)
                clone.Size = UDim2.new(0.8, 0, 0.8, 0)
            elseif p90:GetAttribute("GiftSquareSide") == "Corner" then
                clone.AnchorPoint = Vector2.new(1, 0)
                clone.Position = UDim2.new(1, 0, (t4.CORNER_TOP - (p90.Position.Y.Scale - p90.AnchorPoint.Y * p90.Size.Y.Scale)) / p90.Size.Y.Scale, 0)
                clone.Size = UDim2.new(0.8, 0, 0.8, 0)
            end

            clone.Visible = true
            clone.Parent = p90
            t4.squares[#t4.squares + 1] = clone
            ButtonHover.Attach(clone, {
                tile = 1,
                iconTilt = 20,
                highlight = true,
                highlightCorner = 0.135,
                highlightFade = 0.8,
                icon = clone:FindFirstChild("Icon")
            })
            clone.Activated:Connect(function() -- line: 1489
                -- upvalues: p91 (copy), clone (copy), t4 (ref)
                t4.squarePress(clone, p91)
            end)
        end
    end

    function t4.egg(p92, p93, p94, p95) -- line: 1493
        -- upvalues: ButtonHover (ref), PurchaseFX (ref), LocalPlayer (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref)
        if LocalPlayer:GetAttribute("NoPaidRandom") == true or t4.gifting and t4.who:GetAttribute("NoPaidRandom") == true then
            ButtonHover.Press(p92)
            deny(p92)
            Toast.Show("This is restricted for your account!", "", nil, Toast.RED, "deny")
        elseif t4.gifting then
            ButtonHover.Press(p92)
            giftAsk(p92, p93, p94, p95.product)
        else
            local product = p95.product

            ButtonHover.Press(p92)
            PurchaseFX.Buy(product)
        end
    end

    local t56 = {
        tile = 1,
        iconTilt = -20,
        shine = false,
        buttonScale = 1.12
    }

    function hoverOf(p96) -- line: 1506
        -- upvalues: t56 (copy)
        local v275 = table.clone(t56)

        v275.icon = p96:FindFirstChild("Icon")

        return v275
    end

    t16 = {}

    function t16.on(p97, p98, p99) -- line: 1517
        -- upvalues: t21 (copy)
        p98.Activated:Connect(p99)

        if p97 and not p97:FindFirstChild("Tap") then
            local TextButton = Instance.new("TextButton")

            TextButton.Name = "Tap"
            TextButton.Text = ""
            TextButton.BackgroundTransparency = 1
            TextButton.AutoButtonColor = false
            TextButton.Selectable = false
            TextButton.Size = UDim2.fromScale(1, 1)
            TextButton.ZIndex = 5
            TextButton.Parent = p97
            TextButton.Activated:Connect(p99)

            for _, v276 in ipairs(t21) do
                if v276.gui == p97 then
                    TextButton.MouseEnter:Connect(v276.enter)
                    TextButton.MouseLeave:Connect(v276.leave)
                    p98.SelectionGained:Connect(v276.enter)
                    p98.SelectionLost:Connect(v276.leave)
                end
            end
        end
    end

    do
        local on = t16.on
        local MassiveEgg = StarterPack.Buy

        on(StarterPack, MassiveEgg, function() -- line: 1541
            -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), LocalPlayer (ref), Toast (ref), t4 (ref), StarterPack (ref), deny (ref), giftAsk (ref)
            local Buy = StarterPack.Buy

            if LocalPlayer:GetAttribute("NoPaidRandom") == true or t4.gifting and t4.who:GetAttribute("NoPaidRandom") == true then
                ButtonHover.Press(Buy)
                deny(Buy)
                Toast.Show("This is restricted for your account!", "", nil, Toast.RED, "deny")
            else
                local v277 = (t4.who:GetAttribute("StarterBought") or 0) + 1
                local v278 = ShopConfig.Starter(v277)

                if v278 then
                    if t4.gifting then
                        ButtonHover.Press(StarterPack.Buy)
                        giftAsk(StarterPack.Buy, "Starter", v277, v278.product)
                    else
                        local Buy = StarterPack.Buy
                        local product = v278.product

                        ButtonHover.Press(Buy)
                        PurchaseFX.Buy(product)
                    end
                end
            end
        end)
        t4.square(StarterPack.Buy, function(p100) -- line: 1553
            -- upvalues: ShopConfig (ref)
            local v279 = (p100:GetAttribute("StarterBought") or 0) + 1
            local v280 = ShopConfig.Starter(v279)

            return "Starter", v279, v280 and v280.product
        end)
        on = ButtonHover.Attach

        local Buy, Buy2 = StarterPack.Buy, StarterPack.Buy
        local Activated = table.clone(t56)

        Activated.icon = Buy2:FindFirstChild("Icon")
        on(Buy, Activated)

        local Buy3 = ServerLuck:WaitForChild("Buy")
        local Odds2 = ServerLuck:WaitForChild("Odds")

        t16.on(ServerLuck, Buy3, function() -- line: 1558
            -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), LocalPlayer (ref), Toast (ref), t4 (ref), deny (ref), Buy3 (copy)
            if t4.gifting then
                return
            end

            if LocalPlayer:GetAttribute("NoPaidRandom") ~= true and (not t4.gifting or t4.who:GetAttribute("NoPaidRandom") ~= true) then
                local product = ShopConfig.SERVER_LUCK.product

                ButtonHover.Press(Buy3)
                PurchaseFX.Buy(product)
            else
                ButtonHover.Press(Buy3)
                deny(Buy3)
                Toast.Show("This is restricted for your account!", "", nil, Toast.RED, "deny")
            end
        end)
        MassiveEgg = ButtonHover.Attach
        Activated = table.clone(t56)
        Activated.icon = Buy3:FindFirstChild("Icon")
        MassiveEgg(Buy3, Activated)
        ButtonHover.Attach(Odds2, {
            tile = 1,
            iconTilt = -20,
            highlight = true,
            highlightCorner = 0.3,
            highlightFade = 0.75,
            icon = Odds2:FindFirstChild("Icon")
        })
        Odds2.Activated:Connect(function() -- line: 1564
            -- upvalues: ButtonHover (ref), Odds (ref), Odds2 (copy)
            ButtonHover.Press(Odds2)
            Odds.Show("ServerOdds", Odds2)
        end)
        MassiveEgg = t1:FindFirstChild("MassiveEgg")

        local Odds3 = MassiveEgg and MassiveEgg:FindFirstChild("Odds")

        if Odds3 then
            ButtonHover.Attach(Odds3, {
                tile = 1,
                iconTilt = -20,
                highlight = true,
                highlightCorner = 0.3,
                highlightFade = 0.75,
                icon = Odds3:FindFirstChild("Icon")
            })
            Odds3.Activated:Connect(function() -- line: 1574
                -- upvalues: ButtonHover (ref), Odds (ref), Odds3 (copy)
                ButtonHover.Press(Odds3)
                Odds.Show("MassiveOdds", Odds3)
            end)
        end

        if MassiveEgg then
            for v281, v282 in ipairs(ShopConfig.MASSIVE_EGG) do
                local v283 = MassiveEgg:FindFirstChild(v282.button)

                if v283 then
                    t13[#t13 + 1] = v283

                    local function dress() -- line: 1587
                        -- upvalues: v1 (ref), dressRestricted (ref), t14 (ref), v282 (copy), v283 (copy)
                        local Price = v283.Price
                        local v285 = math.floor(t14[v282] or v282.price)

                        Price.Text = v1 .. " " .. tostring(v285):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                        dressRestricted()
                    end

                    dress()
                    table.insert(t15, dress)
                    LocalPlayer:GetAttributeChangedSignal("NoPaidRandom"):Connect(dress)
                    ButtonHover.Attach(v283, (hoverOf(v283)))
                    v283.Activated:Connect(function() -- line: 1595
                        -- upvalues: t4 (ref), v282 (copy), v283 (copy), v281 (copy)
                        t4.egg(v283, "MassiveEgg", v281, v282)
                    end)
                end
            end
        end
    end

    local Active = ServerLuck:WaitForChild("Active")

    Active.AutoLocalize = false

    local Lasts = ServerLuck:WaitForChild("Lasts")

    Lasts.AutoLocalize = false

    local F = Loc.F

    HellEggPanel = {}
    HellEggPanel.n = math.floor(ShopConfig.SERVER_LUCK.secs / 60 + 0.5)
    Lasts.Text = F("shop.lasts", "LASTS {n} MINUTES!", HellEggPanel)

    do
        local v286 = false

        local function dressLuck() -- line: 1609
            -- upvalues: Loc (ref), Active (copy), Lasts (copy)
            local v288 = math.ceil((workspace:GetAttribute("ServerLuckEnd") or 0) - workspace:GetServerTimeNow())

            Active.Visible = v288 > 0
            Lasts.Visible = v288 <= 0

            if v288 > 0 then
                Active.Text = Loc.F("shop.active", "ACTIVE {time}", {
                    time = string.format("%d:%02d", v288 // 60, v288 % 60)
                })
            end

            return v288 > 0
        end

        local function tickLuck() -- line: 1616
            -- upvalues: Panel (ref), v286 (ref), dressLuck (copy)
            if not v286 then
                v286 = true

                while Panel.Visible and dressLuck() do
                    task.wait(1)
                end

                v286 = false
            end
        end

        Panel:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 1622
            -- upvalues: Panel (ref), tickLuck (copy)
            if Panel.Visible then
                task.spawn(tickLuck)
            end
        end)
        workspace:GetAttributeChangedSignal("ServerLuckEnd"):Connect(function() -- line: 1625
            -- upvalues: Panel (ref), dressLuck (copy), tickLuck (copy)
            dressLuck()

            if Panel.Visible then
                task.spawn(tickLuck)
            end
        end)
        dressLuck()
    end

    function t6.onlyLeft(p101, p102, p103) -- line: 1637
        -- upvalues: Loc (ref)
        local OnlyLeft = p101:FindFirstChild("OnlyLeft")

        if not OnlyLeft then
            return
        end

        OnlyLeft.Text = Loc.F("shop.only_left", "ONLY {n} LEFT!", {
            n = tostring((math.floor(p102))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        })
        OnlyLeft.Visible = not p103 and p102 > 0
    end

    local ZEUS = ShopConfig.ZEUS
    local card = t6.card
    local Buy2 = card:WaitForChild("Buy")
    local Stock = card:WaitForChild("Stock")

    Stock.AutoLocalize = false
    card:WaitForChild("Off").AutoLocalize = false

    local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

    do
        local function left() -- line: 1650
            -- upvalues: ShopConfig (ref), ZEUS (copy)
            return workspace:GetAttribute(ShopConfig.LimitedAttr(ZEUS.key)) or ZEUS.stock
        end
    end

    function t6.dress() -- line: 1651
        -- upvalues: ShopConfig (ref), Loc (ref), t2 (ref), v1 (ref), t4 (ref), t6 (ref), t14 (ref), ZEUS (copy), card (copy), Buy2 (copy), Stock (copy)
        local v290 = workspace:GetAttribute(ShopConfig.LimitedAttr(ZEUS.key)) or ZEUS.stock
        local v291 = t4.who:GetAttribute("Owns" .. ZEUS.key) == true

        Stock.Text = Loc.F("shop.stock", "{left}/{stock}", {
            left = v290,
            stock = ZEUS.stock
        })
        t6.onlyLeft(card, v290, v291)

        local v292 = v291 or v290 <= 0
        local Price = Buy2.Price

        if v291 then
            Price.Text = "OWNED"
        elseif v290 <= 0 then
            Price.Text = "SOLD OUT"
        else
            local v294 = math.floor(t14[ZEUS] or ZEUS.price)

            Price.Text = v1 .. " " .. tostring(v294):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        local v295 = t14[ZEUS] or ZEUS.price
        local v296 = ShopConfig.OffOf(ZEUS, v295)
        local Off = card.Off

        if v296 > 0 then
            Off.Visible = not v292
        else
            Off.Visible = false
        end

        if card.Off.Visible then
            card.OnlyLeft.Visible = false
        end

        card.Off.Text = Loc.F("shop.off", "{n}% Off", {
            n = v296
        })
        Buy2.ImageTransparency = v292 and t2.CLAIMED_FADE or 0

        local Icon = Buy2:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v292 and t2.CLAIMED_FADE or 0
        end
    end

    card.WasPrice.Label.Text = v1 .. " " .. commas(ZEUS.was)
    card.WasPrice.Label:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 1668
        -- upvalues: card (copy)
        local WasPrice = card.WasPrice
        local v297 = WasPrice.Label.TextBounds.X / math.max(1, WasPrice.AbsoluteSize.X)

        WasPrice.Strike.Size = UDim2.fromScale(math.max(0.2, v297 * 1.12), WasPrice.Strike.Size.Y.Scale)
    end)
    task.defer(fitStrike, card.WasPrice)
    workspace:GetAttributeChangedSignal(ShopConfig.LimitedAttr(ZEUS.key)):Connect(t6.dress)
    watch({ "Owns" .. ZEUS.key }, t6.dress)
    Loc.Changed:Connect(t6.dress)
    on = t6.dress
    table.insert(t15, on)
    t6.dress()

    do
        local v299 = false
        local t58 = {
            owned = "You already own this!",
            soldout = "SOLD OUT!",
            busy = "Try again in a moment!"
        }

        ButtonHover.Attach(Buy2, (hoverOf(Buy2)))
        t16.on(card, Buy2, function() -- line: 1678
            -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), ZEUS (copy), Buy2 (copy), LimitedAsk (copy), v299 (ref), t58 (copy)
            ButtonHover.Press(Buy2)

            if not v299 then
                if not t4.who:GetAttribute("Owns" .. ZEUS.key) and not ((workspace:GetAttribute(ShopConfig.LimitedAttr(ZEUS.key)) or ZEUS.stock) <= 0) then
                    if t4.gifting then
                        giftAsk(Buy2, "Limited", table.find(ShopConfig.LIMITED, ZEUS), ZEUS.product)
                    else
                        v299 = true

                        local InvokeServer = LimitedAsk.InvokeServer
                        local key = ZEUS.key
                        local ok, result = pcall(InvokeServer, LimitedAsk, key)

                        v299 = false

                        if not ok or result ~= "ok" then
                            deny(Buy2)

                            local Show = Toast.Show

                            if not ok or not result then
                                result = "busy"
                            end

                            Show(t58[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                        else
                            PurchaseFX.Buy(ZEUS.product)
                        end
                    end
                else
                    deny(Buy2)
                end
            end
        end)
    end

    t4.square(Buy2, function() -- line: 1692
        -- upvalues: ShopConfig (ref), ZEUS (copy)
        return "Limited", table.find(ShopConfig.LIMITED, ZEUS), ZEUS.product
    end)

    local ICICLE = ShopConfig.ICICLE

    v7 = t1:WaitForChild(ICICLE.card)
    t6.icicle = v7

    local Buy3 = v7:WaitForChild("Buy")
    local LimitedAsk2 = Remotes:WaitForChild("LimitedAsk")

    function dress() -- line: 1703
        -- upvalues: t2 (ref), v1 (ref), t4 (ref), t14 (ref), ICICLE (copy), Buy3 (copy)
        local v300 = t4.who:GetAttribute("Owns" .. ICICLE.key) == true
        local Price = Buy3.Price

        if v300 then
            Price.Text = "OWNED"
        else
            local v302 = math.floor(t14[ICICLE] or ICICLE.price)

            Price.Text = v1 .. " " .. tostring(v302):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        Buy3.ImageTransparency = v300 and t2.CLAIMED_FADE or 0

        local Icon = Buy3:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v300 and t2.CLAIMED_FADE or 0
        end
    end

    watch({ "Owns" .. ICICLE.key }, dress)
    Loc.Changed:Connect(dress)
    table.insert(t15, dress)
    dress()

    do
        local v303 = false
        local t59 = {
            owned = "You already own this!",
            busy = "Try again in a moment!"
        }

        ButtonHover.Attach(Buy3, (hoverOf(Buy3)))
        t16.on(v7, Buy3, function() -- line: 1717
            -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), ICICLE (copy), Buy3 (copy), LimitedAsk2 (copy), v303 (ref), t59 (copy)
            ButtonHover.Press(Buy3)

            if not v303 then
                if t4.who:GetAttribute("Owns" .. ICICLE.key) then
                    deny(Buy3)
                elseif t4.gifting then
                    giftAsk(Buy3, "Limited", table.find(ShopConfig.LIMITED, ICICLE), ICICLE.product)
                else
                    v303 = true

                    local InvokeServer = LimitedAsk2.InvokeServer
                    local key = ICICLE.key
                    local ok, result = pcall(InvokeServer, LimitedAsk2, key)

                    v303 = false

                    if not ok or result ~= "ok" then
                        deny(Buy3)

                        local Show = Toast.Show

                        if not ok or not result then
                            result = "busy"
                        end

                        Show(t59[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                    else
                        PurchaseFX.Buy(ICICLE.product)
                    end
                end
            end
        end)
    end

    t4.square(Buy3, function() -- line: 1729
        -- upvalues: ShopConfig (ref), ICICLE (copy)
        return "Limited", table.find(ShopConfig.LIMITED, ICICLE), ICICLE.product
    end)

    do
        local TEALEAF = ShopConfig.TEALEAF

        v7 = t1:WaitForChild(TEALEAF.card)
        t6.tealeaf = v7

        local Buy = v7:WaitForChild("Buy")
        local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

        function dress() -- line: 1741
            -- upvalues: t2 (ref), v1 (ref), t4 (ref), t14 (ref), TEALEAF (copy), Buy (copy)
            local v304 = t4.who:GetAttribute("Owns" .. TEALEAF.key) == true
            local Price = Buy.Price

            if v304 then
                Price.Text = "OWNED"
            else
                local v306 = math.floor(t14[TEALEAF] or TEALEAF.price)

                Price.Text = v1 .. " " .. tostring(v306):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
            end

            Buy.ImageTransparency = v304 and t2.CLAIMED_FADE or 0

            local Icon = Buy:FindFirstChild("Icon")

            if Icon then
                Icon.ImageTransparency = v304 and t2.CLAIMED_FADE or 0
            end
        end

        watch({ "Owns" .. TEALEAF.key }, dress)
        Loc.Changed:Connect(dress)
        table.insert(t15, dress)
        dress()

        local v307 = false
        local t60 = {
            owned = "You already own this!",
            busy = "Try again in a moment!"
        }

        ButtonHover.Attach(Buy, (hoverOf(Buy)))
        t16.on(v7, Buy, function() -- line: 1755
            -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), TEALEAF (copy), Buy (copy), LimitedAsk (copy), v307 (ref), t60 (copy)
            ButtonHover.Press(Buy)

            if not v307 then
                if t4.who:GetAttribute("Owns" .. TEALEAF.key) then
                    deny(Buy)
                elseif t4.gifting then
                    giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, TEALEAF), TEALEAF.product)
                else
                    v307 = true

                    local InvokeServer = LimitedAsk.InvokeServer
                    local key = TEALEAF.key
                    local ok, result = pcall(InvokeServer, LimitedAsk, key)

                    v307 = false

                    if not ok or result ~= "ok" then
                        deny(Buy)

                        local Show = Toast.Show

                        if not ok or not result then
                            result = "busy"
                        end

                        Show(t60[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                    else
                        PurchaseFX.Buy(TEALEAF.product)
                    end
                end
            end
        end)
        t4.square(Buy, function() -- line: 1767
            -- upvalues: ShopConfig (ref), TEALEAF (copy)
            return "Limited", table.find(ShopConfig.LIMITED, TEALEAF), TEALEAF.product
        end)
    end

    HellEggPanel = Pages:WaitForChild("Harpoons")

    local LimitedAsk3 = Remotes:WaitForChild("LimitedAsk")
    local t61 = {}

    for _, v308 in ipairs(ShopConfig.LIMITED) do
        on = v308.harpoonRotation and HellEggPanel:FindFirstChild(v308.card)

        if on then
            t61[v308.key] = {
                row = v308,
                card = on
            }
        end
    end

    do
        local function clock(p104) -- line: 1787
            local v310 = math.max(0, (math.floor(p104)))
            local v311 = v310 // 86400
            local v312 = v310 % 86400 // 3600
            local v313 = v310 % 3600 // 60

            return v311 > 0 and ("%dd %02dh"):format(v311, v312) or ("%02d:%02d:%02d"):format(v312, v313, v310 % 60)
        end
    end

    local v314 = {}
    local v315 = false

    local function stack() -- line: 1793
        -- upvalues: ShopConfig (ref), t6 (ref), setHidden (ref), t61 (copy), v314 (ref), v315 (ref)
        local v316 = ShopConfig.Week()

        if v315 ~= false and v315 == v316 then
            return
        end

        v315 = v316
        v314 = ShopConfig.HarpoonsOf(v316)

        local t62 = {
            [t6.icicle] = true
        }

        for v317, v318 in pairs(t61) do
            t62[v318.card] = table.find(v314, v317) == nil
        end

        setHidden(t62)
    end

    local function dressTimers() -- line: 1802
        -- upvalues: ShopConfig (ref), t61 (copy), v314 (ref)
        local _, v319 = ShopConfig.Week()
        local v320, v321

        if v319 then
            local v324 = math.max(0, (math.floor(v319 - workspace:GetServerTimeNow())))
            local v325 = v324 // 86400
            local v326 = v324 % 86400 // 3600
            local v327 = v324 % 3600 // 60

            if v325 > 0 then
                local v328 = ("%dd %02dh"):format(v325, v326)

                if v328 then
                    v320 = v328
                    v321 = true
                else
                    v328 = ("%02d:%02d:%02d"):format(v326, v327, v324 % 60)

                    if v328 then
                        v320 = v328
                        v321 = true
                    else
                        v321 = false
                    end
                end
            else
                local v329 = ("%02d:%02d:%02d"):format(v326, v327, v324 % 60)

                if v329 then
                    v320 = v329
                    v321 = true
                else
                    v321 = false
                end
            end
        else
            v321 = false
        end

        if not v321 then
            v320 = ""
        end

        for _, v330 in ipairs(v314) do
            local v331 = t61[v330] and t61[v330].card:FindFirstChild("Timer")

            if v331 then
                v331.AutoLocalize = false
                v331.Text = "LEAVES IN " .. v320
            end
        end
    end

    local Icon = TopTabs:WaitForChild("Harpoons"):WaitForChild("Icon")
    local Size = Icon.Size
    local v332 = {
        OUT = 0.12,
        IN = 0.38,
        TWIST = 25
    }

    do
        local v333 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v334 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local n6 = 0

        local function icons() -- line: 1820
            -- upvalues: t6 (ref), t61 (copy), v314 (ref)
            local t63 = {
                t6.card.Art
            }

            for _, v335 in ipairs(v314) do
                local v336 = t61[v335] and t61[v335].card:FindFirstChild("Art")

                if v336 then
                    t63[#t63 + 1] = v336
                end
            end

            return t63
        end

        local function showIcon(p105) -- line: 1828
            -- upvalues: Icon (copy)
            Icon.Image = p105.Image

            local ImageRectOffset, ImageRectSize = p105.ImageRectOffset, p105.ImageRectSize

            Icon.ImageRectOffset = ImageRectOffset
            Icon.ImageRectSize = ImageRectSize
        end

        local function swapTabIcon() -- line: 1832
            -- upvalues: TweenService (ref), Icon (copy), Size (copy), v333 (copy), v334 (copy), n6 (ref), icons (copy)
            local v337 = icons()
            local v338 = n6

            n6 = v338 % #v337 + 1

            local v339 = v337[n6]
            local v340 = TweenService:Create(Icon, v333, {
                Size = UDim2.fromScale(0, 0)
            })

            v340.Completed:Once(function() -- line: 1837
                -- upvalues: v339 (copy), TweenService (ref), Icon (copy), Size (copy), v334 (copy)
                Icon.Image = v339.Image

                local ImageRectOffset, ImageRectSize = v339.ImageRectOffset, v339.ImageRectSize

                Icon.ImageRectOffset = ImageRectOffset
                Icon.ImageRectSize = ImageRectSize
                TweenService:Create(Icon, v334, {
                    Size = Size
                }):Play()

                if Icon.Rotation == 0 then
                    Icon.Rotation = -25
                    TweenService:Create(Icon, v334, {
                        Rotation = 0
                    }):Play()
                end
            end)
            v340:Play()
        end

        local v341 = false

        Panel:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 1867
            -- upvalues: Panel (ref), t6 (ref), stack (copy), dressTimers (copy), Icon (copy), n6 (ref), swapTabIcon (copy), v341 (ref)
            if Panel.Visible then
                if v341 then
                    return
                end

                v341 = true
                stack()
                n6 = 1

                local Art = t6.card.Art

                Icon.Image = Art.Image

                local ImageRectOffset, ImageRectSize = Art.ImageRectOffset, Art.ImageRectSize

                Icon.ImageRectOffset = ImageRectOffset
                Icon.ImageRectSize = ImageRectSize
                task.spawn(function() -- line: 1855
                    -- upvalues: Panel (ref), stack (copy), dressTimers (copy), swapTabIcon (copy), v341 (ref)
                    local n7 = 1

                    while Panel.Visible do
                        stack()
                        dressTimers()

                        if n7 % 3 == 0 then
                            swapTabIcon()
                        end

                        n7 += 1
                        task.wait(1)
                    end

                    v341 = false
                end)
            end
        end)
    end

    workspace:GetAttributeChangedSignal("ShopWeekShift"):Connect(function() -- line: 1868
        -- upvalues: v315 (ref), stack (copy), dressTimers (copy)
        v315 = false
        stack()
        dressTimers()
    end)
    Loc.Changed:Connect(dressTimers)
    stack()
    dressTimers()

    do
        local t64 = {
            owned = "You already own this!",
            ended = "This harpoon has left the shop!",
            busy = "Try again in a moment!"
        }

        for _, v342 in pairs(t61) do
            if v342.row ~= ShopConfig.TEALEAF then
                local row = v342.row
                local Buy = v342.card:WaitForChild("Buy")

                local function dress() -- line: 1877
                    -- upvalues: t2 (ref), v1 (ref), t4 (ref), t14 (ref), row (copy), Buy (copy)
                    local v343 = t4.who:GetAttribute("Owns" .. row.key) == true
                    local Price = Buy.Price

                    if v343 then
                        Price.Text = "OWNED"
                    else
                        local v345 = math.floor(t14[row] or row.price)

                        Price.Text = v1 .. " " .. tostring(v345):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                    end

                    Buy.ImageTransparency = v343 and t2.CLAIMED_FADE or 0

                    local Icon = Buy:FindFirstChild("Icon")

                    if Icon then
                        Icon.ImageTransparency = v343 and t2.CLAIMED_FADE or 0
                    end
                end

                watch({ "Owns" .. row.key }, dress)
                Loc.Changed:Connect(dress)
                table.insert(t15, dress)
                dress()

                local v346 = false

                ButtonHover.Attach(Buy, (hoverOf(Buy)))
                t16.on(v342.card, Buy, function() -- line: 1890
                    -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), LimitedAsk3 (copy), t64 (copy), row (copy), Buy (copy), v346 (ref)
                    ButtonHover.Press(Buy)

                    if not v346 then
                        if t4.who:GetAttribute("Owns" .. row.key) then
                            deny(Buy)
                        elseif t4.gifting then
                            giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, row), row.product)
                        else
                            v346 = true

                            local InvokeServer = LimitedAsk3.InvokeServer
                            local key = row.key
                            local ok, result = pcall(InvokeServer, LimitedAsk3, key)

                            v346 = false

                            if not ok or result ~= "ok" then
                                deny(Buy)

                                local Show = Toast.Show

                                if not ok or not result then
                                    result = "busy"
                                end

                                Show(t64[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                            else
                                PurchaseFX.Buy(row.product)
                            end
                        end
                    end
                end)
                t4.square(Buy, function() -- line: 1902
                    -- upvalues: ShopConfig (ref), row (copy)
                    return "Limited", table.find(ShopConfig.LIMITED, row), row.product
                end)
            end
        end
    end

    local PotionPack = t1:WaitForChild("PotionPack")

    t6.potionPack = PotionPack

    local Buy4 = PotionPack:WaitForChild("Buy")
    local Rewards2 = PotionPack:WaitForChild("Rewards")
    local t65 = {
        Rewards2:WaitForChild("FatPotions"):WaitForChild("Amount"),
        Rewards2:WaitForChild("BagPotions"):WaitForChild("Amount")
    }

    for _, v347 in ipairs(t65) do
        v347.AutoLocalize = false
    end

    money = require(Modules:WaitForChild("PotionConfig"))

    local on4

    for v348, v349 in ipairs({
            Rewards2.FatPotions,
            Rewards2.BagPotions
        }) do
        v332 = ShopConfig.POTION_PACK_POTIONS[v348]
        on4 = v349:WaitForChild("What")
        on4.AutoLocalize = false
        on4.Text = money.Title(v332, Loc) .. " (" .. money.Length(v332) .. ")"
        v349:WaitForChild("Icon").Image = money.TIERS[v332].icon
    end

    do
        local function rung() -- line: 1932
            -- upvalues: ShopConfig (ref), t4 (ref)
            return ShopConfig.PotionPackNext(t4.who:GetAttribute("PotionPackBought") or 0)
        end
    end

    function dress() -- line: 1933
        -- upvalues: ShopConfig (ref), v1 (ref), t4 (ref), setHidden (ref), t14 (ref), PotionPack (copy), Buy4 (copy), t65 (copy)
        local v350 = ShopConfig.PotionPackNext(t4.who:GetAttribute("PotionPackBought") or 0)

        setHidden({
            [PotionPack] = v350 == nil
        })

        if not v350 then
            return
        end

        for _, v351 in ipairs(t65) do
            v351.Text = "x" .. v350.count
        end

        local Price = Buy4.Price
        local v353 = math.floor(t14[v350] or v350.price)

        Price.Text = v1 .. " " .. tostring(v353):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    end

    watch({ "PotionPackBought" }, dress)
    table.insert(t15, dress)
    dress()
    ButtonHover.Attach(Buy4, (hoverOf(Buy4)))
    t16.on(PotionPack, Buy4, function() -- line: 1944
        -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), t4 (ref), deny (ref), giftAsk (ref), Buy4 (copy)
        ButtonHover.Press(Buy4)

        local v354, v355 = ShopConfig.PotionPackNext(t4.who:GetAttribute("PotionPackBought") or 0)

        if v354 then
            if t4.gifting then
                giftAsk(Buy4, "PotionPack", v355, v354.product)
            else
                PurchaseFX.Buy(v354.product)
            end
        else
            deny(Buy4)
        end
    end)
    t4.square(Buy4, function(p106) -- line: 1950
        -- upvalues: ShopConfig (ref)
        local v356, v357 = ShopConfig.PotionPackNext(p106:GetAttribute("PotionPackBought") or 0)

        return "PotionPack", v357, v356 and v356.product
    end)

    local Fish = Pages:WaitForChild("Fish")
    local t66 = {
        serial = Fish:WaitForChild("SerialHeader"),
        sub = Fish:WaitForChild("SerialSub"),
        regular = Fish:WaitForChild("ExclusiveHeader")
    }
    local LimitedAsk4 = Remotes:WaitForChild("LimitedAsk")
    local t67 = {}

    for _, v358 in ipairs(ShopConfig.LIMITED) do
        key = v358.rotation and Fish:FindFirstChild(v358.card)

        if key then
            v332 = #t67 + 1
            on4 = {
                row = v358,
                card = key
            }
            on4.timerAt = key:FindFirstChild("Timer") and key.Timer.Position
            t67[v332] = on4
            key.Visible = false

            if v358 == ShopConfig.DEVILSHARK then
                t8.devil = key
            elseif v358 == ShopConfig.WRAITH then
                t8.wraith = key
            elseif v358 == ShopConfig.MUMMY then
                t8.mummy = key
            elseif key:FindFirstChild("View") then
                t8.swims[v358.key] = {
                    card = key,
                    fish = v358.fish
                }
            end
        end
    end

    local BoostFish = require(Modules:WaitForChild("BoostFish"))
    local Format = require(Modules:WaitForChild("Format"))
    local v359 = #require(Modules:WaitForChild("GrowthDisplay")).stages - 1
    local t68 = {}

    do
        local function priceNow(p107) -- line: 1984
            -- upvalues: ShopConfig (ref), t14 (ref), t68 (copy)
            local v360, v361 = ShopConfig.ProductNow(p107)

            if v360 == p107.plainProduct then
                return t68[p107] or v361
            end

            return t14[p107] or p107.price
        end
    end

    function left(p108) -- line: 1990
        -- upvalues: ShopConfig (ref)
        return workspace:GetAttribute(ShopConfig.LimitedAttr(p108.key)) or ShopConfig.Capacity(p108)
    end

    do
        local function clock(p109) -- line: 1991
            local v363 = math.max(0, (math.floor(p109)))
            local v364 = v363 // 86400
            local v365 = v363 % 86400 // 3600
            local v366 = v363 % 3600 // 60

            return v364 > 0 and ("%dd %02dh"):format(v364, v365) or ("%02d:%02d:%02d"):format(v365, v366, v363 % 60)
        end
    end

    local function dress2(p110) -- line: 1996
        -- upvalues: ShopConfig (ref), LocalPlayer (ref), Loc (ref), t2 (ref), v1 (ref), t6 (ref), t14 (ref), BoostFish (copy), Format (copy), v359 (copy), t68 (copy)
        local row, card = p110.row, p110.card
        local v367, v368 = ShopConfig.Phase(row)

        if not v367 then
            return
        end

        local v369 = v367 == "serial"
        local v370 = workspace:GetAttribute(ShopConfig.LimitedAttr(row.key)) or ShopConfig.Capacity(row)
        local v371 = v369 and v370 <= 0

        for _, v372 in ipairs({ "Limited", "Stock", "StockBox", "StockLabel" }) do
            local v373 = card:FindFirstChild(v372)

            if v373 then
                v373.Visible = v369
            end
        end

        local v374 = ShopConfig.Capacity(row) - row.stock
        local v375 = v374 > 0 and v370 <= v374

        if not v375 or not v370 then
            v370 -= v374
        end

        if not v375 or not v374 then
            v374 = row.stock
        end

        local Stock = card:FindFirstChild("Stock")

        if Stock then
            Stock.AutoLocalize = false
            Stock.Text = Loc.F("shop.stock", "{left}/{stock}", {
                left = math.max(0, v370),
                stock = v374
            })
        end

        local Limited = card:FindFirstChild("Limited")

        if Limited then
            Limited.AutoLocalize = false
            Limited.Text = v375 and Loc.T("LAST CHANCE!") or Loc.T("LIMITED!")
        end

        local onlyLeft = t6.onlyLeft

        if not v369 or not v370 then
            v370 = 0
        end

        onlyLeft(card, v370, false)

        local Timer = card:FindFirstChild("Timer")

        if Timer then
            Timer.AutoLocalize = false

            local v376 = if v369 then "ENDS IN " else "LEAVES IN "
            local v379 = math.max(0, (math.floor(v368 - workspace:GetServerTimeNow())))
            local v380 = v379 // 86400
            local v381 = v379 % 86400 // 3600
            local v382 = v379 % 3600 // 60

            Timer.Text = v376 .. (v380 > 0 and ("%dd %02dh"):format(v380, v381) or ("%02d:%02d:%02d"):format(v381, v382, v379 % 60))

            local StockBox = card:FindFirstChild("StockBox")
            local v383, v384

            if v369 then
                local timerAt = p110.timerAt

                if timerAt then
                    v383 = timerAt
                    v384 = true
                else
                    v384 = false
                end
            elseif StockBox then
                v384 = false
            else
                local timerAt = p110.timerAt

                if timerAt then
                    v383 = timerAt
                    v384 = true
                else
                    v384 = false
                end
            end

            Timer.Position = if not v384 then StockBox.Position else v383
        end

        local Earns = card:FindFirstChild("Earns")
        local EarnsLabel = card:FindFirstChild("EarnsLabel")

        if Earns and EarnsLabel and BoostFish.COPY[row.fish] then
            Earns.AutoLocalize = false
            EarnsLabel.AutoLocalize = false
            EarnsLabel.Text = Loc.T("EARNS")
            Earns.Text = Loc.F("wraith.earns", "{n}x YOUR BEST FISH", {
                n = BoostFish.COPY[row.fish]
            })
        elseif Earns and EarnsLabel and BoostFish.ROWS[row.fish] and row.stage then
            Earns.AutoLocalize = false
            EarnsLabel.AutoLocalize = false
            EarnsLabel.Text = Loc.T("EARNS")
            Earns.Text = Loc.F("hydra.boost", "{pct} MONEY", {
                pct = "+" .. BoostFish.At(row.fish, row.stage) .. "%"
            })
        elseif Earns and EarnsLabel and row.rate and not card:FindFirstChild("Boost") then
            Earns.AutoLocalize = false
            EarnsLabel.AutoLocalize = false
            EarnsLabel.Text = Loc.T("EARNS") .. " (" .. Format.money(row.rate * 2 ^ (v359 - row.stage)) .. "/s FULLY GROWN)"
            Earns.Text = Format.money(row.rate) .. "/s"
        end

        if row.rate and card:FindFirstChild("Boost") and card:FindFirstChild("FullGrown") then
            local Boost, FullGrown = card.Boost, card.FullGrown

            Boost.AutoLocalize = false
            FullGrown.AutoLocalize = false
            card.Boost.Text = Format.money(row.rate) .. "/s"
            card.FullGrown.Text = Loc.F("devil.fullgrown", "({rate} when fully grown)", {
                rate = Format.money(row.rate * 2 ^ (v359 - row.stage)) .. "/s"
            })
        end

        local BestRate = card:FindFirstChild("BestRate")

        if BestRate then
            BestRate.Text = Format.money(tonumber(LocalPlayer:GetAttribute("CopyRate")) or 0) .. "/s"
        end

        local v385 = BoostFish.EAT and BoostFish.EAT[row.fish]

        if v385 and row.rate and card:FindFirstChild("Rate") and card:FindFirstChild("EatRate") and card:FindFirstChild("FullGrown") then
            local v386 = row.rate * 2 ^ (v359 - row.stage)
            local Rate, EatRate, FullGrown = card.Rate, card.EatRate, card.FullGrown

            Rate.AutoLocalize = false
            EatRate.AutoLocalize = false
            FullGrown.AutoLocalize = false
            card.Rate.Text = Format.money(row.rate) .. "/s"
            card.EatRate.Text = "(" .. Format.money(row.rate * v385) .. "/s while eating)"
            card.FullGrown.Text = ("FULLY GROWN: <font color=\"#7CFF5B\">%s/s</font> (<font color=\"#FFD23F\">%s/s</font> WHILE EATING)"):format(Format.money(v386), Format.money(v386 * v385))
        end

        local Buy = card:FindFirstChild("Buy")

        if not Buy then
            return
        end

        local Price = Buy.Price

        if v371 then
            Price.Text = "SOLD OUT"
        else
            local v387, v388 = ShopConfig.ProductNow(row)
            local v390 = math.floor(if v387 == row.plainProduct then t68[row] or v388 else t14[row] or row.price)

            Price.Text = v1 .. " " .. tostring(v390):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        Buy.ImageTransparency = v371 and t2.CLAIMED_FADE or 0

        local Icon = Buy:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v371 and t2.CLAIMED_FADE or 0
        end
    end

    local function dressAll() -- line: 2081
        -- upvalues: t67 (copy), dress2 (copy)
        for _, v391 in ipairs(t67) do
            if v391.card.Visible then
                dress2(v391)
            end
        end
    end

    task.spawn(function() -- line: 2082
        -- upvalues: MarketplaceService (copy), t67 (copy), t68 (copy), dressAll (copy)
        for _, v392 in ipairs(t67) do
            if v392.row.plainProduct then
                local GetProductInfo = MarketplaceService.GetProductInfo
                local plainProduct = v392.row.plainProduct
                local Product = Enum.InfoType.Product
                local ok, result = pcall(GetProductInfo, MarketplaceService, plainProduct, Product)

                if ok and result and type(result.PriceInRobux) == "number" then
                    t68[v392.row] = result.PriceInRobux
                end
            end
        end

        dressAll()
    end)
    LocalPlayer:GetAttributeChangedSignal("CopyRate"):Connect(dressAll)

    local function height(p111) -- line: 2093
        -- upvalues: t46 (copy), Fish (copy)
        if p111:GetAttribute("HW") then
            return p111:GetAttribute("HW")
        end

        local UIAspectRatioConstraint = p111:FindFirstChildOfClass("UIAspectRatioConstraint")

        return UIAspectRatioConstraint and p111.Size.X.Scale / UIAspectRatioConstraint.AspectRatio or p111.Size.Y.Scale * t46[Fish].H
    end

    local Icon2 = TopTabs:WaitForChild("Fish"):WaitForChild("Icon")
    local Size2 = Icon2.Size

    v8 = {
        OUT = 0.12,
        IN = 0.38,
        TWIST = 25
    }

    do
        local v393 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local v394 = TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local t69 = {}
        local n8 = 0

        local function swapTabIcon() -- line: 2108
            -- upvalues: TweenService (ref), Icon2 (copy), Size2 (copy), v393 (copy), v394 (copy), t69 (ref), n8 (ref)
            if #t69 == 0 then
                return
            end

            local v395 = n8

            n8 = v395 % #t69 + 1

            local t70 = t69
            local v396 = t70[n8]
            local v397 = TweenService:Create(Icon2, v393, {
                Size = UDim2.fromScale(0, 0)
            })

            v397.Completed:Once(function() -- line: 2113
                -- upvalues: v396 (copy), TweenService (ref), Icon2 (copy), Size2 (copy), v394 (copy)
                Icon2.Image = v396
                TweenService:Create(Icon2, v394, {
                    Size = Size2
                }):Play()

                if Icon2.Rotation == 0 then
                    Icon2.Rotation = -25
                    TweenService:Create(Icon2, v394, {
                        Rotation = 0
                    }):Play()
                end
            end)
            v397:Play()
        end

        local v398 = false

        local function stack() -- line: 2124
            -- upvalues: ShopConfig (ref), Scale (ref), t46 (copy), Fish (copy), t66 (copy), t67 (copy), dressAll (copy), height (copy), t69 (ref), v398 (ref)
            local v399 = ShopConfig.Week()

            if v398 ~= false and v398 == v399 then
                return
            end

            v398 = v399

            local t71 = {}
            local t72 = {}

            for _, v400 in ipairs(t67) do
                local v401 = ShopConfig.Phase(v400.row)

                v400.card.Visible = v401 ~= nil

                if v401 == "serial" then
                    table.insert(t71, 1, v400)
                elseif v401 == "pool" then
                    t72[#t72 + 1] = v400
                end
            end

            local v402 = v399 and ShopConfig.RegularOf(v399) or {}

            table.sort(t72, function(p112, p113) -- line: 2136
                -- upvalues: v402 (copy)
                return (table.find(v402, p112.row.key) or 0) < (table.find(v402, p113.row.key) or 0)
            end)
            t69 = {}

            for _, v403 in ipairs({ t71, t72 }) do
                for _, v404 in ipairs(v403) do
                    if v404.row.image then
                        local t73 = t69

                        t73[#t69 + 1] = v404.row.image
                    end
                end
            end

            task.spawn(pcall, function() -- line: 2144
                -- upvalues: t69 (ref)
                game:GetService("ContentProvider"):PreloadAsync(t69)
            end)

            local t75 = {}
            local n9 = 0.03

            for _, v405 in pairs(t66) do
                v405.Visible = false
            end

            if #t71 > 0 then
                local serial, sub = t66.serial, t66.sub

                serial.Visible = true
                sub.Visible = true

                local serial2 = t66.serial
                local v406 = height(serial2)

                t75[#t75 + 1] = { serial2, n9, v406 }
                n9 += v406 + 0.022
                n9 -= 0.015399999999999999

                local sub2 = t66.sub
                local v407 = height(sub2)

                t75[#t75 + 1] = { sub2, n9, v407 }
                n9 += v407 + 0.022

                for _, v408 in ipairs(t71) do
                    local card = v408.card
                    local v409 = height(card)

                    t75[#t75 + 1] = { card, n9, v409 }
                    n9 += v409 + 0.022
                end
            end

            if #t72 > 0 then
                t66.regular.Visible = true

                local regular = t66.regular
                local v410 = height(regular)

                t75[#t75 + 1] = { regular, n9, v410 }
                n9 += v410 + 0.022

                for _, v411 in ipairs(t72) do
                    local card = v411.card
                    local v412 = height(card)

                    t75[#t75 + 1] = { card, n9, v412 }
                    n9 += v412 + 0.022
                end
            end

            local v413 = t46[Fish]
            local v415 = math.max(n9 - 0.022 + 0.03, v413.win)

            for _, v416 in ipairs(t75) do
                local v417 = v416[1]
                local v418 = v416[2]
                local v419 = v416[3]

                v417.Position = UDim2.fromScale(v417.Position.X.Scale, (v418 + v417.AnchorPoint.Y * v419) / v415)
                v417.Size = UDim2.fromScale(v417.Size.X.Scale, v419 / v415)
            end

            v413.NH = v415

            local Scale2 = Scale.Scale

            if not (Scale2 < 0.05) then
                Fish.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(t46[Fish].NH * Fish.AbsoluteSize.X / Scale2)))
            end

            dressAll()
        end

        local v421 = false

        local function run() -- line: 2176
            -- upvalues: Panel (ref), dressAll (copy), swapTabIcon (copy), stack (copy), v421 (ref)
            if not v421 then
                v421 = true
                task.spawn(function() -- line: 2179
                    -- upvalues: Panel (ref), dressAll (copy), swapTabIcon (copy), stack (copy), v421 (ref)
                    local n10 = 0

                    while Panel.Visible do
                        stack()
                        dressAll()

                        if n10 % 3 == 0 then
                            swapTabIcon()
                        end

                        n10 += 1
                        task.wait(1)
                    end

                    v421 = false
                end)
            end
        end

        Panel:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 2191
            -- upvalues: Panel (ref), dressAll (copy), swapTabIcon (copy), stack (copy), v421 (ref)
            if Panel.Visible then
                if v421 then
                    return
                end

                v421 = true
                task.spawn(function() -- line: 2179
                    -- upvalues: Panel (ref), dressAll (copy), swapTabIcon (copy), stack (copy), v421 (ref)
                    local n11 = 0

                    while Panel.Visible do
                        stack()
                        dressAll()

                        if n11 % 3 == 0 then
                            swapTabIcon()
                        end

                        n11 += 1
                        task.wait(1)
                    end

                    v421 = false
                end)
            end
        end)
        workspace:GetAttributeChangedSignal("ShopWeekShift"):Connect(function() -- line: 2192
            -- upvalues: v398 (ref), stack (copy)
            v398 = false
            stack()
        end)

        for _, v422 in ipairs(t67) do
            workspace:GetAttributeChangedSignal(ShopConfig.LimitedAttr(v422.row.key)):Connect(function() -- line: 2194
                -- upvalues: dress2 (copy), v422 (copy)
                if v422.card.Visible then
                    dress2(v422)
                end
            end)
        end

        Loc.Changed:Connect(dressAll)
        table.insert(t15, dressAll)
        stack()
    end

    do
        local t76 = {
            soldout = "SOLD OUT!",
            ended = "This fish has left the shop!",
            busy = "Try again in a moment!"
        }

        for _, v423 in ipairs(t67) do
            local row = v423.row
            local Buy = v423.card:FindFirstChild("Buy")

            if Buy then
                local v424 = false

                ButtonHover.Attach(Buy, (hoverOf(Buy)))
                t16.on(v423.card, Buy, function() -- line: 2205
                    -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), LimitedAsk4 (copy), t76 (copy), row (copy), Buy (copy), v424 (ref)
                    ButtonHover.Press(Buy)

                    if v424 then
                        return
                    end

                    local v425 = ShopConfig.Phase(row)

                    if not v425 or v425 == "serial" and (workspace:GetAttribute(ShopConfig.LimitedAttr(row.key)) or ShopConfig.Capacity(row)) <= 0 then
                        deny(Buy)
                    elseif t4.gifting then
                        giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, row), (ShopConfig.ProductNow(row)))
                    else
                        v424 = true

                        local InvokeServer = LimitedAsk4.InvokeServer
                        local key = row.key
                        local ok, result = pcall(InvokeServer, LimitedAsk4, key)

                        v424 = false

                        if not ok or result ~= "ok" then
                            deny(Buy)

                            local Show = Toast.Show

                            if not ok or not result then
                                result = "busy"
                            end

                            Show(t76[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                        else
                            PurchaseFX.Buy((ShopConfig.ProductNow(row)))
                        end
                    end
                end)
                t4.square(Buy, function() -- line: 2219
                    -- upvalues: ShopConfig (ref), row (copy)
                    return "Limited", table.find(ShopConfig.LIMITED, row), (ShopConfig.ProductNow(row))
                end)
            end
        end
    end

    HellEggPanel = require(Modules:WaitForChild("BaitConfig"))

    local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
    local Format2 = require(Modules:WaitForChild("Format"))
    local RunService = game:GetService("RunService")

    money = {
        LOCK = 8,
        FRICTION = 2.6,
        STILL = 0.08,
        MAX = 30,
        STOP = 15,
        SMOOTH = 0.45
    }
    RarityDisplay = {
        W = 0.7,
        H = 0.88,
        GAP = 0.08
    }

    local t77 = {}

    for _, v426 in ipairs({
            HellEggPanel.ALWAYS,
            HellEggPanel.POOL,
            HellEggPanel.UNKNOWN
        }) do
        for _, v427 in ipairs(v426) do
            t77[v427.id] = v427
        end
    end

    local function dressTile(p114, p115, p116) -- line: 2247
        -- upvalues: ShopConfig (ref), FishDisplay (copy), Format2 (copy), t77 (copy)
        local v428 = t77[p115]
        local v429 = v428 and FishDisplay[v428.catches]

        p114.Icon.Image = v429 and v429.icon or ""

        local Rate, Count = p114.Rate, p114.Count

        Rate.AutoLocalize = false
        Count.AutoLocalize = false
        p114.Rate.Text = Format2.money(ShopConfig.BAIT_BUNDLE_RATES[p115] or 0) .. "+/s"
        p114.Count.Text = "x" .. p116
        p114.Count.Visible = p116 > 1

        local FishName = p114:FindFirstChild("FishName")

        if not FishName then
            return
        end

        FishName.AutoLocalize = false
        FishName.Text = v429 and v429.display or ""
    end

    t6.baitBundles = {}

    local t78 = {}
    local v430

    for _, v431 in ipairs(ShopConfig.BAIT_BUNDLES) do
        v9 = t1:WaitForChild(v431.card)
        t6.baitBundles[#t6.baitBundles + 1] = v9

        local Buy = v9:WaitForChild("Buy")
        local Off = v9:WaitForChild("Off")

        Tiles = v9:FindFirstChild("Tag")

        if Tiles then
            Tiles.AutoLocalize = false
        end

        Off.AutoLocalize = false

        local function dress() -- line: 2271
            -- upvalues: ShopConfig (ref), Loc (ref), v1 (ref), t14 (ref), v431 (copy), Buy (copy), Off (copy)
            local v432 = t14[v431] or v431.price
            local Price = Buy.Price
            local v433 = math.floor(v432)

            Price.Text = v1 .. " " .. tostring(v433):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

            local v434 = ShopConfig.OffOf(v431, v432)

            Off.Visible = v434 > 0
            Off.Text = Loc.F("shop.off", "{n}% Off", {
                n = v434
            })
            Off.Position = UDim2.fromScale(Buy.Position.X.Scale, Buy.Position.Y.Scale + Buy.Size.Y.Scale / 2 + 0.015)
        end

        dress()
        table.insert(t15, dress)
        ButtonHover.Attach(Buy, (hoverOf(Buy)))
        v8 = Buy.Activated
        v8:Connect(function() -- line: 2285
            -- upvalues: ButtonHover (ref), PurchaseFX (ref), t4 (ref), deny (ref), v431 (copy), Buy (copy)
            ButtonHover.Press(Buy)

            if t4.gifting then
                deny(Buy)
            else
                PurchaseFX.Buy(v431.product)
            end
        end)
        v8 = t4.square
        v8(Buy, function() -- line: 2291
            -- upvalues: ShopConfig (ref), v431 (copy)
            return "BaitBundle", table.find(ShopConfig.BAIT_BUNDLES, v431), v431.product
        end)
        Tiles = v9:FindFirstChild("Tiles")

        if Tiles then
            for v435, v436 in ipairs(v431.baits) do
                v430 = Tiles.Template:Clone()
                v430.Name = "T" .. v435
                v430.LayoutOrder = v435
                v430.Visible = true
                dressTile(v430, v436[1], v436[2])
                v430.Parent = Tiles
            end
        else
            local Strip = v9:WaitForChild("Strip")

            v10 = #v431.baits

            for i = 0, 1 do
                for v437, v438 in ipairs(v431.baits) do
                    Visible2 = Strip.Template:Clone()
                    on2 = "T" .. i * v10 + v437

                    local v439 = i * v10 + v437

                    Visible2.Name = on2
                    Visible2.LayoutOrder = v439
                    Visible2.Visible = true
                    dressTile(Visible2, v438[1], v438[2])
                    Visible2.Parent = Strip
                end
            end

            Visible = v10 * 2 * 0.7799999999999999 + 0.08

            local AspectRatio = v9:WaitForChild("UIAspectRatioConstraint").AspectRatio

            Strip.CanvasSize = UDim2.fromScale(Visible * Strip.Size.Y.Scale / AspectRatio, Strip.Size.Y.Scale)
            Strip.UIListLayout.Padding = UDim.new(0.08 / Visible, 0)
            Strip.UIPadding.PaddingLeft = UDim.new(0.08 / Visible, 0)

            for _, child in ipairs(Strip:GetChildren()) do
                if child:IsA("Frame") and child ~= Strip.Template then
                    child.Size = UDim2.fromScale(0.7 / Visible, 0.88)
                end
            end

            local t79 = {
                set = nil,
                heldUntil = 0,
                x = 0,
                strip = Strip,
                card = v9,
                half = v10 * 0.7799999999999999 / Visible
            }

            t78[#t78 + 1] = t79

            local UserInputService = game:GetService("UserInputService")

            Strip.ScrollingEnabled = false
            Strip:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 2332
                -- upvalues: Strip (copy), t79 (copy)
                if t79.set and math.abs(Strip.CanvasPosition.X - t79.set) > 1 then
                    t79.heldUntil = os.clock() + 3.5
                end
            end)
            Strip.InputBegan:Connect(function(p117) -- line: 2335
                -- upvalues: Strip (copy), t79 (copy)
                local UserInputType = p117.UserInputType

                if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                t79.heldUntil = os.clock() + 3.5
                t79.vel = 0
                t79.drag = {
                    vel = 0,
                    axis = nil,
                    input = p117,
                    touch = UserInputType == Enum.UserInputType.Touch,
                    from = p117.Position,
                    at = Strip.CanvasPosition.X,
                    lastX = p117.Position.X,
                    lastT = os.clock()
                }
            end)
            UserInputService.InputChanged:Connect(function(p118) -- line: 2343
                -- upvalues: Strip (copy), t79 (copy)
                local drag = t79.drag

                if not drag then
                    return
                end

                local touch = drag.touch
                local v441, v442

                if touch then
                    v441 = p118 == drag.input
                else
                    v442 = p118.UserInputType == Enum.UserInputType.MouseMovement
                end

                if not (touch and v441 or not touch and v442) then
                    return
                end

                local v443 = p118.Position.X - drag.from.X
                local v444 = p118.Position.Y - drag.from.Y

                if not drag.axis then
                    if math.abs(v443) < 8 and math.abs(v444) < 8 then
                        return
                    end

                    drag.axis = math.abs(v443) >= math.abs(v444) and "x" or "y"
                end

                if drag.axis == "x" then
                    t79.heldUntil = os.clock() + 3.5

                    local v445 = Strip.AbsoluteCanvasSize.X * t79.half

                    if not (v445 <= 0) then
                        local elapsed = os.clock()
                        local v446 = elapsed - drag.lastT

                        if v446 > 0 then
                            drag.vel = drag.vel * 0.55 + -(p118.Position.X - drag.lastX) / v446 * 0.45
                        end

                        drag.lastX = p118.Position.X
                        drag.lastT = elapsed

                        local v447 = (drag.at - v443) % v445

                        t79.set = v447
                        Strip.CanvasPosition = Vector2.new(v447, 0)
                    end
                end
            end)
            UserInputService.InputEnded:Connect(function(p119) -- line: 2370
                -- upvalues: Strip (copy), t79 (copy)
                local drag = t79.drag

                if drag and (not drag.touch or p119 == drag.input) and (drag.touch or p119.UserInputType == Enum.UserInputType.MouseButton1) then
                    t79.drag = nil

                    if drag.axis == "x" and not (os.clock() - drag.lastT > 0.08) then
                        local v448 = Strip.AbsoluteWindowSize.Y * 30

                        t79.vel = math.clamp(drag.vel, -v448, v448)
                        t79.heldUntil = os.clock() + 3.5
                    end
                end
            end)
        end
    end

    do
        local function step(p120) -- line: 2383
            -- upvalues: v2 (ref), t78 (copy)
            if not v2 then
                return
            end

            for _, v450 in ipairs(t78) do
                local strip, card = v450.strip, v450.card

                if (v450.vel or 0) == 0 or v450.drag then
                    if card.Visible and card.Parent.Visible and os.clock() >= v450.heldUntil then
                        local v451 = strip.AbsoluteCanvasSize.X * v450.half

                        if v451 > 0 then
                            local v452 = strip.CanvasPosition.X + strip.AbsoluteWindowSize.Y * 0.7799999999999999 * 0.45 * p120

                            if v451 <= v452 then
                                v452 -= v451
                            end

                            v450.set = v452
                            strip.CanvasPosition = Vector2.new(v452, 0)
                        end
                    end
                else
                    local v453 = strip.AbsoluteCanvasSize.X * v450.half

                    if v453 > 0 and card.Visible and card.Parent.Visible then
                        local v454 = (strip.CanvasPosition.X + v450.vel * p120) % v453

                        v450.set = v454
                        strip.CanvasPosition = Vector2.new(v454, 0)
                        v450.vel = v450.vel * math.exp(-2.6 * p120)

                        if math.abs(v450.vel) < 15 then
                            v450.vel = 0
                        end
                    else
                        v450.vel = 0
                    end

                    v450.heldUntil = os.clock() + 3.5
                end
            end
        end

        local connection

        local function watchOpen() -- line: 2415
            -- upvalues: Panel (ref), RunService (copy), t78 (copy), step (copy), connection (ref)
            if Panel.Visible and not connection then
                connection = RunService.Heartbeat:Connect(step)

                return
            end

            if not Panel.Visible and connection then
                connection:Disconnect()
                connection = nil

                for _, v456 in ipairs(t78) do
                    v456.vel = 0
                    v456.drag = nil
                end
            end
        end

        Panel:GetPropertyChangedSignal("Visible"):Connect(watchOpen)
        watchOpen()
    end

    BonePack = t1:WaitForChild("BonePack")
    t6.bonePack = BonePack
    Buy = BonePack:WaitForChild("Buy")

    local Title = BonePack:WaitForChild("Title")
    local Rewards3 = BonePack:WaitForChild("Rewards")
    local t80 = {
        Rewards3:WaitForChild("Fish"),
        Rewards3:WaitForChild("Harpoon"),
        Rewards3:WaitForChild("XP")
    }
    local FishDisplay2 = require(Modules:WaitForChild("FishDisplay"))
    local HarpoonSkins = require(Modules:WaitForChild("HarpoonSkins"))
    local Format3 = require(Modules:WaitForChild("Format"))

    Title.AutoLocalize = false

    for _, v457 in ipairs(t80) do
        v9 = v457.Label
        on3 = v457.Amount
        v9.AutoLocalize = false
        on3.AutoLocalize = false
    end

    local Image = t80[3].Icon.Image
    local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
    local RarityDisplay2 = require(Modules:WaitForChild("RarityDisplay"))

    local function seq(p121, p122) -- line: 2460
        return ColorSequence.new(p121, p122)
    end

    local t81 = {
        money = {
            seq(Color3.fromRGB(0, 225, 0), Color3.fromRGB(0, 206, 7)),
            Color3.new(0, 0, 0)
        },
        xp = {
            seq(Color3.fromRGB(150, 245, 255), Color3.fromRGB(40, 175, 255)),
            Color3.fromRGB(0, 40, 80)
        },
        gold = {
            seq(Color3.fromRGB(255, 240, 120), Color3.fromRGB(255, 175, 20)),
            Color3.fromRGB(90, 45, 0)
        },
        plain = {
            seq(Color3.new(1, 1, 1), Color3.fromRGB(235, 215, 255)),
            Color3.fromRGB(40, 8, 70)
        },
        shadow = {
            seq(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
            Color3.fromRGB(170, 110, 230),
            require(Modules:WaitForChild("MutationDisplay")).Shadow.textColor
        }
    }

    v9 = {
        ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
            ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 180, 50)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 240, 80)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(80, 230, 110)),
            ColorSequenceKeypoint.new(0.8, Color3.fromRGB(70, 160, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 90, 255))
        }),
        Color3.fromRGB(45, 20, 90),
        rot = 0
    }
    t81.rainbow = v9

    local function paint(p123, p124) -- line: 2478
        -- upvalues: RarityStyle (copy), RarityDisplay2 (copy), t81 (copy)
        local v458 = RarityDisplay2[p124]
        local Grad = p123:FindFirstChild("Grad")

        if v458 and v458.color then
            if Grad then
                Grad.Rotation = 0
            end

            RarityStyle.Apply(p123, v458.color)
        else
            local v459 = t81[p124] or t81.plain

            RarityStyle.Track(p123, nil)
            p123.TextColor3 = v459[3] or Color3.new(1, 1, 1)

            if Grad then
                local v460 = v459[1]
                local v461 = v459.rot or 90

                Grad.Color = v460
                Grad.Rotation = v461
            end

            local UIStroke = p123:FindFirstChildOfClass("UIStroke")

            if UIStroke then
                UIStroke.Color = v459[2]
            end
        end
    end

    local function setCol(p125, p126, p127, p128, p129, p130) -- line: 2494
        -- upvalues: paint (copy)
        local zero, zero2 = Vector2.zero, Vector2.zero
        local v462 = p128

        if type(p128) == "table" then
            v462 = p128[1]
            zero = Vector2.new(p128[2], p128[3])
            zero2 = Vector2.new(p128[4], p128[5])
        end

        p125.Label.Text = p126
        paint(p125.Label, p127)

        local Icon, Icon2, Icon3 = p125.Icon, p125.Icon, p125.Icon

        Icon.Image = v462 or ""
        Icon2.ImageRectOffset = zero
        Icon3.ImageRectSize = zero2
        p125.Amount.Text = p129
        paint(p125.Amount, p130)
    end

    local function rung() -- line: 2503
        -- upvalues: ShopConfig (ref), t4 (ref)
        return ShopConfig.BonePackNext(t4.who:GetAttribute("BonePackBought") or 0)
    end

    local ScytheFace = BonePack:WaitForChild("ScytheFace")
    local View = ScytheFace:WaitForChild("View")
    local Off2 = BonePack:WaitForChild("Off")

    Off2.AutoLocalize = false

    local BuyPosition = Buy.Position
    local v463 = UDim2.fromScale(0.85, 0.6)
    local Position = BonePack:WaitForChild("Timer").Position
    local v464 = UDim2.fromScale(ScytheFace:WaitForChild("Perk2").Position.X.Scale, 0.86)

    v430 = {
        TILT = 45,
        TURN = 0,
        MARGIN = 1.03,
        FOV = 8,
        SHEET = "rbxassetid://75441659511954",
        Z = 10
    }

    local function scythe() -- line: 2528
        -- upvalues: ShopConfig (ref), t4 (ref)
        local v465 = ShopConfig.BonePackNext(t4.who:GetAttribute("BonePackBought") or 0)

        return v465 ~= nil and v465.fish == nil, v465
    end

    local v466 = nil

    local function build(p131) -- line: 2534
        -- upvalues: ReplicatedStorage (copy), View (copy)
        if View:FindFirstChildOfClass("Model") then
            return
        end

        local Harpoons = ReplicatedStorage:FindFirstChild("Harpoons")
        local v467 = Harpoons and Harpoons:FindFirstChild(p131.harpoon)

        if not v467 then
            return
        end

        local clone = v467:Clone()

        clone:PivotTo(CFrame.Angles(0, 0, -0.7853981633974483) * CFrame.Angles(0, 0, 0))

        local BoundingBox, BoundingBox2 = clone:GetBoundingBox()

        clone.Parent = View

        local Camera = Instance.new("Camera")

        Camera.FieldOfView = 8
        Camera.Parent = View
        View.CurrentCamera = Camera

        local v468 = math.max(BoundingBox2.X, BoundingBox2.Y) / 2 * 1.03

        Camera.CFrame = CFrame.lookAt(BoundingBox.Position + Vector3.new(0, 0, v468 / 0.06992681194351041 + BoundingBox2.Z / 2), BoundingBox.Position)
    end

    local function bolts() -- line: 2553
        -- upvalues: v2 (ref), t6 (ref), v4 (ref), BonePack (ref), ScytheFace (copy), View (copy), v466 (ref)
        if v2 and v466 ~= v4 then
            v466 = v4

            local v471 = v4

            t6.Zap.Run(BonePack, View, nil, function() -- line: 2557
                -- upvalues: v471 (copy), v4 (ref)
                return v471 == v4
            end, {
                sheet = "rbxassetid://75441659511954",
                z = 10,
                shown = function() -- shown | line: 2558
                    -- upvalues: BonePack (ref), ScytheFace (copy)
                    return ScytheFace.Visible and BonePack.Visible and BonePack.Parent.Visible
                end
            })
        end
    end

    function t6.bonePackLoop() -- line: 2561
        -- upvalues: ShopConfig (ref), t4 (ref), build (copy), bolts (copy)
        local v472 = ShopConfig.BonePackNext(t4.who:GetAttribute("BonePackBought") or 0)

        if v472 ~= nil and v472.fish == nil then
            build(v472)
            bolts()
        end
    end

    local Timer = BonePack:WaitForChild("Timer")

    Timer.AutoLocalize = false

    local n12 = 0

    local function tick() -- line: 2575
        -- upvalues: Loc (ref), t4 (ref), Timer (copy)
        local BonePackEnds = t4.who:GetAttribute("BonePackEnds")
        local v475 = math.max(0, (math.floor((BonePackEnds or 0) - workspace:GetServerTimeNow())))

        Timer.Visible = BonePackEnds ~= nil
        Timer.Text = Loc.F("shop.leaves", "LEAVES IN {time}", {
            time = ("%02d:%02d:%02d"):format(v475 // 3600, v475 % 3600 // 60, v475 % 60)
        })
    end

    local v476

    v476 = function() -- line: 2582
        -- upvalues: v476 (ref), ShopConfig (ref), Loc (ref), v1 (ref), t4 (ref), setHidden (ref), t14 (ref), BonePack (ref), Buy (ref), Title (copy), Rewards3 (copy), t80 (copy), FishDisplay2 (copy), HarpoonSkins (copy), Format3 (copy), Image (copy), setCol (copy), ScytheFace (copy), Off2 (copy), BuyPosition (copy), v463 (copy), Position (copy), v464 (copy), build (copy), bolts (copy), n12 (ref), tick (copy)
        local v477, v478 = ShopConfig.BonePackNext(t4.who:GetAttribute("BonePackBought") or 0)
        local BonePackEnds = t4.who:GetAttribute("BonePackEnds")
        local v479 = ShopConfig.HydraExpired(BonePackEnds, workspace:GetServerTimeNow())
        local v480 = v477 == nil or v479
        local t82 = {
            [BonePack] = v480
        }

        setHidden(t82)

        if not v477 or v479 then
            return
        else
            tick()
            n12 += 1

            if type(BonePackEnds) == "number" then
                local v482 = n12

                task.delay(BonePackEnds - workspace:GetServerTimeNow() + 0.1, function() -- line: 2592
                    -- upvalues: v482 (copy), v476 (ref), n12 (ref)
                    if v482 == n12 then
                        v476()
                    end
                end)
            end
        end

        local v483 = v477.fish == nil

        ScytheFace.Visible = v483
        Title.Visible = not v483
        Rewards3.Visible = not v483

        local v484 = v483 and v463 or BuyPosition

        Buy.Position = v484
        BonePack.Timer.Position = v483 and v464 or Position

        if v483 then
            build(v477)
            bolts()
        end

        local v485 = ShopConfig.BONE_PACK[1]
        local v486 = FishDisplay2[v485.fish]
        local v487 = HarpoonSkins.Get(v477.harpoon)
        local name

        if v478 == 1 then
            name = "Bone Starter Pack"
        elseif v478 == 2 then
            name = "Bone Starter Pack 2"
        else
            if v487 then
                name = v487.name
            end

            if not v487 or not name then
                name = ""
            end
        end

        Title.Text = name

        if v477.fish then
            local v488 = t80[1]
            local v489, v490

            if v477.mutation then
                local v491 = string.upper(v477.mutation)

                if v491 then
                    v489 = v491
                    v490 = true
                elseif v486 then
                    local display = v486.display

                    if display then
                        v489 = display
                        v490 = true
                    else
                        v490 = false
                    end
                else
                    v490 = false
                end
            elseif v486 then
                local display = v486.display

                if display then
                    v489 = display
                    v490 = true
                else
                    v490 = false
                end
            else
                v490 = false
            end

            if not v490 then
                v489 = ""
            end

            setCol(v488, v489, v477.mutation and string.lower(v477.mutation) or v486 and v486.rarity, v477.image or v486 and v486.icon, Format3.money(v485.rate * (v477.mult or 1)) .. "/s", v477.mutation and string.lower(v477.mutation) or "money")

            local v496 = t80[2]
            local name = if v487 then v487.name else nil

            if not v487 or not name then
                name = ""
            end

            local v497 = v487 and v487.rarity
            local v498 = v487 and v487.icon
            local v499 = if v487 then string.upper(v487.rarity) .. " HARPOON" else nil

            if not v487 or not v499 then
                v499 = ""
            end

            setCol(v496, name, v497, v498, v499, v487 and v487.rarity)
            setCol(t80[3], "XP", "xp", Image, "+" .. tostring((math.floor(v477.xp or 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""), "xp")
        else
            local v503 = v477.perks or {}
            local ExclusiveTag = ScytheFace.ExclusiveTag
            local v504 = if v487 then string.upper(v487.rarity) .. " HARPOON" else nil

            ExclusiveTag.Text = if not v487 or not v504 then "" else v504

            local Heading = ScytheFace.Heading
            local name = if v487 then v487.name else nil

            Heading.Text = if not v487 or not name then "" else name
            ScytheFace.HeadingShadow.Text = ScytheFace.Heading.Text

            local Perk1 = ScytheFace.Perk1
            local v505, v506

            if v503.life and v503.life > 0 then
                local v508 = math.floor(v503.life * 100 + 0.5) .. "% EXTRA LIFE CHANCE"

                if v508 then
                    v505 = v508
                    v506 = true
                else
                    v506 = false
                end
            else
                v506 = false
            end

            if not v506 then
                local v509 = false

                if v503.hits and v503.hits > 0 then
                    local v510 = "-" .. v503.hits .. (if v503.hits == 1 then " HIT" else " HITS")

                    if v510 then
                        v505 = v510
                        v509 = true
                    end
                end

                if not v509 then
                    v505 = math.floor((1 - (v503.reel or 1)) * 100 + 0.5) .. "% SLOWER MINIGAME"
                end
            end

            Perk1.Text = v505
            ScytheFace.Perk2.Text = "+" .. math.floor(((v503.luck or 1) - 1) * 100 + 0.5) .. "% MUTATION CHANCE"
            ScytheFace.XP.Text = "+" .. string.upper(Format3.short(v477.xp or 0)) .. " XP"
            ScytheFace.XP.Visible = v477.xp ~= nil
            ScytheFace.XPIcon.Visible = ScytheFace.XP.Visible
        end

        local Price = Buy.Price
        local v514 = math.floor(t14[v477] or v477.price)

        Price.Text = v1 .. " " .. tostring(v514):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

        local v515 = ShopConfig.OffOf(v477, t14[v477] or v477.price)

        Off2.Visible = v515 > 0
        Off2.Text = Loc.F("shop.off", "{n}% Off", {
            n = v515
        })
        Off2.Position = UDim2.fromScale(Buy.Position.X.Scale + Buy.Size.X.Scale / 2 - 0.005, Buy.Position.Y.Scale - Buy.Size.Y.Scale / 2 + 0.046)
    end

    watch({ "BonePackBought", "BonePackEnds" }, v476)
    table.insert(t15, v476)
    v476()
    task.spawn(function() -- line: 2645
        -- upvalues: Panel (ref), t12 (ref), BonePack (ref), tick (copy)
        while true do
            if Panel.Visible and not t12[BonePack] then
                tick()
            end

            task.wait(1)
        end
    end)
end

ButtonHover.Attach(Buy, (hoverOf(Buy)))
t16.on(BonePack, Buy, function() -- line: 2652
    -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), t4 (ref), deny (ref), giftAsk (ref), Buy (ref)
    ButtonHover.Press(Buy)

    local v516, v517 = ShopConfig.BonePackNext(t4.who:GetAttribute("BonePackBought") or 0)

    if not v516 or v516.product == 0 then
        deny(Buy)
    elseif t4.gifting then
        giftAsk(Buy, "BonePack", v517, v516.product)
    else
        PurchaseFX.Buy(v516.product)
    end
end)

local OWNER = ShopConfig.OWNER
local v518 = t1:WaitForChild(OWNER.card)

t6.owner = v518

local Buy2 = v518:WaitForChild("Buy")
local Stock = v518:WaitForChild("Stock")
local Timer = v518:WaitForChild("Timer")

Stock.AutoLocalize = false
Timer.AutoLocalize = false

local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

local function left2() -- line: 2672
    -- upvalues: ShopConfig (ref), OWNER (copy)
    return workspace:GetAttribute(ShopConfig.LimitedAttr(OWNER.key)) or OWNER.stock
end

local function ended() -- line: 2673
    -- upvalues: ShopConfig (ref), OWNER (copy)
    return not ShopConfig.OnSale(OWNER)
end

local function dressTimer() -- line: 2674
    -- upvalues: OWNER (copy), Timer (copy)
    local v521 = math.max(0, (math.floor(OWNER.ends - workspace:GetServerTimeNow())))
    local v522 = v521 // 86400
    local v523 = v521 % 86400 // 3600
    local v524 = v521 % 3600 // 60

    Timer.Text = v522 > 0 and ("LEAVES IN %dd %02dh"):format(v522, v523) or ("LEAVES IN %02d:%02d:%02d"):format(v523, v524, v521 % 60)
end

local function dress2() -- line: 2680
    -- upvalues: ShopConfig (ref), Loc (ref), t2 (ref), v1 (ref), t4 (ref), t6 (ref), t14 (ref), OWNER (copy), v518 (copy), Buy2 (copy), Stock (copy), dressTimer (copy)
    local v526 = workspace:GetAttribute(ShopConfig.LimitedAttr(OWNER.key)) or OWNER.stock
    local v527 = t4.who:GetAttribute("Owns" .. OWNER.key) == true

    Stock.Text = Loc.F("shop.stock", "{left}/{stock}", {
        left = v526,
        stock = OWNER.stock
    })
    t6.onlyLeft(v518, v526, v527)

    local v528 = v527 or v526 <= 0
    local Price = Buy2.Price

    if v527 then
        Price.Text = "OWNED"
    elseif v526 <= 0 then
        Price.Text = "SOLD OUT"
    else
        local v530 = math.floor(t14[OWNER] or OWNER.price)

        Price.Text = v1 .. " " .. tostring(v530):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    end

    Buy2.ImageTransparency = v528 and t2.CLAIMED_FADE or 0

    local Icon = Buy2:FindFirstChild("Icon")

    if Icon then
        Icon.ImageTransparency = v528 and t2.CLAIMED_FADE or 0
    end

    dressTimer()
end

workspace:GetAttributeChangedSignal(ShopConfig.LimitedAttr(OWNER.key)):Connect(dress2)
watch({ "Owns" .. OWNER.key }, dress2)
Loc.Changed:Connect(dress2)
table.insert(t15, dress2)
dress2()

if ended() then
    setHidden({
        [v518] = true
    })
else
    task.spawn(function() -- line: 2700
        -- upvalues: ShopConfig (ref), Panel (ref), setHidden (ref), OWNER (copy), v518 (copy), dressTimer (copy)
        while ShopConfig.OnSale(OWNER) do
            if Panel.Visible then
                dressTimer()
            end

            task.wait(1)
        end

        setHidden({
            [v518] = true
        })
    end)
end

local v531 = false
local t83 = {
    owned = "You already own this!",
    soldout = "SOLD OUT!",
    ended = "This harpoon is gone!",
    busy = "Try again in a moment!"
}

ButtonHover.Attach(Buy2, (hoverOf(Buy2)))
t16.on(v518, Buy2, function() -- line: 2711
    -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), OWNER (copy), Buy2 (copy), LimitedAsk (copy), v531 (ref), t83 (copy)
    ButtonHover.Press(Buy2)

    if not v531 then
        if not t4.who:GetAttribute("Owns" .. OWNER.key) and not ((workspace:GetAttribute(ShopConfig.LimitedAttr(OWNER.key)) or OWNER.stock) <= 0) and ShopConfig.OnSale(OWNER) then
            if t4.gifting then
                giftAsk(Buy2, "Limited", table.find(ShopConfig.LIMITED, OWNER), OWNER.product)
            else
                v531 = true

                local InvokeServer = LimitedAsk.InvokeServer
                local key = OWNER.key
                local ok, result = pcall(InvokeServer, LimitedAsk, key)

                v531 = false

                if not ok or result ~= "ok" then
                    deny(Buy2)

                    local Show = Toast.Show

                    if not ok or not result then
                        result = "busy"
                    end

                    Show(t83[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                else
                    PurchaseFX.Buy(OWNER.product)
                end
            end
        else
            deny(Buy2)
        end
    end
end)
t4.square(Buy2, function() -- line: 2723
    -- upvalues: ShopConfig (ref), OWNER (copy)
    return "Limited", table.find(ShopConfig.LIMITED, OWNER), OWNER.product
end)

local card = t7.card
local Buy3 = card:WaitForChild("Buy")
local BoostFish = require(Modules:WaitForChild("BoostFish"))
local RarityStyle = require(Modules:WaitForChild("RarityStyle"))
local MutationDisplay = require(Modules:WaitForChild("MutationDisplay"))
local color = require(Modules:WaitForChild("RarityDisplay")).Exclusive.color

card:WaitForChild("Boost").AutoLocalize = false

local t84 = {}

t84[0] = {
    tex = "rbxassetid://94864243096531",
    grad = t11.GRAD.Teal,
    ink = Color3.fromRGB(22, 86, 34),
    edge = Color3.fromRGB(30, 110, 40),
    name = Color3.fromRGB(185, 255, 165)
}

local RarityStyle2 = {
    tex = "rbxassetid://85175878291521",
    grad = t11.GRAD.Fire,
    ink = Color3.fromRGB(120, 35, 5),
    edge = Color3.fromRGB(170, 55, 15),
    name = Color3.fromRGB(255, 205, 150)
}

on = {
    tex = "rbxassetid://111497243137583",
    grad = t11.GRAD.Purple,
    ink = Color3.fromRGB(60, 20, 120),
    edge = Color3.fromRGB(90, 45, 170),
    name = Color3.fromRGB(225, 200, 255)
}
key = {
    tex = "rbxassetid://95521428082005",
    rainbow = true,
    ink = Color3.fromRGB(60, 35, 110),
    edge = Color3.new(1, 1, 1),
    name = Color3.fromRGB(255, 240, 200)
}
t84[1] = RarityStyle2
t84[2] = on
t84[3] = key

local UIStroke = card:FindFirstChildOfClass("UIStroke")

local function gradOn(p132, p133, p134) -- line: 2750
    local v532 = p132:FindFirstChild(p133)

    if not p134 or v532 then
        if not p134 and v532 then
            v532:Destroy()
        end
    else
        v532 = Instance.new("UIGradient")
        v532.Name = p133
        v532.Parent = p132
    end

    if v532 then
        v532.Color = p134
    end
end

function t7.look(p135) -- line: 2761
    -- upvalues: t11 (ref), card (copy), t84 (copy), UIStroke (copy)
    local v533 = t84[p135] or t84[0]

    t11.Face(card, v533.grad, v533.tex)
    UIStroke.Color = v533.edge

    local _RAINBOW = v533.rainbow and RAINBOW or nil
    local Rainbow = UIStroke:FindFirstChild("Rainbow")

    if not _RAINBOW or Rainbow then
        if not _RAINBOW and Rainbow then
            Rainbow:Destroy()
        end
    else
        Rainbow = Instance.new("UIGradient")
        Rainbow.Name = "Rainbow"
        Rainbow.Parent = UIStroke
    end

    if Rainbow then
        Rainbow.Color = _RAINBOW
    end

    card.Heading.Grad.Color = ColorSequence.new(Color3.new(1, 1, 1), v533.name)
    card.Heading.Grad.Rotation = 90
    card.Heading:FindFirstChildOfClass("UIStroke").Color = v533.ink
end

local t85 = {
    Molten = "#FF8A1F",
    Shadow = "#E4CCFF"
}
local v534 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 70, 70)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 180, 50)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 240, 80)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(80, 230, 110)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(70, 160, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 90, 255))
})
local t86 = {
    "#FF4646",
    "#FFB432",
    "#FFF050",
    "#50E66E",
    "#46A0FF",
    "#8C5AFF",
    "#BE5AFF"
}

local function rainbowWord(p136) -- line: 2778
    -- upvalues: Loc (ref), t86 (copy)
    local t87 = {}
    local v535 = Loc.Letters(p136)

    if not v535 then
        return "<font color=\"" .. t86[6] .. "\">" .. p136 .. "</font>"
    end

    for v536, v537 in ipairs(v535) do
        t87[v536] = "<font color=\"" .. t86[(v536 - 1) % #t86 + 1] .. "\">" .. v537 .. "</font>"
    end

    return table.concat(t87)
end

local function current() -- line: 2786
    -- upvalues: ShopConfig (ref), t4 (ref)
    return ShopConfig.HydraNext(t4.who:GetAttribute("HydraBought") == true, t4.who:GetAttribute("HydraTier") or 0)
end

local function pct(p137) -- line: 2789
    -- upvalues: ShopConfig (ref), BoostFish (copy)
    return "+" .. BoostFish.At(ShopConfig.HYDRA.fish, ShopConfig.HYDRA.stage, p137.mutation) .. "%"
end

local v538
local n13 = 0

card:WaitForChild("Timer").AutoLocalize = false

function t7.tick() -- line: 2797
    -- upvalues: Loc (ref), t4 (ref), card (copy)
    local v541 = math.max(0, (math.floor((t4.who:GetAttribute("HydraOfferEnds") or 0) - workspace:GetServerTimeNow())))

    card.Timer.Visible = t4.who:GetAttribute("HydraOfferEnds") ~= nil
    card.Timer.Text = Loc.F("shop.leaves", "LEAVES IN {time}", {
        time = ("%02d:%02d:%02d"):format(v541 // 3600, v541 % 3600 // 60, v541 % 60)
    })
end

function t7.dress() -- line: 2803
    -- upvalues: TweenService (ref), Modules (ref), ShopConfig (ref), Loc (ref), v1 (ref), t4 (ref), t7 (ref), setHidden (ref), t14 (ref), card (copy), Buy3 (copy), BoostFish (copy), RarityStyle (copy), MutationDisplay (copy), color (copy), t85 (copy), v534 (copy), rainbowWord (copy), v538 (ref), n13 (ref)
    local v542, v543 = ShopConfig.HydraNext(t4.who:GetAttribute("HydraBought") == true, t4.who:GetAttribute("HydraTier") or 0)
    local HydraOfferEnds = t4.who:GetAttribute("HydraOfferEnds")
    local v544 = ShopConfig.HydraExpired(HydraOfferEnds, workspace:GetServerTimeNow())
    local t88 = {
        [card] = v542 == nil or v544
    }

    setHidden(t88)

    if not v542 or v544 then
        return
    else
        t7.tick()
        n13 += 1

        if type(HydraOfferEnds) == "number" then
            local v547 = n13

            task.delay(HydraOfferEnds - workspace:GetServerTimeNow() + 0.1, function() -- line: 2813
                -- upvalues: v547 (copy), t7 (ref), n13 (ref)
                if v547 == n13 then
                    t7.dress()
                end
            end)
        end
    end

    t7.look(v543)
    card.Art.Image = v542.image
    card.Title.Text = v543 == 0 and "EXCLUSIVE FISH!" or "UPGRADE HYDRA!"

    local Heading = card.Heading

    if v543 == 0 then
        Heading.Text = "GREENLAND HYDRA"
    else
        Heading.Text = Loc.Fish(v542.word, "HYDRA")
    end

    card.Rarity.Text = v542.word

    if v542.mutation == "Rainbow" then
        RarityStyle.Apply(card.Rarity, Color3.new(1, 1, 1))
        card.Rarity.Grad.Color = v534
        card.Rarity.UIStroke.Color = Color3.fromRGB(45, 20, 90)
    else
        RarityStyle.Apply(card.Rarity, v542.mutation and MutationDisplay[v542.mutation].color or color)
    end

    local v548 = "+" .. BoostFish.At(ShopConfig.HYDRA.fish, ShopConfig.HYDRA.stage, v542.mutation) .. "%"

    card.Boost.Text = Loc.F("hydra.boost", "{pct} MONEY", {
        pct = v548
    })

    if v543 == 0 then
        card.Perk1.Text = Loc.F("hydra.perk_money", "• {pct} Aquarium Money", {
            pct = "<font color=\"#FFD24A\">" .. v548 .. "</font>"
        })

        local v549 = #require(Modules:WaitForChild("GrowthDisplay")).stages - 1

        card.Perk2.Text = Loc.F("ghost.fullgrown", "({pct} when fully grown)", {
            pct = "+" .. BoostFish.At(v542.fish, v549, v542.mutation) .. "%"
        })
    else
        local HYDRA = v543 == 1 and ShopConfig.HYDRA or ShopConfig.HYDRA_UPS[v543 - 1]
        local v550 = "+" .. BoostFish.At(ShopConfig.HYDRA.fish, ShopConfig.HYDRA.stage, HYDRA.mutation) .. "%"

        card.Perk1.Text = Loc.F("hydra.perk_money", "• {pct} Aquarium Money", {
            pct = "<font color=\"#9A9CA3\"><s>" .. v550 .. "</s></font> <font color=\"#FFD24A\">" .. v548 .. "</font>"
        })

        local v551 = Loc.T(v542.word)
        local v553 = t85[v542.mutation] and "<font color=\"" .. t85[v542.mutation] .. "\">" .. v551 .. "</font>" or rainbowWord(v551)

        card.Perk2.Text = Loc.F("hydra.turns_short", "(your Hydra turns {mutation})", {
            mutation = v553
        })
    end

    local Label = card.WasPrice.Label
    local v554 = math.floor(v542.was)

    Label.Text = v1 .. " " .. tostring(v554):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

    local Price = Buy3.Price
    local v556 = math.floor(t14[v542] or v542.price)

    Price.Text = v1 .. " " .. tostring(v556):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

    local v557 = t14[v542] or v542.price
    local v558 = ShopConfig.OffOf(v542, v557)

    card.Off.Visible = v558 > 0
    card.Off.Text = Loc.F("shop.off", "{n}% Off", {
        n = v558
    })

    if v538 ~= nil and v538 ~= v543 then
        card.Pop.Scale = 0.85
        TweenService:Create(card.Pop, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
    end

    v538 = v543
end

card.WasPrice.Label:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 2857
    -- upvalues: card (copy)
    local WasPrice = card.WasPrice
    local v559 = WasPrice.Label.TextBounds.X / math.max(1, WasPrice.AbsoluteSize.X)

    WasPrice.Strike.Size = UDim2.fromScale(math.max(0.2, v559 * 1.12), WasPrice.Strike.Size.Y.Scale)
end)
watch({ "HydraBought", "HydraTier", "HydraOfferEnds" }, t7.dress)
task.spawn(function() -- line: 2859
    -- upvalues: Panel (ref), t7 (ref), t12 (ref), card (copy)
    while true do
        if Panel.Visible and not t12[card] then
            t7.tick()
        end

        task.wait(1)
    end
end)
Loc.Changed:Connect(t7.dress)
Visible = t7.dress
table.insert(t15, Visible)
t7.dress()
task.defer(fitStrike, card.WasPrice)
ButtonHover.Attach(Buy3, (hoverOf(Buy3)))
t16.on(card, Buy3, function() -- line: 2870
    -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), t4 (ref), deny (ref), giftAsk (ref), Buy3 (copy)
    ButtonHover.Press(Buy3)

    local v561, v562 = ShopConfig.HydraNext(t4.who:GetAttribute("HydraBought") == true, t4.who:GetAttribute("HydraTier") or 0)

    if v561 then
        if t4.gifting then
            giftAsk(Buy3, v562 == 0 and "Hydra" or "HydraUp", math.max(v562, 1), v561.product)
        else
            PurchaseFX.Buy(v561.product)
        end
    else
        deny(Buy3)
    end
end)

local ULTIMATE = ShopConfig.ULTIMATE
local UltimatePack = t1:FindFirstChild("UltimatePack")

if UltimatePack then
    t7.ult = UltimatePack

    local Buy = UltimatePack:WaitForChild("Buy")

    Buy.Price.AutoLocalize = false

    local Format = require(Modules:WaitForChild("Format"))
    local Text = UltimatePack:WaitForChild("PerkMoney"):WaitForChild("Text")

    Text.AutoLocalize = false

    local PassPerks = require(Modules:WaitForChild("PassPerks"))
    local Text2 = UltimatePack:WaitForChild("PerkFat"):WaitForChild("Text")

    Text2.AutoLocalize = false

    local PerkKey = UltimatePack:WaitForChild("PerkKey")
    local WasPrice = UltimatePack:WaitForChild("WasPrice")

    WasPrice.Label.AutoLocalize = false
    WasPrice.Label.Text = v1 .. " " .. commas(ULTIMATE.was)
    WasPrice.Label:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 2907
        -- upvalues: WasPrice (copy)
        local v563 = WasPrice.Label.TextBounds.X / math.max(1, WasPrice.AbsoluteSize.X)

        WasPrice.Strike.Size = UDim2.fromScale(math.max(0.2, v563 * 1.12), WasPrice.Strike.Size.Y.Scale)
    end)
    task.defer(fitStrike, WasPrice)
    key = UltimatePack:FindFirstChild("Burst")

    if key then
        TweenService:Create(key, TweenInfo.new(24, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
            Rotation = 360
        }):Play()
    end

    function dress2() -- line: 2911
        -- upvalues: ShopConfig (ref), v1 (ref), t4 (ref), setHidden (ref), t14 (ref), ULTIMATE (copy), UltimatePack (copy), Buy (copy), Format (copy), Text (copy), PassPerks (copy), Text2 (copy), PerkKey (copy)
        setHidden({
            [UltimatePack] = t4.who:GetAttribute("UltimateBought") == true
        })

        local Price = Buy.Price
        local v566 = math.floor(t14[ULTIMATE] or ULTIMATE.price)

        Price.Text = v1 .. " " .. tostring(v566):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

        local v567 = ShopConfig.UltimateCash(t4.who:GetAttribute("PenRate") or 0)

        Text.Text = "<font color=\"#7CFF6B\">" .. Format.money(v567) .. "</font> CASH"

        local v568 = ShopConfig.UltimateFat(t4.who:GetAttribute("TableLevel") or 1, PassPerks.FatMul(t4.who))

        Text2.Text = "<font color=\"#FF5F3C\">+ " .. Format.short(v568) .. "</font> FAT"
        PerkKey.Visible = t4.who:GetAttribute("NoPaidRandom") ~= true
    end

    watch({
        "UltimateBought",
        "PenRate",
        "TableLevel",
        ShopConfig.PassAttr("Fat2x"),
        "NoPaidRandom"
    }, dress2)
    table.insert(t15, dress2)
    dress2()
    ButtonHover.Attach(Buy, (hoverOf(Buy)))
    t16.on(UltimatePack, Buy, function() -- line: 2926
        -- upvalues: ButtonHover (ref), PurchaseFX (ref), t4 (ref), deny (ref), giftAsk (ref), ULTIMATE (copy), Buy (copy)
        ButtonHover.Press(Buy)

        if t4.who:GetAttribute("UltimateBought") then
            deny(Buy)
        elseif t4.gifting then
            giftAsk(Buy, "Ultimate", 1, ULTIMATE.product)
        else
            PurchaseFX.Buy(ULTIMATE.product)
        end
    end)
    t4.square(Buy, function() -- line: 2931
        -- upvalues: ULTIMATE (copy)
        return "Ultimate", 1, ULTIMATE.product
    end)
end

local DEVILSHARK = ShopConfig.DEVILSHARK
local v569 = t1:FindFirstChild(DEVILSHARK.card)

if v569 and not DEVILSHARK.rotation then
    t8.devil = v569

    local Buy = v569:WaitForChild("Buy")
    local Stock = v569:WaitForChild("Stock")
    local Timer = v569:WaitForChild("Timer")
    local Format = require(Modules:WaitForChild("Format"))
    local v570 = #require(Modules:WaitForChild("GrowthDisplay")).stages - 1 - DEVILSHARK.stage

    for _, v571 in ipairs({
            Stock,
            Timer,
            v569:WaitForChild("Boost"),
            v569:WaitForChild("FullGrown")
        }) do
        v571.AutoLocalize = false
    end

    local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

    local function left() -- line: 2950
        -- upvalues: ShopConfig (ref), DEVILSHARK (copy)
        return workspace:GetAttribute(ShopConfig.LimitedAttr(DEVILSHARK.key)) or DEVILSHARK.stock
    end

    local function ended() -- line: 2951
        -- upvalues: ShopConfig (ref), DEVILSHARK (copy)
        return not ShopConfig.OnSale(DEVILSHARK)
    end

    local function dressTimer() -- line: 2954
        -- upvalues: DEVILSHARK (copy), Timer (copy)
        local v574 = math.max(0, (math.floor(DEVILSHARK.ends - workspace:GetServerTimeNow())))
        local v575 = v574 // 86400
        local v576 = v574 % 86400 // 3600
        local v577 = v574 % 3600 // 60

        Timer.Text = v575 > 0 and ("LEAVES IN %dd %02dh"):format(v575, v576) or ("LEAVES IN %02d:%02d:%02d"):format(v576, v577, v574 % 60)
    end

    local function dress() -- line: 2959
        -- upvalues: ShopConfig (ref), Loc (ref), t2 (ref), v1 (ref), t4 (ref), t6 (ref), t14 (ref), DEVILSHARK (copy), v569 (copy), Buy (copy), Stock (copy), Format (copy), v570 (copy), dressTimer (copy)
        local v579 = workspace:GetAttribute(ShopConfig.LimitedAttr(DEVILSHARK.key)) or DEVILSHARK.stock
        local v580 = t4.who:GetAttribute("Owns" .. DEVILSHARK.key) == true

        Stock.Text = Loc.F("shop.stock", "{left}/{stock}", {
            left = v579,
            stock = DEVILSHARK.stock
        })
        t6.onlyLeft(v569, v579, v580)
        v569.Boost.Text = Format.money(DEVILSHARK.rate) .. "/s"
        v569.FullGrown.Text = Loc.F("devil.fullgrown", "({rate} when fully grown)", {
            rate = Format.money(DEVILSHARK.rate * 2 ^ v570) .. "/s"
        })
        dressTimer()

        local v581 = v580 or v579 <= 0
        local Price = Buy.Price

        if v580 then
            Price.Text = "OWNED"
        elseif v579 <= 0 then
            Price.Text = "SOLD OUT"
        else
            local v583 = math.floor(t14[DEVILSHARK] or DEVILSHARK.price)

            Price.Text = v1 .. " " .. tostring(v583):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        Buy.ImageTransparency = v581 and t2.CLAIMED_FADE or 0

        local Icon = Buy:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v581 and t2.CLAIMED_FADE or 0
        end
    end

    workspace:GetAttributeChangedSignal(ShopConfig.LimitedAttr(DEVILSHARK.key)):Connect(dress)
    watch({ "Owns" .. DEVILSHARK.key }, dress)
    Loc.Changed:Connect(dress)
    table.insert(t15, dress)
    dress()

    if ended() then
        setHidden({
            [v569] = true
        })
    else
        task.spawn(function() -- line: 2983
            -- upvalues: ShopConfig (ref), Panel (ref), setHidden (ref), DEVILSHARK (copy), v569 (copy), dressTimer (copy)
            while ShopConfig.OnSale(DEVILSHARK) do
                if Panel.Visible then
                    dressTimer()
                end

                task.wait(1)
            end

            setHidden({
                [v569] = true
            })
        end)
    end

    local v584 = false
    local t89 = {
        owned = "You already own this!",
        soldout = "SOLD OUT!",
        ended = "The Devilshark is gone!",
        busy = "Try again in a moment!"
    }

    ButtonHover.Attach(Buy, (hoverOf(Buy)))
    t16.on(v569, Buy, function() -- line: 2994
        -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), DEVILSHARK (copy), Buy (copy), LimitedAsk (copy), v584 (ref), t89 (copy)
        ButtonHover.Press(Buy)

        if not v584 then
            if not t4.who:GetAttribute("Owns" .. DEVILSHARK.key) and not ((workspace:GetAttribute(ShopConfig.LimitedAttr(DEVILSHARK.key)) or DEVILSHARK.stock) <= 0) and ShopConfig.OnSale(DEVILSHARK) then
                if t4.gifting then
                    giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, DEVILSHARK), DEVILSHARK.product)
                else
                    v584 = true

                    local InvokeServer = LimitedAsk.InvokeServer
                    local key = DEVILSHARK.key
                    local ok, result = pcall(InvokeServer, LimitedAsk, key)

                    v584 = false

                    if not ok or result ~= "ok" then
                        deny(Buy)

                        local Show = Toast.Show

                        if not ok or not result then
                            result = "busy"
                        end

                        Show(t89[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                    else
                        PurchaseFX.Buy(DEVILSHARK.product)
                    end
                end
            else
                deny(Buy)
            end
        end
    end)
    t4.square(Buy, function() -- line: 3006
        -- upvalues: ShopConfig (ref), DEVILSHARK (copy)
        return "Limited", table.find(ShopConfig.LIMITED, DEVILSHARK), DEVILSHARK.product
    end)
end

local WRAITH = ShopConfig.WRAITH
local v585 = t1:FindFirstChild(WRAITH.card)

if v585 and not WRAITH.rotation then
    t8.wraith = v585

    local Buy = v585:WaitForChild("Buy")
    local Stock = v585:WaitForChild("Stock")
    local Timer = v585:WaitForChild("Timer")
    local Earns = v585:WaitForChild("Earns")
    local EarnsLabel = v585:WaitForChild("EarnsLabel")
    local BoostFish = require(Modules:WaitForChild("BoostFish"))

    for _, v586 in ipairs({ Stock, Timer, Earns, EarnsLabel }) do
        v586.AutoLocalize = false
    end

    local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

    function left() -- line: 3027
        -- upvalues: ShopConfig (ref), WRAITH (copy)
        return workspace:GetAttribute(ShopConfig.LimitedAttr(WRAITH.key)) or WRAITH.stock
    end

    local function ended() -- line: 3028
        -- upvalues: ShopConfig (ref), WRAITH (copy)
        return not ShopConfig.OnSale(WRAITH)
    end

    local function dressTimer() -- line: 3029
        -- upvalues: WRAITH (copy), Timer (copy)
        local v589 = math.max(0, (math.floor(WRAITH.ends - workspace:GetServerTimeNow())))
        local v590 = v589 // 86400
        local v591 = v589 % 86400 // 3600
        local v592 = v589 % 3600 // 60

        Timer.Text = v590 > 0 and ("LEAVES IN %dd %02dh"):format(v590, v591) or ("LEAVES IN %02d:%02d:%02d"):format(v591, v592, v589 % 60)
    end

    local function dress() -- line: 3034
        -- upvalues: ShopConfig (ref), Loc (ref), t2 (ref), v1 (ref), t4 (ref), t6 (ref), t14 (ref), WRAITH (copy), v585 (copy), Buy (copy), Stock (copy), Earns (copy), EarnsLabel (copy), BoostFish (copy), dressTimer (copy)
        local v594 = workspace:GetAttribute(ShopConfig.LimitedAttr(WRAITH.key)) or WRAITH.stock
        local v595 = t4.who:GetAttribute("Owns" .. WRAITH.key) == true

        Stock.Text = Loc.F("shop.stock", "{left}/{stock}", {
            left = v594,
            stock = WRAITH.stock
        })
        t6.onlyLeft(v585, v594, v595)
        EarnsLabel.Text = Loc.T("EARNS")
        Earns.Text = Loc.F("wraith.earns", "{n}x YOUR BEST FISH", {
            n = BoostFish.COPY[WRAITH.fish] or 3
        })
        dressTimer()

        local v596 = v595 or v594 <= 0
        local Price = Buy.Price

        if v595 then
            Price.Text = "OWNED"
        elseif v594 <= 0 then
            Price.Text = "SOLD OUT"
        else
            local v598 = math.floor(t14[WRAITH] or WRAITH.price)

            Price.Text = v1 .. " " .. tostring(v598):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        Buy.ImageTransparency = v596 and t2.CLAIMED_FADE or 0

        local Icon = Buy:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v596 and t2.CLAIMED_FADE or 0
        end
    end

    workspace:GetAttributeChangedSignal(ShopConfig.LimitedAttr(WRAITH.key)):Connect(dress)
    watch({ "Owns" .. WRAITH.key }, dress)
    Loc.Changed:Connect(dress)
    table.insert(t15, dress)
    dress()

    if ended() then
        setHidden({
            [v585] = true
        })
    else
        task.spawn(function() -- line: 3056
            -- upvalues: ShopConfig (ref), Panel (ref), setHidden (ref), WRAITH (copy), v585 (copy), dressTimer (copy)
            while ShopConfig.OnSale(WRAITH) do
                if Panel.Visible then
                    dressTimer()
                end

                task.wait(1)
            end

            setHidden({
                [v585] = true
            })
        end)
    end

    local v599 = false
    local t90 = {
        owned = "You already own this!",
        soldout = "SOLD OUT!",
        ended = "The Jesterwraith is gone!",
        busy = "Try again in a moment!"
    }

    ButtonHover.Attach(Buy, (hoverOf(Buy)))
    t16.on(v585, Buy, function() -- line: 3067
        -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), WRAITH (copy), Buy (copy), LimitedAsk (copy), v599 (ref), t90 (copy)
        ButtonHover.Press(Buy)

        if not v599 then
            if not t4.who:GetAttribute("Owns" .. WRAITH.key) and not ((workspace:GetAttribute(ShopConfig.LimitedAttr(WRAITH.key)) or WRAITH.stock) <= 0) and ShopConfig.OnSale(WRAITH) then
                if t4.gifting then
                    giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, WRAITH), WRAITH.product)
                else
                    v599 = true

                    local InvokeServer = LimitedAsk.InvokeServer
                    local key = WRAITH.key
                    local ok, result = pcall(InvokeServer, LimitedAsk, key)

                    v599 = false

                    if not ok or result ~= "ok" then
                        deny(Buy)

                        local Show = Toast.Show

                        if not ok or not result then
                            result = "busy"
                        end

                        Show(t90[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                    else
                        PurchaseFX.Buy(WRAITH.product)
                    end
                end
            else
                deny(Buy)
            end
        end
    end)
    t4.square(Buy, function() -- line: 3079
        -- upvalues: ShopConfig (ref), WRAITH (copy)
        return "Limited", table.find(ShopConfig.LIMITED, WRAITH), WRAITH.product
    end)
end

local OROBORUS = ShopConfig.OROBORUS

v7 = t1:FindFirstChild(OROBORUS.card)

if v7 then
    local Buy = v7:WaitForChild("Buy")
    local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

    function dress() -- line: 3092
        -- upvalues: t2 (ref), v1 (ref), t4 (ref), t14 (ref), OROBORUS (copy), Buy (copy)
        local v600 = t4.who:GetAttribute("Owns" .. OROBORUS.key) == true
        local Price = Buy.Price

        if v600 then
            Price.Text = "OWNED"
        else
            local v602 = math.floor(t14[OROBORUS] or OROBORUS.price)

            Price.Text = v1 .. " " .. tostring(v602):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        Buy.ImageTransparency = v600 and t2.CLAIMED_FADE or 0

        local Icon = Buy:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v600 and t2.CLAIMED_FADE or 0
        end
    end

    watch({ "Owns" .. OROBORUS.key }, dress)
    Loc.Changed:Connect(dress)
    table.insert(t15, dress)
    dress()

    local v603 = false
    local t91 = {
        owned = "You already own this!",
        busy = "Try again in a moment!"
    }

    ButtonHover.Attach(Buy, (hoverOf(Buy)))
    t16.on(v7, Buy, function() -- line: 3106
        -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), OROBORUS (copy), Buy (copy), LimitedAsk (copy), v603 (ref), t91 (copy)
        ButtonHover.Press(Buy)

        if not v603 then
            if t4.who:GetAttribute("Owns" .. OROBORUS.key) then
                deny(Buy)
            elseif t4.gifting then
                giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, OROBORUS), OROBORUS.product)
            else
                v603 = true

                local InvokeServer = LimitedAsk.InvokeServer
                local key = OROBORUS.key
                local ok, result = pcall(InvokeServer, LimitedAsk, key)

                v603 = false

                if not ok or result ~= "ok" then
                    deny(Buy)

                    local Show = Toast.Show

                    if not ok or not result then
                        result = "busy"
                    end

                    Show(t91[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                else
                    PurchaseFX.Buy(OROBORUS.product)
                end
            end
        end
    end)
    t4.square(Buy, function() -- line: 3118
        -- upvalues: ShopConfig (ref), OROBORUS (copy)
        return "Limited", table.find(ShopConfig.LIMITED, OROBORUS), OROBORUS.product
    end)
end

local JESTER = ShopConfig.JESTER

v7 = t1:FindFirstChild(JESTER.card)

local dress3

if v7 then
    local Buy = v7:WaitForChild("Buy")
    local BestRate = v7:WaitForChild("BestRate")
    local Format = require(Modules:WaitForChild("Format"))
    local BoostFish = require(Modules:WaitForChild("BoostFish"))
    local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

    function dress3() -- line: 3134
        -- upvalues: t2 (ref), v1 (ref), t4 (ref), t14 (ref), JESTER (copy), Buy (copy)
        local v604 = t4.who:GetAttribute("Owns" .. JESTER.key) == true
        local Price = Buy.Price

        if v604 then
            Price.Text = "OWNED"
        else
            local v606 = math.floor(t14[JESTER] or JESTER.price)

            Price.Text = v1 .. " " .. tostring(v606):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        Buy.ImageTransparency = v604 and t2.CLAIMED_FADE or 0

        local Icon = Buy:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v604 and t2.CLAIMED_FADE or 0
        end
    end

    watch({ "Owns" .. JESTER.key }, dress3)
    Loc.Changed:Connect(dress3)
    table.insert(t15, dress3)
    dress3()

    local function dressRate() -- line: 3145
        -- upvalues: LocalPlayer (ref), JESTER (copy), BestRate (copy), Format (copy), BoostFish (copy)
        local v607 = tonumber(LocalPlayer:GetAttribute("CopyRate")) or 0

        BestRate.Text = Format.money(v607 * (BoostFish.COPY[JESTER.fish] or 2)) .. "/s"
    end

    LocalPlayer:GetAttributeChangedSignal("CopyRate"):Connect(dressRate)
    dressRate()

    local v608 = false
    local t92 = {
        owned = "You already own this!",
        busy = "Try again in a moment!"
    }

    ButtonHover.Attach(Buy, (hoverOf(Buy)))
    t16.on(v7, Buy, function() -- line: 3154
        -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), JESTER (copy), Buy (copy), LimitedAsk (copy), v608 (ref), t92 (copy)
        ButtonHover.Press(Buy)

        if not v608 then
            if t4.who:GetAttribute("Owns" .. JESTER.key) then
                deny(Buy)
            elseif t4.gifting then
                giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, JESTER), JESTER.product)
            else
                v608 = true

                local InvokeServer = LimitedAsk.InvokeServer
                local key = JESTER.key
                local ok, result = pcall(InvokeServer, LimitedAsk, key)

                v608 = false

                if not ok or result ~= "ok" then
                    deny(Buy)

                    local Show = Toast.Show

                    if not ok or not result then
                        result = "busy"
                    end

                    Show(t92[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                else
                    PurchaseFX.Buy(JESTER.product)
                end
            end
        end
    end)
    t4.square(Buy, function() -- line: 3166
        -- upvalues: ShopConfig (ref), JESTER (copy)
        return "Limited", table.find(ShopConfig.LIMITED, JESTER), JESTER.product
    end)
end

local MIME = ShopConfig.MIME

v7 = t1:FindFirstChild(MIME.card)

local dress4

if v7 and not MIME.rotation then
    local Buy = v7:WaitForChild("Buy")
    local BestRate = v7:WaitForChild("BestRate")
    local Format = require(Modules:WaitForChild("Format"))
    local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

    function dress4() -- line: 3181
        -- upvalues: t2 (ref), v1 (ref), t4 (ref), t14 (ref), MIME (copy), Buy (copy)
        local v609 = t4.who:GetAttribute("Owns" .. MIME.key) == true
        local Price = Buy.Price

        if v609 then
            Price.Text = "OWNED"
        else
            local v611 = math.floor(t14[MIME] or MIME.price)

            Price.Text = v1 .. " " .. tostring(v611):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        Buy.ImageTransparency = v609 and t2.CLAIMED_FADE or 0

        local Icon = Buy:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v609 and t2.CLAIMED_FADE or 0
        end
    end

    watch({ "Owns" .. MIME.key }, dress4)
    Loc.Changed:Connect(dress4)
    table.insert(t15, dress4)
    dress4()

    local function dressRate() -- line: 3192
        -- upvalues: LocalPlayer (ref), BestRate (copy), Format (copy)
        BestRate.Text = Format.money(tonumber(LocalPlayer:GetAttribute("CopyRate")) or 0) .. "/s"
    end

    LocalPlayer:GetAttributeChangedSignal("CopyRate"):Connect(dressRate)
    dressRate()

    local v612 = false
    local t93 = {
        owned = "You already own this!",
        busy = "Try again in a moment!"
    }

    ButtonHover.Attach(Buy, (hoverOf(Buy)))
    t16.on(v7, Buy, function() -- line: 3200
        -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), MIME (copy), Buy (copy), LimitedAsk (copy), v612 (ref), t93 (copy)
        ButtonHover.Press(Buy)

        if not v612 then
            if t4.who:GetAttribute("Owns" .. MIME.key) then
                deny(Buy)
            elseif t4.gifting then
                giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, MIME), MIME.product)
            else
                v612 = true

                local InvokeServer = LimitedAsk.InvokeServer
                local key = MIME.key
                local ok, result = pcall(InvokeServer, LimitedAsk, key)

                v612 = false

                if not ok or result ~= "ok" then
                    deny(Buy)

                    local Show = Toast.Show

                    if not ok or not result then
                        result = "busy"
                    end

                    Show(t93[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                else
                    PurchaseFX.Buy(MIME.product)
                end
            end
        end
    end)
    t4.square(Buy, function() -- line: 3212
        -- upvalues: ShopConfig (ref), MIME (copy)
        return "Limited", table.find(ShopConfig.LIMITED, MIME), MIME.product
    end)
end

local HOTDOG = ShopConfig.HOTDOG

v7 = t1:FindFirstChild(HOTDOG.card)

if v7 and not HOTDOG.rotation then
    local Buy = v7:WaitForChild("Buy")
    local LimitedAsk = Remotes:WaitForChild("LimitedAsk")

    function dress() -- line: 3225
        -- upvalues: t2 (ref), v1 (ref), t4 (ref), t14 (ref), HOTDOG (copy), Buy (copy)
        local v613 = t4.who:GetAttribute("Owns" .. HOTDOG.key) == true
        local Price = Buy.Price

        if v613 then
            Price.Text = "OWNED"
        else
            local v615 = math.floor(t14[HOTDOG] or HOTDOG.price)

            Price.Text = v1 .. " " .. tostring(v615):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
        end

        Buy.ImageTransparency = v613 and t2.CLAIMED_FADE or 0

        local Icon = Buy:FindFirstChild("Icon")

        if Icon then
            Icon.ImageTransparency = v613 and t2.CLAIMED_FADE or 0
        end
    end

    watch({ "Owns" .. HOTDOG.key }, dress)
    Loc.Changed:Connect(dress)
    table.insert(t15, dress)
    dress()

    local v616 = false
    local t94 = {
        owned = "You already own this!",
        busy = "Try again in a moment!"
    }

    ButtonHover.Attach(Buy, (hoverOf(Buy)))
    t16.on(v7, Buy, function() -- line: 3239
        -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), HOTDOG (copy), Buy (copy), LimitedAsk (copy), v616 (ref), t94 (copy)
        ButtonHover.Press(Buy)

        if not v616 then
            if t4.who:GetAttribute("Owns" .. HOTDOG.key) then
                deny(Buy)
            elseif t4.gifting then
                giftAsk(Buy, "Limited", table.find(ShopConfig.LIMITED, HOTDOG), HOTDOG.product)
            else
                v616 = true

                local InvokeServer = LimitedAsk.InvokeServer
                local key = HOTDOG.key
                local ok, result = pcall(InvokeServer, LimitedAsk, key)

                v616 = false

                if not ok or result ~= "ok" then
                    deny(Buy)

                    local Show = Toast.Show

                    if not ok or not result then
                        result = "busy"
                    end

                    Show(t94[result] or "Try again in a moment!", "", nil, Toast.RED, "deny")
                else
                    PurchaseFX.Buy(HOTDOG.product)
                end
            end
        end
    end)
    t4.square(Buy, function() -- line: 3251
        -- upvalues: ShopConfig (ref), HOTDOG (copy)
        return "Limited", table.find(ShopConfig.LIMITED, HOTDOG), HOTDOG.product
    end)
end

if t9.card then
    HellEggPanel = t9.card

    for v617, v618 in ipairs(ShopConfig.HELL_EGG) do
        local v619 = HellEggPanel:WaitForChild(v618.button)

        t13[#t13 + 1] = v619

        function dress3() -- line: 3261
            -- upvalues: v1 (ref), dressRestricted (ref), t14 (ref), v618 (copy), v619 (copy)
            local Price = v619.Price
            local v621 = math.floor(t14[v618] or v618.price)

            Price.Text = v1 .. " " .. tostring(v621):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
            dressRestricted()
        end

        dress3()
        table.insert(t15, dress3)
        LocalPlayer:GetAttributeChangedSignal("NoPaidRandom"):Connect(dress3)
        ButtonHover.Attach(v619, (hoverOf(v619)))
        on = v619.Activated
        on:Connect(function() -- line: 3269
            -- upvalues: t4 (ref), v618 (copy), v619 (copy), v617 (copy)
            t4.egg(v619, "HellEgg", v617, v618)
        end)
    end

    local v622 = ShopConfig.HELL_EGG[1]
    local Off = HellEggPanel:WaitForChild("Off")

    Off.AutoLocalize = false

    local function dressOff() -- line: 3276
        -- upvalues: ShopConfig (ref), Loc (ref), t14 (ref), v622 (copy), Off (copy)
        local v623 = t14[v622] or v622.price
        local v624 = ShopConfig.OffOf(v622, v623)

        Off.Visible = v624 > 0
        Off.Text = Loc.F("shop.off", "{n}% Off", {
            n = v624
        })
    end

    dressOff()
    table.insert(t15, dressOff)
end

HellEggPanel = t1:FindFirstChild("HellEggPanel")

if HellEggPanel then
    v7 = require(Modules:WaitForChild("Format")).money

    for _, v625 in ipairs(ShopConfig.HELL_EGG_FISH) do
        RarityStyle2 = HellEggPanel:FindFirstChild("Tiles") and HellEggPanel.Tiles:FindFirstChild(v625.fish)
        on = RarityStyle2 and RarityStyle2:FindFirstChild("Rate")

        if on and v625.rate then
            on.Text = v7(v625.rate) .. "+/s"
        end
    end

    for v626, v627 in ipairs(ShopConfig.HELL_EGG) do
        local v628 = HellEggPanel:FindFirstChild(v627.button)

        if v628 then
            t13[#t13 + 1] = v628

            function dress3() -- line: 3304
                -- upvalues: v1 (ref), dressRestricted (ref), t14 (ref), v627 (copy), v628 (copy)
                local Price = v628.Price
                local v630 = math.floor(t14[v627] or v627.price)

                Price.Text = v1 .. " " .. tostring(v630):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                dressRestricted()
            end

            dress3()
            table.insert(t15, dress3)
            LocalPlayer:GetAttributeChangedSignal("NoPaidRandom"):Connect(dress3)
            ButtonHover.Attach(v628, (hoverOf(v628)))
            on = v628.Activated
            on:Connect(function() -- line: 3312
                -- upvalues: t4 (ref), v627 (copy), v628 (copy), v626 (copy)
                t4.egg(v628, "HellEgg", v626, v627)
            end)
        end
    end

    local Off = HellEggPanel:FindFirstChild("Off")

    if Off then
        Off.AutoLocalize = false

        local v631 = ShopConfig.HELL_EGG[1]

        local function dressPanelOff() -- line: 3320
            -- upvalues: ShopConfig (ref), Loc (ref), t14 (ref), Off (copy), v631 (copy)
            local v632 = ShopConfig.OffOf(v631, t14[v631] or v631.price)

            Off.Visible = v632 > 0
            Off.Text = Loc.F("shop.off", "{n}% Off", {
                n = v632
            })
        end

        dressPanelOff()
        table.insert(t15, dressPanelOff)
    end
end

local VoidsparkEggPanel = t1:FindFirstChild("VoidsparkEggPanel")

local function voidLeft() -- line: 3336
    -- upvalues: ShopConfig (ref)
    return ShopConfig.VOID_EGG_ENDS - workspace:GetServerTimeNow()
end

local v633, v634

if VoidsparkEggPanel then
    v633 = VoidsparkEggPanel:FindFirstChild("Limited") and VoidsparkEggPanel.Limited:FindFirstChild("Timer", true)
    v634 = false
else
    v634 = true
end

local on4, Activated

if not v634 then
    local function clock(p138) -- line: 3341
        local v636 = math.max(0, (math.floor(p138)))
        local v637 = v636 // 86400
        local v638 = v636 % 86400 // 3600
        local v639 = v636 % 3600 // 60
        local v640 = v636 % 60

        if v637 > 0 then
            return string.format("%dd %02dh %02dm %02ds", v637, v638, v639, v640)
        end

        return string.format("%02dh %02dm %02ds", v638, v639, v640)
    end

    if voidLeft() <= 0 then
        setHidden({
            [VoidsparkEggPanel] = true
        })
    else
        money = task.spawn

        local v641 = v633

        money(function() -- line: 3350
            -- upvalues: ShopConfig (ref), Panel (ref), setHidden (ref), VoidsparkEggPanel (copy), clock (copy), v641 (copy)
            while ShopConfig.VOID_EGG_ENDS - workspace:GetServerTimeNow() > 0 do
                if v641 and Panel.Visible then
                    v641.Text = clock(ShopConfig.VOID_EGG_ENDS - workspace:GetServerTimeNow())
                end

                task.wait(1)
            end

            setHidden({
                [VoidsparkEggPanel] = true
            })
        end)
    end

    money = require(Modules:WaitForChild("Format")).money
    RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
    on4 = require(Modules:WaitForChild("FishDisplay"))
    RarityStyle2 = require(Modules:WaitForChild("RarityStyle"))

    for _, v642 in ipairs(ShopConfig.VOID_EGG_FISH) do
        v9 = VoidsparkEggPanel:FindFirstChild("Tiles") and VoidsparkEggPanel.Tiles:FindFirstChild(v642.fish)
        on3 = v9 and v9:FindFirstChild("Rate")

        if on3 and v642.rate then
            on3.Text = money(v642.rate) .. "+/s"
        end

        on3 = v9 and v9:FindFirstChild("Rarity")
        v9 = on4[v642.fish] and on4[v642.fish].rarity
        Activated = v9 and RarityDisplay[v9]

        if on3 and Activated then
            if v9 == "Unknown" then
                on3.TextColor3 = Color3.new(1, 1, 1)
                on3.TextTransparency = 0
                on3.Grad.Color = t10.seq
                on3.Grad.Transparency = NumberSequence.new(0)
                Tiles = on3:FindFirstChildOfClass("UIStroke")

                if Tiles then
                    v8 = t10.INK
                    v10 = t10.STROKE
                    Tiles.Color = v8
                    Tiles.Thickness = v10
                    Tiles.Transparency = 0
                end

                on3:SetAttribute("Flashy", true)
            else
                RarityStyle2.Apply(on3, Activated.color)
            end
        end
    end

    for v643, v644 in ipairs(ShopConfig.VOID_EGG) do
        local v645 = VoidsparkEggPanel:FindFirstChild(v644.button)

        if v645 then
            t13[#t13 + 1] = v645

            function dress4() -- line: 3393
                -- upvalues: v1 (ref), dressRestricted (ref), t14 (ref), v644 (copy), v645 (copy)
                local Price = v645.Price
                local v647 = math.floor(t14[v644] or v644.price)

                Price.Text = v1 .. " " .. tostring(v647):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                dressRestricted()
            end

            dress4()
            table.insert(t15, dress4)
            LocalPlayer:GetAttributeChangedSignal("NoPaidRandom"):Connect(dress4)
            ButtonHover.Attach(v645, (hoverOf(v645)))
            v9 = v645.Activated
            v9:Connect(function() -- line: 3401
                -- upvalues: ShopConfig (ref), t4 (ref), setHidden (ref), deny (ref), VoidsparkEggPanel (copy), v644 (copy), v645 (copy), v643 (copy)
                if ShopConfig.VOID_EGG_ENDS - workspace:GetServerTimeNow() <= 0 then
                    deny(v645)
                    setHidden({
                        [VoidsparkEggPanel] = true
                    })
                else
                    t4.egg(v645, "VoidEgg", v643, v644)
                end
            end)
        end
    end

    for _, v648 in ipairs(ShopConfig.VOID_EGG) do
        local v649 = v648.was and VoidsparkEggPanel:FindFirstChild("Off" .. v648.count)

        if v649 then
            v649.AutoLocalize = false

            local function dressTag() -- line: 3415
                -- upvalues: ShopConfig (ref), Loc (ref), t14 (ref), v648 (copy), v649 (copy)
                local v650 = ShopConfig.OffOf(v648, t14[v648] or v648.price)

                v649.Visible = v650 > 0
                v649.Text = Loc.F("shop.off", "{n}% Off", {
                    n = v650
                })
            end

            dressTag()
            table.insert(t15, dressTag)
        end
    end
end

local AuroraEggPanel = t1:FindFirstChild("AuroraEggPanel")

local function auroraLeft() -- line: 3434
    -- upvalues: ShopConfig (ref)
    return ShopConfig.AURORA_EGG_ENDS - workspace:GetServerTimeNow()
end

local v651

if AuroraEggPanel then
    v651 = AuroraEggPanel:FindFirstChild("Limited") and AuroraEggPanel.Limited:FindFirstChild("Timer", true)
    v634 = false
else
    v634 = true
end

if not v634 then
    local function clock(p139) -- line: 3437
        local v653 = math.max(0, (math.floor(p139)))
        local v654 = v653 // 86400
        local v655 = v653 % 86400 // 3600
        local v656 = v653 % 3600 // 60
        local v657 = v653 % 60

        if v654 > 0 then
            return string.format("%dd %02dh %02dm %02ds", v654, v655, v656, v657)
        end

        return string.format("%02dh %02dm %02ds", v655, v656, v657)
    end

    if auroraLeft() <= 0 then
        v634 = true
    else
        if v651 then
            v651.Text = clock((auroraLeft()))
        end

        v634 = false
    end

    if v634 then
        setHidden({
            [AuroraEggPanel] = true
        })
    else
        on4 = task.spawn

        local v658 = v651

        on4(function() -- line: 3447
            -- upvalues: ShopConfig (ref), Panel (ref), setHidden (ref), AuroraEggPanel (copy), clock (copy), v658 (copy)
            while ShopConfig.AURORA_EGG_ENDS - workspace:GetServerTimeNow() > 0 do
                if v658 and Panel.Visible then
                    v658.Text = clock(ShopConfig.AURORA_EGG_ENDS - workspace:GetServerTimeNow())
                end

                task.wait(1)
            end

            setHidden({
                [AuroraEggPanel] = true
            })
        end)
    end

    on4 = require(Modules:WaitForChild("Format")).money
    RarityStyle2 = require(Modules:WaitForChild("RarityDisplay"))
    on = require(Modules:WaitForChild("FishDisplay"))
    key = require(Modules:WaitForChild("RarityStyle"))

    for _, v659 in ipairs(ShopConfig.AURORA_EGG_FISH) do
        Activated = AuroraEggPanel:FindFirstChild("Tiles") and AuroraEggPanel.Tiles:FindFirstChild(v659.fish)
        Tiles = Activated and Activated:FindFirstChild("Rate")

        if Tiles and v659.rate then
            Tiles.Text = on4(v659.rate) .. "+/s"
        end

        Tiles = Activated and Activated:FindFirstChild("Rarity")
        Activated = on[v659.fish] and on[v659.fish].rarity
        v8 = Activated and RarityStyle2[Activated]

        if Tiles and v8 then
            Tiles.Text = v8.display or Tiles.Text
            key.Apply(Tiles, v8.color)
        end
    end

    for v660, v661 in ipairs(ShopConfig.AURORA_EGG) do
        local v662 = AuroraEggPanel:FindFirstChild(v661.button)

        if v662 then
            t13[#t13 + 1] = v662

            local function dress() -- line: 3475
                -- upvalues: v1 (ref), dressRestricted (ref), t14 (ref), v661 (copy), v662 (copy)
                local Price = v662.Price
                local v664 = math.floor(t14[v661] or v661.price)

                Price.Text = v1 .. " " .. tostring(v664):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                dressRestricted()
            end

            dress()
            table.insert(t15, dress)
            LocalPlayer:GetAttributeChangedSignal("NoPaidRandom"):Connect(dress)
            ButtonHover.Attach(v662, (hoverOf(v662)))
            Activated = v662.Activated
            Activated:Connect(function() -- line: 3483
                -- upvalues: ShopConfig (ref), t4 (ref), setHidden (ref), deny (ref), AuroraEggPanel (copy), v661 (copy), v662 (copy), v660 (copy)
                if ShopConfig.AURORA_EGG_ENDS - workspace:GetServerTimeNow() <= 0 then
                    deny(v662)
                    setHidden({
                        [AuroraEggPanel] = true
                    })
                else
                    t4.egg(v662, "AuroraEgg", v660, v661)
                end
            end)
        end
    end

    for _, v665 in ipairs(ShopConfig.AURORA_EGG) do
        local v666 = v665.was and AuroraEggPanel:FindFirstChild("Off" .. v665.count)

        if v666 then
            v666.AutoLocalize = false

            local function dressTag() -- line: 3497
                -- upvalues: ShopConfig (ref), Loc (ref), t14 (ref), v665 (copy), v666 (copy)
                local v667 = ShopConfig.OffOf(v665, t14[v665] or v665.price)

                v666.Visible = v667 > 0
                v666.Text = Loc.F("shop.off", "{n}% Off", {
                    n = v667
                })
            end

            dressTag()
            table.insert(t15, dressTag)
        end
    end
end

local Cash2x = t1:WaitForChild("Cash2x")
local t95 = {
    title = Cash2x.Title.Text,
    icon = Cash2x.Icon.Image,
    badge = Cash2x.Badge.Text,
    desc = Cash2x.Desc.Text
}

local function cash4Mode(p140) -- line: 3513
    -- upvalues: ShopConfig (ref), LocalPlayer (ref), t4 (ref)
    if p140.key == "Cash2x" then
        return not t4.gifting and LocalPlayer:GetAttribute(ShopConfig.PassAttr("Cash2x")) == true
    end

    return false
end

local function dressCash4(p141) -- line: 3516
    -- upvalues: ShopConfig (ref), Cash2x (copy), t95 (copy)
    local Title = Cash2x.Title

    if p141 then
        Title.Text = "4X CASH"
    else
        Title.Text = t95.title
    end

    Cash2x.Icon.Image = p141 and ShopConfig.CASH4.image or t95.icon

    local Badge = Cash2x.Badge

    if p141 then
        Badge.Text = "x4"
    else
        Badge.Text = t95.badge
    end

    Cash2x.Desc.Text = p141 and t95.desc:gsub("x2", "x4") or t95.desc
end

local function dressPass(p142, p143) -- line: 3523
    -- upvalues: ShopConfig (ref), LocalPlayer (ref), t2 (ref), v1 (ref), t4 (ref), dressRestricted (ref), t14 (ref), dressCash4 (copy)
    if p142.key == "Cash2x" then
        local v668 = p142.key == "Cash2x" and not t4.gifting and LocalPlayer:GetAttribute(ShopConfig.PassAttr("Cash2x")) == true

        dressCash4(v668)

        if v668 then
            local v669 = LocalPlayer:GetAttribute("Cash4x") == true
            local Price = p143.Price

            if v669 then
                Price.Text = "OWNED"
            else
                local CASH4 = ShopConfig.CASH4
                local v671 = math.floor(t14[CASH4] or CASH4.price)

                Price.Text = v1 .. " " .. tostring(v671):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
            end

            p143.ImageTransparency = v669 and t2.CLAIMED_FADE or 0

            local Icon = p143:FindFirstChild("Icon")

            if Icon then
                Icon.ImageTransparency = v669 and t2.CLAIMED_FADE or 0
            end

            return
        end
    end

    local v672 = t4.who:GetAttribute(ShopConfig.PassAttr(p142.key)) == true
    local Price = p143.Price

    if v672 then
        Price.Text = "OWNED"
    else
        local v674 = math.floor(if t4.gifting then t4.price[p142] or p142.price else t14[p142] or p142.price)

        Price.Text = v1 .. " " .. tostring(v674):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    end

    p143.ImageTransparency = v672 and t2.CLAIMED_FADE or 0

    local Icon = p143:FindFirstChild("Icon")

    if Icon then
        Icon.ImageTransparency = v672 and t2.CLAIMED_FADE or 0
    end

    dressRestricted()
end

for v675, v676 in ipairs(ShopConfig.PASSES) do
    local Timer = t1:FindFirstChild(v676.card)
    local Buy = Timer and Timer:FindFirstChild("Buy")

    if Buy then
        ButtonHover.Attach(Buy, (hoverOf(Buy)))
        on3 = t16.on
        on3(Timer, Buy, function() -- line: 3548
            -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), LocalPlayer (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), v676 (copy), Buy (copy), v675 (copy)
            ButtonHover.Press(Buy)

            if v676.perks and v676.perks.luck and (LocalPlayer:GetAttribute("NoPaidRandom") == true or t4.gifting and t4.who:GetAttribute("NoPaidRandom") == true) then
                deny(Buy)
                Toast.Show("This is restricted for your account!", "", nil, Toast.RED, "deny")
            elseif v676.key == "Cash2x" and not t4.gifting and LocalPlayer:GetAttribute(ShopConfig.PassAttr("Cash2x")) == true then
                if LocalPlayer:GetAttribute("Cash4x") == true then
                    deny(Buy)
                else
                    PurchaseFX.Buy(ShopConfig.CASH4.product)
                end
            elseif t4.who:GetAttribute(ShopConfig.PassAttr(v676.key)) then
                deny(Buy)
            elseif t4.gifting then
                giftAsk(Buy, "Pass", v675, v676.gift)
            else
                PurchaseFX.BuyPass(v676.pass)
            end
        end)
        t4.square(Buy, function() -- line: 3559
            -- upvalues: v676 (copy), v675 (copy)
            return "Pass", v675, v676.gift
        end)
        watch({ ShopConfig.PassAttr(v676.key) }, function() -- line: 3560
            -- upvalues: dressPass (copy), v676 (copy), Buy (copy)
            dressPass(v676, Buy)
        end)

        if v676.key == "Cash2x" then
            for _, v677 in ipairs({
                    ShopConfig.PassAttr("Cash2x"),
                    "Cash4x"
                }) do
                Visible = LocalPlayer:GetAttributeChangedSignal(v677)
                Visible:Connect(function() -- line: 3564
                    -- upvalues: dressPass (copy), v676 (copy), Buy (copy)
                    dressPass(v676, Buy)
                end)
            end

            Tiles = function() -- line: 3566
                -- upvalues: dressPass (copy), v676 (copy), Buy (copy)
                dressPass(v676, Buy)
            end

            table.insert(t15, Tiles)
        end

        dressPass(v676, Buy)
    end
end

local Info = t1:WaitForChild("Luck2x"):WaitForChild("Info")

ButtonHover.Attach(Info, {
    tile = 1,
    iconTilt = 20,
    highlight = true,
    highlightCorner = 0.135,
    highlightFade = 0.8,
    icon = Info:WaitForChild("Icon")
})
Info.Activated:Connect(function() -- line: 3574
    -- upvalues: ButtonHover (ref), Odds (ref), Info (copy)
    ButtonHover.Press(Info)
    Odds.Show("LuckInfo", Info)
end)

local function applyRestricted() -- line: 3581
    -- upvalues: ShopConfig (ref), LocalPlayer (ref), t1 (ref), t4 (ref), t13 (ref), dressRestricted (ref), v6 (ref), showStarter (ref), paintPrices (ref), dressPass (copy)
    if LocalPlayer:GetAttribute("NoPaidRandom") == true or t4.gifting and t4.who:GetAttribute("NoPaidRandom") == true then
        dressRestricted()
    else
        for _, v678 in ipairs(t13) do
            local Price = v678:FindFirstChild("Price")

            if v678:IsA("ImageButton") then
                v678.ImageTransparency = 0

                local Icon = v678:FindFirstChild("Icon")

                if Icon then
                    Icon.ImageTransparency = 0
                end
            else
                v678.BackgroundTransparency = 0

                if Price then
                    Price.TextTransparency = 0
                end
            end
        end

        paintPrices()
        v6 = nil
        showStarter()

        for _, v679 in ipairs(ShopConfig.PASSES) do
            local v680 = t1:FindFirstChild(v679.card)

            if v680 and v680:FindFirstChild("Buy") then
                dressPass(v679, v680.Buy)
            end
        end
    end
end

watch({ "NoPaidRandom" }, applyRestricted)
LocalPlayer:GetAttributeChangedSignal("NoPaidRandom"):Connect(applyRestricted)
applyRestricted()

local Format = require(Modules:WaitForChild("Format"))
local TableConfig = require(Modules:WaitForChild("TableConfig"))
local TableDisplay = require(Modules:WaitForChild("TableDisplay"))
local FatDouble = t1:WaitForChild("FatDouble")
local MukbangUp = t1:WaitForChild("MukbangUp")

local function dressFatDouble() -- line: 3619
    -- upvalues: FatDouble (copy)
    FatDouble.Now.Text = "x1"
    FatDouble.Next.Text = "x2"
    FatDouble.Arrow.Visible = true
    FatDouble.NextBurst.Visible = true
end

local Image = MukbangUp.Cash.Image

local function dressMukbang() -- line: 3630
    -- upvalues: ShopConfig (ref), LocalPlayer (ref), v1 (ref), t4 (ref), t14 (ref), Format (copy), TableConfig (copy), TableDisplay (copy), MukbangUp (copy), Image (copy)
    local v681 = t4.who:GetAttribute("TableLevel") or 1
    local v682 = TableConfig.UpgradeCost(v681)
    local Cash = MukbangUp.Cash

    if not (v682 and (LocalPlayer:GetAttribute("Cash") or 0) < v682) then
        Cash.Image = Image
    else
        Cash.Image = "rbxassetid://77662203959363"
    end

    MukbangUp.Now.Image = TableDisplay.Icon(v681)
    MukbangUp.Next.Image = v682 and TableDisplay.Icon(v681 + 1) or ""
    MukbangUp.Arrow.Visible = v682 ~= nil
    MukbangUp.Cash.Price.Text = v682 and Format.money(v682) or "MAX"

    local v683 = ShopConfig.TABLES[v681 + 1]
    local Price = MukbangUp.Robux.Price
    local v684, v685

    if v683 then
        local v687 = math.floor(t14[v683] or v683.price)
        local v688 = v1 .. " " .. tostring(v687):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")

        if v688 then
            v684 = v688
            v685 = true
        else
            v685 = false
        end
    else
        v685 = false
    end

    Price.Text = if not v685 then "MAX" else v684

    return v682
end

watch({ "TableLevel" }, dressMukbang)
LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(dressMukbang)
dressFatDouble()
dressMukbang()

for _, v689 in ipairs({
        MukbangUp.Robux,
        MukbangUp.Cash
    }) do
    ButtonHover.Attach(v689, (hoverOf(v689)))
end

MukbangUp.Robux.Activated:Connect(function() -- line: 3651
    -- upvalues: ButtonHover (ref), ShopConfig (ref), PurchaseFX (ref), t4 (ref), deny (ref), giftAsk (ref), MukbangUp (copy)
    ButtonHover.Press(MukbangUp.Robux)

    local v690 = (t4.who:GetAttribute("TableLevel") or 1) + 1
    local v691 = ShopConfig.TABLES[v690]

    if v691 then
        if t4.gifting then
            giftAsk(MukbangUp.Robux, "Table", v690, v691.product)
        else
            PurchaseFX.Buy(v691.product)
        end
    else
        deny(MukbangUp.Robux)
    end
end)
t4.square(MukbangUp.Robux, function(p144) -- line: 3658
    -- upvalues: ShopConfig (ref)
    local v692 = (p144:GetAttribute("TableLevel") or 1) + 1
    local v693 = ShopConfig.TABLES[v692]

    return "Table", v692, v693 and v693.product
end)
table.insert(t15, dressMukbang)

local TableUpgrade = Remotes:WaitForChild("TableUpgrade")

MukbangUp.Cash.Activated:Connect(function() -- line: 3661
    -- upvalues: ButtonHover (ref), LocalPlayer (ref), Toast (ref), t4 (ref), deny (ref), MukbangUp (copy), dressMukbang (copy), TableUpgrade (copy)
    if t4.gifting then
        return
    end

    ButtonHover.Press(MukbangUp.Cash)

    local v694 = dressMukbang()

    if v694 then
        if (LocalPlayer:GetAttribute("Cash") or 0) < v694 then
            deny(MukbangUp.Cash)
            Toast.Show("Not enough cash!", "", nil, Toast.RED, "deny")
        else
            TableUpgrade:FireServer()
        end
    else
        deny(MukbangUp.Cash)
    end
end)

local PassPerks = require(Modules:WaitForChild("PassPerks"))
local t96 = {}
local Changed

for _, v695 in ipairs({
        {
            ShopConfig.FAT_TIME,
            true
        },
        {
            ShopConfig.CASH_TIME,
            false
        }
    }) do
    for v696, v697 in ipairs(v695[1]) do
        Changed = t1:FindFirstChild(v697.card)
        on2 = Changed and Changed:FindFirstChild("Buy")

        if on2 then
            t96[#t96 + 1] = {
                row = v697,
                card = Changed,
                buy = on2,
                fat = v695[2],
                i = v696
            }
        end
    end
end

local function timeAmount(p145) -- line: 3689
    -- upvalues: ShopConfig (ref), t4 (ref), PassPerks (copy)
    if p145.fat then
        return ShopConfig.FatFor(p145.row, t4.who:GetAttribute("TableLevel") or 1, PassPerks.FatMul(t4.who))
    end

    return ShopConfig.CashFor(p145.row, t4.who:GetAttribute("PenRate") or 0)
end

local function dressTime() -- line: 3695
    -- upvalues: t2 (ref), v1 (ref), t14 (ref), Format (copy), t96 (copy), timeAmount (copy)
    for _, v698 in ipairs(t96) do
        local v699 = timeAmount(v698)

        v698.card.Title.Text = v698.fat and "+" .. Format.short(v699) or Format.money(v699)

        local v700 = v699 <= 0

        v698.buy.ImageTransparency = v700 and t2.CLAIMED_FADE or 0
        v698.buy.Price.TextTransparency = v700 and t2.CLAIMED_FADE or 0

        local Price = v698.buy.Price
        local row = v698.row
        local v702 = math.floor(t14[row] or row.price)

        Price.Text = v1 .. " " .. tostring(v702):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    end
end

watch({
    "TableLevel",
    ShopConfig.PassAttr("Fat2x"),
    "PenRate"
}, dressTime)
table.insert(t15, dressTime)
dressTime()

local function centrePair(p146) -- line: 3710
    local X = p146.AbsoluteSize.X

    if X <= 0 then
        return
    end

    local v703 = p146.Icon.AbsoluteSize.X / X
    local v704 = p146.Title.TextBounds.X / X
    local v705 = (1 - (v703 + 0.03 + v704)) / 2

    p146.Icon.Position = UDim2.fromScale(v705 + v703 / 2, p146.Icon.Position.Y.Scale)
    p146.Title.Position = UDim2.fromScale(v705 + v703 + 0.03, p146.Title.Position.Y.Scale)
end

local v706

for _, v707 in ipairs(t96) do
    local card = v707.card

    v706 = card.Title:GetPropertyChangedSignal("TextBounds")
    v706:Connect(function() -- line: 3720
        -- upvalues: centrePair (copy), card (copy)
        centrePair(card)
    end)
    v706 = card:GetPropertyChangedSignal("AbsoluteSize")
    v706:Connect(function() -- line: 3721
        -- upvalues: centrePair (copy), card (copy)
        centrePair(card)
    end)
    centrePair(card)
end

local v708

for _, v709 in ipairs(t96) do
    ButtonHover.Attach(v709.buy, (hoverOf(v709.buy)))
    v706 = t16.on
    v708 = v709.card
    Visible2 = v709.buy
    v706(v708, Visible2, function() -- line: 3727
        -- upvalues: ButtonHover (ref), PurchaseFX (ref), t4 (ref), deny (ref), giftAsk (ref), timeAmount (copy), v709 (copy)
        if timeAmount(v709) <= 0 then
            ButtonHover.Press(v709.buy)
            deny(v709.buy)
        elseif t4.gifting then
            ButtonHover.Press(v709.buy)
            giftAsk(v709.buy, v709.fat and "FatTime" or "CashTime", v709.i, v709.row.product)
        else
            local buy = v709.buy
            local product = v709.row.product

            ButtonHover.Press(buy)
            PurchaseFX.Buy(product)
        end
    end)
    v706 = t4.square
    v708 = v709.buy
    v706(v708, function() -- line: 3736
        -- upvalues: v709 (copy)
        return if v709.fat then "FatTime" else "CashTime", v709.i, v709.row.product
    end)
end

for v710, v711 in ipairs(ShopConfig.KEYS) do
    v706 = t1:FindFirstChild(v711.card)

    local Buy = v706 and v706:FindFirstChild("Buy")

    if Buy then
        Visible2 = v706:FindFirstChild("Amount")

        if Visible2 then
            Visible2.Text = "+" .. v711.count
        end

        ButtonHover.Attach(Buy, (hoverOf(Buy)))
        Changed = t16.on
        Changed(v706, Buy, function() -- line: 3746
            -- upvalues: ButtonHover (ref), PurchaseFX (ref), LocalPlayer (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), v711 (copy), Buy (copy), v710 (copy)
            if LocalPlayer:GetAttribute("NoPaidRandom") == true or t4.gifting and t4.who:GetAttribute("NoPaidRandom") == true then
                ButtonHover.Press(Buy)
                deny(Buy)
                Toast.Show("This is restricted for your account!", "", nil, Toast.RED, "deny")
            elseif t4.gifting then
                ButtonHover.Press(Buy)
                giftAsk(Buy, "Keys", v710, v711.product)
            else
                local product = v711.product

                ButtonHover.Press(Buy)
                PurchaseFX.Buy(product)
            end
        end)
        t4.square(Buy, function() -- line: 3755
            -- upvalues: v711 (copy), v710 (copy)
            return "Keys", v710, v711.product
        end)
    end
end

local t97 = {}

for v712, v713 in ipairs(ShopConfig.TOKENS) do
    v708 = t1:FindFirstChild(v713.card)

    local Buy = v708 and v708:FindFirstChild("Buy")

    if Buy then
        v708.Title.Text = "+" .. commas(v713.tokens)
        v708.Icon.Image = ShopConfig.TOKEN_ICON
        t97[#t97 + 1] = {
            row = v713,
            card = v708,
            buy = Buy
        }
        ButtonHover.Attach(Buy, (hoverOf(Buy)))
        Changed = t16.on
        Changed(v708, Buy, function() -- line: 3771
            -- upvalues: ButtonHover (ref), PurchaseFX (ref), Toast (ref), t4 (ref), deny (ref), giftAsk (ref), v713 (copy), Buy (copy), v712 (copy)
            if v713.product then
                if t4.gifting then
                    ButtonHover.Press(Buy)
                    giftAsk(Buy, "Tokens", v712, v713.product)
                else
                    local product = v713.product

                    ButtonHover.Press(Buy)
                    PurchaseFX.Buy(product)
                end
            else
                ButtonHover.Press(Buy)
                deny(Buy)
                Toast.Show("Coming soon!", "", nil, Toast.RED, "deny")
            end
        end)

        if v713.product then
            Changed = t4.square
            Changed(Buy, function() -- line: 3785
                -- upvalues: v713 (copy), v712 (copy)
                return "Tokens", v712, v713.product
            end)
        end
    end
end

local function dressTokens() -- line: 3788
    -- upvalues: v1 (ref), t14 (ref), t97 (copy)
    for _, v714 in ipairs(t97) do
        local Price = v714.buy.Price
        local v715

        if v714.row.product then
            local row = v714.row

            v715 = tostring((math.floor(t14[row] or row.price))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") or "?"
        else
            v715 = "?"
        end

        Price.Text = v1 .. " " .. v715
    end
end

table.insert(t15, dressTokens)
dressTokens()

local function centrePair2(p147) -- line: 3796
    local X = p147.AbsoluteSize.X

    if X <= 0 then
        return
    end

    local v718 = p147.Icon.AbsoluteSize.X / X
    local v719 = p147.Title.TextBounds.X / X
    local v720 = (1 - (v718 + 0.03 + v719)) / 2

    p147.Icon.Position = UDim2.fromScale(v720 + v718 / 2, p147.Icon.Position.Y.Scale)
    p147.Title.Position = UDim2.fromScale(v720 + v718 + 0.03, p147.Title.Position.Y.Scale)
end

for _, v721 in ipairs(t97) do
    local card = v721.card

    Changed = card.Title:GetPropertyChangedSignal("TextBounds")
    Changed:Connect(function() -- line: 3806
        -- upvalues: centrePair2 (copy), card (copy)
        centrePair2(card)
    end)
    Changed = card:GetPropertyChangedSignal("AbsoluteSize")
    Changed:Connect(function() -- line: 3807
        -- upvalues: centrePair2 (copy), card (copy)
        centrePair2(card)
    end)
    centrePair2(card)
end

local DonateButton = Main:WaitForChild("DonateButton")

ButtonHover.Attach(DonateButton, {
    tile = 1,
    iconTilt = -20,
    highlight = true,
    highlightCorner = 0.3,
    highlightFade = 0.75,
    icon = DonateButton:FindFirstChild("Icon")
})
DonateButton.Activated:Connect(function() -- line: 3818
    -- upvalues: ButtonHover (ref), t4 (ref), v2 (ref), firstBuy (ref), showPage (ref), InputMode (ref), GuiService (ref), DonateButton (copy)
    ButtonHover.Press(DonateButton)

    if not t4.gifting then
        showPage("Donate")

        if InputMode.Pad() then
            local defer = task.defer
            local v722 = "Donate"

            defer(function() -- line: 906
                -- upvalues: v722 (copy), v2 (ref), firstBuy (ref), GuiService (ref)
                local v723 = v2 and firstBuy(v722)

                if v723 then
                    GuiService.SelectedObject = v723
                end
            end)
        end
    end
end)

for _, v724 in ipairs(ShopConfig.DONATIONS) do
    v708 = t1:FindFirstChild(v724.card)

    local Buy = v708 and v708:FindFirstChild("Buy")

    if Buy then
        Buy.Price.Text = v1 .. " " .. commas(v724.price)
        ButtonHover.Attach(Buy, (hoverOf(Buy)))
        Changed = t16.on
        Changed(v708, Buy, function() -- line: 3830
            -- upvalues: ButtonHover (ref), PurchaseFX (ref), t4 (ref), v724 (copy), Buy (copy)
            if t4.gifting then
                return
            end

            local product = v724.product

            ButtonHover.Press(Buy)
            PurchaseFX.Buy(product)
        end)
    end
end

paintPrices()

local RewardCards = require(Modules:WaitForChild("RewardCards"))

local function rewardCard(p148) -- line: 3842
    -- upvalues: t3 (ref), RewardCards (copy)
    if p148.pass then
        return {
            setup = function(p149) -- setup | line: 3845
                -- upvalues: p148 (copy), t3 (ref)
                local Icon = p149.Main.Icon

                if p148.pass then
                    local v725 = t3[p148.pass] or ""

                    if type(v725) == "table" then
                        Icon.Image = v725[1]
                        Icon.ImageRectOffset = Vector2.new(v725[2], v725[3])
                        Icon.ImageRectSize = Vector2.new(v725[4], v725[5])
                    else
                        Icon.Image = v725
                        Icon.ImageRectOffset = Vector2.zero
                        Icon.ImageRectSize = Vector2.zero
                    end

                    p149.Main.Title.Text = p148.title
                    p149.Main.Rarity.Text = "UNLOCKED"
                end
            end
        }
    end

    return RewardCards.Card(p148)
end

function t7.ultCards(p150) -- line: 3865
    -- upvalues: ShopConfig (ref), Format (copy), rewardCard (copy)
    local function art(p151, p152, p153) -- line: 3866
        return {
            setup = function(p154) -- setup | line: 3867
                -- upvalues: p151 (copy), p152 (copy), p153 (copy)
                p154.Main.Icon.Image = p151

                local Icon, Icon2 = p154.Main.Icon, p154.Main.Icon
                local zero, zero2 = Vector2.zero, Vector2.zero

                Icon.ImageRectOffset = zero
                Icon2.ImageRectSize = zero2
                p154.Main.Title.Text = p152
                p154.Main.Rarity.Text = p153
            end
        }
    end

    local v726 = p150.image or ShopConfig.ULTIMATE.image
    local v727 = "Unicorn Floaty"
    local v728 = "EXCLUSIVE"
    local t101 = {
        setup = function(p155) -- setup | line: 3867
            -- upvalues: v726 (copy), v727 (copy), v728 (copy)
            p155.Main.Icon.Image = v726

            local Icon, Icon2 = p155.Main.Icon, p155.Main.Icon
            local zero, zero2 = Vector2.zero, Vector2.zero

            Icon.ImageRectOffset = zero
            Icon2.ImageRectSize = zero2
            p155.Main.Title.Text = v727
            p155.Main.Rarity.Text = v728
        end
    }
    local v729 = rewardCard({
        pass = "VIP",
        title = "VIP"
    })
    local v730 = rewardCard({
        pass = "XP2x",
        title = "2X XP"
    })
    local v731 = "+" .. Format.money(p150.amount or ShopConfig.ULTIMATE.cash)
    local v732 = "rbxassetid://117252679272986"
    local v733 = "Cash"
    local t102 = {
        setup = function(p156) -- setup | line: 3867
            -- upvalues: v731 (copy), v732 (copy), v733 (copy)
            p156.Main.Icon.Image = v732

            local Icon, Icon2 = p156.Main.Icon, p156.Main.Icon
            local zero, zero2 = Vector2.zero, Vector2.zero

            Icon.ImageRectOffset = zero
            Icon2.ImageRectSize = zero2
            p156.Main.Title.Text = v733
            p156.Main.Rarity.Text = v731
        end
    }
    local fat = p150.fat
    local t103

    if fat then
        local v734 = "+" .. Format.short(p150.fat)

        t103 = {}

        local v735 = "rbxassetid://135825676122341"
        local v736 = "Fat"

        function t103.setup(p157) -- line: 3867
            -- upvalues: v734 (copy), v735 (copy), v736 (copy)
            p157.Main.Icon.Image = v735

            local Icon, Icon2 = p157.Main.Icon, p157.Main.Icon
            local zero, zero2 = Vector2.zero, Vector2.zero

            Icon.ImageRectOffset = zero
            Icon2.ImageRectSize = zero2
            p157.Main.Title.Text = v736
            p157.Main.Rarity.Text = v734
        end
    end

    if not fat or not t103 then
        t103 = nil
    end

    local t100 = {
        t101,
        v729,
        v730,
        t102,
        t103
    }
    local t104 = {}

    for i = 1, 5 do
        if t100[i] then
            t104[#t104 + 1] = t100[i]
        end
    end

    t104[#t104 + 1] = rewardCard({
        xp = p150.xp or ShopConfig.ULTIMATE.xp
    })

    if p150.key then
        t104[#t104 + 1] = rewardCard({
            key = p150.key,
            count = p150.keys or 1
        })
    end

    return t104
end

local v738 = false

local function celebrate(p158, p159) -- line: 3890
    -- upvalues: Modules (ref), ShopConfig (ref), RewardScreen (ref), PurchaseFX (ref), t1 (ref), t6 (ref), t7 (ref), ServerLuck (ref), Format (copy), rewardCard (copy), v738 (ref)
    PurchaseFX.Success()

    if v738 then
        return
    end

    v738 = true

    local v739 = {}

    if (p158 == "Starter" or p158 == "Keys" or p158 == "PotionPack") and type(p159) == "table" and type(p159.rewards) == "table" then
        for _, v741 in ipairs(p159.rewards) do
            v739[#v739 + 1] = rewardCard(v741)
        end
    elseif p158 == "BaitBundle" and type(p159) == "table" and type(p159.rewards) == "table" then
        local BaitConfig = require(Modules:WaitForChild("BaitConfig"))
        local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
        local t106 = {}

        for _, v743 in ipairs({
                BaitConfig.ALWAYS,
                BaitConfig.POOL,
                BaitConfig.UNKNOWN
            }) do
            for _, v744 in ipairs(v743) do
                t106[v744.id] = v744
            end
        end

        for _, v745 in ipairs(p159.rewards) do
            local v746 = t106[v745.bait]
            local v747 = v746 and FishDisplay[v746.catches]

            v739[#v739 + 1] = {
                setup = function(p160) -- setup | line: 3907
                    -- upvalues: v745 (copy), v746 (copy), v747 (copy)
                    p160.Main.Icon.Image = v747 and v747.icon or ""

                    local Icon, Icon2 = p160.Main.Icon, p160.Main.Icon
                    local zero, zero2 = Vector2.zero, Vector2.zero

                    Icon.ImageRectOffset = zero
                    Icon2.ImageRectSize = zero2
                    p160.Main.Title.Text = v746 and v746.name or v745.bait
                    p160.Main.Rarity.Text = "x" .. (v745.count or 1)
                end
            }
        end
    elseif p158 == "ServerLuck" and type(p159) == "table" then
        local Icon = ServerLuck:FindFirstChild("Icon")

        v739[1] = {
            setup = function(p161) -- setup | line: 3917
                -- upvalues: p159 (copy), Icon (copy)
                p161.Main.Icon.Image = Icon and Icon.Image or ""

                local Icon2, Icon3 = p161.Main.Icon, p161.Main.Icon
                local zero, zero2 = Vector2.zero, Vector2.zero

                Icon2.ImageRectOffset = zero
                Icon3.ImageRectSize = zero2
                p161.Main.Title.Text = "X3 SERVER SPAWN LUCK"
                p161.Main.Rarity.Text = "+" .. math.floor((p159.secs or 0) / 60) .. " MIN"
            end
        }
    elseif p158 == "Limited" and type(p159) == "table" and p159.fish then
        local v750 = require(Modules:WaitForChild("FishDisplay"))[p159.fish]

        v739[1] = {
            setup = function(p162) -- setup | line: 3926
                -- upvalues: p159 (copy), v750 (copy)
                local Icon = p162.Main.Icon
                local image = p159.image
                local v751, v752

                if image then
                    v751 = image
                    v752 = true
                elseif v750 then
                    local icon = v750.icon

                    if icon then
                        v751 = icon
                        v752 = true
                    else
                        v752 = false
                    end
                else
                    v752 = false
                end

                Icon.Image = if not v752 then "" else v751

                local Icon2, Icon3 = p162.Main.Icon, p162.Main.Icon
                local zero, zero2 = Vector2.zero, Vector2.zero

                Icon2.ImageRectOffset = zero
                Icon3.ImageRectSize = zero2
                p162.Main.Title.Text = p159.title or ""
                p162.Main.Rarity.Text = p159.word or "EXCLUSIVE"
            end
        }
    elseif p158 == "Limited" and type(p159) == "table" then
        local Art = t6.card.Art

        for _, v753 in ipairs(ShopConfig.LIMITED) do
            local v754 = v753.harpoon == p159.harpoon and t1:FindFirstChild(v753.card)

            if v754 and v754:FindFirstChild("Art") then
                Art = v754.Art
            end
        end

        v739[1] = {
            setup = function(p163) -- setup | line: 3940
                -- upvalues: p159 (copy), Art (ref)
                p163.Main.Icon.Image = Art.Image

                local Icon, Icon2 = p163.Main.Icon, p163.Main.Icon
                local ImageRectOffset, ImageRectSize = Art.ImageRectOffset, Art.ImageRectSize

                Icon.ImageRectOffset = ImageRectOffset
                Icon2.ImageRectSize = ImageRectSize
                p163.Main.Title.Text = p159.title or ""
                p163.Main.Rarity.Text = "EXCLUSIVE"
            end
        }
    elseif (p158 == "Hydra" or p158 == "HydraUp" or p158 == "AdminFish") and type(p159) == "table" then
        local v755 = require(Modules:WaitForChild("FishDisplay"))[p159.fish]

        v739[1] = {
            setup = function(p164) -- setup | line: 3951
                -- upvalues: p159 (copy), v755 (copy)
                local Icon = p164.Main.Icon
                local image = p159.image
                local v756, v757

                if image then
                    v756 = image
                    v757 = true
                elseif v755 then
                    local icon = v755.icon

                    if icon then
                        v756 = icon
                        v757 = true
                    else
                        v757 = false
                    end
                else
                    v757 = false
                end

                Icon.Image = if not v757 then "" else v756

                local Icon2, Icon3 = p164.Main.Icon, p164.Main.Icon
                local zero, zero2 = Vector2.zero, Vector2.zero

                Icon2.ImageRectOffset = zero
                Icon3.ImageRectSize = zero2
                p164.Main.Title.Text = p159.title or ""
                p164.Main.Rarity.Text = p159.word or "EXCLUSIVE"
            end
        }
    elseif p158 == "BonePack" and type(p159) == "table" then
        local v758 = p159.fish and require(Modules:WaitForChild("FishDisplay"))[p159.fish]
        local v759 = p159.harpoon and require(Modules:WaitForChild("HarpoonSkins")).Get(p159.harpoon)

        if v758 then
            v739[#v739 + 1] = {
                setup = function(p165) -- setup | line: 3963
                    -- upvalues: p159 (copy), v758 (copy), Format (copy)
                    p165.Main.Icon.Image = p159.image or v758.icon or ""

                    local Icon, Icon2 = p165.Main.Icon, p165.Main.Icon
                    local zero, zero2 = Vector2.zero, Vector2.zero

                    Icon.ImageRectOffset = zero
                    Icon2.ImageRectSize = zero2
                    p165.Main.Title.Text = p159.mutation and string.upper(p159.mutation) .. " " .. v758.display or v758.display
                    p165.Main.Rarity.Text = p159.rate and Format.money(p159.rate) .. "/s" or "EXCLUSIVE"
                end
            }
        end

        if v759 then
            v739[#v739 + 1] = {
                setup = function(p166) -- setup | line: 3971
                    -- upvalues: v759 (copy)
                    p166.Main.Icon.Image = v759.icon or ""

                    local Icon, Icon2 = p166.Main.Icon, p166.Main.Icon
                    local zero, zero2 = Vector2.zero, Vector2.zero

                    Icon.ImageRectOffset = zero
                    Icon2.ImageRectSize = zero2
                    p166.Main.Title.Text = v759.name
                    p166.Main.Rarity.Text = string.upper(v759.rarity) .. " HARPOON"
                end
            }
        end

        if p159.xp then
            v739[#v739 + 1] = rewardCard({
                xp = p159.xp
            })
        end
    elseif p158 == "Cash4x" and type(p159) == "table" then
        v739[1] = {
            setup = function(p167) -- setup | line: 3981
                -- upvalues: p159 (copy)
                p167.Main.Icon.Image = p159.image or ""

                local Icon, Icon2 = p167.Main.Icon, p167.Main.Icon
                local zero, zero2 = Vector2.zero, Vector2.zero

                Icon.ImageRectOffset = zero
                Icon2.ImageRectSize = zero2
                p167.Main.Title.Text = p159.title or ""
                p167.Main.Rarity.Text = "UNLOCKED"
            end
        }
    elseif (p158 == "Pass" or p158 == "GiftPass") and type(p159) == "table" then
        v739[1] = rewardCard({
            pass = p159.key or p159.pass,
            title = p159.title
        })
    elseif p158 == "Ultimate" and type(p159) == "table" then
        v739 = t7.ultCards(p159)
    elseif p158 ~= "Tokens" or type(p159) ~= "table" then
        if p158 == "Donation" and type(p159) == "table" then
            v739[1] = {
                setup = function(p168) -- setup | line: 4002
                    -- upvalues: p159 (copy), ShopConfig (ref)
                    p168.Main.Icon.Image = ShopConfig.DONATE_ICON

                    local Icon, Icon2 = p168.Main.Icon, p168.Main.Icon
                    local zero, zero2 = Vector2.zero, Vector2.zero

                    Icon.ImageRectOffset = zero
                    Icon2.ImageRectSize = zero2
                    p168.Main.Title.Text = tostring((math.floor(p159.amount or 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. " ROBUX"
                    p168.Main.Rarity.Text = "DONATED"
                end
            }
        end
    else
        v739[1] = {
            setup = function(p169) -- setup | line: 3994
                -- upvalues: p159 (copy), ShopConfig (ref)
                p169.Main.Icon.Image = ShopConfig.TOKEN_ICON

                local Icon, Icon2 = p169.Main.Icon, p169.Main.Icon
                local zero, zero2 = Vector2.zero, Vector2.zero

                Icon.ImageRectOffset = zero
                Icon2.ImageRectSize = zero2
                p169.Main.Title.Text = "+" .. tostring((math.floor(p159.amount or 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
                p169.Main.Rarity.Text = "HARPOON TOKENS"
            end
        }
    end

    if #v739 > 0 then
        RewardScreen.Show(v739, nil, "THANK YOU!")
    end

    v738 = false
end

local function celebrateFree(p170) -- line: 4013
    -- upvalues: RewardScreen (ref), PurchaseFX (ref), rewardCard (copy)
    PurchaseFX.Success()

    local t118 = {}

    for _, v766 in ipairs(p170) do
        t118[#t118 + 1] = rewardCard(v766)
    end

    RewardScreen.Show(t118)
end

Remotes:WaitForChild("PurchaseGranted").OnClientEvent:Connect(function(p171, p172) -- line: 4019
    -- upvalues: ShopConfig (ref), celebrate (copy)
    if p171 ~= "Crate" and p171 ~= "Bait" and not ShopConfig.EGGS[p171] and p171 ~= "EggBundle" and p171 ~= "ZoneRush" and p171 ~= "Recover" and p171 ~= "MutationUpgrade" and p171 ~= "Pumpkin" and p171 ~= "Turkey" and p171 ~= "CompactorRush" then
        task.spawn(celebrate, p171, p172)
    end
end)

local Buy4 = FreeReward:WaitForChild("Buy")
local ShopFreeClaim = Remotes:WaitForChild("ShopFreeClaim")

local function freeClaimed() -- line: 4037
    -- upvalues: LocalPlayer (ref)
    if LocalPlayer:GetAttribute("ShopUnlocked") == true then
        return not LocalPlayer:GetAttribute("ShopFreeReady")
    end

    return false
end

local function dressFree() -- line: 4038
    -- upvalues: LocalPlayer (ref), t2 (ref), t4 (ref), FreeReward (ref), setHidden (ref), Buy4 (copy)
    local v767 = LocalPlayer:GetAttribute("ShopUnlocked") == true and not LocalPlayer:GetAttribute("ShopFreeReady")

    Buy4.Price.Text = v767 and "CLAIMED" or "FREE"
    Buy4.ImageTransparency = v767 and t2.CLAIMED_FADE or 0

    local Icon = Buy4:FindFirstChild("Icon")

    if Icon then
        Icon.ImageTransparency = v767 and t2.CLAIMED_FADE or 0
    end

    local t119 = {
        [FreeReward] = v767 or t4.gifting
    }

    setHidden(t119)
end

local v768 = false

ButtonHover.Attach(Buy4, (hoverOf(Buy4)))
t16.on(FreeReward, Buy4, function() -- line: 4048
    -- upvalues: ButtonHover (ref), LocalPlayer (ref), deny (ref), celebrateFree (copy), Buy4 (copy), ShopFreeClaim (copy), v768 (ref)
    ButtonHover.Press(Buy4)

    if not v768 then
        if LocalPlayer:GetAttribute("ShopFreeReady") then
            v768 = true

            local function v769() -- line: 4053
                -- upvalues: ShopFreeClaim (copy)
                return ShopFreeClaim:InvokeServer()
            end

            local ok, result = pcall(v769)

            if ok and type(result) == "table" and #result > 0 then
                celebrateFree(result)
            else
                deny(Buy4)
            end

            v768 = false
        else
            deny(Buy4)
        end
    end
end)

local v770 = Badge.Attach(Button, {
    icon = Button:FindFirstChild("Icon"),
    at = Vector2.new(0.9, 0.1)
})
local v771 = Badge.Attach(FreeReward, {
    text = "!",
    size = 0.34,
    zIndex = 10,
    at = Vector2.new(0.965, 0.1)
})

local function refreshBadge() -- line: 4063
    -- upvalues: LocalPlayer (ref), dressFree (copy), v770 (copy), v771 (copy)
    dressFree()
    v771.Set(LocalPlayer:GetAttribute("ShopFreeReady") and 1 or 0)

    if LocalPlayer:GetAttribute("ShopUnlocked") then
        v770.Set((not LocalPlayer:GetAttribute("ShopFreeReady") or LocalPlayer:GetAttribute("ShopOpened")) and 0 or 1)
    else
        v770.Set(0)
    end
end

for _, v772 in ipairs({ "ShopUnlocked", "ShopFreeReady", "ShopOpened" }) do
    LocalPlayer:GetAttributeChangedSignal(v772):Connect(refreshBadge)
end

refreshBadge()

local function viewAt(p173) -- line: 4080
    -- upvalues: t4 (ref), v6 (ref), paintPrices (ref)
    for _, v773 in ipairs(t4.conns) do
        v773:Disconnect()
    end

    table.clear(t4.conns)
    t4.who = p173
    v6 = nil

    for _, v774 in ipairs(t4.watchers) do
        for _, v775 in ipairs(v774[1]) do
            t4.conns[#t4.conns + 1] = p173:GetAttributeChangedSignal(v775):Connect(v774[2])
        end
    end

    for _, v776 in ipairs(t4.watchers) do
        v776[2]()
    end

    paintPrices()
end

local function look(p174, p175, p176) -- line: 4093
    -- upvalues: t4 (ref)
    if p174 then
        t4.looks[#t4.looks + 1] = {
            p174,
            p175,
            p174[p175],
            p176
        }
    end
end

local function inkLook(p177) -- line: 4096
    -- upvalues: t4 (ref)
    if not p177 then
        return
    end

    local UIStroke = p177:FindFirstChildOfClass("UIStroke")
    local stroke = t4.INK.stroke

    if UIStroke then
        t4.looks[#t4.looks + 1] = {
            UIStroke,
            "Color",
            UIStroke.Color,
            stroke
        }
    end

    local UIGradient = p177:FindFirstChildOfClass("UIGradient")
    local grad = t4.INK.grad

    if UIGradient then
        t4.looks[#t4.looks + 1] = {
            UIGradient,
            "Color",
            UIGradient.Color,
            grad
        }
    end

    local rot = t4.INK.rot

    if UIGradient then
        t4.looks[#t4.looks + 1] = {
            UIGradient,
            "Rotation",
            UIGradient.Rotation,
            rot
        }
    end
end

local function plateLook(p178) -- line: 4104
    -- upvalues: t4 (ref), inkLook (copy)
    local v777 = t4.PLATE[1]

    if p178 then
        t4.looks[#t4.looks + 1] = {
            p178,
            "Image",
            p178.Image,
            v777
        }
    end

    local v778 = t4.PLATE[2]

    if p178 then
        t4.looks[#t4.looks + 1] = {
            p178,
            "ImageRectOffset",
            p178.ImageRectOffset,
            v778
        }
    end

    local v779 = t4.PLATE[3]

    if p178 then
        t4.looks[#t4.looks + 1] = {
            p178,
            "ImageRectSize",
            p178.ImageRectSize,
            v779
        }
    end

    local Icon = p178:FindFirstChild("Icon")
    local ICON = t4.ICON

    if Icon then
        t4.looks[#t4.looks + 1] = {
            Icon,
            "Image",
            Icon.Image,
            ICON
        }
    end

    inkLook(p178:FindFirstChild("Price"))
    inkLook(p178:FindFirstChild("Label"))
end

plateLook(StarterPack.Buy)

local card2

for _, v780 in ipairs(ShopConfig.PASSES) do
    card2 = t1:FindFirstChild(v780.card)

    if card2 and card2:FindFirstChild("Buy") then
        plateLook(card2.Buy)
    end
end

plateLook(FatDouble.Buy)
plateLook(MukbangUp.Robux)

for _, child in ipairs(t1:GetChildren()) do
    card2 = if child.Name:match("^Key_") or child.Name:match("^Fat_") or child.Name:match("^Cash_") then child:FindFirstChild("Buy") else child.Name:match("^Token_") and child:FindFirstChild("Buy")

    if card2 then
        look(card2, "BackgroundColor3", t4.TAB)
        look(card2:FindFirstChildOfClass("UIStroke"), "Color", t4.INK.stroke)
        inkLook(card2:FindFirstChild("Price"))
    end
end

look(MukbangUp.Cash, "Visible", false)
look(TopTabs:WaitForChild("Gift"), "Visible", false)
look(Main:WaitForChild("DonateButton"), "Visible", false)

local GiftingFor = Panel:WaitForChild("GiftingFor")

look(GiftingFor, "Visible", true)

for _, v781 in ipairs(t4.squares) do
    look(v781, "Visible", false)
    card2 = v781.Parent

    local GiftShift = v781.Parent:GetAttribute("GiftShift")

    if GiftShift then
        look(card2, "Position", card2.Position - UDim2.fromScale(GiftShift, 0))
    end
end

local function dressGift(p179) -- line: 4143
    -- upvalues: t4 (ref)
    for _, v782 in ipairs(t4.looks) do
        v782[1][v782[2]] = p179 and v782[4] or v782[3]
    end
end

v5 = function() -- line: 4148
    -- upvalues: LocalPlayer (ref), t4 (ref), t6 (ref), t7 (ref), FreeReward (ref), ServerLuck (ref), setHidden (ref), GiftRequest (ref), viewAt (copy)
    t4.gifting = false

    for _, v783 in ipairs(t4.looks) do
        v783[1][v783[2]] = v783[3]
    end

    local t120 = {}

    t120[ServerLuck] = false

    local v784 = LocalPlayer:GetAttribute("ShopUnlocked") == true and not LocalPlayer:GetAttribute("ShopFreeReady")

    t120[FreeReward] = v784

    for _, v785 in ipairs(t6.baitBundles) do
        t120[v785] = false
    end

    setHidden(t120)
    t7.dress()
    viewAt(LocalPlayer)
    task.spawn(pcall, GiftRequest.InvokeServer, GiftRequest, "Cancel")
end

local function openGift(p180) -- line: 4160
    -- upvalues: Players (copy), TweenService (ref), PanelFocus (ref), PurchaseFX (ref), LocalPlayer (ref), Panel (ref), Scale (ref), t1 (ref), Close (ref), GiftPicker (ref), Loc (ref), t4 (ref), Sound (ref), v2 (ref), v3 (ref), t6 (ref), startLoops (ref), showPage (ref), PadMenu (ref), close (ref), FreeReward (ref), ServerLuck (ref), setHidden (ref), viewAt (copy), GiftingFor (copy)
    if p180.Parent ~= Players then
        return
    end

    LocalPlayer:SetAttribute("ShopOpen", true)
    GiftPicker.Close()
    t4.gifting = true

    for _, v786 in ipairs(t4.looks) do
        v786[1][v786[2]] = v786[4] or v786[3]
    end

    local t121 = {
        [ServerLuck] = true,
        [FreeReward] = true
    }

    for _, v787 in ipairs(t6.baitBundles) do
        t121[v787] = true
    end

    setHidden(t121)
    viewAt(p180)
    GiftingFor.AutoLocalize = false
    GiftingFor.Text = Loc.F("gift.for", "YOU ARE GIFTING FOR @{name}", {
        name = p180.Name
    })
    v3 = true
    v2 = true
    Sound:Play()
    Scale.Scale = PanelFocus.FEEL.FROM
    showPage("Popular", true)
    Panel.Visible = true
    PurchaseFX.ShopGlow(true, false, t4.GLOW)
    startLoops()

    local v788 = TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    })

    v788.Completed:Once(function() -- line: 4182
        -- upvalues: v3 (ref)
        v3 = false
    end)
    v788:Play()
    PadMenu.Open(Panel, function() -- line: 4185
        -- upvalues: close (ref)
        if close then
            close()
        end
    end, {
        closeButton = Close,
        first = function() -- first | line: 4186
            -- upvalues: t1 (ref)
            return t1:FindFirstChild("StarterPack") and t1.StarterPack:FindFirstChild("Buy")
        end
    })
end

local function closePicker() -- line: 4190
    -- upvalues: PanelFocus (ref), LocalPlayer (ref), GiftPicker (ref), v3 (ref)
    GiftPicker.Close()
    LocalPlayer:SetAttribute("ShopOpen", nil)
    v3 = true
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    PanelFocus.Focus(false)
    task.delay(PanelFocus.FEEL.CLOSE_TIME, function() -- line: 4196
        -- upvalues: PanelFocus (ref), v3 (ref)
        PanelFocus.GiveBack()
        task.delay(PanelFocus.FEEL.BUTTON_IN, function() -- line: 4198
            -- upvalues: v3 (ref)
            v3 = false
        end)
    end)
end

local function toPicker() -- line: 4203
    -- upvalues: TweenService (ref), PanelFocus (ref), PurchaseFX (ref), Panel (ref), Scale (ref), GiftPicker (ref), Odds (ref), t4 (ref), t5 (ref), v2 (ref), v3 (ref), v4 (ref), PadMenu (ref), openGift (copy), closePicker (copy)
    if v3 or not v2 or t4.gifting then
        return
    end

    v3 = true
    v2 = false
    PadMenu.Close(Panel)
    Odds.Hide(true)
    PurchaseFX.ShopGlow(false)
    v4 += 1

    for _, v789 in ipairs(t5) do
        v789:Pause()
    end

    table.clear(t5)

    local v790 = TweenService:Create(Scale, PanelFocus.popOut, {
        Scale = 0
    })

    v790.Completed:Once(function(p181) -- line: 4211
        -- upvalues: Panel (ref), v2 (ref), v3 (ref)
        if p181 == Enum.PlaybackState.Completed and not v2 then
            Panel.Visible = false
        end

        v3 = false
    end)
    v790:Play()
    GiftPicker.Open(openGift, closePicker)
end

local Gift = TopTabs:WaitForChild("Gift")

ButtonHover.Attach(Gift, {
    tile = 1,
    iconTilt = 20,
    highlight = true,
    highlightCorner = 0.135,
    highlightFade = 0.8,
    icon = Gift:WaitForChild("Icon")
})
Gift.Activated:Connect(function() -- line: 4220
    -- upvalues: ButtonHover (ref), toPicker (copy), Gift (copy)
    ButtonHover.Press(Gift)
    toPicker()
end)
Players.PlayerRemoving:Connect(function(p182) -- line: 4226
    -- upvalues: Toast (ref), Loc (ref), t4 (ref), v3 (ref), close2 (ref)
    if t4.gifting and p182 == t4.who then
        Toast.Show(Loc.F("gift.left", "@{name} left the game!", {
            name = p182.Name
        }), "", nil, Toast.RED, "deny")
        task.spawn(function() -- line: 4229
            -- upvalues: v3 (ref), close2 (ref)
            local elapsed = os.clock()

            while v3 and os.clock() - elapsed < 1 do
                task.wait()
            end

            close2()
        end)
    end
end)

local function iconCard(p183, p184, p185) -- line: 4238
    return {
        setup = function(p186) -- setup | line: 4239
            -- upvalues: p183 (copy), p184 (copy), p185 (copy)
            local Icon = p186.Main.Icon

            Icon.Image = p183
            Icon.ImageRectOffset = Vector2.zero
            Icon.ImageRectSize = Vector2.zero
            p186.Main.Title.Text = p184
            p186.Main.Rarity.Text = p185
        end
    }
end

local Image2 = FatDouble:WaitForChild("Icon").Image
local Image3 = MukbangUp.Cash:WaitForChild("Icon").Image

local function giftCards(p187, p188) -- line: 4250
    -- upvalues: ShopConfig (ref), t1 (ref), t4 (ref), t7 (ref), Format (copy), TableDisplay (copy), rewardCard (copy), Image2 (copy), Image3 (copy)
    if type(p187) ~= "table" then
        return {}
    end

    if type(p187.rewards) == "table" then
        local t123 = {}

        for _, v791 in ipairs(p187.rewards) do
            t123[#t123 + 1] = rewardCard(v791)
        end

        return t123
    end

    local v793 = tostring(p187.title or "Gift")

    if p187.kind == "Ultimate" then
        return t7.ultCards(p187)
    end

    if ShopConfig.EGGS[p187.kind] then
        local t124 = if p188 then {} else nil

        if not p188 or not t124 then
            local ICON = t4.ICON
            local v794 = "GIFT"

            t124 = {
                {
                    setup = function(p189) -- setup | line: 4239
                        -- upvalues: v793 (copy), ICON (copy), v794 (copy)
                        local Icon = p189.Main.Icon

                        Icon.Image = ICON
                        Icon.ImageRectOffset = Vector2.zero
                        Icon.ImageRectSize = Vector2.zero
                        p189.Main.Title.Text = v793
                        p189.Main.Rarity.Text = v794
                    end
                }
            }
        end

        return t124
    end

    if p187.harpoon then
        for _, v795 in ipairs(ShopConfig.LIMITED) do
            local v796 = v795.harpoon == p187.harpoon and t1:FindFirstChild(v795.card)

            if v796 and v796:FindFirstChild("Art") then
                local Art = v796.Art
                local Image = v796.Art.Image
                local v797 = "EXCLUSIVE"
                local t126 = {
                    setup = function(p190) -- setup | line: 4239
                        -- upvalues: v793 (copy), Image (copy), v797 (copy)
                        local Icon = p190.Main.Icon

                        Icon.Image = Image
                        Icon.ImageRectOffset = Vector2.zero
                        Icon.ImageRectSize = Vector2.zero
                        p190.Main.Title.Text = v793
                        p190.Main.Rarity.Text = v797
                    end
                }
                local setup = t126.setup

                t126.setup = function(p191) -- line: 4269
                    -- upvalues: Art (copy), setup (copy)
                    setup(p191)

                    local Icon, Icon2 = p191.Main.Icon, p191.Main.Icon
                    local ImageRectOffset, ImageRectSize = Art.ImageRectOffset, Art.ImageRectSize

                    Icon.ImageRectOffset = ImageRectOffset
                    Icon2.ImageRectSize = ImageRectSize
                end

                return { t126 }
            end
        end
    end

    if p187.image then
        local image = p187.image
        local v798 = p187.word or "EXCLUSIVE"

        return {
            {
                setup = function(p192) -- setup | line: 4239
                    -- upvalues: v793 (copy), image (copy), v798 (copy)
                    local Icon = p192.Main.Icon

                    Icon.Image = image
                    Icon.ImageRectOffset = Vector2.zero
                    Icon.ImageRectSize = Vector2.zero
                    p192.Main.Title.Text = v793
                    p192.Main.Rarity.Text = v798
                end
            }
        }
    end

    if p187.pass then
        return {
            rewardCard({
                pass = p187.pass,
                title = v793
            })
        }
    end

    if p187.kind == "Fat" then
        local v799 = "FAT BOOST"

        return {
            {
                setup = function(p193) -- setup | line: 4239
                    -- upvalues: v793 (copy), v799 (copy), Image2 (copy)
                    local Icon = p193.Main.Icon

                    Icon.Image = Image2
                    Icon.ImageRectOffset = Vector2.zero
                    Icon.ImageRectSize = Vector2.zero
                    p193.Main.Title.Text = v793
                    p193.Main.Rarity.Text = v799
                end
            }
        }
    end

    if p187.kind ~= "Table" or not p187.level then
        if p187.kind == "FatTime" then
            local v800 = p187.amount and "+" .. Format.short(p187.amount) or "FAT"

            return {
                {
                    setup = function(p194) -- setup | line: 4239
                        -- upvalues: v793 (copy), v800 (copy), Image2 (copy)
                        local Icon = p194.Main.Icon

                        Icon.Image = Image2
                        Icon.ImageRectOffset = Vector2.zero
                        Icon.ImageRectSize = Vector2.zero
                        p194.Main.Title.Text = v793
                        p194.Main.Rarity.Text = v800
                    end
                }
            }
        end

        if p187.kind == "CashTime" then
            local v801 = p187.amount and "+" .. Format.money(p187.amount) or "CASH"

            return {
                {
                    setup = function(p195) -- setup | line: 4239
                        -- upvalues: v793 (copy), v801 (copy), Image3 (copy)
                        local Icon = p195.Main.Icon

                        Icon.Image = Image3
                        Icon.ImageRectOffset = Vector2.zero
                        Icon.ImageRectSize = Vector2.zero
                        p195.Main.Title.Text = v793
                        p195.Main.Rarity.Text = v801
                    end
                }
            }
        end

        local ICON = t4.ICON
        local v802 = "GIFT"

        return {
            {
                setup = function(p196) -- setup | line: 4239
                    -- upvalues: v793 (copy), ICON (copy), v802 (copy)
                    local Icon = p196.Main.Icon

                    Icon.Image = ICON
                    Icon.ImageRectOffset = Vector2.zero
                    Icon.ImageRectSize = Vector2.zero
                    p196.Main.Title.Text = v793
                    p196.Main.Rarity.Text = v802
                end
            }
        }
    end

    local v803 = TableDisplay.Icon(p187.level)
    local v804 = "UNLOCKED"

    return {
        {
            setup = function(p197) -- setup | line: 4239
                -- upvalues: v793 (copy), v803 (copy), v804 (copy)
                local Icon = p197.Main.Icon

                Icon.Image = v803
                Icon.ImageRectOffset = Vector2.zero
                Icon.ImageRectSize = Vector2.zero
                p197.Main.Title.Text = v793
                p197.Main.Rarity.Text = v804
            end
        }
    }
end

local function revealGift(p198, p199) -- line: 4285
    -- upvalues: RewardScreen (ref), PlayerGui (ref)
    local elapsed = os.clock()

    while (PlayerGui:FindFirstChild("LoadingGui") or RewardScreen.Busy()) and os.clock() - elapsed < 90 do
        task.wait(0.25)
    end

    if #p198 > 0 then
        RewardScreen.Show(p198, nil, p199)
    end
end

Remotes:WaitForChild("GiftNotice").OnClientEvent:Connect(function(p200, p201, p202) -- line: 4290
    -- upvalues: PurchaseFX (ref), Loc (ref), giftCards (copy), revealGift (copy)
    if p200 == "Sent" then
        PurchaseFX.Success()
        task.spawn(revealGift, giftCards(p201), "GIFT SENT!")
    elseif p200 == "Received" then
        task.spawn(revealGift, giftCards(p201, true), Loc.F("gift.got", "@{name} GIFTED YOU!", {
            name = tostring(p202)
        }))
    end
end)
