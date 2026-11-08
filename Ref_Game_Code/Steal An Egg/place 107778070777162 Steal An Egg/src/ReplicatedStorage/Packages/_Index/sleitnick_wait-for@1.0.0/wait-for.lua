-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Promise = require(script.Parent.Parent.Parent.Promise)
local t1 = {
    Error = {
        Unparented = "Unparented",
        ParentChanged = "ParentChanged"
    }
}

local function PromiseWatchAncestry(p1, p2) -- line: 40
    -- upvalues: Promise (copy), t1 (copy)
    return Promise.race({
        p2,
        Promise.fromEvent(p1.AncestryChanged, function(_, p4) -- line: 43
            return p4 == nil
        end):andThen(function() -- line: 45
            -- upvalues: Promise (copy), t1 (copy)
            return Promise.reject(t1.Error.Unparented)
        end)
    })
end

function t1.Child(p5, p6, p7) -- line: 61
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local v1 = p5:FindFirstChild(p6)

    if v1 then
        return Promise.resolve(v1)
    end

    return PromiseWatchAncestry(p5, Promise.fromEvent(p5.ChildAdded, function(p8) -- line: 68
        -- upvalues: p6 (copy)
        return p8.Name == p6
    end):timeout(p7 or 120))
end

function t1.ChildWhichIsA(p9, p10, p11) -- line: 94
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local v2 = p9:FindFirstChildWhichIsA(p10)

    if v2 then
        return Promise.resolve(v2)
    end

    return PromiseWatchAncestry(p9, Promise.fromEvent(p9.ChildAdded, function(p12) -- line: 101
        -- upvalues: p10 (copy)
        return p12:IsA(p10)
    end):timeout(p11 or 120))
end

function t1.Children(p13, p14, p15) -- line: 125
    -- upvalues: Promise (copy), t1 (copy)
    local v3 = table.create(#p14)

    for v4, v5 in ipairs(p14) do
        v3[v4] = t1.Child(p13, v5, p15)
    end

    return Promise.all(v3):andThen(function(p16) -- line: 130
        -- upvalues: p13 (copy), Promise (copy), t1 (copy)
        for _, v6 in ipairs(p16) do
            if v6.Parent ~= p13 then
                return Promise.reject(t1.Error.ParentChanged)
            end
        end

        return p16
    end)
end

function t1.Descendant(p17, p18, p19) -- line: 153
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local v7 = p17:FindFirstChild(p18, true)

    if v7 then
        return Promise.resolve(v7)
    end

    return PromiseWatchAncestry(p17, Promise.fromEvent(p17.DescendantAdded, function(p20) -- line: 160
        -- upvalues: p18 (copy)
        return p20.Name == p18
    end):timeout(p19 or 120))
end

function t1.Descendants(p21, p22, p23) -- line: 184
    -- upvalues: Promise (copy), t1 (copy)
    local v8 = table.create(#p22)

    for v9, v10 in ipairs(p22) do
        v8[v9] = t1.Descendant(p21, v10, p23)
    end

    return Promise.all(v8):andThen(function(p24) -- line: 189
        -- upvalues: p21 (copy), Promise (copy), t1 (copy)
        for _, v11 in ipairs(p24) do
            if not v11:IsDescendantOf(p21) then
                return Promise.reject(t1.Error.ParentChanged)
            end
        end

        return p24
    end)
end

function t1.PrimaryPart(p25, p26) -- line: 210
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local PrimaryPart = p25.PrimaryPart
    local PrimaryPart2 = PrimaryPart

    if PrimaryPart then
        return Promise.resolve(PrimaryPart)
    end

    return PromiseWatchAncestry(p25, Promise.fromEvent(p25:GetPropertyChangedSignal("PrimaryPart"), function() -- line: 217
        -- upvalues: p25 (copy), PrimaryPart2 (ref)
        PrimaryPart2 = p25.PrimaryPart

        return PrimaryPart2 ~= nil
    end):andThen(function() -- line: 221
        -- upvalues: PrimaryPart2 (ref)
        return PrimaryPart2
    end):timeout(p26 or 120))
end

function t1.ObjectValue(p27, p28) -- line: 238
    -- upvalues: Promise (copy), PromiseWatchAncestry (copy)
    local Value = p27.Value
    local v12 = Value

    if Value then
        return Promise.resolve(Value)
    end

    return PromiseWatchAncestry(p27, Promise.fromEvent(p27.Changed, function(p29) -- line: 245
        -- upvalues: v12 (ref)
        v12 = p29

        return v12 ~= nil
    end):andThen(function() -- line: 249
        -- upvalues: v12 (ref)
        return v12
    end):timeout(p28 or 120))
end

function t1.Custom(p30, p31) -- line: 268
    -- upvalues: RunService (copy), Promise (copy)
    local v13 = p30()

    if v13 ~= nil then
        return Promise.resolve(v13)
    end

    return Promise.new(function(p32, _, p34) -- line: 273
        -- upvalues: p30 (copy), RunService (copy)
        local connection

        local function OnDone() -- line: 275
            -- upvalues: connection (ref)
            connection:Disconnect()
        end

        local function Update() -- line: 278
            -- upvalues: p32 (copy), connection (ref), p30 (copy)
            local v14 = p30()

            if v14 == nil then
                return
            end

            connection:Disconnect()
            p32(v14)
        end

        connection = RunService.Heartbeat:Connect(Update)
        p34(OnDone)
    end):timeout(p31 or 120)
end

return t1
