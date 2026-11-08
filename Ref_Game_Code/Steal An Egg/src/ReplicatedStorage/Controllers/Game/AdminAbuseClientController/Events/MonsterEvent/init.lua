-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local EggState = require(ReplicatedStorage.Client.EggState)
local Identity = require(ReplicatedStorage.Shared.Utils.Identity)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
local t1 = {
    "First",
    "Second",
    "Third"
}
local AvatarBust = Enum.ThumbnailType.AvatarBust
local Size150x150 = Enum.ThumbnailSize.Size150x150
local v1 = UDim2.fromScale(0, 0)
local v2 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v5 = Color3.fromRGB(255, 255, 32)
local v6 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v7 = Vector2.new(0.3, 0.35)
local v8 = Vector2.new(0.7, 0.65)
local v9 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v10 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v11 = Trove.new()
local v12 = false
local LocalPlayer = Players.LocalPlayer
local MonsterEventUI = LocalPlayer.PlayerGui:WaitForChild("MonsterEventUI")
local Rows = MonsterEventUI.Board.Rows
local v13 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local v14
local v15 = false
local t5 = {}
local v16 = {}
local v17 = false
local UpdateWinsUI

local function BuildRow(p1) -- line: 107
    -- upvalues: v1 (copy), Rows (copy)
    local v18 = Rows:FindFirstChild(p1)

    assert(v18 and v18:IsA("Frame"), (("MonsterEventUI is missing its %* row"):format(p1)))

    local Avatar = v18:FindFirstChild("Avatar")

    assert(Avatar and Avatar:IsA("ImageLabel"), (("the %* row is missing its Avatar"):format(p1)))

    local Amount = Avatar:FindFirstChild("Amount")

    assert(Amount and Amount:IsA("TextLabel"), (("the %* row is missing its Amount label"):format(p1)))

    local t6 = {
        Shown = false,
        Occupant = nil,
        Frame = v18,
        Avatar = Avatar,
        Amount = Amount,
        BaseSize = v18.Size,
        BaseColor = v18.BackgroundColor3
    }

    v18.Size = v1
    v18.Visible = false

    return t6
end

local function SetRowShown(p2, p3) -- line: 130
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    if p2.Shown == p3 then
        return
    end

    p2.Shown = p3

    local Frame = p2.Frame

    if p3 then
        Frame.Size = v1
        Frame.Visible = true
        TweenService:Create(Frame, v2, {
            Size = p2.BaseSize
        }):Play()
    else
        local tween = TweenService:Create(Frame, v2, {
            Size = v1
        })

        tween.Completed:Once(function() -- line: 145
            -- upvalues: p2 (copy), Frame (copy)
            Frame.Visible = p2.Shown
        end)
        tween:Play()
    end
end

local function FlashRow(p4) -- line: 149
    -- upvalues: TweenService (copy), v3 (copy)
    p4.Frame.BackgroundColor3 = p4.BaseColor:Lerp(Color3.new(1, 1, 1), 0.6)
    TweenService:Create(p4.Frame, v3, {
        BackgroundColor3 = p4.BaseColor
    }):Play()
end

local function ResolvePlayerImage(p5) -- line: 155
    -- upvalues: Players (copy), Identity (copy), AvatarBust (copy), Size150x150 (copy), t2 (copy), t3 (copy), UpdateWinsUI (ref)
    local v25 = t2[p5]

    if v25 then
        return v25
    end

    if not t3[p5] then
        local v26 = Players:FindFirstChild(p5)

        if v26 and v26:IsA("Player") then
            t3[p5] = true
            task.spawn(function() -- line: 165
                -- upvalues: p5 (copy), v26 (copy), Identity (copy), AvatarBust (copy), Size150x150 (copy), t2 (copy), t3 (copy), UpdateWinsUI (ref)
                local Thumbnail = Identity.Thumbnail
                local UserId = v26.UserId
                local ok, result = pcall(Thumbnail, UserId, AvatarBust, Size150x150)

                t3[p5] = nil

                if ok and type(result) == "string" then
                    t2[p5] = result
                    UpdateWinsUI()
                end
            end)
        end
    end

    return nil
end

