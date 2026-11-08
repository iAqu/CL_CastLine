-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local AreaEggResetWall = require(ReplicatedStorage.Client.AreaEggResetWall)

require(ReplicatedStorage.Shared.Types.AreaEggs)

local Audio = require(ReplicatedStorage.Shared.Audio)
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local CaptureTheEgg = require(ReplicatedStorage.Data.CaptureTheEgg)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local EggRenderer = require(ReplicatedStorage.Shared.Eggs.EggRenderer)
local EggState = require(ReplicatedStorage.Client.EggState)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local PlayVFX = require(ReplicatedStorage.UserGenerated.VFX.PlayVFX)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SpawnLock = require(ReplicatedStorage.Client.SpawnLock)
local Trove = require(ReplicatedStorage.Packages.Trove)
local EggUidAttribute = CaptureTheEgg.EggUidAttribute
local t1 = {
    "Leader",
    "Second",
    "Third"
}
local t2 = {
    "Leader",
    "Second",
    "Third",
    "You"
}
local t3 = {
    Color3.fromRGB(255, 214, 89),
    Color3.fromRGB(213, 213, 213),
    Color3.fromRGB(204, 141, 96)
}
local v1 = UDim2.fromScale(0.5, 0.085)
local v2 = UDim2.fromScale(0.5, 0.2)
local v3 = UDim2.fromScale(0.5, -0.35)
local LocalPlayer = Players.LocalPlayer
local t4
local t5 = {}
local v4 = {}
local n1 = 0
local n2 = 0
local CarrierUserId, AbsoluteSize, UserId
local v5 = false
local Uid = nil
local v6
local v7 = false
local v8 = false
local v9 = not AreaEggResetWall.IsSealed()
local n3 = 0
local v10
local n4 = 0
local n5 = 0
local v11 = false
local v12 = false
local v13 = false
local n6 = 0
local v14 = false
local v15, t6, v16, t7
local t8 = {}
local t9 = {}
local t10 = {}
local t11 = {}

local function cancelTween(p1) -- line: 168
    if p1 ~= nil then
        p1:Cancel()
    end
end

local function formatSeconds(p2) -- line: 174
    return string.format("%.1f", math.floor(math.max(p2, 0) * 10) / 10)
end

local function easeOutQuint(p3) -- line: 178
    return 1 - (1 - p3) ^ 5
end

local function easeInOutCubic(p4) -- line: 182
    if p4 < 0.5 then
        return p4 * 4 * p4 * p4
    end

    return 1 - (p4 * -2 + 2) ^ 3 / 2
end

local function warnMissingAssetOnce(p5, p6) -- line: 186
    -- upvalues: t10 (copy)
    if not t10[p5] then
        t10[p5] = true
        warn(p6)
    end
end

local function getScoreboardUi() -- line: 198
    -- upvalues: t2 (copy), LocalPlayer (copy), t4 (ref), v13 (ref)
    local t12 = t4

    if t12 ~= nil and t12.Gui.Parent ~= nil then
        return t12
    end

    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local CaptureTheEggUI = PlayerGui and PlayerGui:FindFirstChild("CaptureTheEggUI")
    local Board, Rows

    if CaptureTheEggUI ~= nil and CaptureTheEggUI:IsA("ScreenGui") then
        Board = CaptureTheEggUI:FindFirstChild("Board")
        Rows = Board and Board:FindFirstChild("Rows")

        if Board ~= nil and Board:IsA("Frame") and Rows ~= nil and Rows:IsA("Frame") then
            local UIListLayout = Rows:FindFirstChildOfClass("UIListLayout")

            if UIListLayout ~= nil then
                UIListLayout:Destroy()
            end

            local t13 = {}

            for _, v18 in t2 do
                local v19 = Rows:FindFirstChild(v18)
                local Avatar = v19 and v19:FindFirstChild("Avatar")
                local Timer = Avatar and Avatar:FindFirstChild("Timer")

                if v19 == nil
                    or not v19:IsA("Frame")
                    or Avatar == nil
                    or not Avatar:IsA("ImageLabel")
                    or Timer == nil
                    or not Timer:IsA("TextLabel") then
                    local v20 = v13

                    if not v20 then
                        v13 = true
                        warn((("[CaptureTheEgg] CaptureTheEggUI is missing its %* card."):format(v18)))
                    end

                    return nil
                end

                local UIScale = v19:FindFirstChildOfClass("UIScale")

                if UIScale == nil then
                    UIScale = Instance.new("UIScale")
                    UIScale.Name = "UIScale"
                    UIScale.Parent = v19
                end

                v19.AnchorPoint = Vector2.new(0.5, 0.5)
                v19.Position = UDim2.fromScale(0.5, 0.5)
                v19.Visible = false
                UIScale.Scale = 0.72
                t13[v18] = {
                    Rank = nil,
                    UserId = nil,
                    MoveTween = nil,
                    ScaleTween = nil,
                    AvatarTween = nil,
                    TimerTween = nil,
                    Token = 0,
                    Name = v18,
                    Frame = v19,
                    Avatar = Avatar,
                    Timer = Timer,
                    Scale = UIScale
                }
            end

            local t14 = {
                Gui = CaptureTheEggUI,
                Board = Board,
                Rows = Rows,
                Cards = t13
            }

            t4 = t14
            v13 = false

            return t14
        end

        if not v13 then
            v13 = true
            warn("[CaptureTheEgg] CaptureTheEggUI is stale; it needs a Board frame with a Rows frame.")
        end

        return nil
    end

    if not v13 then
        v13 = true
        warn("[CaptureTheEgg] CaptureTheEggUI is missing from StarterGui.")
    end

    return nil
end

local function applyBoardVisibility(p7) -- line: 288
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v3 (copy), v5 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n4 (ref), getScoreboardUi (copy)
    local v21 = getScoreboardUi()

    if v21 == nil then
        return
    end

    local Gui, Board = v21.Gui, v21.Board
    local v22 = v7 and v9

    if v22 == v8 and not p7 then
        if v22 then
            Gui.Enabled = true
        end

        return
    end

    n4 += 1

    local v23 = n4
    local v24 = v10

    if v24 ~= nil then
        v24:Cancel()
    end

    v10 = nil

    if v22 then
        local v25 = if v5 then v2 else v1

        Gui.Enabled = true

        if not v8 then
            Board.Position = v3
        end

        v8 = true

        if p7 then
            Board.Position = v25
        else
            v10 = TweenService:Create(Board, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = v25
            })
            v10:Play()
        end
    else
        v8 = false

        if p7 then
            Board.Position = v3
            Gui.Enabled = false
        elseif Gui.Enabled then
            v10 = TweenService:Create(Board, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = v3
            })
            v10:Play()
            v10.Completed:Once(function() -- line: 345
                -- upvalues: Gui (copy), v23 (copy), v8 (ref), n4 (ref)
                if v23 == n4 and not v8 then
                    Gui.Enabled = false
                end
            end)
        else
            Board.Position = v3
        end
    end
end

local function setBoardShown(p8, p9) -- line: 352
    -- upvalues: v7 (ref), applyBoardVisibility (copy)
    v7 = p8
    applyBoardVisibility(p9)
end

local function setWallIsDown(p10) -- line: 357
    -- upvalues: v9 (ref), applyBoardVisibility (copy)
    if v9 ~= p10 then
        v9 = p10
        applyBoardVisibility()
    end
end

local function setLocalPlayerCarryingEgg(p11) -- line: 365
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v5 (ref), v8 (ref), v10 (ref), n4 (ref), getScoreboardUi (copy)
    if v5 == p11 then
        return
    end

    v5 = p11

    if v8 then
        local v26 = getScoreboardUi()

        if v26 ~= nil and v26.Gui.Enabled then
            n4 += 1

            local v27 = v10

            if v27 ~= nil then
                v27:Cancel()
            end

            v10 = TweenService:Create(v26.Board, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = if p11 then v2 else v1
            })
            v10:Play()
        end
    end
end

