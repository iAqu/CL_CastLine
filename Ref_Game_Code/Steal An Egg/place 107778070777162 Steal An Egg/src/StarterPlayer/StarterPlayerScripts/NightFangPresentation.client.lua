-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local NightFangHeight = require(ReplicatedStorage.Shared.Modules.NightFangHeight)
local t1 = {}

local function isTarget(p1) -- line: 10
    if p1:GetAttribute("MountOwnsAnimationHeight") == true then
        return false
    end

    if p1.Name == "Zombified Halloween Terrorbird" then
        return true
    end

    return p1:GetAttribute("PreparedSourceName") == "Zombified Bat"
end

local function remove(p2) -- line: 15
    -- upvalues: NightFangHeight (copy), t1 (copy)
    local v1 = t1[p2]

    if not v1 then
        return
    end

    t1[p2] = nil
    v1.Connection:Disconnect()
    NightFangHeight.Reset(v1)
end

local function add(p3) -- line: 23
    -- upvalues: NightFangHeight (copy), t1 (copy)
    if not t1[p3] and p3:GetAttribute("MountOwnsAnimationHeight") ~= true and (p3.Name == "Zombified Halloween Terrorbird" or p3:GetAttribute("PreparedSourceName") == "Zombified Bat") then
        local v2 = p3:FindFirstChild("Control", true)

        if v2 and v2:IsA("Bone") then
            local v3 = NightFangHeight.New(p3)

            if v3 then
                v3.Connection = p3.Destroying:Connect(function() -- line: 29
                    -- upvalues: p3 (copy), NightFangHeight (copy), t1 (copy)
                    local v4 = t1[p3]

                    if not v4 then
                        return
                    end

                    t1[p3] = nil
                    v4.Connection:Disconnect()
                    NightFangHeight.Reset(v4)
                end)
                t1[p3] = v3
            end
        end
    end
end

for _, descendant in Workspace:GetDescendants() do
    if descendant:IsA("Model") then
        add(descendant)
    end
end

Workspace.DescendantAdded:Connect(function(p4) -- line: 36
    -- upvalues: Workspace (copy), add (copy)
    if p4:IsA("Model") then
        add(p4)
    elseif p4:IsA("Bone") and p4.Name == "Control" then
        local Parent = p4.Parent

        while Parent and Parent ~= Workspace do
            if Parent:IsA("Model") then
                add(Parent)
            end

            Parent = Parent.Parent
        end
    end
end)
Workspace.DescendantRemoving:Connect(function(p5) -- line: 47
    -- upvalues: Workspace (copy), NightFangHeight (copy), t1 (copy)
    if t1[p5] then
        task.defer(function() -- line: 49
            -- upvalues: p5 (copy), Workspace (copy), NightFangHeight (copy), t1 (copy)
            if p5:IsDescendantOf(Workspace) then
                return
            end

            local v5 = t1[p5]

            if not v5 then
                return
            end

            t1[p5] = nil
            v5.Connection:Disconnect()
            NightFangHeight.Reset(v5)
        end)
    end
end)
RunService.PreAnimation:Connect(function() -- line: 54
    -- upvalues: NightFangHeight (copy), t1 (copy)
    for _, v6 in t1 do
        NightFangHeight.Reset(v6)
    end
end)
RunService.PreSimulation:Connect(function() -- line: 57
    -- upvalues: NightFangHeight (copy), t1 (copy)
    for _, v7 in t1 do
        NightFangHeight.Apply(v7)
    end
end)
