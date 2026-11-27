-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Config = require(ReplicatedStorage.Shared.Config)
local Format = require(ReplicatedStorage.Shared.Format)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Hud = require(script.Parent.Parent.UI.Hud)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Backpack = require(script.Parent.Parent.UI.Backpack)
local LevelBar = require(script.Parent.Parent.UI.LevelBar)
local Menus = require(script.Parent.Parent.UI.Menus)
local Controls = require(script.Parent.Parent.Character.Controls)
local Poses = require(script.Parent.Parent.Character.Poses)
local MiniGames = require(script.Parent.Parent.MiniGames.MiniGames)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1
local v2 = false
local v3 = nil
local n1 = 0
local n2 = 0
local v4 = Color3.fromRGB(90, 185, 255)

local function v5() -- line: 31
    return false
end

local function myZone() -- line: 36
    -- upvalues: Config (copy), LocalPlayer (copy)
    local v6 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))

    return v6 and v6:FindFirstChild("LiftZone")
end

local function inside(p1, p2, p3, p4) -- line: 42
    local Center = p1:FindFirstChild("Center")

    if not Center then
        return false
    end

    local v7 = Center.CFrame:PointToObjectSpace(p2)
    local v8 = (p1:GetAttribute("Size") or 9) / 2 + p3

    if math.abs(v7.X) <= v8 then
        if not (math.abs(v7.Z) <= v8) then
            return false
        end

        if p4 then
            return p4
        end

        return math.abs(v7.Y) < 7
    end

    return false
end

local function showGain() -- line: 52
    -- upvalues: Format (copy), Hud (copy), n1 (ref), v4 (copy)
    if n1 > 0 then
        Hud.worldPopup(("+%* XP"):format((Format.short(n1))), v4)
        n1 = 0
    end
end

local function repSounds() -- line: 60
    -- upvalues: Format (copy), Hud (copy), UIUtil (copy), Poses (copy), MiniGames (copy), LocalPlayer (copy), v3 (ref), n1 (ref), v4 (copy)
    local Character = LocalPlayer.Character
    local v9 = false
    local v10 = false
    local v11 = false
    local v12 = false
    local v13 = false
    local v14 = false

    if Character then
        v9 = true
    else
        v14 = true
    end

    if v9 then
        if Character:GetAttribute("Lifting") then
            v10 = true
        else
            v14 = true
        end
    end

    v9 = false

    local v15

    if v10 then
        v15 = Poses.liftPhase()

        if v3 then
            v9 = true
        else
            v14 = false
        end
    end

    v10 = false

    if v9 then
        if MiniGames.isOpen() then
            v14 = false
        else
            v10 = true
        end
    end

    v9 = false

    local LIFT_TOP

    if v10 then
        LIFT_TOP = Poses.LIFT_TOP

        if v3 <= v15 then
            v11 = true
        else
            v9 = true
        end
    end

    v10 = false

    local v16

    if v9 then
        if v3 < LIFT_TOP then
            v16 = true
            v12 = true
        else
            v10 = true
        end
    end

    v9 = false

    if v10 then
        if LIFT_TOP <= v15 then
            v13 = true
        else
            v9 = true
        end
    end

    v10 = false

    if v9 then
        v16 = false
        v12 = true
    end

    v9 = false

    if v13 then
        v16 = true
        v12 = true
    end

    v13 = false

    if v11 then
        if v3 < LIFT_TOP then
            v13 = true
        else
            v16 = false
            v12 = true
        end
    end

    v11 = false

    if v13 then
        if LIFT_TOP <= v15 then
            v9 = true
        else
            v11 = true
        end
    end

    v13 = false

    if v11 then
        v16 = false
        v12 = true
    end

    v11 = false

    if v9 then
        v16 = true
        v12 = true
    end

    v9 = false

    if v12 then
        if v16 then
            v9 = true
        else
            v11 = true
        end
    end

    v12 = false

    if v9 then
        UIUtil.sound("Pop", 0.7, 0.95 + math.random() * 0.1)
        UIUtil.sound("Rep", 0.25, 0.97 + math.random() * 0.06)

        if n1 > 0 then
            v12 = true
        else
            v11 = true
        end
    end

    v9 = false

    if v12 then
        Hud.worldPopup(("+%* XP"):format((Format.short(n1))), v4)
        n1 = 0
        v11 = true
    end

    v12 = false

    local LIFT_BOTTOM

    if v11 then
        LIFT_BOTTOM = Poses.LIFT_BOTTOM

        if v3 <= v15 then
            v9 = true
        else
            v12 = true
        end
    end

    v11 = false

    local v17

    if v12 then
        if v3 < LIFT_BOTTOM then
            v17 = true
            v13 = true
        else
            v11 = true
        end
    end

    v12 = false

    if v11 then
        if LIFT_BOTTOM <= v15 then
            v10 = true
        else
            v12 = true
        end
    end

    if v12 then
        v17 = false
        v13 = true
    end

    v12 = false

    if v10 then
        v17 = true
        v13 = true
    end

    v10 = false

    if v9 then
        if v3 < LIFT_BOTTOM then
            v10 = true
        else
            v17 = false
            v13 = true
        end
    end

    v9 = false

    if v10 then
        if LIFT_BOTTOM <= v15 then
            v12 = true
        else
            v9 = true
        end
    end

    if v9 then
        v17 = false
        v13 = true
    end

    if v12 then
        v17 = true
        v13 = true
    end

    v12 = false

    if v13 then
        if v17 then
            v12 = true
        else
            v14 = false
        end
    end

    if v12 then
        v14 = false
        UIUtil.sound("Clank", 0.25, 1.1)
    end

    v3 = if not v14 then v15 else nil