local function refreshSpawnLock() -- line: 391
    -- upvalues: Workspace (copy), SpawnLock (copy), EggUidAttribute (copy), Uid (ref), v6 (ref)
    local v29 = Uid ~= nil and Uid == Workspace:GetAttribute(EggUidAttribute)

    if v29 and v6 == nil then
        v6 = SpawnLock.ObtainLock()

        return
    end

    if not v29 and v6 ~= nil then
        local v30 = v6

        v6 = nil
        v30()
    end
end

local function cancelCardTweens(p12) -- line: 402
    local MoveTween = p12.MoveTween

    if MoveTween ~= nil then
        MoveTween:Cancel()
    end

    local ScaleTween = p12.ScaleTween

    if ScaleTween ~= nil then
        ScaleTween:Cancel()
    end

    local AvatarTween = p12.AvatarTween

    if AvatarTween ~= nil then
        AvatarTween:Cancel()
    end

    local TimerTween = p12.TimerTween

    if TimerTween ~= nil then
        TimerTween:Cancel()
    end

    p12.MoveTween = nil
    p12.ScaleTween = nil
    p12.AvatarTween = nil
    p12.TimerTween = nil
end

local function removeTransferGhost(p13) -- line: 413
    -- upvalues: t5 (copy)
    local v31 = table.find(t5, p13)

    if v31 ~= nil then
        table.remove(t5, v31)
    end

    p13:Destroy()
end

local function clearTransferGhosts() -- line: 421
    -- upvalues: t5 (copy)
    for _, v32 in t5 do
        v32:Destroy()
    end

    table.clear(t5)
end

local function cardWidthScale(p14, p15) -- line: 428
    local AbsoluteSize = p14.Rows.AbsoluteSize

    if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then
        return p15.Frame.Size.X.Scale
    end

    return p15.Frame.Size.Y.Scale * AbsoluteSize.Y / AbsoluteSize.X
end

local function calculateCardPositions(p16, p17) -- line: 436
    local t16 = {}
    local v34 = math.max(#p17 - 1, 0) * 0.025

    for _, v35 in p17 do
        local State = v35.State
        local AbsoluteSize = p16.Rows.AbsoluteSize

        v34 += if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then State.Frame.Size.Y.Scale * AbsoluteSize.Y / AbsoluteSize.X else State.Frame.Size.X.Scale
    end

    local v36 = 0.5 - v34 * 0.5

    for _, v37 in p17 do
        local State = v37.State
        local AbsoluteSize = p16.Rows.AbsoluteSize
        local v38 = if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then State.Frame.Size.Y.Scale * AbsoluteSize.Y / AbsoluteSize.X else State.Frame.Size.X.Scale

        t16[v37.State.Name] = UDim2.fromScale(v36 + v38 * 0.5, 0.5)
        v36 += v38 + 0.025
    end

    return t16
end

local function createTransferGhost(p18, p19, p20, p21) -- line: 452
    -- upvalues: TweenService (copy), t5 (copy)
    local AbsoluteSize = p18.Rows.AbsoluteSize

    if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 or p19.Avatar.AbsoluteSize.X <= 0 then
        return false
    end

    local v39 = p19.Avatar.AbsolutePosition + p19.Avatar.AbsoluteSize * 0.5 - p18.Rows.AbsolutePosition
    local clone = p19.Avatar:Clone()

    clone.Name = ("Transfer_%*"):format(p19.UserId or 0)

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("TextLabel") then
            descendant:Destroy()
        end
    end

    clone.AnchorPoint = Vector2.new(0.5, 0.5)
    clone.Position = UDim2.fromScale(v39.X / AbsoluteSize.X, v39.Y / AbsoluteSize.Y)
    clone.Size = UDim2.fromScale(p19.Avatar.AbsoluteSize.X / AbsoluteSize.X, p19.Avatar.AbsoluteSize.Y / AbsoluteSize.Y)
    clone.ZIndex = 30
    clone.Parent = p18.Rows
    table.insert(t5, clone)

    local fromScale = UDim2.fromScale
    local AbsoluteSize2 = p18.Rows.AbsoluteSize
    local v40 = fromScale(if not (AbsoluteSize2.X > 0 and AbsoluteSize2.Y > 0) then p20.Frame.Size.X.Scale else p20.Frame.Size.Y.Scale * AbsoluteSize2.Y / AbsoluteSize2.X, p20.Frame.Size.Y.Scale)
    local tween = TweenService:Create(clone, TweenInfo.new(0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        ImageTransparency = 0.35,
        Position = p21,
        Size = v40
    })

    tween:Play()
    tween.Completed:Once(function() -- line: 489
        -- upvalues: clone (copy), t5 (copy)
        local v41 = table.find(t5, clone)

        if v41 ~= nil then
            table.remove(t5, v41)
        end

        clone:Destroy()
    end)

    return true
end

local function showCard(p22, p23) -- line: 495
    -- upvalues: TweenService (copy)
    local v42 = p22.Frame.Visible and p22.UserId ~= nil

    p22.Token += 1

    local MoveTween = p22.MoveTween

    if MoveTween ~= nil then
        MoveTween:Cancel()
    end

    local ScaleTween = p22.ScaleTween

    if ScaleTween ~= nil then
        ScaleTween:Cancel()
    end

    if not v42 then
        p22.Frame.Position = p23 + UDim2.fromScale(0, -0.32)
        p22.Scale.Scale = 0.72
    end

    p22.Frame.Visible = true
    p22.MoveTween = TweenService:Create(p22.Frame, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = p23
    })
    p22.ScaleTween = TweenService:Create(p22.Scale, TweenInfo.new(v42 and 0.24 or 0.46, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = 1
    })
    p22.MoveTween:Play()
    p22.ScaleTween:Play()
end

local function hideCard(p24, p25) -- line: 519
    -- upvalues: TweenService (copy)
    if not p24.Frame.Visible and p24.UserId == nil then
        return
    end

    p24.Token += 1

    local Token, MoveTween = p24.Token, p24.MoveTween

    if MoveTween ~= nil then
        MoveTween:Cancel()
    end

    local ScaleTween = p24.ScaleTween

    if ScaleTween ~= nil then
        ScaleTween:Cancel()
    end

    local AvatarTween = p24.AvatarTween

    if AvatarTween ~= nil then
        AvatarTween:Cancel()
    end

    local TimerTween = p24.TimerTween

    if TimerTween ~= nil then
        TimerTween:Cancel()
    end

    p24.MoveTween = nil
    p24.ScaleTween = nil
    p24.AvatarTween = nil
    p24.TimerTween = nil
    p24.UserId = nil
    p24.Rank = nil

    if p25 then
        p24.Frame.Visible = false
        p24.Frame.Position = UDim2.fromScale(0.5, 0.5)
        p24.Scale.Scale = 0.72
        p24.Avatar.ImageTransparency = 0
        p24.Timer.TextTransparency = 0
    else
        p24.MoveTween = TweenService:Create(p24.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = p24.Frame.Position + UDim2.fromScale(0, 0.18)
        })
        p24.ScaleTween = TweenService:Create(p24.Scale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Scale = 0.72
        })
        p24.MoveTween:Play()
        p24.ScaleTween:Play()
        p24.ScaleTween.Completed:Once(function() -- line: 550
            -- upvalues: p24 (copy), Token (copy)
            if p24.Token == Token and p24.UserId == nil then
                p24.Frame.Visible = false
            end
        end)
    end
end