local function FillRow(p6, p7, p8) -- line: 177
    -- upvalues: TweenService (copy), Simple (copy), v1 (copy), v2 (copy), FlashRow (copy), ResolvePlayerImage (copy)
    local v27 = ResolvePlayerImage(p7)

    p6.Avatar.Image = v27 or ""
    p6.Amount.Text = Simple.FormatCompact(p8, ".#")

    if p6.Occupant ~= nil and p6.Occupant ~= p7 then
        FlashRow(p6)
    end

    p6.Occupant = p7

    if p6.Shown == true then
        return
    end

    p6.Shown = true

    local Frame = p6.Frame

    Frame.Size = v1
    Frame.Visible = true
    TweenService:Create(Frame, v2, {
        Size = p6.BaseSize
    }):Play()
end

local function ClearRow(p9) -- line: 190
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    p9.Occupant = nil

    if p9.Shown == false then
        return
    end

    p9.Shown = false

    local Frame = p9.Frame
    local tween = TweenService:Create(Frame, v2, {
        Size = v1
    })

    tween.Completed:Once(function() -- line: 145
        -- upvalues: p9 (copy), Frame (copy)
        Frame.Visible = p9.Shown
    end)
    tween:Play()
end

function UpdateWinsUI() -- line: 195
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), LocalPlayer (copy), v13 (ref), t4 (copy), v14 (ref), FillRow (copy)
    local t7 = {}

    for v28, v29 in v13 do
        if v29 > 0 then
            table.insert(t7, {
                Name = v28,
                Wins = v29
            })
        end
    end

    table.sort(t7, function(p10, p11) -- line: 204
        if p10.Wins == p11.Wins then
            return p10.Name < p11.Name
        end

        return p10.Wins > p11.Wins
    end)

    local Name = LocalPlayer.Name
    local v30 = false

    for v31, v32 in t4 do
        local v33 = t7[v31]

        if v33 ~= nil then
            FillRow(v32, v33.Name, v33.Wins)
            v30 = v30 or v33.Name == Name
        else
            v32.Occupant = nil

            if v32.Shown ~= false then
                v32.Shown = false

                local Frame = v32.Frame
                local tween = TweenService:Create(Frame, v2, {
                    Size = v1
                })

                tween.Completed:Once(function() -- line: 145
                    -- upvalues: Frame (copy), v32 (copy)
                    Frame.Visible = v32.Shown
                end)
                tween:Play()
            end
        end
    end

    local v34 = v14

    assert(v34, "MonsterEventUI has no You row")

    if not v30 then
        FillRow(v34, Name, v13[Name] or 0)

        return
    end

    v34.Occupant = nil

    if v34.Shown ~= false then
        v34.Shown = false

        local Frame = v34.Frame
        local tween = TweenService:Create(Frame, v2, {
            Size = v1
        })

        tween.Completed:Once(function() -- line: 145
            -- upvalues: v34 (copy), Frame (copy)
            Frame.Visible = v34.Shown
        end)
        tween:Play()
    end
end

local function CollectWinPartFades(p12) -- line: 235
    local t9 = {
        {
            Property = "Transparency",
            Object = p12,
            Base = p12.Transparency
        }
    }

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("TextLabel") then
            table.insert(t9, {
                Property = "TextTransparency",
                Object = descendant,
                Base = descendant.TextTransparency
            })
            table.insert(t9, {
                Property = "BackgroundTransparency",
                Object = descendant,
                Base = descendant.BackgroundTransparency
            })
        elseif descendant:IsA("ImageLabel") then
            table.insert(t9, {
                Property = "ImageTransparency",
                Object = descendant,
                Base = descendant.ImageTransparency
            })
            table.insert(t9, {
                Property = "BackgroundTransparency",
                Object = descendant,
                Base = descendant.BackgroundTransparency
            })
        elseif descendant:IsA("Frame") then
            table.insert(t9, {
                Property = "BackgroundTransparency",
                Object = descendant,
                Base = descendant.BackgroundTransparency
            })
        elseif descendant:IsA("UIStroke") then
            table.insert(t9, {
                Property = "Transparency",
                Object = descendant,
                Base = descendant.Transparency
            })
        end
    end

    return t9
