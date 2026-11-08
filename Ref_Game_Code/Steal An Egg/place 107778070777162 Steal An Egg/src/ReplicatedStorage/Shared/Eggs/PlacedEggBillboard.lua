-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ServerClock = require(game:GetService("ReplicatedStorage").Shared.Util.ServerClock)
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Assets = require(ReplicatedStorage.Data.Assets)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
local Eggs = require(ReplicatedStorage.Shared.Types.Eggs)
local Elapsed = require(ReplicatedStorage.Shared.Utils.Time).Elapsed
local GUI = require(ReplicatedStorage.Client.GUI)
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local HoverHighlight = require(ReplicatedStorage.Client.WorldFX.HoverHighlight)
local MonsterParasite = require(ReplicatedStorage.Shared.Types.MonsterParasite)
local SurfaceTracker = require(ReplicatedStorage.Client.SmartProximityPrompt.SurfaceTracker)
local MonsterParasite2 = require(ReplicatedStorage.Data.MonsterParasite)
local Save = require(ReplicatedStorage.Shared.Save)
local t = require(ReplicatedStorage.Packages.t)
local t1 = {}
local t2 = {}
local v1, t3
local v2 = ""
local v3
local n1 = 0
local tween = nil
local v4
local t4 = {}

local function getKey(p1, p2) -- line: 81
    return (("%*:%*"):format(p1, p2))
end

local function bindGui() -- line: 83
    -- upvalues: GUI (copy), t3 (ref)
    local t5 = t3

    if t5 ~= nil then
        return t5
    end

    local v5 = GUI.AssetEggData()

    assert(v5:IsA("ScreenGui"), "PlayerGui.AssetEggData must be a ScreenGui")

    local Frame = v5.Frame

    assert(Frame:IsA("GuiObject"), "AssetEggData.Frame must be a GuiObject")

    local CanvasGroup = Frame.CanvasGroup

    assert(CanvasGroup:IsA("GuiObject"), "AssetEggData.Frame.CanvasGroup must be a GuiObject")

    local DisplayName = CanvasGroup.DisplayName

    assert(DisplayName:IsA("TextLabel"), "AssetEggData.Frame.CanvasGroup.DisplayName must be a TextLabel")

    local RemainingHatchTime = CanvasGroup.RemainingHatchTime

    assert(RemainingHatchTime:IsA("TextLabel"), "AssetEggData.Frame.CanvasGroup.RemainingHatchTime must be a TextLabel")

    local t6 = {
        Root = v5,
        Frame = Frame,
        CanvasGroup = CanvasGroup,
        DisplayName = DisplayName,
        RemainingHatchTime = RemainingHatchTime
    }

    t3 = t6
    Frame.Visible = false
    RemainingHatchTime.RichText = true

    return t6
end

local function getRemainingSeconds(p3) -- line: 120
    -- upvalues: ServerClock (copy), Players (copy), EggRecords (copy)
    local Record = p3.Record
    local Placement = Record.Placement
    local v6, v7

    if Placement ~= nil then
        if Placement.ReadyAt ~= nil then
            v7 = true
        else
            local TimeSkipSeconds = p3.TimeSkipSeconds

            v6 = if TimeSkipSeconds ~= nil then TimeSkipSeconds.Value else 0
            v7 = false
        end
    else
        v7 = true
    end

    if v7 then
        return 0
    end

    return (math.max(0, EggRecords.GrowthSecondsRemaining(Record, ServerClock.Now(), Record.GrowthSpeedMultiplier, nil, Players.LocalPlayer) - v6))
end