local function setCardEntry(p26, p27, p28, p29) -- line: 557
    -- upvalues: TweenService (copy), t3 (copy)
    local v43 = p26.UserId ~= p27.UserId
    local Seconds = p27.Seconds
    local v45 = string.format("%.1f", math.floor(math.max(Seconds, 0) * 10) / 10)
    local v46 = p26.Timer.Text ~= v45

    p26.Token += 1

    local Token, AvatarTween = p26.Token, p26.AvatarTween

    if AvatarTween ~= nil then
        AvatarTween:Cancel()
    end

    local TimerTween = p26.TimerTween

    if TimerTween ~= nil then
        TimerTween:Cancel()
    end

    p26.UserId = p27.UserId
    p26.Rank = p28
    p26.Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(p27.UserId)
    p26.Timer.Text = v45

    local UIStroke = p26.Avatar:FindFirstChildOfClass("UIStroke")

    if UIStroke ~= nil then
        if p28 ~= nil then
            UIStroke.Color = t3[p28]
        else
            UIStroke.Color = p26.Frame.BackgroundColor3
        end
    end

    if v43 then
        p26.Avatar.ImageTransparency = p29 and 1 or 0.52
        p26.Timer.TextTransparency = 1

        local v47 = p29 and 0.2356 or 0

        task.delay(v47, function() -- line: 579
            -- upvalues: p26 (copy), p27 (copy), Token (copy), TweenService (copy)
            if p26.Token ~= Token or p26.UserId ~= p27.UserId then
                return
            end

            p26.AvatarTween = TweenService:Create(p26.Avatar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0
            })
            p26.TimerTween = TweenService:Create(p26.Timer, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0
            })
            p26.AvatarTween:Play()
            p26.TimerTween:Play()
        end)
    else
        if p26.Avatar.ImageTransparency > 0 then
            p26.AvatarTween = TweenService:Create(p26.Avatar, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0
            })
            p26.AvatarTween:Play()
        end

        if v46 or p26.Timer.TextTransparency > 0 then
            p26.Timer.TextTransparency = math.max(p26.Timer.TextTransparency, 0.28)
            p26.TimerTween = TweenService:Create(p26.Timer, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                TextTransparency = 0
            })
            p26.TimerTween:Play()
        end
    end
end

local function pulseLeader(p30) -- line: 617
    -- upvalues: TweenService (copy), t3 (copy)
    local ScaleTween = p30.ScaleTween

    if ScaleTween ~= nil then
        ScaleTween:Cancel()
    end

    p30.Scale.Scale = 1.16
    p30.ScaleTween = TweenService:Create(p30.Scale, TweenInfo.new(0.62, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
        Scale = 1
    })
    p30.ScaleTween:Play()

    local UIStroke = p30.Avatar:FindFirstChildOfClass("UIStroke")

    if UIStroke == nil then
        return
    end

    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Thickness = 4
    TweenService:Create(UIStroke, TweenInfo.new(0.62, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Thickness = 2,
        Color = t3[1]
    }):Play()
end

