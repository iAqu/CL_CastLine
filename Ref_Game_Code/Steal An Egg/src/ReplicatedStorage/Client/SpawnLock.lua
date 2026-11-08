-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local t1 = {}
local clone
local v1 = false
local t2 = {}

local function anyClaims() -- line: 19
    -- upvalues: t1 (copy)
    return next(t1) ~= nil
end

local function findTemplate() -- line: 23
    -- upvalues: ReplicatedStorage (copy), v1 (ref)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local SpawnLock = if Assets == nil then nil else Assets:FindFirstChild("SpawnLock")

    if SpawnLock == nil and not v1 then
        v1 = true
        warn("SpawnLock: ReplicatedStorage.Assets.SpawnLock does not exist, so the spawn barrier cannot be raised")
    end

    return SpawnLock
end

local function collidableParts(p1) -- line: 35
    local t3 = {}

    local function consider(p2) -- line: 37
        -- upvalues: t3 (copy)
        if p2:IsA("BasePart") and p2.CanCollide then
            t3[#t3 + 1] = p2
        end
    end

    if p1:IsA("BasePart") and p1.CanCollide then
        t3[#t3 + 1] = p1
    end

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.CanCollide then
            t3[#t3 + 1] = descendant
        end
    end

    return t3
end

local function touchesCharacter(p3, p4) -- line: 49
    -- upvalues: Workspace (copy)
    local v2 = OverlapParams.new()

    v2.FilterType = Enum.RaycastFilterType.Include
    v2.FilterDescendantsInstances = { p4 }

    return #Workspace:GetPartsInPart(p3, v2) > 0
end

local function solidifyOnceClear(p5) -- line: 59
    -- upvalues: Players (copy), RunService (copy), collidableParts (copy), touchesCharacter (copy)
    local v3 = collidableParts(p5)

    for _, v4 in v3 do
        v4.CanCollide = false
    end

    if #v3 ~= 0 then
        task.spawn(function() -- line: 67
            -- upvalues: p5 (copy), v3 (copy), Players (copy), RunService (copy), touchesCharacter (copy)
            while true do
                if #v3 > 0 then
                    RunService.Heartbeat:Wait()

                    if p5.Parent == nil then
                        break
                    end

                    local LocalPlayer = Players.LocalPlayer
                    local Character = if LocalPlayer == nil then nil else LocalPlayer.Character

                    for i = #v3, 1, -1 do
                        local v5 = v3[i]

                        if Character == nil or not touchesCharacter(v5, Character) then
                            v5.CanCollide = true
                            table.remove(v3, i)
                        end
                    end

                    continue
                end

                return
            end
        end)
    end
end

local function raiseBarrier() -- line: 86
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), v1 (ref), solidifyOnceClear (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local SpawnLock = if Assets == nil then nil else Assets:FindFirstChild("SpawnLock")

    if SpawnLock == nil and not v1 then
        v1 = true
        warn("SpawnLock: ReplicatedStorage.Assets.SpawnLock does not exist, so the spawn barrier cannot be raised")
    end

    if SpawnLock == nil then
        return nil
    end

    local clone = SpawnLock:Clone()

    solidifyOnceClear(clone)
    clone.Parent = Workspace

    return clone
end

local function syncBarrier() -- line: 97
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), t1 (copy), clone (ref), v1 (ref), solidifyOnceClear (copy)
    local clone2 = clone

    if next(t1) ~= nil then
        if clone2 == nil or clone2.Parent == nil then
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local SpawnLock = if Assets == nil then nil else Assets:FindFirstChild("SpawnLock")

            if SpawnLock == nil and not v1 then
                v1 = true
                warn("SpawnLock: ReplicatedStorage.Assets.SpawnLock does not exist, so the spawn barrier cannot be raised")
            end

            local clone2

            if SpawnLock ~= nil then
                clone2 = SpawnLock:Clone()
                solidifyOnceClear(clone2)
                clone2.Parent = Workspace
            end

            clone = clone2
        end
    else
        clone = nil

        if clone2 ~= nil then
            clone2:Destroy()
        end
    end
end

function t2.ObtainLock() -- line: 111
    -- upvalues: ReplicatedStorage (copy), Workspace (copy), t1 (copy), clone (ref), v1 (ref), solidifyOnceClear (copy)
    local v6 = table.freeze({})

    t1[v6] = true

    local clone2 = clone

    if next(t1) ~= nil then
        if clone2 == nil or clone2.Parent == nil then
            local Assets = ReplicatedStorage:FindFirstChild("Assets")
            local SpawnLock = if Assets == nil then nil else Assets:FindFirstChild("SpawnLock")

            if SpawnLock == nil and not v1 then
                v1 = true
                warn("SpawnLock: ReplicatedStorage.Assets.SpawnLock does not exist, so the spawn barrier cannot be raised")
            end

            local clone2

            if SpawnLock ~= nil then
                clone2 = SpawnLock:Clone()
                solidifyOnceClear(clone2)
                clone2.Parent = Workspace
            end

            clone = clone2
        end
    else
        clone = nil

        if clone2 ~= nil then
            clone2:Destroy()
        end
    end

    return function() -- line: 115
        -- upvalues: v6 (copy), ReplicatedStorage (copy), Workspace (copy), t1 (copy), clone (ref), v1 (ref), solidifyOnceClear (copy)
        if t1[v6] == nil then
            return
        end

        t1[v6] = nil

        local clone2 = clone

        if next(t1) ~= nil then
            if clone2 == nil or clone2.Parent == nil then
                local Assets = ReplicatedStorage:FindFirstChild("Assets")
                local SpawnLock = if Assets == nil then nil else Assets:FindFirstChild("SpawnLock")

                if SpawnLock == nil and not v1 then
                    v1 = true
                    warn("SpawnLock: ReplicatedStorage.Assets.SpawnLock does not exist, so the spawn barrier cannot be raised")
                end

                local clone2

                if SpawnLock ~= nil then
                    clone2 = SpawnLock:Clone()
                    solidifyOnceClear(clone2)
                    clone2.Parent = Workspace
                end

                clone = clone2
            end
        else
            clone = nil

            if clone2 ~= nil then
                clone2:Destroy()
            end
        end
    end
end

function t2.IsLocked() -- line: 124
    -- upvalues: t1 (copy)
    return next(t1) ~= nil
end

return table.freeze(t2)
