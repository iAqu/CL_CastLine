-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Audio = require(ReplicatedStorage.Shared.Audio)
local BanjoCricket = require(ReplicatedStorage.Data.BanjoCricket)
local Mushrooms = require(script.Parent.Mushrooms)
local Sounds = require(script.Parent.Sounds)
local t1 = {}
local t2 = {}
local t3 = {}
local v1 = "Closed"
local v2
local n1 = 0
local t4 = {}

local function rootsOpened(p1, p2) -- line: 45
    -- upvalues: BanjoCricket (copy)
    local Attribute = p1:GetAttribute(BanjoCricket.Attributes.RevealOffset)

    if typeof(Attribute) == "Vector3" then
        return p2 + Attribute
    end

    local _, BoundingBox = p1:GetBoundingBox()

    return p2 - Vector3.new(0, BoundingBox.Y, 0)
end

local function doorOpened(p3, p4) -- line: 54
    -- upvalues: BanjoCricket (copy)
    local Attribute = p3:GetAttribute(BanjoCricket.Attributes.DoorOpenAngle)

    if typeof(Attribute) ~= "number" then
        Attribute = 100
    end

    return p4 * CFrame.Angles(0, math.rad(Attribute), 0)
end

local function makePassable(p5) -- line: 62
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end

local function snapOpen(p6) -- line: 70
    -- upvalues: makePassable (copy)
    p6.Model:PivotTo(p6.Opened)
    makePassable(p6.Model)
end

local function glide(p7, p8, p9) -- line: 75
    -- upvalues: TweenService (copy), makePassable (copy)
    makePassable(p7.Model)

    local CFrameValue = Instance.new("CFrameValue")

    CFrameValue.Value = p7.Closed
    CFrameValue.Changed:Connect(function(p10) -- line: 79
        -- upvalues: p7 (copy)
        if p7.Model.Parent ~= nil then
            p7.Model:PivotTo(p10)
        end
    end)

    local tween = TweenService:Create(CFrameValue, TweenInfo.new(p8, p9, Enum.EasingDirection.Out), {
        Value = p7.Opened
    })

    tween.Completed:Once(function() -- line: 89
        -- upvalues: CFrameValue (copy)
        CFrameValue:Destroy()
    end)
    tween:Play()
end

local function binder(p11, p12) -- line: 95
    -- upvalues: Workspace (copy), v1 (ref), makePassable (copy)
    return function(p13) -- line: 99
        -- upvalues: p11 (copy), p12 (copy), Workspace (copy), v1 (ref), makePassable (copy)
        if not p11[p13] and p13:IsA("Model") and p13:IsDescendantOf(Workspace) then
            local Pivot = p13:GetPivot()
            local t5 = {
                Model = p13,
                Closed = Pivot,
                Opened = p12(p13, Pivot)
            }

            p11[p13] = t5

            if v1 == "Open" then
                t5.Model:PivotTo(t5.Opened)
                makePassable(t5.Model)
            end
        end
    end
end

local function track(p14, p15, p16) -- line: 120
    -- upvalues: CollectionService (copy), Workspace (copy), v1 (ref), makePassable (copy)
    local function v3(p17) -- line: 99
        -- upvalues: p15 (copy), p16 (copy), Workspace (copy), v1 (ref), makePassable (copy)
        if not p15[p17] and p17:IsA("Model") and p17:IsDescendantOf(Workspace) then
            local Pivot = p17:GetPivot()
            local t6 = {
                Model = p17,
                Closed = Pivot,
                Opened = p16(p17, Pivot)
            }

            p15[p17] = t6

            if v1 == "Open" then
                t6.Model:PivotTo(t6.Opened)
                makePassable(t6.Model)
            end
        end
    end

    CollectionService:GetInstanceAddedSignal(p14):Connect(v3)
    CollectionService:GetInstanceRemovedSignal(p14):Connect(function(p18) -- line: 127
        -- upvalues: p15 (copy)
        p15[p18] = nil
    end)

    for _, v4 in CollectionService:GetTagged(p14) do
        v3(v4)
    end
end

local function openDoorways() -- line: 135
    -- upvalues: t3 (copy)
    for _, v5 in t3 do
        v5.CanCollide = false
    end
end

local function trackDoorways() -- line: 141
    -- upvalues: CollectionService (copy), Workspace (copy), BanjoCricket (copy), t3 (copy), v1 (ref)
    local Doorway = BanjoCricket.Tags.Doorway

    local function bind(p19) -- line: 143
        -- upvalues: Workspace (copy), t3 (copy), v1 (ref)
        if not (p19:IsA("BasePart") and p19:IsDescendantOf(Workspace)) then
            return
        end

        t3[p19] = p19

        if v1 == "Open" then
            p19.CanCollide = false
        end
    end

    CollectionService:GetInstanceAddedSignal(Doorway):Connect(bind)
    CollectionService:GetInstanceRemovedSignal(Doorway):Connect(function(p20) -- line: 156
        -- upvalues: t3 (copy)
        t3[p20] = nil
    end)

    for _, v6 in CollectionService:GetTagged(Doorway) do
        if v6:IsA("BasePart") and v6:IsDescendantOf(Workspace) then
            t3[v6] = v6

            if v1 == "Open" then
                v6.CanCollide = false
            end
        end
    end
end