local function buildCardAssignments(p31, p32) -- line: 639
    -- upvalues: t1 (copy), LocalPlayer (copy)
    local t17 = {}
    local v51 = false

    for i = 1, math.min(#p32, #t1) do
        v51 = v51 or p32[i].UserId == LocalPlayer.UserId
        table.insert(t17, {
            State = p31.Cards[t1[i]],
            Entry = p32[i],
            Rank = i
        })
    end

    if not v51 then
        local v52

        for _, v53 in p32 do
            if v53.UserId == LocalPlayer.UserId then
                v52 = v53
                break
            end
        end

        if v52 == nil then
            v52 = {
                Seconds = 0,
                UserId = LocalPlayer.UserId,
                Name = LocalPlayer.DisplayName
            }
        end

        table.insert(t17, {
            Rank = nil,
            State = p31.Cards.You,
            Entry = v52
        })
    end

    return t17
end

local function reconcileScoreboard(p33) -- line: 676
    -- upvalues: UserId (ref), v8 (ref), getScoreboardUi (copy), calculateCardPositions (copy), createTransferGhost (copy), showCard (copy), hideCard (copy), setCardEntry (copy), pulseLeader (copy), buildCardAssignments (copy)
    local v54 = getScoreboardUi()

    if v54 == nil then
        return
    end

    local v55 = buildCardAssignments(v54, p33)
    local v56 = calculateCardPositions(v54, v55)
    local t20 = {}

    for _, v57 in v54.Cards do
        if v57.Frame.Visible and v57.UserId ~= nil then
            t20[v57.UserId] = v57
        end
    end

    local t21 = {}

    if v8 and v54.Gui.Enabled then
        for _, v58 in v55 do
            local v59 = t20[v58.Entry.UserId]

            if v59 ~= nil and v59 ~= v58.State then
                t21[v58.State.Name] = createTransferGhost(v54, v59, v58.State, v56[v58.State.Name])
            end
        end
    end

    local t22 = {}

    for _, v60 in v55 do
        local State = v60.State

        t22[State.Name] = true
        showCard(State, v56[State.Name])
        setCardEntry(State, v60.Entry, v60.Rank, t21[State.Name] == true)
    end

    for v61, v62 in v54.Cards do
        if not t22[v61] then
            hideCard(v62)
        end
    end

    local UserId2 = if #p33 > 0 then p33[1].UserId else nil

    if UserId ~= nil and UserId2 ~= nil and UserId ~= UserId2 then
        pulseLeader(v54.Cards.Leader)
    end

    UserId = UserId2
end

local function sanitizeEntries(p34) -- line: 722
    local t23 = {}
    local t24 = {}

    for _, v63 in p34 do
        if type(v63) == "table" and type(v63.UserId) == "number" and type(v63.Name) == "string" and type(v63.Seconds) == "number" and v63.Seconds == v63.Seconds and v63.Seconds < 1e999 and not t24[v63.UserId] then
            t24[v63.UserId] = true
            table.insert(t23, {
                UserId = v63.UserId,
                Name = v63.Name,
                Seconds = math.max(v63.Seconds, 0)
            })
        end
    end

    return t23
end

local function buildLiveEntries() -- line: 748
    -- upvalues: Workspace (copy), EggState (copy), EggUidAttribute (copy), v4 (ref), n1 (ref), CarrierUserId (ref), v11 (ref), v12 (ref)
    local v64 = table.clone(v4)
    local CarrierUserId2 = CarrierUserId
    local v65, v66

    if CarrierUserId2 ~= nil then
        if v11 and v12 and Workspace:GetAttribute("Event_CaptureTheEggGameplay") == true then
            local Attribute = Workspace:GetAttribute(EggUidAttribute)

            if type(Attribute) == "string" then
                v65 = EggState.ReadFieldEgg(Attribute)
            end

            v66 = if v65 == nil then 0 elseif v65.CarrierUserId == CarrierUserId2 then math.clamp(Workspace:GetServerTimeNow() - n1, 0, 2) else 0
        else
            v66 = 0
        end
    else
        v66 = 0
    end

    if v66 > 0 then
        for v68, v69 in v64 do
            if v69.UserId == CarrierUserId2 then
                local v70 = table.clone(v69)

                v70.Seconds += v66
                v64[v68] = v70
                break
            end
        end
    end

    table.sort(v64, function(p35, p36) -- line: 784
        if p35.Seconds == p36.Seconds then
            return p35.UserId < p36.UserId
        end

        return p35.Seconds > p36.Seconds
    end)

    return v64
end

local function refreshScoreboardCards(p37) -- line: 794
    -- upvalues: AbsoluteSize (ref), getScoreboardUi (copy), buildCardAssignments (copy), reconcileScoreboard (copy)
    local v71 = getScoreboardUi()

    if v71 ~= nil then
        local AbsoluteSize2 = v71.Rows.AbsoluteSize

        if AbsoluteSize == AbsoluteSize2 then
            local v72 = buildCardAssignments(v71, p37)
            local t26 = {}

            for _, v73 in v72 do
                local State = v73.State

                t26[State.Name] = true

                if not State.Frame.Visible or State.UserId ~= v73.Entry.UserId or State.Rank ~= v73.Rank then
                    reconcileScoreboard(p37)

                    return
                end
            end

            for v74, v75 in v71.Cards do
                if v75.UserId ~= nil and not t26[v74] then
                    reconcileScoreboard(p37)

                    return
                end
            end

            for _, v76 in v72 do
                local Timer = v76.State.Timer
                local Seconds = v76.Entry.Seconds
                local v78 = string.format("%.1f", math.floor(math.max(Seconds, 0) * 10) / 10)

                if Timer.Text ~= v78 then
                    Timer.Text = v78
                end
            end
        else
            AbsoluteSize = AbsoluteSize2
            reconcileScoreboard(p37)
        end
    end
end

local function renderScoreboard(p38, p39) -- line: 836
    -- upvalues: Workspace (copy), v4 (ref), n1 (ref), n2 (ref), CarrierUserId (ref), v7 (ref), v11 (ref), v12 (ref), v14 (ref), applyBoardVisibility (copy), sanitizeEntries (copy), buildLiveEntries (copy), refreshScoreboardCards (copy)
    local CarrierUserId2, v79

    if type(p39) == "table" then
        if type(p39.Revision) ~= "number" or p39.Revision ~= p39.Revision or p39.Revision >= 1e999 or p39.Revision <= n2 then
            v79 = true
        elseif type(p39.SampledAt) ~= "number" or p39.SampledAt ~= p39.SampledAt or math.abs(p39.SampledAt) == 1e999 then
            v79 = true
        else
            n2 = p39.Revision
            v4 = sanitizeEntries(p38)
            n1 = p39.SampledAt

            if type(p39.CarrierUserId) == "number" then
                CarrierUserId2 = p39.CarrierUserId
            end

            v79 = false
        end
    else
        v79 = true
    end

    if v79 then
        return
    end

    CarrierUserId = CarrierUserId2

    if not v11 and Workspace:GetAttribute("Event_CaptureTheEgg") == true then
        v11 = true
    end

    if not v11 then
        return
    end

    v12 = Workspace:GetAttribute("Event_CaptureTheEggGameplay") == true
    refreshScoreboardCards((buildLiveEntries()))
    v7 = not not (v11 and v12 and not v14)
    applyBoardVisibility(nil)
end

local function updateLiveTimers() -- line: 875
    -- upvalues: t4 (ref), v8 (ref), buildLiveEntries (copy), refreshScoreboardCards (copy)
    local t27 = t4

    if t27 ~= nil and v8 and t27.Gui.Enabled then
        refreshScoreboardCards((buildLiveEntries()))
    end
end

local function resetScoreboardCards() -- line: 883
    -- upvalues: t5 (copy), v4 (ref), n1 (ref), CarrierUserId (ref), AbsoluteSize (ref), UserId (ref), getScoreboardUi (copy)
    for _, v80 in t5 do
        v80:Destroy()
    end

    table.clear(t5)

    local v81 = getScoreboardUi()

    if v81 ~= nil then
        for _, v82 in v81.Cards do
            if v82.Frame.Visible or v82.UserId ~= nil then
                v82.Token += 1

                local _, MoveTween = v82.Token, v82.MoveTween

                if MoveTween ~= nil then
                    MoveTween:Cancel()
                end

                local ScaleTween = v82.ScaleTween

                if ScaleTween ~= nil then
                    ScaleTween:Cancel()
                end

                local AvatarTween = v82.AvatarTween

                if AvatarTween ~= nil then
                    AvatarTween:Cancel()
                end

                local TimerTween = v82.TimerTween

                if TimerTween ~= nil then
                    TimerTween:Cancel()
                end

                v82.MoveTween = nil
                v82.ScaleTween = nil
                v82.AvatarTween = nil
                v82.TimerTween = nil
                v82.UserId = nil
                v82.Rank = nil
                v82.Frame.Visible = false
                v82.Frame.Position = UDim2.fromScale(0.5, 0.5)
                v82.Scale.Scale = 0.72
                v82.Avatar.ImageTransparency = 0
                v82.Timer.TextTransparency = 0
            end
        end
    end

    UserId = nil
    v4 = {}
    n1 = 0
    CarrierUserId = nil
    AbsoluteSize = nil
end

local function refreshScoreboardAvailability() -- line: 898
    -- upvalues: Workspace (copy), v7 (ref), v11 (ref), v12 (ref), v14 (ref), applyBoardVisibility (copy), buildLiveEntries (copy), refreshScoreboardCards (copy)
    if not v11 and Workspace:GetAttribute("Event_CaptureTheEgg") == true then
        v11 = true
    end

    v12 = v11 and Workspace:GetAttribute("Event_CaptureTheEggGameplay") == true

    local v83 = v12

    if not v83 or v14 then
        v7 = false
    else
        refreshScoreboardCards((buildLiveEntries()))
        v7 = true
    end

    applyBoardVisibility(nil)
end

local function resolveAsset(p40, p41) -- line: 916
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v84 = Assets and Assets:FindFirstChild(p40)

    return v84 and v84:FindFirstChild(p41)
end

local function playSound(p42, p43, p44) -- line: 922
    -- upvalues: ReplicatedStorage (copy), Audio (copy), t10 (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Sounds = Assets and Assets:FindFirstChild("Sounds")
    local v85 = Sounds and Sounds:FindFirstChild(p42)
    local Play, v86

    if v85 ~= nil and v85:IsA("Sound") then
        Play = Audio.Play
        v86 = p44 or script

        local ok, result = pcall(Play, v85, v86)

        if ok then
            if result ~= nil and result.Parent ~= nil then
                if p44 == nil then
                    p43:Add(result)
                end

                return result
            end
        else
            warn((("[CaptureTheEgg] %* failed to play: %*"):format(p42, result)))
        end

        return nil
    end

    local v87 = ("[CaptureTheEgg] Missing ReplicatedStorage.Assets.Sounds.%*; the cinematic will continue without it."):format(p42)

    if not t10[p42] then
        t10[p42] = true
        warn(v87)
    end

    return nil
end

local function emitImpactVfx(p45) -- line: 948
    -- upvalues: Debris (copy), ReplicatedStorage (copy), Workspace (copy), PlayVFX (copy), t10 (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local Particles = Assets and Assets:FindFirstChild("Particles")
    local BigHitGroundAttach = Particles and Particles:FindFirstChild("BigHitGroundAttach")

    if BigHitGroundAttach ~= nil then
        if BigHitGroundAttach:IsA("ParticleEmitter") or BigHitGroundAttach:FindFirstChildWhichIsA("ParticleEmitter", true) ~= nil then
            local Part = Instance.new("Part")

            Part.Name = "CaptureTheEggImpactVFX"
            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Transparency = 1
            Part.Size = Vector3.new(0.1, 0.1, 0.1)
            Part.CFrame = p45
            Part.Parent = Workspace:FindFirstChild("Transient") or Workspace
            Debris:AddItem(Part, 10)

            local clone = BigHitGroundAttach:Clone()
            local ok, result = pcall(PlayVFX, Part, p45, clone)

            if not ok then
                clone:Destroy()
                warn((("[CaptureTheEgg] BigHitGroundAttach failed to play: %*"):format(result)))
            end
        elseif not t10.BigHitGroundAttachEmitter then
            t10.BigHitGroundAttachEmitter = true
            warn("[CaptureTheEgg] BigHitGroundAttach has no ParticleEmitter descendants; impact VFX was skipped.")
        end
    elseif not t10.BigHitGroundAttach then
        t10.BigHitGroundAttach = true
        warn("[CaptureTheEgg] Missing ReplicatedStorage.Assets.Particles.BigHitGroundAttach; impact VFX was skipped.")
    end
end

local function preloadCutsceneAssets(p46) -- line: 988
    -- upvalues: ContentProvider (copy), ReplicatedStorage (copy), CaptureTheEgg (copy), EggRecords (copy), EggRenderer (copy), t9 (copy)
    if t9[p46] then
        return
    end

    t9[p46] = true
    task.spawn(function() -- line: 994
        -- upvalues: p46 (copy), ContentProvider (copy), ReplicatedStorage (copy), CaptureTheEgg (copy), EggRecords (copy), EggRenderer (copy)
        local t28 = {}
        local t29 = {}

        for _, v88 in {
                { "Sounds", "CinematicRiser" },
                { "Sounds", "CinematicBoom" },
                { "Sounds", "ImpactBoom" },
                { "Particles", "BigHitGroundAttach" }
            } do
            local v89 = v88[1]
            local v90 = v88[2]
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local v91 = Assets and Assets:FindFirstChild(v89)
            local v92 = v91 and v91:FindFirstChild(v90)

            if v92 ~= nil then
                table.insert(t28, v92)
            end
        end

        local function v93() -- line: 1011
            -- upvalues: p46 (copy), EggRecords (copy), EggRenderer (copy)
            return EggRenderer.GetTemplate(EggRecords.NewEgg(p46))
        end

        local ok, result = pcall(v93)

        if ok and typeof(result) == "Instance" then
            table.insert(t28, result)
        end

        for _, v94 in {
                CaptureTheEgg.DanceAnimationId,
                CaptureTheEgg.R6DanceAnimationId
            } do
            local Animation = Instance.new("Animation")

            Animation.AnimationId = v94
            table.insert(t28, Animation)
            table.insert(t29, Animation)
        end

        if #t28 > 0 then
            local PreloadAsync = ContentProvider.PreloadAsync

            pcall(PreloadAsync, ContentProvider, t28)
        end

        for _, v95 in t29 do
            v95:Destroy()
        end
    end)
end

local function resolvePreloadCategory(p47) -- line: 1034
    -- upvalues: CaptureTheEgg (copy)
    if type(p47) == "table" and type(p47.EggCategory) == "string" and p47.EggCategory ~= "" then
        return p47.EggCategory
    end

    return CaptureTheEgg.CarryCategory
end

local function ensureOverlay() -- line: 1041
    -- upvalues: LocalPlayer (copy), t7 (ref)
    local t30 = t7

    if t30 ~= nil and t30.Gui.Parent ~= nil then
        return t30
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "CaptureTheEggCinematic"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 50
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Name = "Vignette"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://104574024062008"
    ImageLabel.ImageColor3 = Color3.new(0, 0, 0)
    ImageLabel.ImageTransparency = 1
    ImageLabel.ScaleType = Enum.ScaleType.Stretch
    ImageLabel.Size = UDim2.fromScale(1, 1)
    ImageLabel.ZIndex = 1
    ImageLabel.Parent = ScreenGui

    local function createBar(p48, p49) -- line: 1065
        -- upvalues: ScreenGui (copy)
        local Frame = Instance.new("Frame")

        Frame.Name = p48
        Frame.BackgroundColor3 = Color3.new(0, 0, 0)
        Frame.BorderSizePixel = 0
        Frame.Position = p49
        Frame.Size = UDim2.fromScale(1, 0.11)
        Frame.ZIndex = 2
        Frame.Parent = ScreenGui

        return Frame
    end

    local Top = createBar("Top", UDim2.fromScale(0, -0.11))
    local Bottom = createBar("Bottom", UDim2.fromScale(0, 1))

    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local t31 = {
        Gui = ScreenGui,
        Top = Top,
        Bottom = Bottom,
        Vignette = ImageLabel
    }

    t7 = t31

    return t31
end

local function setOverlayShown(p50) -- line: 1091
    -- upvalues: TweenService (copy), t8 (ref), ensureOverlay (copy)
    for _, v96 in t8 do
        v96:Cancel()
    end

    table.clear(t8)

    local v97 = ensureOverlay()
    local v98 = TweenInfo.new(0.9, Enum.EasingStyle.Quint, if p50 then Enum.EasingDirection.Out else Enum.EasingDirection.In)

    t8 = {
        TweenService:Create(v97.Top, v98, {
            Position = if p50 then UDim2.fromScale(0, 0) else UDim2.fromScale(0, -0.11)
        }),
        TweenService:Create(v97.Bottom, v98, {
            Position = if p50 then UDim2.fromScale(0, 0.89) else UDim2.fromScale(0, 1)
        }),
        TweenService:Create(v97.Vignette, v98, {
            ImageTransparency = p50 and 0.3 or 1
        })
    }

    for _, v99 in t8 do
        v99:Play()
    end
end

local function cloneStarterCharacter(p51) -- line: 1125
    -- upvalues: Players (copy), ReplicatedStorage (copy), CaptureTheEgg (copy), t10 (copy)
    local v100 = ReplicatedStorage:FindFirstChild(CaptureTheEgg.StarterRigName)

    if v100 ~= nil and not v100:IsA("Model") then
        v100 = nil
    end

    if v100 == nil then
        local PlayerByUserId = Players:GetPlayerByUserId(p51)

        v100 = PlayerByUserId and PlayerByUserId.Character
    end

    if v100 == nil then
        return nil
    end

    v100.Archivable = true

    local clone = v100:Clone()

    v100.Archivable = false

    local v101 = clone:FindFirstChild("HumanoidRootPart", true)

    if v101 == nil or not v101:IsA("BasePart") then
        v101 = clone.PrimaryPart
    end

    if v101 == nil then
        clone:Destroy()

        if not t10.DanceRigRoot then
            t10.DanceRigRoot = true
            warn("[CaptureTheEgg] The starter's cloned character has no root part.")
        end

        return nil
    end

    clone.PrimaryPart = v101

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = descendant == v101
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = descendant ~= v101
        elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
            descendant:Destroy()
        end
    end

    local Humanoid = clone:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        Humanoid.AutoRotate = false
        Humanoid.BreakJointsOnDeath = false
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    return clone
end

local function playDance(p52) -- line: 1176
    -- upvalues: CaptureTheEgg (copy), t10 (copy)
    local Humanoid = p52:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        local Animator = Humanoid:FindFirstChildOfClass("Animator")

        if Animator == nil then
            Animator = Instance.new("Animator")
            Animator.Parent = Humanoid
        end

        for _, v102 in Animator:GetPlayingAnimationTracks() do
            v102:Stop(0)
        end

        local Animation = Instance.new("Animation")

        if Humanoid.RigType == Enum.HumanoidRigType.R6 then
            Animation.AnimationId = CaptureTheEgg.R6DanceAnimationId
        else
            Animation.AnimationId = CaptureTheEgg.DanceAnimationId
        end

        Animation.Parent = p52

        local LoadAnimation = Animator.LoadAnimation
        local ok, result = pcall(LoadAnimation, Animator, Animation)

        if ok then
            result.Priority = Enum.AnimationPriority.Action
            result.Looped = true
            result:Play(0.1, 1, 1)
        else
            warn((("[CaptureTheEgg] Could not load the starter dance: %*"):format(result)))
        end
    elseif not t10.DanceHumanoid then
        t10.DanceHumanoid = true
        warn("[CaptureTheEgg] The starter's dancer rig has no Humanoid.")
    end
end

local function getModelTopOffset(p53) -- line: 1212
    local BoundingBox, BoundingBox2 = p53:GetBoundingBox()

    return BoundingBox.Position.Y + BoundingBox2.Y * 0.5 - p53:GetPivot().Position.Y
end

local function getModelBottomToPivot(p54) -- line: 1217
    local BoundingBox, BoundingBox2 = p54:GetBoundingBox()

    return p54:GetPivot().Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y * 0.5)
end

local function handheldNoise(p55, p56) -- line: 1222
    return (math.noise(p55 * 0.25, p56 * 7.31, 0.5) + math.noise(p55 * 1.25, p56 * 7.31 + 3.17, 9.5) * 0.2) / 1.2 * 2
end

local function handheldOffset(p57, p58) -- line: 1228
    local v103 = (math.noise(p57 * 0.25, 7.31, 0.5) + math.noise(p57 * 1.25, 10.48, 9.5) * 0.2) / 1.2 * 2 * 0.02007128639793479 * p58
    local v104 = (math.noise(p57 * 0.25, 14.62, 0.5) + math.noise(p57 * 1.25, 17.79, 9.5) * 0.2) / 1.2 * 2 * 0.014835298641951801 * p58
    local v105 = (math.noise(p57 * 0.25, 21.93, 0.5) + math.noise(p57 * 1.25, 25.1, 9.5) * 0.2) / 1.2 * 2 * 0.007853981633974483 * p58
    local v109 = Vector3.new((math.noise(p57 * 0.25, 29.24, 0.5) + math.noise(p57 * 1.25, 32.41, 9.5) * 0.2) / 1.2 * 2 * 0.1599999964237213, (math.noise(p57 * 0.25, 36.55, 0.5) + math.noise(p57 * 1.25, 39.72, 9.5) * 0.2) / 1.2 * 2 * 0.12999999523162842, (math.noise(p57 * 0.25, 43.86, 0.5) + math.noise(p57 * 1.25, 47.03, 9.5) * 0.2) / 1.2 * 2 * 0.07999999821186066) * p58

    return CFrame.new(v109) * CFrame.Angles(0, v103, 0) * CFrame.Angles(v104, 0, v105)
end

local function resolveShotDirection(p59, p60) -- line: 1240
    local v110 = p59.Position - p60
    local v111 = Vector3.new(v110.X, 0, v110.Z)

    if v111.Magnitude < 1 then
        return (Vector3.new(1, 0, 1)).Unit
    end

    return v111.Unit
end

local function resolveEggShot(p61, p62, p63) -- line: 1249
    local v113 = p61 + Vector3.new(0, p63 * 0.5, 0)
    local v116 = p61 + p62 * (p63 * 0.55 + 45) + Vector3.new(0, p63 * 0.18 + 11, 0)

    return CFrame.lookAt(v116, v113)
end

local function restoreCutsceneCamera() -- line: 1256
    -- upvalues: Workspace (copy), t6 (ref)
    local CurrentCamera = Workspace.CurrentCamera
    local t35 = t6

    t6 = nil

    if CurrentCamera == nil or t35 == nil then
        return
    end

    CurrentCamera.CFrame = t35.CFrame
    CurrentCamera.FieldOfView = t35.FieldOfView
    CurrentCamera.CameraType = t35.CameraType

    if t35.CameraSubject ~= nil and t35.CameraSubject.Parent ~= nil then
        CurrentCamera.CameraSubject = t35.CameraSubject
    end
end

local function revealScoreboardAfterCutscene() -- line: 1272
    -- upvalues: v11 (ref), refreshScoreboardAvailability (copy)
    if v11 then
        refreshScoreboardAvailability()
    end
end

local function stopCutscene(p64) -- line: 1279
    -- upvalues: RunService (copy), Workspace (copy), v11 (ref), n6 (ref), v14 (ref), v15 (ref), t6 (ref), v16 (ref), refreshScoreboardAvailability (copy), setOverlayShown (copy)
    if not v14 then
        return
    end

    n6 += 1
    v14 = false

    local UnbindFromRenderStep = RunService.UnbindFromRenderStep

    pcall(UnbindFromRenderStep, RunService, "CaptureTheEggCutsceneCamera")

    local v117 = v15

    v15 = nil

    if v117 ~= nil then
        v117:Clean()
    end

    setOverlayShown(false)

    local CurrentCamera = Workspace.CurrentCamera
    local t36 = t6

    t6 = nil

    if CurrentCamera ~= nil and t36 ~= nil then
        CurrentCamera.CFrame = t36.CFrame
        CurrentCamera.FieldOfView = t36.FieldOfView
        CurrentCamera.CameraType = t36.CameraType

        if t36.CameraSubject ~= nil and t36.CameraSubject.Parent ~= nil then
            CurrentCamera.CameraSubject = t36.CameraSubject
        end
    end

    if v16 ~= nil then
        local v118 = v16

        v16 = nil
        v118()
    end

    if p64 then
        if not v11 then
            return
        end

        refreshScoreboardAvailability()
    end
end

local function buildCutsceneRecord(p65, p66) -- line: 1305
    -- upvalues: EggRecords (copy)
    local v119 = EggRecords.NewEgg(p65)

    if p66 ~= nil and #p66 > 0 then
        v119.Mutations = table.clone(p66)
        v119.BaseMutation = p66[1]
    end

    return v119
end

local function playCutscene(p67, p68, p69, p70, p71, p72) -- line: 1314
    -- upvalues: RunService (copy), TweenService (copy), Workspace (copy), CameraShaker (copy), CameraShakerDriver (copy), CaptureTheEgg (copy), EggRecords (copy), EggRenderer (copy), HiddenUIHandler (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v5 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n4 (ref), v11 (ref), n6 (ref), v14 (ref), v15 (ref), t6 (ref), v16 (ref), getScoreboardUi (copy), refreshScoreboardAvailability (copy), playSound (copy), emitImpactVfx (copy), setOverlayShown (copy), cloneStarterCharacter (copy), playDance (copy), handheldOffset (copy), stopCutscene (copy)
    if v14 then
        return
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        local function v120() -- line: 1332
            -- upvalues: p71 (copy), p72 (copy), Workspace (copy), CaptureTheEgg (copy), EggRecords (copy), EggRenderer (copy)
            local RenderVisual = EggRenderer.RenderVisual
            local t37 = {
                OwnerUserId = 0,
                UID = "CaptureTheEggCutscene",
                ModelName = "CaptureTheEggCutsceneEgg"
            }
            local v121 = EggRecords.NewEgg(p71)

            if p72 ~= nil and #p72 > 0 then
                v121.Mutations = table.clone(p72)
                v121.BaseMutation = p72[1]
            end

            t37.Record = v121
            t37.ScaleMultiplier = CaptureTheEgg.EggScale

            return RenderVisual(t37, Workspace)
        end

        local ok, result = pcall(v120)

        if ok then
            local function v122() -- line: 1347
                -- upvalues: p67 (copy), p68 (copy), p69 (copy), p70 (copy), CurrentCamera (copy), result (copy), RunService (copy), TweenService (copy), Workspace (copy), CameraShaker (copy), CameraShakerDriver (copy), CaptureTheEgg (copy), HiddenUIHandler (copy), Trove (copy), v1 (copy), v2 (copy), v3 (copy), v5 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n4 (ref), n6 (ref), v14 (ref), v15 (ref), t6 (ref), v16 (ref), getScoreboardUi (copy), playSound (copy), emitImpactVfx (copy), setOverlayShown (copy), cloneStarterCharacter (copy), playDance (copy), handheldOffset (copy), stopCutscene (copy)
                n6 += 1

                local v123 = n6

                v14 = true

                local v124 = Trove.new()

                v15 = v124

                local v125 = CameraShaker.new()
                local Model = result.Model

                v124:Add(Model)

                local BoundingBox, BoundingBox2 = Model:GetBoundingBox()
                local v126 = BoundingBox.Position.Y + BoundingBox2.Y * 0.5 - Model:GetPivot().Position.Y
                local v127 = p68.Position + Vector3.new(0, 260, 0)
                local v128 = CFrame.new(v127) * p68.Rotation

                Model:PivotTo(v128)

                local _CFrame = CurrentCamera.CFrame
                local Position = p69.Position
                local v129 = _CFrame.Position - Position
                local v130 = Vector3.new(v129.X, 0, v129.Z)
                local Unit = if v130.Magnitude < 1 then (Vector3.new(1, 0, 1)).Unit else v130.Unit
                local v131 = cloneStarterCharacter(p67)
                local v132

                if v131 ~= nil then
                    local BoundingBox, BoundingBox2 = v131:GetBoundingBox()

                    v132 = v131:GetPivot().Position.Y - (BoundingBox.Position.Y - BoundingBox2.Y * 0.5)
                else
                    v132 = 0
                end

                local Rotation = CFrame.lookAt(Vector3.new(0, 0, 0), Unit).Rotation

                if v131 ~= nil then
                    local v135 = v128.Position + v128.UpVector * v126 + Vector3.new(0, v132 + 0.25, 0)

                    v131:PivotTo(CFrame.new(v135) * Rotation)
                    v131.Parent = Workspace
                    v124:Add(v131)
                    playDance(v131)
                end

                local elapsed = os.clock()
                local v136 = false
                local v137 = false
                local v138 = true
                local v139 = false
                local v140 = playSound("CinematicRiser", v124, nil)

                t6 = {
                    CFrame = CurrentCamera.CFrame,
                    FieldOfView = CurrentCamera.FieldOfView,
                    CameraType = CurrentCamera.CameraType,
                    CameraSubject = CurrentCamera.CameraSubject
                }

                local t38 = t6

                v7 = false

                local v141 = getScoreboardUi()

                if v141 ~= nil then
                    local Gui, Board = v141.Gui, v141.Board
                    local v142 = v7 and v9

                    if v142 == v8 then
                    end

                    n4 += 1

                    local v143 = v10

                    if v143 ~= nil then
                        v143:Cancel()
                    end

                    v10 = nil

                    if v142 then
                        local v144 = if v5 then v2 else v1

                        Gui.Enabled = true

                        if not v8 then
                            Board.Position = v3
                        end

                        v8 = true
                        Board.Position = v144
                    else
                        v8 = false
                        Board.Position = v3
                        Gui.Enabled = false
                    end
                end

                v16 = HiddenUIHandler.Acquire()
                setOverlayShown(true)
                CurrentCamera.CameraType = Enum.CameraType.Scriptable

                local function stepCutscene(p73) -- line: 1397
                    -- upvalues: v123 (copy), v124 (copy), v125 (copy), Model (copy), v126 (copy), v127 (copy), v131 (copy), Rotation (copy), elapsed (copy), v136 (ref), v137 (ref), v138 (ref), v139 (ref), v140 (copy), t38 (copy), Unit (copy), v132 (ref), p68 (copy), p69 (copy), p70 (copy), CurrentCamera (copy), TweenService (copy), Workspace (copy), CameraShakerDriver (copy), CaptureTheEgg (copy), n6 (ref), v14 (ref), playSound (copy), emitImpactVfx (copy), setOverlayShown (copy), handheldOffset (copy), stopCutscene (copy)
                    if v123 ~= n6 or not v14 then
                        return
                    end

                    CurrentCamera.CameraType = Enum.CameraType.Scriptable

                    local ServerTimeNow = Workspace:GetServerTimeNow()
                    local v146 = math.clamp((ServerTimeNow - (p70 - CaptureTheEgg.CutsceneFallSeconds)) / CaptureTheEgg.CutsceneFallSeconds, 0, 1)
                    local v147 = v146 * 0.08 + v146 ^ 2.65 * 0.92
                    local v148 = v127:Lerp(p68.Position, v147)
                    local v150 = math.sin(3.141592653589793 * v146)
                    local v152 = math.sin(15.707963267948966 * v146) * 0.19198621771937624 * v150
                    local v154 = math.sin(21.991148575128552 * v146) * 0.13962634015954636 * v150
                    local v155 = CFrame.Angles(v152, 25.132741228718345 * v146, v154)
                    local v156 = CFrame.new(v148) * p68.Rotation * v155

                    if v138 then
                        Model:PivotTo(v156)
                    end

                    if v131 ~= nil then
                        local v159 = v156.Position + v156.UpVector * v126 + Vector3.new(0, v132 + 0.25, 0)

                        v131:PivotTo(CFrame.new(v159) * Rotation)
                    end

                    if v146 >= 1 and not v136 then
                        v136 = true

                        if v138 then
                            v138 = false
                            Model:PivotTo(p68)
                            Model:Destroy()
                        end

                        if v131 ~= nil then
                            local v162 = p68.Position + p68.UpVector * v126 + Vector3.new(0, v132 + 0.25, 0)

                            v131:PivotTo(CFrame.new(v162) * Rotation)
                        end

                        if v140 ~= nil and v140.Parent ~= nil then
                            local tween = TweenService:Create(v140, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                Volume = 0
                            })

                            v124:Add(tween)
                            tween:Play()
                        end

                        playSound("CinematicBoom", v124, nil)
                        playSound("ImpactBoom", v124, p69)
                        emitImpactVfx(p69)
                        v125:ShakeOnce(8.5, 12, 0, 1.35)
                    end

                    local v163 = os.clock() - elapsed
                    local v165 = 1 - (1 - math.clamp(v163 / 0.95, 0, 1)) ^ 5
                    local v167 = v148 + Vector3.new(0, v126 * 0.5, 0)
                    local v170 = v148 + Unit * (v126 * 0.55 + 45) + Vector3.new(0, v126 * 0.18 + 11, 0)
                    local v171 = CFrame.lookAt(v170, v167)
                    local Position = p68.Position
                    local v173 = Position + Vector3.new(0, v126 * 0.5, 0)
                    local v176 = Position + Unit * (v126 * 0.55 + 45) + Vector3.new(0, v126 * 0.18 + 11, 0)
                    local v177 = CFrame.lookAt(v176, v173)
                    local v178 = t38.CFrame:Lerp(v171, v165)
                    local v179 = t38.FieldOfView + (50 - t38.FieldOfView) * v165
                    local v181 = math.max(ServerTimeNow - p70, 0)
                    local v182, v183, v184, v185, v186

                    if v136 then
                        local v187 = t38.CFrame:Lerp(v177, v165)
                        local v189 = v179 + math.exp(-v181 * 6) * 9

                        if v181 >= 1.5 then
                            v182 = math.clamp((v181 - 1.5) / 1.15, 0, 1)
                            v186 = v182
                            v183 = if v182 < 0.5 then v182 * 4 * v182 * v182 else 1 - (v182 * -2 + 2) ^ 3 / 2
                            v184 = v177:Lerp(t38.CFrame, v183)
                            v185 = (t38.FieldOfView - 50) * v183 + 50

                            if not v137 then
                                v137 = true
                                setOverlayShown(false)
                            end
                        else
                            v184 = v187
                            v186 = 0
                            v185 = v189
                        end
                    else
                        v184 = v178
                        v186 = 0
                        v185 = v179
                    end

                    local v192 = math.clamp(v163 / 1.1, 0, 1)

                    if v136 then
                        v192 *= 0.55
                    end

                    local v193 = v192 * (1 - v186)

                    CurrentCamera.FieldOfView = v185
                    CurrentCamera.CFrame = v184 * handheldOffset(v163, v193) * CameraShakerDriver.Advance(v125, p73)

                    if v186 >= 1 and not v139 then
                        v139 = true
                        task.defer(function() -- line: 1487
                            -- upvalues: v123 (copy), n6 (ref), stopCutscene (copy)
                            if v123 == n6 then
                                stopCutscene(true)
                            end
                        end)
                    end
                end

                RunService:BindToRenderStep("CaptureTheEggCutsceneCamera", Enum.RenderPriority.Camera.Value + 1, function(p74) -- line: 1495
                    -- upvalues: v123 (copy), v139 (ref), stepCutscene (copy), n6 (ref), stopCutscene (copy)
                    local traceback = debug.traceback
                    local v195, v196 = xpcall(stepCutscene, traceback, p74)

                    if v195 or v139 then
                        return
                    end

                    v139 = true
                    warn((("[CaptureTheEgg] Cutscene frame failed: %*"):format(v196)))
                    task.defer(function() -- line: 1500
                        -- upvalues: v123 (copy), n6 (ref), stopCutscene (copy)
                        if v123 == n6 then
                            stopCutscene(true)
                        end
                    end)
                end)
            end

            local traceback = debug.traceback
            local v197, v198 = xpcall(v122, traceback)

            if not v197 then
                warn((("[CaptureTheEgg] Cutscene setup failed: %*"):format(v198)))

                if v14 then
                    stopCutscene(true)
                else
                    if not v11 then
                        return
                    end

                    refreshScoreboardAvailability()
                end
            end
        else
            warn((("[CaptureTheEgg] Could not render the falling egg: %*"):format(result)))

            if v11 then
                refreshScoreboardAvailability()
            end
        end
    elseif v11 then
        refreshScoreboardAvailability()
    end
end

function t11.StartEvent(_, _, p77) -- line: 1522
    -- upvalues: ContentProvider (copy), ReplicatedStorage (copy), Workspace (copy), CaptureTheEgg (copy), EggRecords (copy), EggRenderer (copy), v1 (copy), v2 (copy), v3 (copy), v5 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n4 (ref), n5 (ref), v11 (ref), v12 (ref), t9 (copy), getScoreboardUi (copy), resetScoreboardCards (copy), refreshScoreboardAvailability (copy)
    n5 += 1
    v11 = true
    v12 = Workspace:GetAttribute("Event_CaptureTheEggGameplay") == true
    resetScoreboardCards()
    v7 = false

    local v199 = getScoreboardUi()

    if v199 ~= nil then
        local Gui, Board = v199.Gui, v199.Board
        local v200 = v7 and v9

        if v200 == v8 then
        end

        n4 += 1

        local v201 = v10

        if v201 ~= nil then
            v201:Cancel()
        end

        v10 = nil

        if v200 then
            local v202 = if v5 then v2 else v1

            Gui.Enabled = true

            if not v8 then
                Board.Position = v3
            end

            v8 = true
            Board.Position = v202
        else
            v8 = false
            Board.Position = v3
            Gui.Enabled = false
        end
    end

    local v203 = false

    if type(p77) == "table" and type(p77.EggCategory) == "string" then
        v203 = p77.EggCategory ~= ""
    end

    local v204 = if v203 then p77.EggCategory else CaptureTheEgg.CarryCategory

    if not t9[v204] then
        t9[v204] = true
        task.spawn(function() -- line: 994
            -- upvalues: v204 (copy), ContentProvider (copy), ReplicatedStorage (copy), CaptureTheEgg (copy), EggRecords (copy), EggRenderer (copy)
            local t39 = {}
            local t40 = {}

            for _, v205 in {
                    { "Sounds", "CinematicRiser" },
                    { "Sounds", "CinematicBoom" },
                    { "Sounds", "ImpactBoom" },
                    { "Particles", "BigHitGroundAttach" }
                } do
                local v206 = v205[1]
                local v207 = v205[2]
                local Assets = ReplicatedStorage:FindFirstChild("Assets")
                local v208 = Assets and Assets:FindFirstChild(v206)
                local v209 = v208 and v208:FindFirstChild(v207)

                if v209 ~= nil then
                    table.insert(t39, v209)
                end
            end

            local function v210() -- line: 1011
                -- upvalues: v204 (copy), EggRecords (copy), EggRenderer (copy)
                return EggRenderer.GetTemplate(EggRecords.NewEgg(v204))
            end

            local ok, result = pcall(v210)

            if ok and typeof(result) == "Instance" then
                table.insert(t39, result)
            end

            for _, v211 in {
                    CaptureTheEgg.DanceAnimationId,
                    CaptureTheEgg.R6DanceAnimationId
                } do
                local Animation = Instance.new("Animation")

                Animation.AnimationId = v211
                table.insert(t39, Animation)
                table.insert(t40, Animation)
            end

            if #t39 > 0 then
                local PreloadAsync = ContentProvider.PreloadAsync

                pcall(PreloadAsync, ContentProvider, t39)
            end

            for _, v212 in t40 do
                v212:Destroy()
            end
        end)
    end

    refreshScoreboardAvailability()
end

function t11.StopEvent(_) -- line: 1532
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v5 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n4 (ref), n5 (ref), v11 (ref), v12 (ref), getScoreboardUi (copy), applyBoardVisibility (copy), hideCard (copy), resetScoreboardCards (copy), stopCutscene (copy)
    n5 += 1

    local v213 = n5

    v11 = false
    v12 = false
    stopCutscene(false)
    v7 = false
    applyBoardVisibility(nil)

    local v214 = getScoreboardUi()

    if v214 ~= nil then
        for _, v215 in v214.Cards do
            hideCard(v215)
        end
    end

    task.delay(0.26, function() -- line: 1545
        -- upvalues: v213 (copy), v1 (copy), v2 (copy), v3 (copy), v5 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n4 (ref), n5 (ref), getScoreboardUi (copy), resetScoreboardCards (copy)
        if v213 ~= n5 then
            return
        end

        resetScoreboardCards()
        v7 = false

        local v216 = getScoreboardUi()

        if v216 == nil then
            return
        end

        local Gui, Board = v216.Gui, v216.Board
        local v217 = v7 and v9

        if v217 == v8 then
        end

        n4 += 1

        local v218 = v10

        if v218 ~= nil then
            v218:Cancel()
        end

        v10 = nil

        if v217 then
            local v219 = if v5 then v2 else v1

            Gui.Enabled = true

            if not v8 then
                Board.Position = v3
            end

            v8 = true
            Board.Position = v219
        else
            v8 = false
            Board.Position = v3
            Gui.Enabled = false
        end
    end)
end

Remotes.EggCapture.StandingsRefreshed.OnClientEvent:Connect(function(p79, p80) -- line: 1559
    -- upvalues: renderScoreboard (copy)
    if type(p79) == "table" then
        renderScoreboard(p79, p80)
    end
end)
Remotes.EggCapture.CutsceneBegan.OnClientEvent:Connect(function(p81, p82, p83, p84, p85, p86) -- line: 1568
    -- upvalues: playCutscene (copy)
    if type(p81) == "number" and typeof(p82) == "CFrame" and typeof(p83) == "CFrame" and type(p84) == "number" and p84 == p84 and type(p85) == "string" then
        playCutscene(p81, p82, p83, p84, p85, if type(p86) == "table" then p86 else nil)
    end
end)
AreaEggResetWall.Changed:Connect(function(p87) -- line: 1599
    -- upvalues: AreaEggResetWall (copy), v9 (ref), n3 (ref), applyBoardVisibility (copy)
    n3 += 1

    if p87 then
        if v9 ~= false then
            v9 = false
            applyBoardVisibility()
        end
    else
        local v221 = n3

        task.delay(AreaEggResetWall.CollapseSeconds, function() -- line: 1606
            -- upvalues: v221 (copy), AreaEggResetWall (copy), v9 (ref), n3 (ref), applyBoardVisibility (copy)
            if v221 ~= n3 or AreaEggResetWall.IsSealed() or v9 == true then
                return
            end

            v9 = true
            applyBoardVisibility()
        end)
    end
end)
EggState.CarryChanged:Connect(function(p88) -- line: 1613
    -- upvalues: Workspace (copy), SpawnLock (copy), EggUidAttribute (copy), Uid (ref), v6 (ref), setLocalPlayerCarryingEgg (copy)
    setLocalPlayerCarryingEgg(p88.IsCarrying)
    Uid = if p88.IsCarrying then p88.Uid else nil

    local v222 = Uid ~= nil and Uid == Workspace:GetAttribute(EggUidAttribute)

    if v222 and v6 == nil then
        v6 = SpawnLock.ObtainLock()

        return
    end

    if not v222 and v6 ~= nil then
        local v223 = v6

        v6 = nil
        v223()
    end
end)
LocalPlayer.CharacterRemoving:Connect(function() -- line: 1619
    -- upvalues: Workspace (copy), SpawnLock (copy), EggUidAttribute (copy), Uid (ref), v6 (ref), setLocalPlayerCarryingEgg (copy)
    setLocalPlayerCarryingEgg(false)
    Uid = nil

    local v224 = Uid ~= nil and Uid == Workspace:GetAttribute(EggUidAttribute)

    if v224 and v6 == nil then
        v6 = SpawnLock.ObtainLock()

        return
    end

    if not v224 and v6 ~= nil then
        local v225 = v6

        v6 = nil
        v225()
    end
end)
Workspace:GetAttributeChangedSignal(EggUidAttribute):Connect(refreshSpawnLock)
Workspace:GetAttributeChangedSignal("Event_CaptureTheEggGameplay"):Connect(refreshScoreboardAvailability)
RunService.RenderStepped:Connect(function() -- line: 1629
    -- upvalues: t4 (ref), v8 (ref), buildLiveEntries (copy), refreshScoreboardCards (copy)
    local t41 = t4

    if t41 ~= nil and v8 then
        if not t41.Gui.Enabled then
            return
        end

        refreshScoreboardCards((buildLiveEntries()))
    end
end)
task.defer(function() -- line: 1635
    -- upvalues: Workspace (copy), v1 (copy), v2 (copy), v3 (copy), v5 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), n4 (ref), v11 (ref), getScoreboardUi (copy), resetScoreboardCards (copy), refreshScoreboardAvailability (copy)
    if Workspace:GetAttribute("Event_CaptureTheEgg") == true then
        v11 = true
        refreshScoreboardAvailability()
    else
        resetScoreboardCards()
        v7 = false

        local v226 = getScoreboardUi()

        if v226 ~= nil then
            local Gui, Board = v226.Gui, v226.Board
            local v227 = v7 and v9

            if v227 == v8 then
            end

            n4 += 1

            local v228 = v10

            if v228 ~= nil then
                v228:Cancel()
            end

            v10 = nil

            if v227 then
                local v229 = if v5 then v2 else v1

                Gui.Enabled = true

                if not v8 then
                    Board.Position = v3
                end

                v8 = true
                Board.Position = v229
            else
                v8 = false
                Board.Position = v3
                Gui.Enabled = false
            end
        end
    end
end)

return t11
