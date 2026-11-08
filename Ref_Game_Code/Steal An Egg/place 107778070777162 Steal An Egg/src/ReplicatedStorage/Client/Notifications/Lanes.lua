-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GUI = require(ReplicatedStorage.Client.GUI)
local RoundDeferral = require(script.Parent.RoundDeferral)
local v1 = TweenInfo.new(0.16, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
local v3 = TweenInfo.new(0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
local v4 = TweenInfo.new(0.22, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
local t1 = {
    Feed = "Feed",
    Banner = "Banner"
}
local t2 = {
    Banner = true
}
local t3 = {}
local v5 = GUI.Notifications()
local t4 = {}

for v6, v7 in t1 do
    t4[v6] = {
        lastAdmit = (-1e999),
        issued = 0,
        wakeToken = 0,
        pumpPending = false,
        id = v6,
        holder = v5:WaitForChild(v7),
        guarded = t2[v6] == true,
        waiting = {},
        live = {}
    }
end

local t5 = {}
local n1 = 0
local n2 = 0
local v8

local function asGroup(p1) -- line: 125
    return if p1:IsA("CanvasGroup") then p1 else nil
end

local function expectKind(p2, p3, p4) -- line: 129
    if p2 ~= nil and typeof(p2) ~= p3 then
        error(("notification entry field %* expects a %*, got %*"):format(p4, p3, (typeof(p2))), 3)
    end
end

local function claimKey(p5) -- line: 135
    -- upvalues: t5 (copy)
    if p5 ~= nil then
        if t5[p5] then
            return false
        end

        t5[p5] = true
    end

    return true
end

local function releaseKey(p6) -- line: 146
    -- upvalues: t5 (copy)
    if p6 ~= nil then
        t5[p6] = nil
    end
end

local function dropFrom(p7, p8) -- line: 152
    local v9 = table.find(p7, p8)

    if v9 ~= nil then
        table.remove(p7, v9)
    end
end

local t6 = {}
local connection

local function integrate(p9, p10) -- line: 162
    local v10 = -227.3956854010988 * (p9.value - 1) - 18.698759474166447 * p9.velocity

    p9.velocity += v10 * p10
    p9.value += p9.velocity * p10

    if not (math.abs(p9.value - 1) < 0.002) then
        return false
    end

    return math.abs(p9.velocity) < 0.02
end

local function stepSprings(p11) -- line: 171
    -- upvalues: t6 (ref), connection (ref)
    local v12 = math.min(p11, 0.03333333333333333)
    local t7 = {}

    for _, v13 in t6 do
        local scale = v13.scale

        if scale.Parent ~= nil then
            local v14 = -227.3956854010988 * (v13.value - 1) - 18.698759474166447 * v13.velocity

            v13.velocity += v14 * v12
            v13.value += v13.velocity * v12

            if math.abs(v13.value - 1) < 0.002 and math.abs(v13.velocity) < 0.02 then
                scale.Scale = 1
            else
                scale.Scale = v13.value
                table.insert(t7, v13)
            end
        end
    end

    t6 = t7

    if #t6 ~= 0 or connection == nil then
        return
    end

    connection:Disconnect()
    connection = nil
end

local function launchSpring(p12) -- line: 193
    -- upvalues: RunService (copy), t6 (ref), connection (ref), stepSprings (copy)
    p12.Scale = 0.55

    local t8 = t6

    table.insert(t8, {
        value = 0.55,
        velocity = 0,
        scale = p12
    })

    if connection == nil then
        connection = RunService.RenderStepped:Connect(stepSprings)
    end
end

local function abandonSpring(p13) -- line: 201
    -- upvalues: t6 (ref)
    for v17, v18 in t6 do
        if v18.scale == p13 then
            table.remove(t6, v17)

            return
        end
    end
end

local function finalize(p14) -- line: 210
    -- upvalues: t4 (copy), t5 (copy), n2 (ref), v8 (ref)
    local v19 = t4[p14.laneId]
    local waiting = v19.waiting
    local v20 = table.find(waiting, p14)

    if v20 ~= nil then
        table.remove(waiting, v20)
    end

    local live = v19.live
    local v21 = table.find(live, p14)

    if v21 ~= nil then
        table.remove(live, v21)
    end

    local uniqueKey = p14.uniqueKey

    if uniqueKey ~= nil then
        t5[uniqueKey] = nil
    end

    if p14.shownAt ~= nil then
        if p14.pinned then
            n2 = os.clock() + 0.8
            task.delay(0.8, function() -- line: 219
                -- upvalues: t4 (copy), v8 (ref)
                for _, v22 in t4 do
                    v8(v22)
                end
            end)
        end

        local onRetired = p14.onRetired

        if onRetired ~= nil then
            task.spawn(onRetired, p14.frame)
        end
    end

    if not p14.destroyed then
        p14.destroyed = true
        p14.frame:Destroy()
    end

    v8(v19)
end

local function retire(p15) -- line: 238
    -- upvalues: TweenService (copy), v2 (copy), v3 (copy), abandonSpring (copy), finalize (copy)
    if p15.retiring then
        return
    end

    p15.retiring = true
    p15.expiryToken += 1

    local frame = p15.frame
    local UIScale = frame:FindFirstChildOfClass("UIScale")

    if UIScale ~= nil then
        abandonSpring(UIScale)
        TweenService:Create(UIScale, v2, {
            Scale = 0.7
        }):Play()
    end

    if not frame:IsA("CanvasGroup") then
        frame = nil
    end

    if frame ~= nil then
        TweenService:Create(frame, v3, {
            GroupTransparency = 1
        }):Play()
    end

    task.delay(0.28, finalize, p15)
end

local function armExpiry(p16) -- line: 258
    -- upvalues: retire (copy)
    p16.expiryToken += 1

    local expiryToken = p16.expiryToken

    task.delay(p16.seconds, function() -- line: 261
        -- upvalues: p16 (copy), expiryToken (copy), retire (copy)
        if expiryToken == p16.expiryToken and p16.shownAt ~= nil and not p16.retiring then
            retire(p16)
        end
    end)
end

local function watchFrame(p17) -- line: 268
    -- upvalues: finalize (copy)
    p17.frame.Destroying:Connect(function() -- line: 269
        -- upvalues: p17 (copy), finalize (copy)
        p17.destroyed = true

        if p17.retiring then
            return
        end

        p17.retiring = true
        p17.expiryToken += 1
        task.defer(finalize, p17)
    end)
end

local function admit(p18, p19) -- line: 280
    -- upvalues: RunService (copy), TweenService (copy), v1 (copy), t6 (ref), connection (ref), stepSprings (copy), retire (copy)
    local elapsed = os.clock()

    p18.lastAdmit = elapsed
    p18.issued += 1
    p19.shownAt = elapsed
    table.insert(p18.live, p19)

    local frame = p19.frame
    local frame2 = if frame:IsA("CanvasGroup") then frame else nil
    local v23 = if frame2 == nil then 0 else frame2.GroupTransparency

    if frame2 ~= nil then
        frame2.GroupTransparency = 1
    end

    local v24 = frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

    v24.Scale = 0.55
    v24.Parent = frame

    if p19.pinned then
        frame.LayoutOrder = -p18.issued
    else
        frame.LayoutOrder = p18.issued
    end

    frame.AnchorPoint = Vector2.one * 0.5
    frame.Parent = p18.holder
    v24.Scale = 0.55

    local t10 = t6

    table.insert(t10, {
        value = 0.55,
        velocity = 0,
        scale = v24
    })

    if connection == nil then
        connection = RunService.RenderStepped:Connect(stepSprings)
    end

    if frame2 ~= nil then
        TweenService:Create(frame2, v1, {
            GroupTransparency = v23
        }):Play()
    end

    p19.expiryToken += 1

    local expiryToken = p19.expiryToken

    task.delay(p19.seconds, function() -- line: 261
        -- upvalues: p19 (copy), expiryToken (copy), retire (copy)
        if expiryToken == p19.expiryToken and p19.shownAt ~= nil and not p19.retiring then
            retire(p19)
        end
    end)

    local onShown = p19.onShown

    if onShown ~= nil then
        task.spawn(onShown, frame)
    end
end

local function capacityOf(p20) -- line: 316
    local Capacity = p20.holder:GetAttribute("Capacity")

    if typeof(Capacity) == "number" then
        return Capacity
    end

    return 3
end

local function pinnedBusy() -- line: 321
    -- upvalues: t4 (copy), n2 (ref)
    if os.clock() < n2 then
        return true
    end

    for _, v25 in t4 do
        for _, v26 in v25.live do
            if v26.pinned then
                return true
            end
        end
    end

    return false
end

local function takeAdmissible(p21) -- line: 335
    -- upvalues: RoundDeferral (copy), pinnedBusy (copy)
    local v27 = pinnedBusy()
    local v28 = false

    for v29, v30 in p21.waiting do
        if not (RoundDeferral.HoldsBack(v30.delayInRound) or v30.pinned and v27) then
            table.remove(p21.waiting, v29)

            return v30, v28
        end

        v28 = true
    end

    return nil, v28
end

local function wake(p22, p23) -- line: 350
    -- upvalues: v8 (ref)
    p22.wakeToken += 1

    local wakeToken = p22.wakeToken

    task.delay(p23, function() -- line: 353
        -- upvalues: p22 (copy), wakeToken (copy), v8 (ref)
        if wakeToken == p22.wakeToken then
            v8(p22)
        end
    end)
end

local function pump(p24) -- line: 360
    -- upvalues: n1 (ref), v8 (ref), admit (copy), takeAdmissible (copy)
    p24.wakeToken += 1

    while true do
        if #p24.waiting > 0 then
            local v31 = #p24.live
            local Capacity = p24.holder:GetAttribute("Capacity")

            if typeof(Capacity) ~= "number" then
                Capacity = 3
            end

            if v31 < Capacity then
                if not (p24.guarded and n1 > 0) then
                    local v32 = os.clock() - p24.lastAdmit

                    if v32 < 0.14 then
                        local v33 = 0.14 - v32

                        p24.wakeToken += 1

                        local wakeToken = p24.wakeToken

                        task.delay(v33, function() -- line: 353
                            -- upvalues: p24 (copy), wakeToken (copy), v8 (ref)
                            if wakeToken == p24.wakeToken then
                                v8(p24)
                            end
                        end)
                    else
                        local v34, v35 = takeAdmissible(p24)

                        if v34 ~= nil then
                            admit(p24, v34)
                            continue
                        end

                        if v35 then
                            p24.wakeToken += 1

                            local wakeToken = p24.wakeToken

                            task.delay(0.4, function() -- line: 353
                                -- upvalues: p24 (copy), wakeToken (copy), v8 (ref)
                                if wakeToken == p24.wakeToken then
                                    v8(p24)
                                end
                            end)
                        end
                    end
                end

                return
            end
        end

        break
    end
end

v8 = function(p25) -- line: 384
    -- upvalues: pump (copy)
    if p25.pumpPending then
        return
    end

    p25.pumpPending = true
    task.defer(function() -- line: 389
        -- upvalues: p25 (copy), pump (copy)
        p25.pumpPending = false
        pump(p25)
    end)
end

local holder = t4.Banner.holder
local holderPosition = holder.Position
local n3 = 0

local function isDisplayed(p26) -- line: 399
    while p26 ~= nil and not p26:IsA("LayerCollector") do
        if p26:IsA("GuiObject") and not p26.Visible then
            return false
        end

        p26 = p26.Parent
    end

    return p26 ~= nil and p26.Enabled == true
end

local function overlaps(p27, p28, p29, p30, p31) -- line: 410
    local AbsolutePosition = p27.AbsolutePosition
    local v37 = AbsolutePosition + p27.AbsoluteSize

    if AbsolutePosition.X < p30 and p28 < v37.X and AbsolutePosition.Y < p31 then
        return p29 < v37.Y
    end

    return false
end

local function lowestBlockerEdge(p32, p33, p34, p35, p36) -- line: 416
    -- upvalues: CollectionService (copy), isDisplayed (copy)
    local v38 = p34

    for _, v39 in CollectionService:GetTagged("TopNotificationBlocker") do
        if v39:IsA("GuiObject") and v39:IsDescendantOf(p32) and isDisplayed(v39) then
            local AbsolutePosition = v39.AbsolutePosition
            local v40 = AbsolutePosition + v39.AbsoluteSize

            if AbsolutePosition.X < p35 and p33 < v40.X and AbsolutePosition.Y < p36 and p34 < v40.Y then
                v38 = math.max(v38, v39.AbsolutePosition.Y + v39.AbsoluteSize.Y)
            end
        end
    end

    return v38
end

local function refreshClearance(p37) -- line: 431
    -- upvalues: TweenService (copy), v4 (copy), v5 (copy), holder (copy), holderPosition (copy), n3 (ref), lowestBlockerEdge (copy)
    local Y = v5.AbsoluteSize.Y

    if Y <= 0 then
        return
    end

    local Y2 = holder.AbsoluteSize.Y
    local v42 = v5.AbsolutePosition.Y + holderPosition.Y.Scale * Y + holderPosition.Y.Offset - holder.AnchorPoint.Y * Y2
    local X = holder.AbsolutePosition.X
    local v44 = math.max(lowestBlockerEdge(p37, X, v42, X + holder.AbsoluteSize.X, v42 + Y2) - v42, 0) / Y

    if v44 > 0 then
        v44 += Y2 * 0.12 / Y
    end

    if not (math.abs(v44 - n3) < 0.0025) then
        n3 = v44
        TweenService:Create(holder, v4, {
            Position = holderPosition + UDim2.fromScale(0, v44)
        }):Play()
    end
end

function t3.Schedule(p38) -- line: 461
    -- upvalues: t4 (copy), t5 (copy), v8 (ref), finalize (copy)
    if typeof(p38) ~= "table" then
        error(("Lanes.Schedule expects an entry table, got %*"):format((typeof(p38))), 2)
    end

    local v46 = t4[p38.Lane]

    if v46 == nil then
        error(("unknown notification lane %*"):format((tostring(p38.Lane))), 2)
    end

    local Frame = p38.Frame

    if typeof(Frame) ~= "Instance" or not Frame:IsA("GuiObject") then
        error("a notification needs a GuiObject to show", 2)
    end

    local Seconds = p38.Seconds

    if Seconds ~= nil and typeof(Seconds) ~= "number" then
        error(("notification entry field Seconds expects a number, got %*"):format((typeof(Seconds))), 3)
    end

    local UniqueKey = p38.UniqueKey

    if UniqueKey ~= nil and typeof(UniqueKey) ~= "string" then
        error(("notification entry field UniqueKey expects a string, got %*"):format((typeof(UniqueKey))), 3)
    end

    local DelayInRound = p38.DelayInRound

    if DelayInRound ~= nil and typeof(DelayInRound) ~= "boolean" then
        error(("notification entry field DelayInRound expects a boolean, got %*"):format((typeof(DelayInRound))), 3)
    end

    local OnShown = p38.OnShown

    if OnShown ~= nil and typeof(OnShown) ~= "function" then
        error(("notification entry field OnShown expects a function, got %*"):format((typeof(OnShown))), 3)
    end

    local OnRetired = p38.OnRetired

    if OnRetired ~= nil and typeof(OnRetired) ~= "function" then
        error(("notification entry field OnRetired expects a function, got %*"):format((typeof(OnRetired))), 3)
    end

    if not (#v46.waiting >= 24) then
        local UniqueKey = p38.UniqueKey
        local v47

        if UniqueKey ~= nil then
            if t5[UniqueKey] then
                v47 = false
            else
                v47 = true
                t5[UniqueKey] = true
            end
        else
            v47 = true
        end

        if v47 then
            local SammyDialogue = Frame:GetAttribute("SammyDialogue")
            local t12 = {
                shownAt = nil,
                retiring = false,
                destroyed = false,
                expiryToken = 0,
                frame = Frame,
                seconds = p38.Seconds or 3,
                uniqueKey = p38.UniqueKey,
                delayInRound = p38.DelayInRound == true,
                laneId = v46.id,
                onShown = p38.OnShown,
                onRetired = p38.OnRetired,
                pinned = SammyDialogue ~= nil and SammyDialogue ~= false
            }

            table.insert(v46.waiting, t12)
            t12.frame.Destroying:Connect(function() -- line: 269
                -- upvalues: t12 (copy), finalize (copy)
                t12.destroyed = true

                if t12.retiring then
                    return
                end

                t12.retiring = true
                t12.expiryToken += 1
                task.defer(finalize, t12)
            end)
            v8(v46)

            return true
        end
    end

    return false
end

function t3.HoldBanner() -- line: 505
    -- upvalues: t4 (copy), n1 (ref), v8 (ref)
    n1 += 1

    local v50 = false

    return function() -- line: 508
        -- upvalues: v50 (ref), t4 (copy), n1 (ref), v8 (ref)
        if v50 then
            return
        end

        v50 = true
        n1 -= 1
        v8(t4.Banner)
    end
end

function t3.IsBannerShowing() -- line: 518
    -- upvalues: t4 (copy)
    return #t4.Banner.live > 0
end

task.spawn(function() -- line: 522
    -- upvalues: Players (copy), refreshClearance (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    while true do
        task.wait(0.25)
        refreshClearance(PlayerGui)
    end
end)

return table.freeze(t3)
