-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GameFlags = require(ReplicatedStorage.Shared.Flags.GameFlags)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local PointInBox = require(ReplicatedStorage.Shared.Utils.PointInBox)
local Player = require(ReplicatedStorage.Shared.Player)
local Signal = require(ReplicatedStorage.Packages.Signal)
local v1 = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local t1 = {
    Changed = Signal.new()
}
local t2 = {}
local v2 = nil
local v3 = false

local function padBox(p1) -- line: 47
    -- upvalues: ModelBounds (copy)
    if p1:IsA("BasePart") then
        return p1.CFrame, p1.Size
    end

    if p1:IsA("Model") then
        return ModelBounds(p1)
    end

    return p1:GetPivot(), (Vector3.new(0, 0, 0))
end

local function topUnderFoot(p2, p3) -- line: 59
    -- upvalues: ModelBounds (copy), PointInBox (copy)
    local Surface = p2.Surface
    local v4, v5

    if Surface:IsA("BasePart") then
        v4 = Surface.CFrame
        v5 = Surface.Size
    elseif Surface:IsA("Model") then
        v4, v5 = ModelBounds(Surface)
    else
        v4 = Surface:GetPivot()
        v5 = Vector3.new(0, 0, 0)
    end

    return if PointInBox(v4 * CFrame.new((Vector3.new(0, 6, 0))), v5 + Vector3.new(0, 12, 0), p3) then (v4 * CFrame.new(0, v5.Y / 2, 0)).Position.Y else nil
end

local function padBeneath(p4) -- line: 69
    -- upvalues: t2 (copy), topUnderFoot (copy)
    local n1 = (-1e999)
    local v6

    for _, v7 in t2 do
        local v8 = topUnderFoot(v7, p4)

        if v8 ~= nil and n1 < v8 then
            n1 = v8
            v6 = v7
        end
    end

    return v6
end

t1.Changed:Connect(function(p5, p6) -- line: 92
    local Entered = if p5 == nil then nil else p5.Hooks.Entered

    if Entered ~= nil then
        task.spawn(Entered)
    end

    local Left = if p6 == nil then nil else p6.Hooks.Left

    if Left ~= nil then
        task.spawn(Left)
    end
end)

local function poll() -- line: 103
    -- upvalues: Player (copy), t1 (copy), t2 (copy), v2 (ref), v3 (ref), padBeneath (copy)
    while #t2 > 0 do
        local v9 = Player.FindRootPart()
        local v10 = if v9 == nil then nil else padBeneath(v9.Position)
        local v11 = v2

        if v10 ~= v11 then
            v2 = v10
            t1.Changed:Fire(v10, v11)
        end

        task.wait(0.15)
    end

    local v12 = v2

    if v12 ~= nil then
        v2 = nil
        t1.Changed:Fire(nil, v12)
    end

    v3 = false
end

local function startBob(p7) -- line: 113
    -- upvalues: TweenService (copy), GameFlags (copy), v1 (copy)
    local Pivot = p7:GetPivot()
    local NumberValue = Instance.new("NumberValue")

    NumberValue.Name = "PadMarkerLift"
    NumberValue.Value = -0.4

    local connection = NumberValue.Changed:Connect(function(p8) -- line: 118
        -- upvalues: p7 (copy), Pivot (copy)
        p7:PivotTo(Pivot + Vector3.new(0, p8, 0))
    end)

    NumberValue.Parent = p7

    local tween = TweenService:Create(NumberValue, v1, {
        Value = 0.4
    })

    if not GameFlags.WorldOverlaysHidden:Get() then
        tween:Play()
    end

    return {
        Height = NumberValue,
        Motion = tween,
        Follow = connection
    }
end

local function stopBob(p9) -- line: 130
    p9.Motion:Cancel()
    p9.Follow:Disconnect()
    p9.Height:Destroy()
end

GameFlags.WorldOverlaysHidden.Changed:Connect(function(p10) -- line: 136
    -- upvalues: t2 (copy)
    for _, v13 in t2 do
        local Bob = v13.Bob

        if Bob ~= nil then
            if p10 then
                Bob.Motion:Pause()
            else
                Bob.Motion:Play()
            end
        end
    end
end)

function t1.Track(p11, p12) -- line: 152
    -- upvalues: t2 (copy), v2 (ref), v3 (ref), poll (copy), startBob (copy)
    assert(typeof(p11) == "Instance" and p11:IsA("PVInstance"), "Pads.Track needs a PVInstance surface")

    local t3

    local function untrack() -- line: 156
        -- upvalues: t3 (ref), t2 (copy), v2 (ref)
        local v15 = table.find(t2, t3)

        if v15 == nil then
            return
        end

        table.remove(t2, v15)
        t3.Gone:Disconnect()

        local Bob = t3.Bob

        if Bob ~= nil then
            Bob.Motion:Cancel()
            Bob.Follow:Disconnect()
            Bob.Height:Destroy()
        end

        if v2 == t3 then
            v2 = nil
        end
    end

    local Parent = p11.Parent
    local PadMarker = if Parent == nil then nil else Parent:FindFirstChild("PadMarker")

    t3 = {
        Surface = p11,
        Hooks = p12 or {},
        Bob = if PadMarker == nil or not PadMarker:IsA("PVInstance") then nil else startBob(PadMarker),
        Gone = p11.Destroying:Once(untrack)
    }
    table.insert(t2, t3)

    if not v3 then
        v3 = true
        task.spawn(poll)
    end

    return untrack
end

return table.freeze(t1)
