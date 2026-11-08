-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Trove = require(script.Parent.Parent.Trove)
local Signal = require(script.Parent.Parent.Signal)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 96
    -- upvalues: Trove (copy), Signal (copy), t1 (copy)
    local t2 = {}

    setmetatable(t2, t1)
    t2._trove = Trove.new()
    t2._shown = t2._trove:Construct(Signal)
    t2._shownTrove = Trove.new()
    t2._trove:Add(t2._shownTrove)
    t2.Instance = p1:FindFirstChild(p2)

    local function OnInstanceSet() -- line: 107
        -- upvalues: t2 (copy)
        local Instance = t2.Instance

        if typeof(Instance) ~= "Instance" then
            return
        end

        t2._shown:Fire(Instance, t2._shownTrove)
        t2._shownTrove:Connect(Instance:GetPropertyChangedSignal("Parent"), function() -- line: 111
            -- upvalues: Instance (copy), t2 (copy)
            if not Instance.Parent then
                t2._shownTrove:Clean()
            end
        end)
        t2._shownTrove:Add(function() -- line: 116
            -- upvalues: Instance (copy), t2 (copy)
            if t2.Instance == Instance then
                t2.Instance = nil
            end
        end)
    end

    local function OnChildAdded(p3) -- line: 124
        -- upvalues: p2 (copy), t2 (copy), OnInstanceSet (copy)
        if p3.Name == p2 and not t2.Instance then
            t2.Instance = p3
            OnInstanceSet()
        end
    end

    t2._trove:Connect(p1.ChildAdded, OnChildAdded)

    if t2.Instance then
        OnInstanceSet()
    end

    return t2
end

function t1.primary(p4) -- line: 146
    -- upvalues: Trove (copy), Signal (copy), t1 (copy)
    local t3 = {}

    setmetatable(t3, t1)
    t3._trove = Trove.new()
    t3._shown = t3._trove:Construct(Signal)
    t3._shownTrove = Trove.new()
    t3._trove:Add(t3._shownTrove)
    t3.Instance = p4.PrimaryPart

    local function OnPrimaryPartChanged() -- line: 157
        -- upvalues: p4 (copy), t3 (copy)
        local PrimaryPart = p4.PrimaryPart

        t3._shownTrove:Clean()
        t3.Instance = PrimaryPart

        if PrimaryPart then
            t3._shown:Fire(PrimaryPart, t3._shownTrove)
        end
    end

    t3._trove:Connect(p4:GetPropertyChangedSignal("PrimaryPart"), OnPrimaryPartChanged)

    if t3.Instance then
        local PrimaryPart = p4.PrimaryPart

        t3._shownTrove:Clean()
        t3.Instance = PrimaryPart

        if PrimaryPart then
            t3._shown:Fire(PrimaryPart, t3._shownTrove)
        end
    end

    return t3
end

function t1.Observe(p5, p6) -- line: 184
    if p5.Instance then
        task.spawn(p6, p5.Instance, p5._shownTrove)
    end

    return p5._shown:Connect(p6)
end

function t1.Destroy(p7) -- line: 196
    p7._trove:Destroy()
end

return t1