end

local self = setmetatable({}, {
    __mode = "k"
})

local function refreshStands() -- line: 87
    -- upvalues: Players (copy), Config (copy), self (copy)
    for _, v19 in Config.allPlots() do
        local LiftZone = v19:FindFirstChild("LiftZone")
        local Barbell = LiftZone and LiftZone:FindFirstChild("Barbell")

        if Barbell then
            local PlayerByUserId = Players:GetPlayerByUserId(v19:GetAttribute("OwnerUserId") or 0)
            local v20 = PlayerByUserId ~= nil and PlayerByUserId.Character ~= nil and PlayerByUserId.Character:GetAttribute("Lifting") == true

            if self[Barbell] == true ~= v20 then
                self[Barbell] = v20 or nil

                for _, descendant in Barbell:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = v20 and 1 or 0
                    end
                end
            end
        end
    end
end

local function stop() -- line: 106
    -- upvalues: Format (copy), Remotes (copy), Hud (copy), Backpack (copy), LevelBar (copy), Controls (copy), MiniGames (copy), v1 (ref), v3 (ref), n1 (ref), v4 (copy)
    if not v1 then
        return
    end

    v1 = nil
    v3 = nil

    if n1 > 0 then
        Hud.worldPopup(("+%* XP"):format((Format.short(n1))), v4)
        n1 = 0
    end

    Remotes.Lift:FireServer(false)
    Hud.hideExit()
    MiniGames.setAvailable(false)
    LevelBar.setVisible(false)
    Controls.unlock("Lift")
    Backpack.setVisible(true)
end

local function start(p5, p6) -- line: 122
    -- upvalues: Remotes (copy), Hud (copy), Backpack (copy), LevelBar (copy), Menus (copy), Controls (copy), MiniGames (copy), v1 (ref), v2 (ref), stop (copy)
    v1 = p5
    v2 = false

    local Center = p5.Center
    local v21 = Vector3.new(Center.Position.X, p6.Position.Y, Center.Position.Z)

    Backpack.setVisible(false)
    Menus.closeAll()
    Controls.lock("Lift", CFrame.lookAt(v21, v21 + Center.CFrame.LookVector), true)
    Remotes.Lift:FireServer(true)
    Hud.showExit(stop)
    MiniGames.setAvailable(true)
    LevelBar.setVisible(true)
end

function t1.isActive() -- line: 137
    -- upvalues: v1 (ref)
    return v1 ~= nil
end

function t1.repCount() -- line: 142
    -- upvalues: n2 (ref)
    return n2
end

function t1.setBusyCheck(p7) -- line: 146
    -- upvalues: v5 (ref)
    v5 = p7
end

function t1.init() -- line: 150
    -- upvalues: RunService (copy), Config (copy), Format (copy), Remotes (copy), Hud (copy), LocalPlayer (copy), v1 (ref), v2 (ref), n1 (ref), n2 (ref), v4 (copy), v5 (ref), inside (copy), repSounds (copy), refreshStands (copy), stop (copy), start (copy)
    Remotes.Rep.OnClientEvent:Connect(function(p8) -- line: 151
        -- upvalues: Format (copy), Hud (copy), v1 (ref), n1 (ref), n2 (ref), v4 (copy)
        n2 += 1
        n1 += p8

        if not v1 and n1 > 0 then
            Hud.worldPopup(("+%* XP"):format((Format.short(n1))), v4)
            n1 = 0
        end
    end)
    RunService.Heartbeat:Connect(function() -- line: 158
        -- upvalues: Config (copy), LocalPlayer (copy), v1 (ref), v2 (ref), v5 (ref), inside (copy), repSounds (copy), refreshStands (copy), stop (copy), start (copy)
        refreshStands()

        local Character = LocalPlayer.Character
        local v22 = Character

        if Character then
            v22 = Character:FindFirstChildOfClass("Humanoid")
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        local v23 = Character ~= nil and v22 ~= nil and v22.Health > 0

        if v1 then
            if v23 and v1.Parent and inside(v1, Character.Position, 2) then
                repSounds()
            else
                stop()
            end
        else
            local v24 = Config.plotOf(LocalPlayer.UserId, Config.playerWorld(LocalPlayer))
            local LiftZone = v24 and v24:FindFirstChild("LiftZone")

            if v23 and LiftZone then
                local CharacterPosition = Character.Position
                local Center = LiftZone:FindFirstChild("Center")

                if Center then
                    local v25 = Center.CFrame:PointToObjectSpace(CharacterPosition)
                    local v26 = (LiftZone:GetAttribute("Size") or 9) / 2 + 0

                    if math.abs(v25.X) <= v26 and math.abs(v25.Z) <= v26 then
                        if v2 and not v5() and (LocalPlayer:GetAttribute("BarbellTier") or 0) > 0 then
                            local CharacterPosition = Character.Position
                            local Center = LiftZone:FindFirstChild("Center")

                            if Center then
                                local v27 = Center.CFrame:PointToObjectSpace(CharacterPosition)
                                local v28 = (LiftZone:GetAttribute("Size") or 9) / 2 + 0

                                if math.abs(v27.X) <= v28 and math.abs(v27.Z) <= v28 and math.abs(v27.Y) < 7 then
                                    start(LiftZone, Character)
                                end
                            end
                        end

                        return
                    end
                end
            end

            v2 = true
        end
    end)
end

return t1
