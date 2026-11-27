-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local GroupReward = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GroupReward")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Toast = require(Modules:WaitForChild("Toast"))
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local HarpoonSkins = require(Modules:WaitForChild("HarpoonSkins"))
local HarpoonView = require(Modules:WaitForChild("HarpoonView"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local RewardScreen = require(Modules:WaitForChild("RewardScreen"))
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local PurchaseFX = require(Modules:WaitForChild("PurchaseFX"))
local RewardCards = require(Modules:WaitForChild("RewardCards"))
local GroupRewardConfig = require(Modules:WaitForChild("GroupRewardConfig"))
local Plots = workspace:WaitForChild("Plots")
local t1 = {
    BOTTOM_AT = 0.3,
    SHAKE_MOVE = 0.008,
    SHAKE_TURN = 2.5,
    LIGHTEN = 0.45,
    SPIN_AFTER = 0.35,
    LOOP_SOUND = "rbxassetid://126079437435883",
    LOOP_VOLUME = 0.5,
    LOOP_IN = 0.4,
    LOOP_OUT = 0.12,
    YES_SOUND = "rbxassetid://86488607363887",
    YES_VOLUME = 0.6,
    TILE_FIRST = 0.12,
    TILE_GAP = 0.09,
    BOB = 0.035,
    BOB_TIME = 1.1,
    WOBBLE = 9,
    WOBBLE_TIME = 0.6,
    RAINBOW_LAP = 2.5,
    SHINE_STEP = 0.14,
    SHINE_EVERY = 2.6,
    TITLE_LAP = 6,
    FLY = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    ROCK_OUT = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
    TILE_POP = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SHINE = TweenInfo.new(0.45, Enum.EasingStyle.Linear)
}
local SoundService = game:GetService("SoundService")

local function sound(p1, p2, p3) -- line: 115
    -- upvalues: SoundService (copy)
    local Sound = Instance.new("Sound")
    local v1 = p3 == true

    Sound.SoundId = p1
    Sound.Volume = p2
    Sound.Looped = v1
    Sound.Parent = SoundService

    return Sound
end

local LOOP_SOUND, YES_SOUND = t1.LOOP_SOUND, t1.LOOP_VOLUME
local Sound = Instance.new("Sound")

Sound.SoundId = LOOP_SOUND
Sound.Volume = YES_SOUND
Sound.Looped = true
Sound.Parent = SoundService
YES_SOUND = t1.YES_SOUND

local YES_VOLUME = t1.YES_VOLUME
local Sound2 = Instance.new("Sound")

Sound2.SoundId = YES_SOUND
Sound2.Volume = YES_VOLUME
Sound2.Looped = false
Sound2.Parent = SoundService
task.spawn(function() -- line: 123
    -- upvalues: Sound (copy), Sound2 (copy)
    game:GetService("ContentProvider"):PreloadAsync({
        Sound,
        Sound2
    })
end)

local v2

local function fadeLoop(p4) -- line: 125
    -- upvalues: TweenService (copy), LocalPlayer (copy), t1 (copy), Sound (copy), v2 (ref)
    if v2 then
        v2:Cancel()
    end

    LocalPlayer:SetAttribute("MusicDuck", if p4 then 0 else nil)

    if p4 then
        Sound.Volume = 0
        Sound.TimePosition = 0
        Sound:Play()
    end

    v2 = TweenService:Create(Sound, TweenInfo.new(p4 and t1.LOOP_IN or t1.LOOP_OUT), {
        Volume = p4 and t1.LOOP_VOLUME or 0
    })

    if not p4 then
        v2.Completed:Once(function(p5) -- line: 135
            -- upvalues: Sound (copy)
            if p5 == Enum.PlaybackState.Completed then
                Sound:Stop()
            end
        end)
    end

    v2:Play()
end

local TelemetryReport = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TelemetryReport")

local function log(p6, p7, p8) -- line: 141
    -- upvalues: TelemetryReport (copy)
    TelemetryReport:FireServer("group", p6, p7, p8)
end

local function ask(p9) -- line: 145
    -- upvalues: GroupReward (copy)
    local InvokeServer = GroupReward.InvokeServer
    local v5, v6, v7 = pcall(InvokeServer, GroupReward, p9)

    if v5 then
        return v6, v7
    end

    return "busy"
end

local GroupRewardGui = PlayerGui:WaitForChild("GroupRewardGui")
local Panel = GroupRewardGui:WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Close = Panel:WaitForChild("Main"):WaitForChild("Close")
local Claim = Panel:WaitForChild("Claim")
local Choose = GroupRewardGui:WaitForChild("Choose")
local Scale2 = Choose:WaitForChild("Scale")
local Confirm = GroupRewardGui:WaitForChild("Confirm")
local Card = Confirm:WaitForChild("Card")
local Image = Card:WaitForChild("Image")
local Aspect = Card:WaitForChild("Aspect")
local Scale3 = Card:WaitForChild("Scale")
local Bottom = Confirm:WaitForChild("Bottom")
local Scale4 = Bottom:WaitForChild("Scale")
local Yes = Bottom:WaitForChild("Yes")
local CardPosition, Size = Card.Position, Card.Size
local t3 = {
    Choose:WaitForChild("Shadow"),
    Choose:WaitForChild("Love")
}
local t4 = {
    Close,
    Card:WaitForChild("Close")
}

Panel.Visible = false
Choose.Visible = false
Confirm.Visible = false

local v8
local v9 = false
local v10
local v11 = false
local v12

local function setClaimText(p10) -- line: 176
    -- upvalues: Claim (copy)
    Claim.Text.Text = p10
end

local function dressClaim() -- line: 179
    -- upvalues: LocalPlayer (copy), Claim (copy)
    local v13 = LocalPlayer:GetAttribute("GroupRewardOwned") and "CLAIMED" or "CLAIM"

    Claim.Text.Text = v13
end

local function popIn(p11, p12) -- line: 183
    -- upvalues: TweenService (copy), PanelFocus (copy)
    p12.Scale = PanelFocus.FEEL.FROM
    p11.Visible = true
    TweenService:Create(p12, PanelFocus.popIn, {
        Scale = 1
    }):Play()
end

local function popOut(p13, p14) -- line: 188
    -- upvalues: TweenService (copy), PanelFocus (copy)
    local tween = TweenService:Create(p14, PanelFocus.popOut, {
        Scale = 0
    })

    tween.Completed:Once(function(p15) -- line: 190
        -- upvalues: p13 (copy)
        if p15 == Enum.PlaybackState.Completed then
            p13.Visible = false
        end
    end)
    tween:Play()
end

local Rewards = Panel:WaitForChild("Rewards")
local t5 = {
    Rewards:WaitForChild("Key"),
    Rewards:WaitForChild("XP"),
    Rewards:WaitForChild("Mystery")
}
local v14 = t5[3]

RewardCards.Card({
    key = GroupRewardConfig.KEY,
    count = GroupRewardConfig.KEYS
}).setup(t5[1])
RewardCards.Card({
    xp = GroupRewardConfig.XP
}).setup(t5[2])
v14.Main.Icon.Image = GroupRewardConfig.MYSTERY_ICON

local t6 = {}

for _, v15 in ipairs(t5) do
    t6[v15] = v15.Main.Icon.Position
end

local n1 = 0
local t7 = {}

local function loop(p16, p17, p18) -- line: 207
    -- upvalues: TweenService (copy), t7 (copy)
    local tween = TweenService:Create(p16, p17, p18)

    t7[#t7 + 1] = tween
    tween:Play()
end

local function panelLife(p19) -- line: 212
    -- upvalues: TweenService (copy), ButtonHover (copy), t1 (copy), Claim (copy), t5 (copy), v14 (copy), t6 (copy), n1 (ref), t7 (copy)
    n1 += 1

    for _, v16 in ipairs(t7) do
        v16:Cancel()
    end

    table.clear(t7)

    for _, v17 in ipairs(t5) do
        v17.Main.Icon.Position = t6[v17]
        v17.Main.Icon.Rotation = 0
        v17.Effect.UIGradient.Offset = Vector2.new(-1, 0)
        v17.Pop.Scale = p19 and 0 or 1
    end

    if not p19 then
        return
    end

    local v18 = n1
    local v19 = TweenInfo.new(t1.BOB_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

    for v20, v21 in ipairs(t5) do
        task.delay(t1.TILE_FIRST + (v20 - 1) * t1.TILE_GAP, function() -- line: 226
            -- upvalues: v18 (copy), v21 (copy), TweenService (copy), t1 (copy), n1 (ref)
            if n1 == v18 then
                TweenService:Create(v21.Pop, t1.TILE_POP, {
                    Scale = 1
                }):Play()
            end
        end)

        local tween = TweenService:Create(v21.Main.Icon, v19, {
            Position = t6[v21] - UDim2.fromScale(0, t1.BOB)
        })

        t7[#t7 + 1] = tween
        tween:Play()
    end

    local Icon = v14.Main.Icon

    Icon.Rotation = -t1.WOBBLE

    local tween = TweenService:Create(Icon, TweenInfo.new(t1.WOBBLE_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Rotation = t1.WOBBLE
    })

    t7[#t7 + 1] = tween
    tween:Play()

    local UIGradient = v14.Main.Rarity:FindFirstChildOfClass("UIGradient")

    UIGradient.Rotation = 0

    local tween2 = TweenService:Create(UIGradient, TweenInfo.new(t1.RAINBOW_LAP, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
        Rotation = 360
    })

    t7[#t7 + 1] = tween2
    tween2:Play()
    ButtonHover.Sparkle(Claim, function() -- line: 239
        -- upvalues: v18 (copy), n1 (ref)
        return n1 == v18
    end)
    task.spawn(function() -- line: 241
        -- upvalues: v18 (copy), TweenService (copy), ButtonHover (copy), t1 (copy), Claim (copy), t5 (copy), n1 (ref)
        task.wait(t1.TILE_FIRST + #t5 * t1.TILE_GAP + t1.TILE_POP.Time)

        while true do
            if n1 == v18 then
                for _, v24 in ipairs(t5) do
                    if n1 ~= v18 then
                        return
                    end

                    local UIGradient = v24.Effect.UIGradient

                    UIGradient.Offset = Vector2.new(-1, 0)
                    TweenService:Create(UIGradient, t1.SHINE, {
                        Offset = Vector2.new(1, 0)
                    }):Play()
                    task.wait(t1.SHINE_STEP)
                end

                if n1 == v18 then
                    ButtonHover.Sweep(Claim, t1.SHINE.Time)
                    task.wait(t1.SHINE_EVERY)
                    continue
                end
            end

            return
        end
    end)
end

panelLife(false)

local connection

local function stopShake() -- line: 261
    -- upvalues: fadeLoop (copy), Image (copy), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
        fadeLoop(false)
    end

    Image.Position = UDim2.fromScale(0.5, 0.5)
    Image.Rotation = 0
end

local function startShake() -- line: 269
    -- upvalues: RunService (copy), t1 (copy), fadeLoop (copy), Image (copy), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
        fadeLoop(false)
    end

    Image.Position = UDim2.fromScale(0.5, 0.5)
    Image.Rotation = 0
    fadeLoop(true)
    connection = RunService.RenderStepped:Connect(function() -- line: 272
        -- upvalues: t1 (copy), Image (copy)
        Image.Position = UDim2.fromScale(0.5 + (math.random() * 2 - 1) * t1.SHAKE_MOVE, 0.5 + (math.random() * 2 - 1) * t1.SHAKE_MOVE)
        Image.Rotation = (math.random() * 2 - 1) * t1.SHAKE_TURN
    end)
end

local PadMenu = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("PadMenu"))
local closeAll

local function hideAll() -- line: 283
    -- upvalues: fadeLoop (copy), GroupRewardGui (copy), Panel (copy), Choose (copy), Confirm (copy), Image (copy), t3 (copy), v10 (ref), connection (ref), PadMenu (copy)
    PadMenu.Close(GroupRewardGui)

    if connection then
        connection:Disconnect()
        connection = nil
        fadeLoop(false)
    end

    Image.Position = UDim2.fromScale(0.5, 0.5)
    Image.Rotation = 0
    Panel.Visible = false
    Choose.Visible = false
    Confirm.Visible = false

    for _, v25 in ipairs(t3) do
        v25.ImageTransparency = 0
    end

    v10 = nil
end

local function holdDive(p20) -- line: 294
    -- upvalues: LocalPlayer (copy)
    LocalPlayer:SetAttribute("GroupRewardOpen", p20 or nil)
end

local function open() -- line: 298
    -- upvalues: TweenService (copy), LocalPlayer (copy), PanelFocus (copy), PurchaseFX (copy), TelemetryReport (copy), GroupRewardGui (copy), Panel (copy), Scale (copy), Claim (copy), v8 (ref), v9 (ref), panelLife (copy), PadMenu (copy), closeAll (ref)
    if v8 or v9 then
        return
    end

    v8 = "panel"
    v9 = true
    LocalPlayer:SetAttribute("GroupRewardOpen", true)
    PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
    PanelFocus.MakeWay(function() -- line: 303
        -- upvalues: v8 (ref)
        return v8 ~= nil
    end)

    local v26 = LocalPlayer:GetAttribute("GroupRewardOwned") and "CLAIMED" or "CLAIM"

    Claim.Text.Text = v26
    Scale.Scale = PanelFocus.FEEL.FROM
    Panel.Visible = true
    TweenService:Create(Scale, PanelFocus.popIn, {
        Scale = 1
    }):Play()
    panelLife(true)
    PurchaseFX.Rainbow(true)
    PanelFocus.Focus(true)
    task.delay(PanelFocus.FEEL.OPEN_TIME, function() -- line: 309
        -- upvalues: v9 (ref)
        v9 = false
    end)
    PadMenu.Open(GroupRewardGui, function() -- line: 310
        -- upvalues: TelemetryReport (copy), v8 (ref), v9 (ref), closeAll (ref)
        if not closeAll or v9 then
            return
        end

        TelemetryReport:FireServer("group", "close", v8, "pad")
        closeAll()
    end, {})
end

local function closeAll2(p21) -- line: 318
    -- upvalues: TweenService (copy), LocalPlayer (copy), PanelFocus (copy), PurchaseFX (copy), fadeLoop (copy), GroupRewardGui (copy), Panel (copy), Scale (copy), Choose (copy), Scale2 (copy), Confirm (copy), Image (copy), Scale3 (copy), Scale4 (copy), t3 (copy), v8 (ref), v9 (ref), v10 (ref), v11 (ref), popOut (copy), panelLife (copy), connection (ref), PadMenu (copy)
    if not v8 then
        return
    end

    v8 = "closing"
    v9 = true
    PadMenu.Close(GroupRewardGui)
    PurchaseFX.Rainbow(false)
    PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)
    PanelFocus.Focus(false)

    if Panel.Visible then
        popOut(Panel, Scale)
    end

    if Choose.Visible then
        popOut(Choose, Scale2)
    end

    if Confirm.Visible then
        if connection then
            connection:Disconnect()
            connection = nil
            fadeLoop(false)
        end

        Image.Position = UDim2.fromScale(0.5, 0.5)
        Image.Rotation = 0
        TweenService:Create(Scale3, PanelFocus.popOut, {
            Scale = 0
        }):Play()
        TweenService:Create(Scale4, PanelFocus.popOut, {
            Scale = 0
        }):Play()
    end

    task.delay(PanelFocus.FEEL.CLOSE_TIME, function() -- line: 332
        -- upvalues: p21 (copy), LocalPlayer (copy), PanelFocus (copy), fadeLoop (copy), GroupRewardGui (copy), Panel (copy), Choose (copy), Confirm (copy), Image (copy), t3 (copy), v8 (ref), v9 (ref), v10 (ref), v11 (ref), panelLife (copy), connection (ref), PadMenu (copy)
        PadMenu.Close(GroupRewardGui)

        if connection then
            connection:Disconnect()
            connection = nil
            fadeLoop(false)
        end

        Image.Position = UDim2.fromScale(0.5, 0.5)
        Image.Rotation = 0
        Panel.Visible = false
        Choose.Visible = false
        Confirm.Visible = false

        for _, v28 in ipairs(t3) do
            v28.ImageTransparency = 0
        end

        v10 = nil
        panelLife(false)
        PanelFocus.GiveBack()
        v8 = nil

        if not v11 then
            LocalPlayer:SetAttribute("GroupRewardOpen", nil)
        end

        if p21 then
            task.spawn(p21)
        end

        task.delay(PanelFocus.FEEL.BUTTON_IN, function() -- line: 339
            -- upvalues: v9 (ref)
            v9 = false
        end)
    end)
end

closeAll = closeAll2

local function toChoose() -- line: 345
    -- upvalues: TweenService (copy), PanelFocus (copy), Panel (copy), Scale (copy), Choose (copy), Scale2 (copy), v8 (ref), v9 (ref), popOut (copy), panelLife (copy)
    if v8 ~= "panel" then
        return
    end

    v8 = "choose"
    v9 = true
    popOut(Panel, Scale)
    task.delay(PanelFocus.FEEL.CLOSE_TIME, function() -- line: 349
        -- upvalues: TweenService (copy), PanelFocus (copy), Choose (copy), Scale2 (copy), v8 (ref), v9 (ref), panelLife (copy)
        panelLife(false)

        if v8 ~= "choose" then
            return
        end

        PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
        Scale2.Scale = PanelFocus.FEEL.FROM
        Choose.Visible = true
        TweenService:Create(Scale2, PanelFocus.popIn, {
            Scale = 1
        }):Play()
        task.delay(PanelFocus.FEEL.OPEN_TIME, function() -- line: 354
            -- upvalues: v9 (ref)
            v9 = false
        end)
    end)
end

local function pick(p22) -- line: 359
    -- upvalues: TweenService (copy), RunService (copy), PanelFocus (copy), t1 (copy), fadeLoop (copy), TelemetryReport (copy), Choose (copy), Scale2 (copy), Confirm (copy), Card (copy), Image (copy), Aspect (copy), Scale3 (copy), Bottom (copy), Scale4 (copy), CardPosition (copy), Size (copy), v8 (ref), v9 (ref), v10 (ref), popOut (copy), connection (ref)
    if v8 ~= "choose" or v9 then
        return
    else
        local Harpoon, Harpoon2 = p22:GetAttribute("Harpoon")

        TelemetryReport:FireServer("group", "pick", Harpoon, Harpoon2)
        v8 = "confirm"
        v9 = true
        v10 = p22
        PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)

        local Image2, ImageRectOffset, ImageRectSize = p22.Image, p22.ImageRectOffset, p22.ImageRectSize

        Image.Image = Image2
        Image.ImageRectOffset = ImageRectOffset
        Image.ImageRectSize = ImageRectSize
        Aspect.AspectRatio = p22:GetAttribute("Aspect") or 0.65

        local v30 = p22.AbsolutePosition + p22.AbsoluteSize / 2 - Confirm.AbsolutePosition

        Card.Position = UDim2.fromScale(v30.X / Confirm.AbsoluteSize.X, v30.Y / Confirm.AbsoluteSize.Y)
        Card.Size = UDim2.fromScale(Size.X.Scale, p22.AbsoluteSize.Y / Confirm.AbsoluteSize.Y)
        Scale3.Scale = 1
        Bottom.Visible = false
        Confirm.Visible = true
        p22.ImageTransparency = 1
        popOut(Choose, Scale2)
        TweenService:Create(Card, t1.FLY, {
            Position = CardPosition,
            Size = Size
        }):Play()

        if connection then
            connection:Disconnect()
            connection = nil
            fadeLoop(false)
        end
    end

    Image.Position = UDim2.fromScale(0.5, 0.5)
    Image.Rotation = 0
    fadeLoop(true)
    connection = RunService.RenderStepped:Connect(function() -- line: 272
        -- upvalues: t1 (copy), Image (copy)
        Image.Position = UDim2.fromScale(0.5 + (math.random() * 2 - 1) * t1.SHAKE_MOVE, 0.5 + (math.random() * 2 - 1) * t1.SHAKE_MOVE)
        Image.Rotation = (math.random() * 2 - 1) * t1.SHAKE_TURN
    end)
    task.delay(t1.BOTTOM_AT, function() -- line: 377
        -- upvalues: TweenService (copy), PanelFocus (copy), Bottom (copy), Scale4 (copy), v8 (ref), v9 (ref)
        if v8 ~= "confirm" then
            return
        end

        Scale4.Scale = PanelFocus.FEEL.FROM
        Bottom.Visible = true
        TweenService:Create(Scale4, PanelFocus.popIn, {
            Scale = 1
        }):Play()
        task.delay(PanelFocus.FEEL.OPEN_TIME, function() -- line: 380
            -- upvalues: v9 (ref)
            v9 = false
        end)
    end)
end

local function revealCard(p23) -- line: 385
    -- upvalues: HarpoonSkins (copy), HarpoonView (copy), RarityDisplay (copy), t1 (copy)
    local v31 = HarpoonSkins.Get(p23)
    local v32 = v31 and RarityDisplay[v31.rarity]

    return {
        setup = function(p24) -- setup | line: 389
            -- upvalues: p23 (copy), v31 (copy), v32 (copy), HarpoonView (copy), t1 (copy)
            local Icon = p24.Main.Icon

            Icon.Image = ""

            local v33 = HarpoonView.Mount(Icon, p23, Icon.ZIndex)

            p24.Main.Title.Text = v31 and v31.name or p23
            p24.Main.Rarity.Text = v32 and v32.display or ""

            local UIGradient = p24.Main.Rarity:FindFirstChildOfClass("UIGradient")

            if UIGradient and v32 then
                UIGradient.Color = ColorSequence.new(v32.color:Lerp(Color3.new(1, 1, 1), t1.LIGHTEN), v32.color)
            end

            task.delay(t1.SPIN_AFTER, function() -- line: 397
                -- upvalues: v33 (copy), HarpoonView (copy)
                if v33 and v33.Parent then
                    HarpoonView.Spin(v33)
                end
            end)
        end
    }
end

local function rewardCards(p25) -- line: 403
    -- upvalues: RewardCards (copy), GroupRewardConfig (copy), revealCard (copy)
    local t12 = {}

    if p25 then
        t12[1] = revealCard(p25)
    end

    t12[#t12 + 1] = RewardCards.Card({
        key = GroupRewardConfig.KEY,
        count = GroupRewardConfig.KEYS
    })
    t12[#t12 + 1] = RewardCards.Card({
        xp = GroupRewardConfig.XP
    })

    return t12
end

local ExperienceNotificationService = game:GetService("ExperienceNotificationService")

local function askNotifications() -- line: 415
    -- upvalues: ExperienceNotificationService (copy)
    local CanPromptOptInAsync = ExperienceNotificationService.CanPromptOptInAsync
    local ok, result = pcall(CanPromptOptInAsync, ExperienceNotificationService)

    if ok and result then
        local PromptOptIn = ExperienceNotificationService.PromptOptIn

        pcall(PromptOptIn, ExperienceNotificationService)
    end
end

local function celebrate(p26) -- line: 421
    -- upvalues: LocalPlayer (copy), RewardScreen (copy), PurchaseFX (copy), v11 (ref), v12 (ref), closeAll2 (copy), rewardCards (copy), ExperienceNotificationService (copy)
    PurchaseFX.Success()
    closeAll2(function() -- line: 423
        -- upvalues: p26 (copy), LocalPlayer (copy), RewardScreen (copy), v11 (ref), v12 (ref), rewardCards (copy), ExperienceNotificationService (copy)
        RewardScreen.Show((rewardCards(p26)))
        v11 = false
        LocalPlayer:SetAttribute("GroupRewardOpen", nil)
        v12(true)

        local CanPromptOptInAsync = ExperienceNotificationService.CanPromptOptInAsync
        local ok, result = pcall(CanPromptOptInAsync, ExperienceNotificationService)

        if not (ok and result) then
            return
        end

        local PromptOptIn = ExperienceNotificationService.PromptOptIn

        pcall(PromptOptIn, ExperienceNotificationService)
    end)
end

local function yes() -- line: 433
    -- upvalues: TweenService (copy), LocalPlayer (copy), GroupReward (copy), Toast (copy), HarpoonSkins (copy), RewardScreen (copy), PanelFocus (copy), PurchaseFX (copy), Sound2 (copy), fadeLoop (copy), Choose (copy), Scale2 (copy), Confirm (copy), Image (copy), Scale3 (copy), Scale4 (copy), v8 (ref), v9 (ref), v10 (ref), v11 (ref), v12 (ref), connection (ref), closeAll2 (copy), rewardCards (copy), ExperienceNotificationService (copy)
    local Harpoon, v34

    if v8 ~= "confirm" or v9 then
        v34 = true
    elseif v10 then
        Harpoon = v10:GetAttribute("Harpoon")
        v8 = "giving"

        if connection then
            connection:Disconnect()
            connection = nil
            fadeLoop(false)
        end

        v34 = false
    else
        v34 = true
    end

    if v34 then
        return
    end

    Image.Position = UDim2.fromScale(0.5, 0.5)
    Image.Rotation = 0
    Sound2:Play()
    v11 = true

    local InvokeServer = GroupReward.InvokeServer
    local v35, v36, v37 = pcall(InvokeServer, GroupReward, Harpoon)

    if not v35 then
        v36 = "busy"
        v37 = nil
    end

    if v36 ~= "granted" then
        v11 = false
        v12(true)
    end

    if v8 == "giving" then
        if v36 == "granted" then
            local v38 = v37 or Harpoon

            PurchaseFX.Success()
            closeAll2(function() -- line: 423
                -- upvalues: v38 (copy), LocalPlayer (copy), RewardScreen (copy), v11 (ref), v12 (ref), rewardCards (copy), ExperienceNotificationService (copy)
                RewardScreen.Show((rewardCards(v38)))
                v11 = false
                LocalPlayer:SetAttribute("GroupRewardOpen", nil)
                v12(true)

                local CanPromptOptInAsync = ExperienceNotificationService.CanPromptOptInAsync
                local ok, result = pcall(CanPromptOptInAsync, ExperienceNotificationService)

                if not (ok and result) then
                    return
                end

                local PromptOptIn = ExperienceNotificationService.PromptOptIn

                pcall(PromptOptIn, ExperienceNotificationService)
            end)
        elseif v36 == "have" then
            local v39 = HarpoonSkins.Get(Harpoon)

            Toast.Show("You already own the " .. (v39 and v39.name or Harpoon) .. "!", "", nil, Toast.RED, "deny")
            v8 = "choose"
            v9 = true
            TweenService:Create(Scale3, PanelFocus.popOut, {
                Scale = 0
            }):Play()
            TweenService:Create(Scale4, PanelFocus.popOut, {
                Scale = 0
            }):Play()
            task.delay(PanelFocus.FEEL.CLOSE_TIME, function() -- line: 461
                -- upvalues: TweenService (copy), PanelFocus (copy), Choose (copy), Scale2 (copy), Confirm (copy), v8 (ref), v9 (ref), v10 (ref)
                if v8 ~= "choose" then
                    return
                end

                Confirm.Visible = false

                if v10 then
                    v10.ImageTransparency = 0
                end

                v10 = nil
                Scale2.Scale = PanelFocus.FEEL.FROM
                Choose.Visible = true
                TweenService:Create(Scale2, PanelFocus.popIn, {
                    Scale = 1
                }):Play()
                task.delay(PanelFocus.FEEL.OPEN_TIME, function() -- line: 467
                    -- upvalues: v9 (ref)
                    v9 = false
                end)
            end)
        else
            closeAll2()

            if v36 ~= "owned" then
                Toast.Show("Couldn't claim it, try again!", "", nil, Toast.RED, "deny")
            end
        end
    elseif v11 then
        v11 = false
        v12(true)
    end
end

local v40 = false
local v41 = false

Claim.Activated:Connect(function() -- line: 484
    -- upvalues: TweenService (copy), LocalPlayer (copy), GroupReward (copy), Toast (copy), RewardScreen (copy), PanelFocus (copy), PurchaseFX (copy), TelemetryReport (copy), Panel (copy), Scale (copy), Claim (copy), Choose (copy), Scale2 (copy), v8 (ref), v9 (ref), v11 (ref), v12 (ref), popOut (copy), panelLife (copy), closeAll2 (copy), rewardCards (copy), ExperienceNotificationService (copy), v40 (ref), v41 (ref)
    if not v40 and v8 == "panel" then
        if LocalPlayer:GetAttribute("GroupRewardOwned") then
            closeAll2()
        else
            if not v41 then
                v41 = true
                task.spawn(pcall, function() -- line: 489
                    game:GetService("AvatarEditorService"):PromptSetFavorite(game.PlaceId, Enum.AvatarItemType.Asset, true)
                end)
            end

            v40 = true
            TelemetryReport:FireServer("group", "claim", nil, nil)
            Claim.Text.Text = "CLAIMING..."
            v11 = true

            local InvokeServer = GroupReward.InvokeServer
            local v43, v44, v45 = pcall(InvokeServer, GroupReward, nil)

            if not v43 then
                v44 = "busy"
                v45 = nil
            end

            if v44 ~= "granted" then
                v11 = false
            end

            if v8 == "panel" then
                if v44 == "choose" then
                    if v8 == "panel" then
                        v8 = "choose"
                        v9 = true
                        popOut(Panel, Scale)
                        task.delay(PanelFocus.FEEL.CLOSE_TIME, function() -- line: 349
                            -- upvalues: TweenService (copy), PanelFocus (copy), Choose (copy), Scale2 (copy), v8 (ref), v9 (ref), panelLife (copy)
                            panelLife(false)

                            if v8 ~= "choose" then
                                return
                            end

                            PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
                            Scale2.Scale = PanelFocus.FEEL.FROM
                            Choose.Visible = true
                            TweenService:Create(Scale2, PanelFocus.popIn, {
                                Scale = 1
                            }):Play()
                            task.delay(PanelFocus.FEEL.OPEN_TIME, function() -- line: 354
                                -- upvalues: v9 (ref)
                                v9 = false
                            end)
                        end)
                    end

                    local v46 = LocalPlayer:GetAttribute("GroupRewardOwned") and "CLAIMED" or "CLAIM"

                    Claim.Text.Text = v46
                elseif v44 == "granted" then
                    local v47 = LocalPlayer:GetAttribute("GroupRewardOwned") and "CLAIMED" or "CLAIM"

                    Claim.Text.Text = v47
                    PurchaseFX.Success()

                    local v48 = v45

                    closeAll2(function() -- line: 423
                        -- upvalues: v48 (copy), LocalPlayer (copy), RewardScreen (copy), v11 (ref), v12 (ref), rewardCards (copy), ExperienceNotificationService (copy)
                        RewardScreen.Show((rewardCards(v48)))
                        v11 = false
                        LocalPlayer:SetAttribute("GroupRewardOpen", nil)
                        v12(true)

                        local CanPromptOptInAsync = ExperienceNotificationService.CanPromptOptInAsync
                        local ok, result = pcall(CanPromptOptInAsync, ExperienceNotificationService)

                        if not (ok and result) then
                            return
                        end

                        local PromptOptIn = ExperienceNotificationService.PromptOptIn

                        pcall(PromptOptIn, ExperienceNotificationService)
                    end)
                elseif v44 == "owned" then
                    Claim.Text.Text = "CLAIMED!"
                    task.delay(0.35, closeAll2)
                elseif v44 == "notInGroup" then
                    local v49 = LocalPlayer:GetAttribute("GroupRewardOwned") and "CLAIMED" or "CLAIM"

                    Claim.Text.Text = v49
                    Toast.Show("Join the group to claim these rewards!", "", nil, Toast.RED, "deny")
                else
                    local v50 = LocalPlayer:GetAttribute("GroupRewardOwned") and "CLAIMED" or "CLAIM"

                    Claim.Text.Text = v50
                end
            elseif v11 then
                v11 = false
                v12(true)
            end

            v40 = false
        end
    end
end)

local Activated

for _, v51 in ipairs(t4) do
    Activated = v51.Activated
    Activated:Connect(function() -- line: 526
        -- upvalues: TelemetryReport (copy), v8 (ref), v9 (ref), closeAll2 (copy)
        if v9 or v8 == "giving" then
            return
        end

        TelemetryReport:FireServer("group", "close", v8, "x")
        closeAll2()
    end)
    ButtonHover.Attach(v51, {
        shine = false,
        tile = 1,
        icon = v51:FindFirstChild("X")
    })
end

ButtonHover.Attach(Claim, {
    shine = true,
    highlight = true
})
ButtonHover.Attach(Yes, {
    shine = false,
    highlight = true
})
Yes.Activated:Connect(yes)

for _, v53 in ipairs(t3) do
    ButtonHover.Attach(v53, {
        shine = false
    })
    Activated = v53.Activated
    Activated:Connect(function() -- line: 539
        -- upvalues: pick (copy), v53 (copy)
        pick(v53)
    end)
end

ReplicatedStorage.Remotes:WaitForChild("HarpoonEnter").OnClientEvent:Connect(function() -- line: 543
    -- upvalues: LocalPlayer (copy), PanelFocus (copy), PurchaseFX (copy), fadeLoop (copy), TelemetryReport (copy), GroupRewardGui (copy), Panel (copy), Choose (copy), Confirm (copy), Image (copy), t3 (copy), v8 (ref), v9 (ref), v10 (ref), panelLife (copy), connection (ref), PadMenu (copy)
    if not v8 then
        return
    end

    TelemetryReport:FireServer("group", "close", v8, "dive")
    v8 = nil
    v9 = false
    LocalPlayer:SetAttribute("GroupRewardOpen", nil)
    PurchaseFX.Rainbow(false)
    panelLife(false)
    PadMenu.Close(GroupRewardGui)

    if connection then
        connection:Disconnect()
        connection = nil
        fadeLoop(false)
    end

    Image.Position = UDim2.fromScale(0.5, 0.5)
    Image.Rotation = 0
    Panel.Visible = false
    Choose.Visible = false
    Confirm.Visible = false

    for _, v55 in ipairs(t3) do
        v55.ImageTransparency = 0
    end

    v10 = nil
    PanelFocus.Focus(false, true)
    PanelFocus.GiveBackRight()
end)
ProximityPromptService.PromptTriggered:Connect(function(p27) -- line: 555
    -- upvalues: open (copy)
    if p27.Name == "GroupRewardPrompt" then
        open()
    end
end)

local PromptLook = require(Modules:WaitForChild("PromptLook"))
local t13 = {}

local function styleAsCustom(p28) -- line: 562
    if not p28:IsA("ProximityPrompt") or p28.Name ~= "GroupRewardPrompt" then
        return
    end

    p28.Style = Enum.ProximityPromptStyle.Custom
    p28.HoldDuration = 0
    p28.ClickablePrompt = false
end

for _, descendant in ipairs(Plots:GetDescendants()) do
    if descendant:IsA("ProximityPrompt") and descendant.Name == "GroupRewardPrompt" then
        descendant.Style = Enum.ProximityPromptStyle.Custom
        descendant.HoldDuration = 0
        descendant.ClickablePrompt = false
    end
end

Plots.DescendantAdded:Connect(styleAsCustom)
ProximityPromptService.PromptShown:Connect(function(p29) -- line: 571
    -- upvalues: open (copy), PromptLook (copy), t13 (copy)
    local Parent = p29.Parent

    if p29.Name == "GroupRewardPrompt" and Parent and (Parent:IsA("BasePart") or Parent:IsA("Attachment")) then
        local v56 = t13[p29]

        if not v56 then
            v56 = PromptLook.Build(Parent, "GroupRewardPromptUI", open)
            t13[p29] = v56
            p29.Destroying:Once(function() -- line: 578
                -- upvalues: p29 (copy), v56 (ref), t13 (copy)
                v56.bb:Destroy()
                t13[p29] = nil
            end)
        end

        PromptLook.Show(v56, p29.ObjectText, p29.ActionText)
    end
end)
ProximityPromptService.PromptHidden:Connect(function(p30) -- line: 585
    -- upvalues: PromptLook (copy), t13 (copy)
    local v57 = t13[p30]

    if v57 then
        PromptLook.Hide(v57)
    end
end)

local t14 = {}

local function mine(p31) -- line: 595
    -- upvalues: LocalPlayer (copy)
    return p31 ~= nil and p31.Name == LocalPlayer:GetAttribute("Plot")
end

local t15 = {}

local function spinTitle(p32, p33) -- line: 600
    -- upvalues: TweenService (copy), t1 (copy), t15 (copy)
    local v58 = t15[p32]

    if p33 then
        if not v58 then
            local GroupChest = p32:FindFirstChild("GroupChest")
            local v59 = GroupChest and GroupChest:FindFirstChild("Title", true)
            local v60 = v59 and v59:FindFirstChildWhichIsA("UIGradient", true)

            if v60 then
                v60.Rotation = 0

                local tween = TweenService:Create(v60, TweenInfo.new(t1.TITLE_LAP, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
                    Rotation = 360
                })

                t15[p32] = tween
                tween:Play()
            end
        end
    elseif v58 then
        v58:Cancel()
        t15[p32] = nil
    end
end

local function takeOut(p34, p35) -- line: 619
    -- upvalues: t14 (copy), t15 (copy)
    local v61 = t15[p34]

    if v61 then
        v61:Cancel()
        t15[p34] = nil
    end

    if t14[p34] == nil then
        p34.Destroying:Once(function() -- line: 622
            -- upvalues: p34 (copy), t14 (copy), t15 (copy)
            t14[p34] = nil

            local v62 = t15[p34]

            if v62 then
                v62:Cancel()
                t15[p34] = nil
            end
        end)
    end

    t14[p34] = p35
    p34.Parent = nil
end

local t16 = {}

local function shrinkAway(p36, p37) -- line: 632
    -- upvalues: TweenService (copy), t1 (copy), t14 (copy), t15 (copy), t16 (copy)
    if t16[p36] then
        return
    end

    t16[p36] = true

    for _, descendant in ipairs(p36:GetDescendants()) do
        if descendant:IsA("BillboardGui") then
            descendant.Enabled = false
        end

        if descendant:IsA("ProximityPrompt") then
            descendant.Enabled = false
        end

        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false
        end
    end

    local Scale = p36:GetScale()
    local NumberValue = Instance.new("NumberValue")

    NumberValue.Value = 1
    NumberValue.Changed:Connect(function(p38) -- line: 643
        -- upvalues: p36 (copy), Scale (copy)
        if p36.Parent then
            p36:ScaleTo(Scale * math.max(p38, 0.01))
        end
    end)

    local tween = TweenService:Create(NumberValue, t1.ROCK_OUT, {
        Value = 0.01
    })

    tween.Completed:Once(function() -- line: 645
        -- upvalues: p36 (copy), p37 (copy), NumberValue (copy), t14 (copy), t15 (copy), t16 (copy)
        NumberValue:Destroy()
        t16[p36] = nil

        if p36.Parent then
            local v63 = t15[p36]

            if v63 then
                v63:Cancel()
                t15[p36] = nil
            end

            if t14[p36] == nil then
                p36.Destroying:Once(function() -- line: 622
                    -- upvalues: p36 (copy), t14 (copy), t15 (copy)
                    t14[p36] = nil

                    local v64 = t15[p36]

                    if v64 then
                        v64:Cancel()
                        t15[p36] = nil
                    end
                end)
            end

            t14[p36] = p37
            p36.Parent = nil
        end
    end)
    tween:Play()
end

local function settle(p39, p40, p41) -- line: 653
    -- upvalues: LocalPlayer (copy), t14 (copy), t15 (copy), spinTitle (copy), shrinkAway (copy)
    if p40 ~= nil and p40.Name == LocalPlayer:GetAttribute("Plot") and not LocalPlayer:GetAttribute("GroupRewardOwned") then
        if p39.Parent ~= p40 then
            t14[p39] = nil

            local function v65() -- line: 658
                -- upvalues: p39 (copy), p40 (copy)
                p39.Parent = p40
            end

            pcall(v65)
        end

        spinTitle(p39, true)
    elseif p39.Parent == p40 then
        if p41 and p40 ~= nil and p40.Name == LocalPlayer:GetAttribute("Plot") then
            shrinkAway(p39, p40)
        else
            local v66 = t15[p39]

            if v66 then
                v66:Cancel()
                t15[p39] = nil
            end

            if t14[p39] == nil then
                p39.Destroying:Once(function() -- line: 622
                    -- upvalues: p39 (copy), t14 (copy), t15 (copy)
                    t14[p39] = nil

                    local v67 = t15[p39]

                    if v67 then
                        v67:Cancel()
                        t15[p39] = nil
                    end
                end)
            end

            t14[p39] = p40
            p39.Parent = nil
        end
    end
end

v12 = function(p42) -- line: 665
    -- upvalues: Plots (copy), t14 (copy), settle (copy)
    for v68, v69 in pairs(t14) do
        settle(v68, v69, false)
    end

    for _, child in ipairs(Plots:GetChildren()) do
        local GroupReward = child:FindFirstChild("GroupReward")

        if GroupReward and not t14[GroupReward] then
            settle(GroupReward, child, p42)
        end
    end
end

Plots.DescendantAdded:Connect(function(p43) -- line: 672
    -- upvalues: LocalPlayer (copy), Plots (copy), spinTitle (copy), settle (copy)
    if p43.Name == "GroupReward" and p43:IsA("Model") then
        task.defer(function() -- line: 674
            -- upvalues: p43 (copy), Plots (copy), settle (copy)
            if p43.Parent and p43.Parent.Parent == Plots then
                settle(p43, p43.Parent, false)
            end
        end)

        return
    end

    if p43:IsA("UIGradient") and p43:FindFirstAncestor("GroupChest") then
        local GroupReward = p43:FindFirstAncestor("GroupReward")

        if GroupReward and GroupReward.Parent and GroupReward.Parent.Parent == Plots then
            local GroupRewardParent = GroupReward.Parent

            if GroupRewardParent ~= nil and GroupRewardParent.Name == LocalPlayer:GetAttribute("Plot") and not LocalPlayer:GetAttribute("GroupRewardOwned") then
                task.defer(spinTitle, GroupReward, true)
            end
        end
    end
end)
LocalPlayer:GetAttributeChangedSignal("Plot"):Connect(function() -- line: 685
    -- upvalues: v12 (ref)
    v12(false)
end)
LocalPlayer:GetAttributeChangedSignal("GroupRewardOwned"):Connect(function() -- line: 686
    -- upvalues: LocalPlayer (copy), Claim (copy), v11 (ref), v12 (ref)
    local v71 = LocalPlayer:GetAttribute("GroupRewardOwned") and "CLAIMED" or "CLAIM"

    Claim.Text.Text = v71

    if not v11 then
        v12(true)
    end
end)
v12(false)
