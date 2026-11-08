-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local t = require(ReplicatedStorage.Packages.t)
local Signal = require(ReplicatedStorage.Packages.Signal)
local t1 = {}
local t2 = {
    ModelAdded = Signal.new()
}

function t2.ApplyModelHidden(p1, p2) -- line: 23
    -- upvalues: t (copy)
    t.strict(t.instanceIsA("Model"))(p1)
    t.strict(t.boolean)(p2)

    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = p2 and 1 or 0
        end
    end
end

function t2.ResolveModel(p3) -- line: 34
    -- upvalues: Workspace (copy), t (copy)
    t.strict(t.string)(p3)

    local v1 = Workspace:FindFirstChild(p3)

    if v1 == nil then
        return nil
    end

    assert(v1:IsA("Model"), (("Workspace area egg %* must be a Model"):format(p3)))

    return v1
end

function t2.SetHidden(p4, p5) -- line: 44
    -- upvalues: Workspace (copy), t (copy), t1 (copy), t2 (copy)
    t.strict(t.string)(p4)
    t.strict(t.boolean)(p5)

    if p5 then
        t1[p4] = true
    else
        t1[p4] = nil
    end

    for _, child in ipairs(Workspace:GetChildren()) do
        if child.Name == p4 and child:IsA("Model") then
            t2.ApplyModelHidden(child, p5)
        end
    end
end

function t2.Start() -- line: 60
    -- upvalues: Workspace (copy), t1 (copy), t2 (copy)
    Workspace.ChildAdded:Connect(function(p6) -- line: 61
        -- upvalues: Workspace (copy), t1 (copy), t2 (copy)
        if not p6:IsA("Model") or p6.Parent ~= Workspace then
            return
        end

        if t1[p6.Name] == true then
            t2.ApplyModelHidden(p6, true)
        end

        t2.ModelAdded:Fire(p6)
    end)
end

return table.freeze(t2)