local function getEntryScreenPosition(p4) -- line: 141
    -- upvalues: Workspace (copy), ModelBounds (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera ~= nil then
        local v9, v10 = CurrentCamera:WorldToViewportPoint(ModelBounds(p4.Model).Position)

        if v10 then
            return true, Vector2.new(v9.X, v9.Y)
        end
    end

    return false, Vector2.zero
end

local function selectNearestEntry() -- line: 157
    -- upvalues: Players (copy), t1 (copy)
    local Character = Players.LocalPlayer.Character

    if Character == nil or Character.PrimaryPart == nil then
        return nil
    end

    local PrimaryPartPosition = Character.PrimaryPart.Position
    local n2 = 1e999
    local v11

    for _, v12 in pairs(t1) do
        if v12.Model.Parent ~= nil then
            local _, ClosestSurfacePoint = v12.Tracker:GetClosestSurfacePoint(PrimaryPartPosition, 0, 7)

            if ClosestSurfacePoint ~= nil and ClosestSurfacePoint <= 7 and ClosestSurfacePoint < n2 then
                n2 = ClosestSurfacePoint
                v11 = v12
            end
        end
    end

    return v11
end

local function updateStaticContent(p5, p6) -- line: 181
    -- upvalues: Assets (copy), SwapGradient (copy)
    local v13 = Assets.Directory[p6.Record.AssetCategory]

    assert(v13 ~= nil, (("Missing asset config for category %*"):format(p6.Record.AssetCategory)))
    p5.DisplayName.Text = "Egg"
    SwapGradient(p5.DisplayName, if v13.Egg.HideRarity or p6.Record.PurchaseId ~= nil then nil else v13.Rarity.RarityGradient)
end

local function updateCountdown(p7, p8) -- line: 194
    -- upvalues: ServerClock (copy), Players (copy), EggRecords (copy), Elapsed (copy), MonsterParasite (copy), MonsterParasite2 (copy), Save (copy), v2 (ref)
    local v16 = p8.OwnerUserId == Players.LocalPlayer.UserId

    p7.RemainingHatchTime.Visible = v16

    if not v16 then
        v2 = ""

        return
    end

    local Record = p8.Record
    local Placement = Record.Placement
    local v17, v18

    if Placement ~= nil then
        if Placement.ReadyAt ~= nil then
            v18 = true
        else
            local TimeSkipSeconds = p8.TimeSkipSeconds

            v17 = if TimeSkipSeconds ~= nil then TimeSkipSeconds.Value else 0
            v18 = false
        end
    else
        v18 = true
    end

    local v19 = if v18 then 0 else math.max(0, EggRecords.GrowthSecondsRemaining(Record, ServerClock.Now(), Record.GrowthSpeedMultiplier, nil, Players.LocalPlayer) - v17)
    local v21 = if v19 <= 0 then "Ready!" else Elapsed(v19)
    local v22 = EggRecords.ServerGrowthBoostMultiplier()
    local v23 = Save.Await()
    local v24 = if v23 == nil or not MonsterParasite.IsBoostActive(v23.MonsterParasite, MonsterParasite.BoostKinds.EggGrowth) then 0 else MonsterParasite2.BoostMultiplier(MonsterParasite.BoostKinds.EggGrowth) - 1
    local v25 = p8.Record.GrowthSpeedMultiplier + v22 + v24

    if v19 > 0 and v25 > 1 then
        v21 ..= (" <font color=\"#FFD700\">(x%*)</font>"):format(v25)
    end

    if v21 ~= v2 then
        v2 = v21
        p7.RemainingHatchTime.Text = v21
    end
end

local function clearActiveHighlight() -- line: 235
    -- upvalues: HoverHighlight (copy), v3 (ref)
    local v26 = v3

    v3 = nil

    if v26 ~= nil then
        HoverHighlight.FadeOut(v26, 0.25)
    end
end

local function playCanvasFade(p9, p10, p11) -- line: 253
    -- upvalues: TweenService (copy), v1 (ref), n1 (ref), tween (ref), v4 (ref)
    if tween ~= nil and v4 == p10 then
        return
    end

    local tween2 = tween

    tween = nil
    v4 = nil

    if tween2 ~= nil then
        tween2:Cancel()
        tween2:Destroy()
    end

    v4 = p10

    if p10 < 1 then
        p9.Frame.Visible = true
    end

    if math.abs(p9.CanvasGroup.GroupTransparency - p10) <= 0.001 then
        p9.CanvasGroup.GroupTransparency = p10
        v4 = nil

        if p10 >= 1 and p11 ~= nil and v1 == nil and n1 == p11 then
            p9.Frame.Visible = false
        end
    else
        local tween2 = TweenService:Create(p9.CanvasGroup, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            GroupTransparency = p10
        })

        tween = tween2
        tween2.Completed:Once(function(p12) -- line: 284
            -- upvalues: p9 (copy), p10 (copy), p11 (copy), tween2 (copy), v1 (ref), n1 (ref), tween (ref), v4 (ref)
            if tween == tween2 then
                tween = nil
                v4 = nil
            end

            tween2:Destroy()

            if p12 == Enum.PlaybackState.Completed then
                p9.CanvasGroup.GroupTransparency = p10

                if p10 >= 1 and p11 ~= nil and v1 == nil and n1 == p11 then
                    p9.Frame.Visible = false
                end
            end
        end)
        tween2:Play()
    end