local function songEmitter() -- line: 164
    -- upvalues: CollectionService (copy), Workspace (copy), BanjoCricket (copy), t2 (copy)
    for _, v7 in CollectionService:GetTagged(BanjoCricket.Tags.Music) do
        if v7:IsDescendantOf(Workspace) then
            return v7
        end
    end

    for _, v8 in t2 do
        return v8.Model
    end

    return nil
end

local function playSong(p21) -- line: 176
    -- upvalues: Audio (copy), BanjoCricket (copy), v2 (ref), songEmitter (copy)
    if v2 == nil then
        local v9 = songEmitter()

        if v9 ~= nil then
            v2 = Audio.Play(BanjoCricket.Sounds.Band, v9, {
                Looped = true,
                MaxDistance = 90,
                Volume = p21
            })
        end
    end
end

local function creakRoots(p22) -- line: 191
    -- upvalues: Sounds (copy), t1 (copy)
    local _, v10 = next(t1)

    if v10 then
        Sounds.Creak(v10.Closed, p22)
    end
end

function t4.Start() -- line: 198
    -- upvalues: BanjoCricket (copy), t1 (copy), t2 (copy), rootsOpened (copy), doorOpened (copy), track (copy), trackDoorways (copy)
    track(BanjoCricket.Tags.Roots, t1, rootsOpened)
    track(BanjoCricket.Tags.Door, t2, doorOpened)
    trackDoorways()
end

function t4.Strain(p23) -- line: 205
    -- upvalues: RunService (copy), Sounds (copy), t1 (copy), v1 (ref), n1 (ref)
    if v1 ~= "Closed" then
        return
    end

    n1 += 1

    local v11 = n1
    local elapsed = os.clock()
    local v12 = math.clamp(p23, 0, 1) * 0.06981317007977318
    local _, v13 = next(t1)

    if v13 then
        Sounds.Creak(v13.Closed, p23)
    end

    local connection

    connection = RunService.PreRender:Connect(function() -- line: 215
        -- upvalues: v11 (copy), elapsed (copy), v12 (copy), connection (ref), t1 (copy), v1 (ref), n1 (ref)
        local v14 = (os.clock() - elapsed) / 0.6
        local v15 = n1 == v11 and v1 == "Closed"

        if not v15 or v14 >= 1 then
            connection:Disconnect()

            if v15 then
                for _, v16 in t1 do
                    v16.Model:PivotTo(v16.Closed)
                end
            end
        else
            local v17 = v12 * (1 - v14)

            for _, v18 in t1 do
                v18.Model:PivotTo(v18.Closed * CFrame.Angles(math.sin(v14 * 40) * v17, 0, math.cos(v14 * 29) * v17))
            end
        end
    end)
end

function t4.Open() -- line: 242
    -- upvalues: Audio (copy), BanjoCricket (copy), t1 (copy), t2 (copy), t3 (copy), v1 (ref), v2 (ref), makePassable (copy), songEmitter (copy)
    if v1 ~= "Closed" then
        return
    end

    v1 = "Open"

    for _, v22 in t1 do
        v22.Model:PivotTo(v22.Opened)
        makePassable(v22.Model)
    end

    for _, v23 in t2 do
        v23.Model:PivotTo(v23.Opened)
        makePassable(v23.Model)
    end

    for _, v24 in t3 do
        v24.CanCollide = false
    end

    local Band = BanjoCricket.Volume.Band

    if v2 == nil then
        local v25 = songEmitter()

        if v25 ~= nil then
            v2 = Audio.Play(BanjoCricket.Sounds.Band, v25, {
                Looped = true,
                MaxDistance = 90,
                Volume = Band
            })
        end
    end
end

function t4.Play() -- line: 257
    -- upvalues: Audio (copy), BanjoCricket (copy), Mushrooms (copy), Sounds (copy), t1 (copy), t2 (copy), t3 (copy), v1 (ref), v2 (ref), glide (copy), playSong (copy)
    if v1 ~= "Closed" then
        return
    end

    v1 = "Revealing"

    local Reveal = BanjoCricket.Reveal

    task.delay(Reveal.LightsAt, Mushrooms.SetAllLit, true)
    task.delay(Reveal.HarmonyAt, Sounds.Strum)
    task.delay(Reveal.MusicAt, playSong, BanjoCricket.Volume.BandFaint)
    task.delay(Reveal.RootsAt, function() -- line: 266
        -- upvalues: Reveal (copy), Sounds (copy), t1 (copy), glide (copy)
        local _, v26 = next(t1)

        if v26 then
            Sounds.Creak(v26.Closed, 1)
        end

        for _, v27 in t1 do
            glide(v27, Reveal.RootsSeconds, Enum.EasingStyle.Quad)
        end
    end)
    task.delay(Reveal.DoorAt, function() -- line: 272
        -- upvalues: Reveal (copy), Audio (copy), BanjoCricket (copy), t2 (copy), t3 (copy), v1 (ref), v2 (ref), glide (copy)
        v1 = "Open"

        for _, v28 in t2 do
            glide(v28, Reveal.DoorSeconds, Enum.EasingStyle.Back)
        end

        for _, v29 in t3 do
            v29.CanCollide = false
        end

        local v30 = v2

        if v30 then
            Audio.FadeTo(v30, {
                Volume = BanjoCricket.Volume.Band,
                Seconds = Reveal.DoorSeconds
            })
        end
    end)
    task.delay(Reveal.LightsOffAt, Mushrooms.SetAllLit, false)
end

return table.freeze(t4)
