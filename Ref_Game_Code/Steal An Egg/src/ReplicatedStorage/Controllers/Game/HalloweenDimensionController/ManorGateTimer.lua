-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HalloweenDimensionFlags = require(ReplicatedStorage.Shared.Flags.HalloweenDimensionFlags)
local HalloweenManor = require(ReplicatedStorage.Data.HalloweenManor)
local Log = require(ReplicatedStorage.Packages.Log)
local ManorInterior = require(ReplicatedStorage.Shared.Util.ManorInterior)

require(ReplicatedStorage.Packages.Trove)

local v1 = Log.new()
local t1 = {}
local t2 = {}

local function gateWait(p1) -- line: 40
    if p1 >= 86400 then
        return string.format("%dd %02dh", p1 // 86400, p1 % 86400 // 3600)
    end

    if p1 >= 3600 then
        return string.format("%02d:%02d:%02d", p1 // 3600, p1 % 3600 // 60, p1 % 60)
    end

    return string.format("%02d:%02d", p1 // 60, p1 % 60)
end

local function signText() -- line: 58
    -- upvalues: Workspace (copy), ManorInterior (copy), gateWait (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v2 = ManorInterior.GateOpensAt(ServerTimeNow)
    local v3 = if v2 == nil then 0 else math.max(math.ceil(v2 - ServerTimeNow), 0)

    return string.format("UNLOCKS IN %s", gateWait(v3))
end

local function labelOf(p2) -- line: 65
    -- upvalues: v1 (copy)
    local Hitbox = p2:FindFirstChild("Hitbox")
    local Sign = if Hitbox == nil then nil else Hitbox:FindFirstChild("Sign")
    local Title = if Sign == nil then nil else Sign:FindFirstChild("Title")

    if Title ~= nil and Title:IsA("TextLabel") then
        return Title
    end

    v1:AtWarning():Log((("%* has no Hitbox.Sign.Title; skipping its timer"):format((p2:GetFullName()))))

    return nil
end

local function forget(p3) -- line: 76
    -- upvalues: t1 (copy)
    local v6 = t1[p3]

    if v6 == nil then
        return
    end

    t1[p3] = nil
    v6.Label.Text = v6.Original

    if v6.Gui ~= nil then
        v6.Gui.Enabled = v6.WasEnabled
    end
end

local function track(p4) -- line: 88
    -- upvalues: Workspace (copy), t1 (copy), labelOf (copy)
    if p4:IsA("Model") and p4:IsDescendantOf(Workspace) and t1[p4] == nil then
        local v7 = labelOf(p4)

        if v7 ~= nil then
            local BillboardGui = v7:FindFirstAncestorWhichIsA("BillboardGui")

            t1[p4] = {
                Gui = BillboardGui,
                Label = v7,
                Original = v7.Text,
                WasEnabled = BillboardGui == nil or BillboardGui.Enabled
            }
        end
    end
end

local function refresh(p5) -- line: 108
    -- upvalues: CollectionService (copy), Workspace (copy), HalloweenDimensionFlags (copy), ManorInterior (copy), t1 (copy), gateWait (copy), track (copy)
    local v8 = HalloweenDimensionFlags.ManorGateTimerEnabled:Get()

    for v9 in t1 do
        if not v8 or not v9:IsDescendantOf(Workspace) then
            local v11 = t1[v9]

            if v11 ~= nil then
                t1[v9] = nil
                v11.Label.Text = v11.Original

                if v11.Gui ~= nil then
                    v11.Gui.Enabled = v11.WasEnabled
                end
            end
        end
    end

    if not v8 then
        return
    end

    for _, v12 in CollectionService:GetTagged(p5) do
        track(v12)
    end

    local v13 = not ManorInterior.GateOpen()
    local v14

    if v13 then
        local ServerTimeNow = Workspace:GetServerTimeNow()
        local v15 = ManorInterior.GateOpensAt(ServerTimeNow)
        local v16 = if v15 == nil then 0 else math.max(math.ceil(v15 - ServerTimeNow), 0)

        v14 = string.format("UNLOCKS IN %s", gateWait(v16))
    end

    for _, v19 in t1 do
        if v19.Gui ~= nil and v19.Gui.Enabled ~= v13 then
            v19.Gui.Enabled = v13
        end

        if v14 ~= nil and v19.Label.Text ~= v14 then
            v19.Label.Text = v14
        end
    end
end

function t2.Start(p6) -- line: 137
    -- upvalues: CollectionService (copy), HalloweenDimensionFlags (copy), HalloweenManor (copy), v1 (copy), t1 (copy), refresh (copy)
    local Gate = HalloweenManor.Tags.Gate

    if Gate ~= nil then
        p6:Connect(CollectionService:GetInstanceAddedSignal(Gate), function() -- line: 143
            -- upvalues: Gate (copy), refresh (copy)
            refresh(Gate)
        end)
        p6:Connect(HalloweenDimensionFlags.ManorGateOpen.Changed, function() -- line: 146
            -- upvalues: Gate (copy), refresh (copy)
            refresh(Gate)
        end)
        p6:Add(function() -- line: 149
            -- upvalues: t1 (copy)
            for v20 in t1 do
                local v21 = t1[v20]

                if v21 ~= nil then
                    t1[v20] = nil
                    v21.Label.Text = v21.Original

                    if v21.Gui ~= nil then
                        v21.Gui.Enabled = v21.WasEnabled
                    end
                end
            end
        end)
        p6:Add(task.spawn(function() -- line: 154
            -- upvalues: Gate (copy), refresh (copy)
            while true do
                refresh(Gate)
                task.wait(1)
            end
        end))
    else
        v1:AtWarning():Log("HalloweenManor.Tags.Gate is missing; no manor gate timer")
    end
end

return table.freeze(t2)