end

local function setActiveEntry(p13) -- line: 307
    -- upvalues: HoverHighlight (copy), v1 (ref), v2 (ref), v3 (ref), n1 (ref), bindGui (copy), updateStaticContent (copy), updateCountdown (copy), playCanvasFade (copy)
    if p13 ~= nil then
        local v31 = bindGui()

        n1 += 1

        if not v31.Frame.Visible then
            v31.CanvasGroup.GroupTransparency = 1
        end

        playCanvasFade(v31, 0, nil)

        local v32 = ("%*:%*"):format(p13.OwnerUserId, p13.Uid)

        if v1 ~= v32 then
            v1 = v32
            v2 = ""

            local v33 = v3

            v3 = nil

            if v33 ~= nil then
                HoverHighlight.FadeOut(v33, 0.25)
            end

            v3 = HoverHighlight.FadeIn(p13.Model, "EggHoverHighlight", 0.25)
            updateStaticContent(v31, p13)
        end

        updateCountdown(v31, p13)
        v31.Frame.Visible = true
    elseif v1 ~= nil then
        local v28 = bindGui()

        v1 = nil
        v2 = ""
        n1 += 1

        local v29 = n1
        local v30 = v3

        v3 = nil

        if v30 ~= nil then
            HoverHighlight.FadeOut(v30, 0.25)
        end

        if v28.Frame.Visible then
            playCanvasFade(v28, 1, v29)
        end
    end
end

local function updateBillboard() -- line: 345
    -- upvalues: Workspace (copy), ModelBounds (copy), HoverHighlight (copy), t2 (copy), v1 (ref), v2 (ref), v3 (ref), n1 (ref), bindGui (copy), selectNearestEntry (copy), playCanvasFade (copy), setActiveEntry (copy)
    if next(t2) ~= nil then
        if v1 ~= nil then
            local v46 = bindGui()

            v1 = nil
            v2 = ""
            n1 += 1

            local v47 = n1
            local v48 = v3

            v3 = nil

            if v48 ~= nil then
                HoverHighlight.FadeOut(v48, 0.25)
            end

            if v46.Frame.Visible then
                playCanvasFade(v46, 1, v47)
            end
        end
    else
        local v34 = selectNearestEntry()

        if v34 ~= nil then
            local v38 = bindGui()
            local CurrentCamera = Workspace.CurrentCamera
            local v39, v40

            if CurrentCamera ~= nil then
                local v41, v42 = CurrentCamera:WorldToViewportPoint(ModelBounds(v34.Model).Position)

                if v42 then
                    v39 = true
                    v40 = Vector2.new(v41.X, v41.Y)
                else
                    v39 = false
                    v40 = Vector2.zero
                end
            else
                v39 = false
                v40 = Vector2.zero
            end

            if v39 then
                setActiveEntry(v34)
                v38.Frame.Position = UDim2.fromOffset(v40.X, v40.Y)
            elseif v1 ~= nil then
                local v43 = bindGui()

                v1 = nil
                v2 = ""
                n1 += 1

                local v44 = n1
                local v45 = v3

                v3 = nil

                if v45 ~= nil then
                    HoverHighlight.FadeOut(v45, 0.25)
                end

                if v43.Frame.Visible then
                    playCanvasFade(v43, 1, v44)
                end
            end
        elseif v1 ~= nil then
            local v35 = bindGui()

            v1 = nil
            v2 = ""
            n1 += 1

            local v36 = n1
            local v37 = v3

            v3 = nil

            if v37 ~= nil then
                HoverHighlight.FadeOut(v37, 0.25)
            end

            if v35.Frame.Visible then
                playCanvasFade(v35, 1, v36)
            end
        end
    end
end

