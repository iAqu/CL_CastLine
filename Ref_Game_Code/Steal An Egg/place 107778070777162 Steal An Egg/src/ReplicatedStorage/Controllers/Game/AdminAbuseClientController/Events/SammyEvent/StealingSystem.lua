-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CarryRunBackEffects = require(script.Parent.Parent.Parent.Parent.AreaEggsController.CarryRunBackEffects)
local Player = require(ReplicatedStorage.Shared.Player)

require(ReplicatedStorage.Packages.Trove)

local TutorialBeam = require(ReplicatedStorage.Client.WorldFX.TutorialBeam)
local LocalPlayer = Players.LocalPlayer
local v1
local v2 = false

local function raidMap() -- line: 42
    -- upvalues: Workspace (copy)
    return Workspace:FindFirstChild("SammyEventMap")
end

local function returnPoint() -- line: 46
    -- upvalues: Workspace (copy)
    local SammyEventMap = Workspace:FindFirstChild("SammyEventMap")
    local LaserGun = if SammyEventMap then SammyEventMap:FindFirstChild("LaserGun") else nil
    local ReturnZone = if LaserGun then LaserGun:FindFirstChild("ReturnZone") else nil

    return if ReturnZone ~= nil and ReturnZone:IsA("BasePart") then ReturnZone else nil
end

local function nearestSteal() -- line: 54
    -- upvalues: Workspace (copy), Player (copy), LocalPlayer (copy)
    local SammyEventMap = Workspace:FindFirstChild("SammyEventMap")
    local v3 = Player.FindRootPart(LocalPlayer)

    if SammyEventMap == nil or v3 == nil or not v3:IsA("BasePart") then
        return nil
    end

    local n1 = 1e999
    local Parent

    for _, child in SammyEventMap:GetChildren() do
        if child:IsA("Model") then
            local v4 = child:FindFirstChild("StealBrainrot", true)
            local Parent2 = if v4 == nil then nil else v4.Parent

            if Parent2 ~= nil and Parent2:IsA("BasePart") then
                local Magnitude = (Parent2.Position - v3.Position).Magnitude

                if Magnitude < n1 then
                    n1 = Magnitude
                    Parent = Parent2
                end
            end
        end
    end

    return Parent
end

local function cageTarget() -- line: 82
    -- upvalues: Workspace (copy)
    local SammyEventMap = Workspace:FindFirstChild("SammyEventMap")
    local CagedBen = if SammyEventMap then SammyEventMap:FindFirstChild("CagedBen") else nil
    local Hitbox = if CagedBen then CagedBen:FindFirstChild("Hitbox") else nil

    return if Hitbox ~= nil and Hitbox:IsA("BasePart") then Hitbox else nil
end

local function dropBeam() -- line: 89
    -- upvalues: TutorialBeam (copy), v1 (ref)
    local v5 = v1

    if v5 ~= nil then
        v1 = nil
        TutorialBeam.Destroy(v5)
    end
end

local function refresh() -- line: 97
    -- upvalues: Workspace (copy), TutorialBeam (copy), LocalPlayer (copy), v1 (ref), nearestSteal (copy)
    local v6

    if LocalPlayer:GetAttribute("SammyCarrying") ~= nil then
        local SammyEventMap = Workspace:FindFirstChild("SammyEventMap")
        local LaserGun = if SammyEventMap then SammyEventMap:FindFirstChild("LaserGun") else nil

        if LaserGun then
            v6 = LaserGun:FindFirstChild("ReturnZone")
        end

        if v6 == nil or not v6:IsA("BasePart") then
            v6 = nil
        end
    else
        local v7 = nearestSteal()

        if v7 then
            v6 = v7
        else
            local SammyEventMap = Workspace:FindFirstChild("SammyEventMap")
            local CagedBen = if SammyEventMap then SammyEventMap:FindFirstChild("CagedBen") else nil

            if CagedBen then
                v6 = CagedBen:FindFirstChild("Hitbox")
            end

            if v6 == nil or not v6:IsA("BasePart") then
                v6 = nil
            end
        end
    end

    if v6 ~= nil then
        local v9 = v1

        if v9 ~= nil then
            TutorialBeam.Retarget(v9, v6)
        else
            v1 = TutorialBeam.Attach(v6, {
                BeamName = "SammyReturnBeam"
            })
        end
    else
        local v8 = v1

        if v8 ~= nil then
            v1 = nil
            TutorialBeam.Destroy(v8)
        end
    end
end

local function stopRunBack() -- line: 115
    -- upvalues: CarryRunBackEffects (copy), v2 (ref)
    if v2 then
        v2 = false
        CarryRunBackEffects.ForceStop()
    end
end

local function syncRunBack() -- line: 124
    -- upvalues: CarryRunBackEffects (copy), LocalPlayer (copy), v2 (ref)
    if LocalPlayer:GetAttribute("SammyCarrying") ~= nil then
        if not v2 then
            v2 = true
            CarryRunBackEffects.ForceStart()
        end
    elseif v2 then
        v2 = false
        CarryRunBackEffects.ForceStop()
    end
end

local function stop() -- line: 135
    -- upvalues: CarryRunBackEffects (copy), TutorialBeam (copy), v1 (ref), v2 (ref)
    local v10 = v1

    if v10 ~= nil then
        v1 = nil
        TutorialBeam.Destroy(v10)
    end

    if v2 then
        v2 = false
        CarryRunBackEffects.ForceStop()
    end
end

return {
    Start = function(p1) -- start | line: 140
        -- upvalues: Workspace (copy), CarryRunBackEffects (copy), TutorialBeam (copy), LocalPlayer (copy), v1 (ref), v2 (ref), refresh (copy), stop (copy)
        local v11 = v1

        if v11 ~= nil then
            v1 = nil
            TutorialBeam.Destroy(v11)
        end

        if v2 then
            v2 = false
            CarryRunBackEffects.ForceStop()
        end

        p1:Connect(LocalPlayer:GetAttributeChangedSignal("SammyCarrying"), function() -- line: 142
            -- upvalues: CarryRunBackEffects (copy), LocalPlayer (copy), v2 (ref), refresh (copy)
            refresh()

            if LocalPlayer:GetAttribute("SammyCarrying") ~= nil then
                if not v2 then
                    v2 = true
                    CarryRunBackEffects.ForceStart()
                end
            elseif v2 then
                v2 = false
                CarryRunBackEffects.ForceStop()
            end
        end)
        p1:Add(stop)
        p1:Add(task.spawn(function() -- line: 149
            -- upvalues: Workspace (copy), refresh (copy)
            Workspace:WaitForChild("SammyEventMap", 10)

            while true do
                refresh()
                task.wait(0.25)
            end
        end))
    end,
    Stop = stop
}