end

local function SetWinPartHidden(p13, p14) -- line: 255
    -- upvalues: TweenService (copy), v4 (copy)
    if p13.Hidden == p14 then
        return
    end

    p13.Hidden = p14

    if not p14 then
        p13.Gui.Enabled = true
    end

    for _, v35 in p13.Fades do
        local v36 = if p14 then 1 else v35.Base

        TweenService:Create(v35.Object, v4, {
            [v35.Property] = v36
        }):Play()
    end

    if p14 then
        task.delay(0.35, function() -- line: 269
            -- upvalues: p13 (copy)
            if p13.Hidden then
                p13.Gui.Enabled = false
            end
        end)
    end
end

local function ApplyWinPartVisibility() -- line: 277
    -- upvalues: t5 (ref), v16 (ref), v17 (ref), SetWinPartHidden (copy)
    for v37, v38 in t5 do
        SetWinPartHidden(v38, v17 or v16[v37] == true)
    end
end

local function FlashWinClaim() -- line: 284
    -- upvalues: Lighting (copy), TweenService (copy), v5 (copy), v6 (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

    ColorCorrectionEffect.Name = "MonsterEventWinFlash"
    ColorCorrectionEffect.TintColor = v5
    ColorCorrectionEffect.Contrast = 0.2
    ColorCorrectionEffect.Saturation = 0.1
    ColorCorrectionEffect.Parent = Lighting
    ColorCorrectionEffect.Enabled = true

    local tween = TweenService:Create(ColorCorrectionEffect, v6, {
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.new(1, 1, 1)
    })

    tween.Completed:Once(function() -- line: 300
        -- upvalues: ColorCorrectionEffect (copy)
        ColorCorrectionEffect:Destroy()
    end)
    tween:Play()
end

local function GetLocalRowAvatar() -- line: 305
    -- upvalues: LocalPlayer (copy), t4 (copy), v14 (ref)
    local Name = LocalPlayer.Name

    for _, v40 in t4 do
        if v40.Shown and v40.Occupant == Name then
            return v40.Avatar
        end
    end

    local v41 = v14

    return if v41 ~= nil and v41.Shown and v41.Occupant == Name then v41.Avatar else nil
end

local function ScreenPositionOf(p15) -- line: 318
    -- upvalues: MonsterEventUI (copy)
    local AbsoluteSize = MonsterEventUI.AbsoluteSize
    local v42 = p15.AbsolutePosition + p15.AbsoluteSize * 0.5 - MonsterEventUI.AbsolutePosition

    return UDim2.fromScale(v42.X / AbsoluteSize.X, v42.Y / AbsoluteSize.Y)
end

local function SpawnTrophyBurst(p16) -- line: 324
    -- upvalues: TweenService (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), MonsterEventUI (copy), GetLocalRowAvatar (copy)
    for _ = 1, math.clamp(p16, 1, 7) do
        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "MonsterEventTrophy"
        ImageLabel.Image = "rbxassetid://82857133407630"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.ImageTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ImageLabel.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(ImageLabel, TweenInfo.new(0.1), {
            Size = UDim2.fromScale(0.06, 0.06)
        }):Play()
        ImageLabel.Rotation = math.random(0, 359)
        ImageLabel.Position = UDim2.fromScale(v7.X + math.random() * (v8.X - v7.X), v7.Y + math.random() * (v8.Y - v7.Y))
        ImageLabel.ZIndex = 10

        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

        UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
        UIAspectRatioConstraint.Parent = ImageLabel
        ImageLabel.Parent = MonsterEventUI
        TweenService:Create(ImageLabel, v9, {
            ImageTransparency = 0
        }):Play()
        task.delay(0.2, function() -- line: 348
            -- upvalues: ImageLabel (copy), TweenService (copy), v10 (copy), MonsterEventUI (copy), GetLocalRowAvatar (copy)
            if ImageLabel.Parent == nil then
                return
            end

            local v43 = GetLocalRowAvatar()
            local t16 = {
                ImageTransparency = 1
            }

            if v43 ~= nil then
                local AbsoluteSize = MonsterEventUI.AbsoluteSize
                local v44 = v43.AbsolutePosition + v43.AbsoluteSize * 0.5 - MonsterEventUI.AbsolutePosition

                t16.Position = UDim2.fromScale(v44.X / AbsoluteSize.X, v44.Y / AbsoluteSize.Y)
            end

            local tween = TweenService:Create(ImageLabel, v10, t16)

            tween.Completed:Once(function() -- line: 359
                -- upvalues: ImageLabel (copy)
                ImageLabel:Destroy()
            end)
            tween:Play()
        end)
    end
end

local function InitWinParts() -- line: 365
    -- upvalues: v11 (copy), t5 (ref), CollectWinPartFades (copy)
    local v45 = workspace:WaitForChild("MonsterEventMap", 10)

    if v45 == nil then
        return
    end

    local WinParts = v45:FindFirstChild("WinParts")

    assert(WinParts ~= nil, "MonsterEventMap is missing its WinParts model")

    for _, child in WinParts:GetChildren() do
        assert(child:IsA("BasePart"), (("Win part %* is not a BasePart"):format(child.Name)))

        local SurfaceGui = child:FindFirstChildOfClass("SurfaceGui")

        assert(SurfaceGui ~= nil, (("Win part %* is missing its SurfaceGui"):format(child.Name)))

        local t17 = t5

        t17[child.Name] = {
            Hidden = false,
            Part = child,
            Gui = SurfaceGui,
            Fades = CollectWinPartFades(child)
        }
    end

    v11:Add(function() -- line: 385
        -- upvalues: t5 (ref)
        t5 = {}
    end)
end

for v50, v51 in t1 do
    t4[v50] = BuildRow(v51)
end

v14 = BuildRow("You")
Remotes.MonsterEvent.WinsUpdated.OnClientEvent:Connect(function(p17) -- line: 395
    -- upvalues: v13 (ref), UpdateWinsUI (ref)
    v13 = p17
    UpdateWinsUI()
end)
Remotes.MonsterEvent.PlaySFX.OnClientEvent:Connect(function(p18) -- line: 400
    script.SFX[p18]:Play()
end)
EggState.CarryChanged:Connect(function(p19) -- line: 404
    -- upvalues: v15 (ref)
    v15 = p19.IsCarrying
end)
Remotes.MonsterEvent.WinPartsUpdated.OnClientEvent:Connect(function(p20, p21) -- line: 406
    -- upvalues: t5 (ref), v16 (ref), v17 (ref), SetWinPartHidden (copy), FlashWinClaim (copy), SpawnTrophyBurst (copy)
    v16 = p20

    for v52, v53 in t5 do
        SetWinPartHidden(v53, v17 or v16[v52] == true)
    end

    if p21 ~= nil then
        FlashWinClaim()
        SpawnTrophyBurst(p21)
    end
end)

local v55 = false

local function OnKillBrickAdded(p22) -- line: 418
    -- upvalues: TweenService (copy), LocalPlayer (copy), MonsterEventUI (copy), v55 (ref)
    p22.Touched:Connect(function(p23) -- line: 419
        -- upvalues: TweenService (copy), LocalPlayer (copy), MonsterEventUI (copy), v55 (ref)
        if p23.Parent ~= LocalPlayer.Character or v55 then
            return
        end

        script.SFX.Died:Play()
        MonsterEventUI.Cover.Position = UDim2.new(-2, 0, 0.5, 0)
        v55 = true
        TweenService:Create(MonsterEventUI.Cover, TweenInfo.new(0.2), {
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.6)
        TweenService:Create(MonsterEventUI.Cover, TweenInfo.new(0.2), {
            Position = UDim2.new(2.7, 0, 0.5, 0)
        }):Play()
        task.wait(0.2)
        v55 = false
    end)
end

CollectionService:GetInstanceAddedSignal("MonsterEventKillBrick"):Connect(OnKillBrickAdded)

for _, v56 in CollectionService:GetTagged("MonsterEventKillBrick") do
    v56.Touched:Connect(function(p24) -- line: 419
        -- upvalues: TweenService (copy), LocalPlayer (copy), MonsterEventUI (copy), v55 (ref)
        if p24.Parent ~= LocalPlayer.Character or v55 then
            return
        end

        script.SFX.Died:Play()
        MonsterEventUI.Cover.Position = UDim2.new(-2, 0, 0.5, 0)
        v55 = true
        TweenService:Create(MonsterEventUI.Cover, TweenInfo.new(0.2), {
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.6)
        TweenService:Create(MonsterEventUI.Cover, TweenInfo.new(0.2), {
            Position = UDim2.new(2.7, 0, 0.5, 0)
        }):Play()
        task.wait(0.2)
        v55 = false
    end)
end

return {
    StartEvent = function(_, _) -- StartEvent | line: 454
        -- upvalues: TweenService (copy), Workspace (copy), Remotes (copy), LightingController (copy), v11 (copy), v12 (ref), MonsterEventUI (copy), v13 (ref), v15 (ref), t5 (ref), v16 (ref), v17 (ref), UpdateWinsUI (ref), SetWinPartHidden (copy), InitWinParts (copy)
        v11:Clean()
        v12 = true
        MonsterEventUI.Enabled = true

        for _, child in game.Workspace.World.Build["1"].COLLISIONS["COLL GUARD"]["WALL RIGHT (COLL GUARD)"]:GetChildren() do
            if child:IsA("BasePart") then
                child.CanCollide = false
                v11:Add(function() -- line: 463
                    -- upvalues: child (copy)
                    child.CanCollide = true
                end)
            end
        end

        task.spawn(function() -- line: 470
            -- upvalues: Workspace (copy), v12 (ref), v15 (ref)
            local FrozenWallRight = Workspace.World.Build["1"].COLLISIONS["GUARD NO COLLIDE"].PLAYER["WALL RIGHT"].FrozenWallRight

            while v12 do
                FrozenWallRight.CanCollide = v15
                task.wait()
            end

            FrozenWallRight.CanCollide = true
        end)
        workspace.World.Build.MainMap.Bases.SIDE_WALLS.CanCollide = false
        v11:Add(function() -- line: 483
            workspace.World.Build.MainMap.Bases.SIDE_WALLS.CanCollide = true
        end)
        v13 = Remotes.MonsterEvent.GetWins:InvokeServer()
        UpdateWinsUI()
        LightingController.SetLayer("MonsterEvent", "MonsterEvent", 25, 2)
        InitWinParts()
        v16 = Remotes.MonsterEvent.GetWinParts:InvokeServer()

        for v57, v58 in t5 do
            SetWinPartHidden(v58, v17 or v16[v57] == true)
        end

        if workspace:GetAttribute("PlayMonsterCutscene") then
            v17 = true

            for v60, v61 in t5 do
                SetWinPartHidden(v61, v17 or v16[v60] == true)
            end

            local Run = require(script.Cutscene)(v11).Run
            local _warn = warn

            xpcall(Run, _warn)
            v17 = false

            for v63, v64 in t5 do
                SetWinPartHidden(v64, v17 or v16[v63] == true)
            end
        end

        local MonsterEventMap = workspace:FindFirstChild("MonsterEventMap")

        if MonsterEventMap then
            local SurfaceGui = MonsterEventMap.WallStartVisual1.SurfaceGui
            local SurfaceGui2 = MonsterEventMap.WallStartVisual2.SurfaceGui

            SurfaceGui.Enabled = true
            SurfaceGui2.Enabled = true
        end

        local MonsterEventMusic = workspace:FindFirstChild("MonsterEventMusic")

        if MonsterEventMusic then
            TweenService:Create(MonsterEventMusic, TweenInfo.new(5), {
                Volume = 0.5
            }):Play()
        end
    end,
    StopEvent = function(_) -- StopEvent | line: 523
        -- upvalues: LightingController (copy), v11 (copy), v12 (ref), MonsterEventUI (copy), v13 (ref), v16 (ref), v17 (ref), UpdateWinsUI (ref)
        v11:Clean()
        v12 = false
        MonsterEventUI.Enabled = false
        v13 = {}
        UpdateWinsUI()
        v16 = {}
        v17 = false
        LightingController.ClearLayer("MonsterEvent", 2)
    end
}