function t4.SetEntry(p14) -- line: 372
    -- upvalues: Eggs (copy), SurfaceTracker (copy), t (copy), t1 (copy)
    t.strict(t.number)(p14.OwnerUserId)
    t.strict(t.string)(p14.Uid)
    t.strict(t.instanceIsA("Model"))(p14.Model)
    assert(Eggs.SchemaValidation.RuntimeEggRecord(p14.Record), "Invalid runtime egg record")

    local v50 = ("%*:%*"):format(p14.OwnerUserId, p14.Uid)
    local v51 = t1[v50]
    local v52 = if v51 == nil or v51.Model ~= p14.Model then SurfaceTracker.new(p14.Model) else v51.Tracker

    if v51 ~= nil and v51.Model ~= p14.Model then
        v51.Tracker:Destroy()
    end

    t1[v50] = {
        OwnerUserId = p14.OwnerUserId,
        Uid = p14.Uid,
        Record = p14.Record,
        Model = p14.Model,
        TimeSkipSeconds = p14.TimeSkipSeconds,
        Tracker = v52
    }
end

function t4.SetNightPresentationActive(p15, p16, p17) -- line: 397
    -- upvalues: HoverHighlight (copy), t (copy), t2 (copy), v1 (ref), v2 (ref), v3 (ref), n1 (ref), bindGui (copy), playCanvasFade (copy)
    t.strict(t.number)(p15)
    t.strict(t.string)(p16)
    t.strict(t.boolean)(p17)

    local v53 = ("%*:%*"):format(p15, p16)
    local v54, v55, Visible

    if p17 then
        t2[v53] = p15

        if v1 == nil then
            return
        end

        v54 = bindGui()
        v1 = nil
        v2 = ""
        n1 += 1
        v55 = n1

        local v56 = v3

        v3 = nil

        if v56 ~= nil then
            HoverHighlight.FadeOut(v56, 0.25)
        end

        Visible = v54.Frame.Visible
    else
        t2[v53] = nil
    end

    if (not p17 or Visible) and p17 then
        playCanvasFade(v54, 1, v55)
    end
end

function t4.RemoveEntry(p18, p19) -- line: 415
    -- upvalues: HoverHighlight (copy), t (copy), t1 (copy), t2 (copy), v1 (ref), v2 (ref), v3 (ref), n1 (ref), bindGui (copy), playCanvasFade (copy)
    t.strict(t.number)(p18)
    t.strict(t.string)(p19)

    local v57 = ("%*:%*"):format(p18, p19)
    local v58 = t1[v57]

    if v58 ~= nil then
        v58.Tracker:Destroy()
    end

    t1[v57] = nil
    t2[v57] = nil

    if v1 ~= v57 or v1 == nil then
        return
    end

    local v59 = bindGui()

    v1 = nil
    v2 = ""
    n1 += 1

    local v60 = n1
    local v61 = v3

    v3 = nil

    if v61 ~= nil then
        HoverHighlight.FadeOut(v61, 0.25)
    end

    if v59.Frame.Visible then
        playCanvasFade(v59, 1, v60)
    end
end

function t4.DestroyOwner(p20) -- line: 431
    -- upvalues: HoverHighlight (copy), t (copy), t1 (copy), t2 (copy), v1 (ref), v2 (ref), v3 (ref), n1 (ref), bindGui (copy), playCanvasFade (copy)
    t.strict(t.number)(p20)

    for v62, v63 in pairs(t1) do
        if v63.OwnerUserId == p20 then
            v63.Tracker:Destroy()
            t1[v62] = nil

            if v1 == v62 and v1 ~= nil then
                local v64 = bindGui()

                v1 = nil
                v2 = ""
                n1 += 1

                local v65 = n1
                local v66 = v3

                v3 = nil

                if v66 ~= nil then
                    HoverHighlight.FadeOut(v66, 0.25)
                end

                if v64.Frame.Visible then
                    playCanvasFade(v64, 1, v65)
                end
            end
        end
    end

    for v67, v68 in pairs(t2) do
        if v68 == p20 then
            t2[v67] = nil
        end
    end
end

RunService:BindToRenderStep(("PlacedEggBillboard@%*"):format((HttpService:GenerateGUID(false))), Enum.RenderPriority.Last.Value, updateBillboard)

return t4
