-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Areas = require(ReplicatedStorage.Data.Areas)
local t = require(ReplicatedStorage.Packages.t)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Player = require(ReplicatedStorage.Shared.Player)
local Sakura = require(ReplicatedStorage.Data.Sakura)
local SakuraBloomPolicy = require(ReplicatedStorage.Client.Modules.SakuraBloomPolicy)
local Save = require(ReplicatedStorage.Shared.Save)
local t1 = {
    ["Cherry Blossom"] = true,
    [Sakura.AreaDisplay.AreaId] = true
}
local LocalPlayer = Players.LocalPlayer
local World = Workspace:WaitForChild("World")

assert(World:IsA("Folder"), "Workspace.World must be a Folder")

local Areas2 = World.Areas

assert(Areas2:IsA("Folder"), "Workspace.World.Areas must be a Folder")

local SeparationLine = Areas2.SeparationLine

assert(SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

local GuardAreas = Areas2.GuardAreas

assert(GuardAreas:IsA("Folder"), "Workspace.World.Areas.GuardAreas must be a Folder")

local Build = World:WaitForChild("Build")
local CherryBlossom = Areas2:WaitForChild("CherryBlossom")

assert(CherryBlossom:IsA("Folder"), "Workspace.World.Areas.CherryBlossom must be a Folder")

local t2 = {}
local t3 = {}
local AreaId, v1, Lighting

local function rebuildAreaEntries(_) -- line: 70
    -- upvalues: Areas (copy), GuardAreaGeometry (copy), Sakura (copy), GuardAreas (copy), CherryBlossom (copy), t3 (copy)
    table.clear(t3)

    for _, v2 in ipairs(GuardAreaGeometry.ReadAreaBounds(GuardAreas)) do
        t3[#t3 + 1] = {
            AreaId = v2.AreaId,
            Bounds = v2.Bounds,
            Config = Areas.Directory[v2.AreaId]
        }
    end

    local Bounds = CherryBlossom:FindFirstChild("Bounds")

    if Bounds and Bounds:IsA("BasePart") then
        t3[#t3 + 1] = {
            AreaId = Sakura.AreaDisplay.AreaId,
            Bounds = Bounds,
            Config = Sakura.AreaDisplay
        }
    end

    table.sort(t3, function(p2, p3) -- line: 90
        -- upvalues: Areas (copy)
        local v3 = Areas.GetProgressionOrder(p2.Config)
        local v4 = Areas.GetProgressionOrder(p3.Config)

        if v3 == v4 then
            return p2.AreaId < p3.AreaId
        end

        return v3 < v4
    end)
end

local function isEntryAvailable(p4) -- line: 102
    -- upvalues: t1 (copy), Build (copy)
    if p4.Bounds.Parent and p4.Bounds.Parent:GetAttribute("ZoneHidden") == true then
        return false
    end

    return not (t1[p4.AreaId] and Build:FindFirstChild("CherryBlossomZone") == nil)
end

local function resolveCurrentArea(p5) -- line: 115
    -- upvalues: t (copy), GuardAreaGeometry (copy), t1 (copy), Build (copy), t3 (copy)
    t.strict(t.Vector3)(p5)

    for _, v5 in ipairs(t3) do
        if (not v5.Bounds.Parent or v5.Bounds.Parent:GetAttribute("ZoneHidden") ~= true) and (not t1[v5.AreaId] or Build:FindFirstChild("CherryBlossomZone") ~= nil) and GuardAreaGeometry.IsWithinFootprint(v5.Bounds, p5) then
            return v5
        end
    end

    return nil
end

local function isBloomUnlocked() -- line: 130
    -- upvalues: SakuraBloomPolicy (copy), Save (copy)
    local v6 = Save.IsLoaded()
    local v7 = if v6 then Save.Peek() else nil

    return SakuraBloomPolicy.HasBloomUnlocked(v6, v7)
end

local function updateZoneLighting(p6, p7) -- line: 136
    -- upvalues: Workspace (copy), LightingController (copy), SakuraBloomPolicy (copy), Save (copy), t1 (copy), Lighting (ref)
    local v8, v9

    if p7 and t1[p7] then
        if Workspace:GetAttribute("Event_GreatBloom") then
            local v10 = Save.IsLoaded()
            local v11 = if v10 then Save.Peek() else nil

            if SakuraBloomPolicy.HasBloomUnlocked(v10, v11) then
                v8 = p6
                v9 = true
            else
                v9 = false
            end
        else
            v9 = false
        end
    else
        v8 = p6
        v9 = true
    end

    if not v9 then
        v8 = nil
    end

    local Lighting2 = if v8 then v8.Lighting else nil

    if Lighting2 ~= Lighting then
        Lighting = Lighting2

        if Lighting2 ~= nil then
            LightingController.SetLayer("ZoneLighting", Lighting2, 25, 2)
        else
            LightingController.ClearLayer("ZoneLighting", 2)
        end
    end
end

local function step(p8) -- line: 160
    -- upvalues: Players (copy), Areas (copy), GuardAreaGeometry (copy), Player (copy), LocalPlayer (copy), SeparationLine (copy), AreaId (ref), v1 (ref), resolveCurrentArea (copy), updateZoneLighting (copy)
    local v12 = Player.FindRootPart(LocalPlayer)

    if v12 ~= nil then
        assert(v12:IsA("BasePart"), (("%* must be a BasePart"):format((v12:GetFullName()))))

        if GuardAreaGeometry.IsPastLine(SeparationLine, v12.Position) then
            local v14 = resolveCurrentArea(v12.Position)

            if v14 ~= nil then
                Players.LocalPlayer:SetAttribute("AreaId", v14.AreaId)
                updateZoneLighting(v14.Config, v14.AreaId)

                if v14.AreaId ~= AreaId then
                    AreaId = v14.AreaId

                    local v15 = Areas.GetProgressionOrder(v14.Config)
                    local v16 = v1

                    v1 = v15

                    if v16 == nil or not (v15 <= v16) then
                        p8(v14.Config, v14.AreaId)
                    end
                end
            else
                AreaId = nil
                updateZoneLighting(nil)
            end
        else
            AreaId = nil
            v1 = nil
            updateZoneLighting(nil)
        end
    else
        AreaId = nil
        updateZoneLighting(nil)
    end
end

function t2.Start(p9) -- line: 206
    -- upvalues: RunService (copy), t (copy), GuardAreas (copy), rebuildAreaEntries (copy), step (copy)
    t.strict(t.callback)(p9)
    rebuildAreaEntries(nil)
    GuardAreas.ChildAdded:Connect(rebuildAreaEntries)
    GuardAreas.ChildRemoved:Connect(rebuildAreaEntries)

    local n1 = 0

    RunService.Heartbeat:Connect(function(p10) -- line: 214
        -- upvalues: p9 (copy), n1 (ref), step (copy)
        n1 += p10

        if not (n1 < 0.1) then
            n1 = 0
            step(p9)
        end
    end)
end

return t2
