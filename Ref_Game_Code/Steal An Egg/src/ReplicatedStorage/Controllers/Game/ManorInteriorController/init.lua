-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ambience = require(script.Ambience)
local Door = require(script.Door)
local LightingController = require(script.Parent.LightingController)
local Log = require(ReplicatedStorage.Packages.Log)
local ManorInterior = require(ReplicatedStorage.Shared.Util.ManorInterior)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Transition = require(script.Transition)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Unlock = require(script.Unlock)
local LocalPlayer = Players.LocalPlayer
local Markers = ManorInterior.Markers
local Inside = ManorInterior.Attributes.Inside
local Warning = Log.new():LimitUnderLevel("Warning")
local v1 = Trove.new()
local v2
local v3 = nil
local v4 = v1:Extend()
local n1 = 0
local v5 = false
local v6 = false
local n2 = 0
local v7 = false
local t1 = {}

local function isInside() -- line: 57
    -- upvalues: LocalPlayer (copy), Inside (copy)
    return LocalPlayer:GetAttribute(Inside) == true
end

local function lockControls(p1) -- line: 61
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")

    if PlayerModule ~= nil and PlayerModule:IsA("ModuleScript") then
        local _require = require
        local ok, result = pcall(_require, PlayerModule)

        if ok then
            local Controls = result:GetControls()

            if Controls then
                Controls:Disable()
                p1:Add(function() -- line: 74
                    -- upvalues: Controls (copy)
                    Controls:Enable()
                end)
            end
        end
    end
end

local function applyLighting(p2) -- line: 80
    -- upvalues: LightingController (copy), ManorInterior (copy), Warning (copy), v7 (ref)
    if LightingController.Presets[ManorInterior.LightingPreset] ~= nil then
        LightingController.SetLayer("ManorInterior", ManorInterior.LightingPreset, 200, 0)
    elseif not v7 then
        v7 = true
        Warning:AtWarning():Log("[ManorInterior] no ManorInterior lighting preset found")
    end

    p2:Add(function() -- line: 92
        -- upvalues: LightingController (copy)
        LightingController.ClearLayer("ManorInterior", 0)
    end)
end

local function enterInside() -- line: 97
    -- upvalues: Ambience (copy), v1 (copy), v2 (ref), applyLighting (copy)
    if v2 ~= nil then
        return
    end

    local v8 = v1:Extend()

    v2 = v8
    applyLighting(v8)
    Ambience.Start(v8)
end

local function leaveInside() -- line: 107
    -- upvalues: v2 (ref)
    local v9 = v2

    v2 = nil

    if v9 ~= nil then
        v9:Destroy()
    end
end

local function sync() -- line: 115
    -- upvalues: Ambience (copy), LocalPlayer (copy), Inside (copy), v1 (copy), v2 (ref), applyLighting (copy)
    if LocalPlayer:GetAttribute(Inside) == true then
        if v2 == nil then
            local v10 = v1:Extend()

            v2 = v10
            applyLighting(v10)
            Ambience.Start(v10)
        end
    else
        local v11 = v2

        v2 = nil

        if v11 ~= nil then
            v11:Destroy()
        end
    end
end

local function markerFrame(p3) -- line: 123
    -- upvalues: ManorInterior (copy)
    local v12 = ManorInterior.Marker(p3)

    return if v12 ~= nil then v12.CFrame else nil
end

local function fallbackFrame() -- line: 128
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v13 = Player.FindRootPart(LocalPlayer)

    if v13 == nil then
        return CFrame.identity
    end

    return v13.CFrame
end

local function buildContext(p4, p5) -- line: 133
    -- upvalues: ManorInterior (copy), Player (copy), LocalPlayer (copy), Markers (copy)
    local Doors = p4.Doors

    if typeof(Doors) ~= "Instance" or not Doors:IsA("Model") then
        Doors = ManorInterior.Doors()
    end

    local Spawn = p4.Spawn
    local v14

    if typeof(Spawn) == "CFrame" then
        v14 = p4.Spawn
    else
        local Spawn = Markers.Spawn
        local v15 = ManorInterior.Marker(Spawn)

        if v15 ~= nil then
            v14 = v15.CFrame
        end

        if not v14 then
            local v16 = Player.FindRootPart(LocalPlayer)

            v14 = if v16 ~= nil then v16.CFrame else CFrame.identity
        end
    end

    local DoorInside = p4.DoorInside
    local v17

    if typeof(DoorInside) == "CFrame" then
        v17 = p4.DoorInside
    else
        local DoorInside = Markers.DoorInside
        local v18 = ManorInterior.Marker(DoorInside)

        v17 = (if v18 == nil then nil else v18.CFrame) or v14
    end

    local DoorOutside = p4.DoorOutside
    local v19

    if typeof(DoorOutside) == "CFrame" then
        v19 = p4.DoorOutside
    elseif Doors ~= nil then
        v19 = ManorInterior.DoorOutside(Doors)
    else
        local v20 = Player.FindRootPart(LocalPlayer)

        v19 = if v20 ~= nil then v20.CFrame else CFrame.identity
    end

    local Interior, Destination = p4.Interior, p4.Destination

    return {
        Doors = Doors,
        DoorOutside = v19,
        DoorInside = v17,
        Spawn = v14,
        Destination = if typeof(Destination) ~= "CFrame" then nil else Destination,
        Interior = if typeof(Interior) ~= "Instance" or not Interior:IsA("Model") then ManorInterior.Interior() else Interior,
        Arrive = p5
    }
end

local function invoke(p6, p7) -- line: 163
    -- upvalues: n1 (ref)
    if n1 ~= p7 then
        return false
    end

    local function v21() -- line: 167
        -- upvalues: p6 (copy), p7 (copy)
        return p6:InvokeServer(p7)
    end

    local ok, result = pcall(v21)

    if ok then
        ok = result == true and n1 == p7
    end

    return ok
end

local function playUnlock(p8) -- line: 173
    -- upvalues: Door (copy), ManorInterior (copy), Unlock (copy), LocalPlayer (copy), Warning (copy)
    local v22 = p8:FindFirstChild(ManorInterior.LockName)

    Door.MarkOpen()

    local Play = Unlock.Play
    local t3 = {
        Doors = p8,
        Lock = if v22 == nil or not v22:IsA("Model") then nil else v22,
        Character = LocalPlayer.Character,
        Key = Door.TakeKey()
    }
    local ok, result = pcall(Play, t3)

    if ok then
        return
    end

    Warning:AtWarning():Log((("[ManorInterior] unlock animation failed: %*"):format(result)))

    local SetOpen = Unlock.SetOpen
    local t4 = {
        Key = nil,
        Doors = p8,
        Lock = if v22 == nil then nil elseif v22:IsA("Model") then v22 else nil,
        Character = LocalPlayer.Character
    }

    pcall(SetOpen, t4, true)
end

local function unlockDoors(p9) -- line: 193
    -- upvalues: Door (copy), v1 (copy), lockControls (copy), playUnlock (copy)
    local v23 = v1:Extend()

    Door.SetBusy(true)
    v23:Add(function() -- line: 196
        -- upvalues: Door (copy)
        Door.SetBusy(false)
    end)
    lockControls(v23)
    playUnlock(p9)
    v23:Destroy()
end

local function travel(p10, p11, p12) -- line: 204
    -- upvalues: Door (copy), MusicDirector (copy), Remotes (copy), Transition (copy), Warning (copy), v1 (copy), v3 (ref), n1 (ref), lockControls (copy), buildContext (copy)
    local v24 = v3

    if v24 ~= nil then
        v24:Destroy()
    end

    local v25 = v1:Extend()

    v3 = v25
    n1 = p11
    Door.SetBusy(true)
    v25:Add(function() -- line: 213
        -- upvalues: Door (copy)
        Door.SetBusy(false)
    end)
    lockControls(v25)

    if p10 == "Enter" then
        v25:Add(MusicDirector.Suppress())
    end

    local v26 = if typeof(p12) == "table" then p12 else {}
    local v27 = if p10 == "Enter" then Remotes.ManorInterior.Arrive else Remotes.ManorInterior.Leave
    local v28 = buildContext(v26, function() -- line: 224
        -- upvalues: p11 (copy), v27 (copy), n1 (ref)
        if n1 ~= p11 then
            return false
        end

        local function v29() -- line: 167
            -- upvalues: p11 (copy), v27 (copy)
            return v27:InvokeServer(p11)
        end

        local ok, result = pcall(v29)

        if ok then
            ok = result == true and n1 == p11
        end

        return ok
    end)

    task.spawn(function() -- line: 227
        -- upvalues: p10 (copy), v25 (copy), v28 (copy), Transition (copy), Warning (copy), v3 (ref)
        local function v30() -- line: 228
            -- upvalues: p10 (copy), v28 (copy), Transition (copy)
            if p10 == "Enter" then
                Transition.Enter(v28)
            else
                Transition.Exit(v28)
            end
        end

        local ok, result = pcall(v30)

        if not ok then
            Warning:AtWarning():Log((("[ManorInterior] %* transition failed: %*"):format(p10, result)))
            Transition.Abort()
        end

        if v3 == v25 then
            v3 = nil
            v25:Destroy()
        end
    end)
end

local function coverRespawn() -- line: 259
    -- upvalues: ManorInterior (copy), Player (copy), Transition (copy), LocalPlayer (copy), Markers (copy), Inside (copy), v4 (copy)
    if LocalPlayer:GetAttribute(Inside) ~= true then
        return
    end

    v4:Clean()
    Transition.Cover()

    local elapsed = os.clock()

    v4:Add(task.spawn(function() -- line: 266
        -- upvalues: elapsed (copy), ManorInterior (copy), Player (copy), Transition (copy), LocalPlayer (copy), Markers (copy), Inside (copy)
        while true do
            if os.clock() - elapsed < 20 then
                task.wait(0.1)

                if LocalPlayer:GetAttribute(Inside) == true then
                    local v31 = ManorInterior.Marker(Markers.Spawn)
                    local v32 = Player.FindRootPart(LocalPlayer)
                    local v33 = Player.FindHumanoid(LocalPlayer)

                    if v31 ~= nil and v32 ~= nil and v33 ~= nil and v33.Health > 0 and (v32.Position - v31.Position).Magnitude <= 30 then
                        task.wait(0.2)
                        break
                    end

                    continue
                end
            end

            break
        end

        Transition.Reveal()
    end))
end

local function requestExit() -- line: 290
    -- upvalues: Remotes (copy), v6 (ref), n2 (ref)
    local function v34() -- line: 291
        -- upvalues: Remotes (copy)
        Remotes.ManorInterior.Request:InvokeServer()
    end

    pcall(v34)
    n2 = os.clock() + 0.6
    v6 = false
end

local function watchExit() -- line: 298
    -- upvalues: ManorInterior (copy), Player (copy), LocalPlayer (copy), Markers (copy), Inside (copy), v3 (ref), v6 (ref), n2 (ref), requestExit (copy)
    if LocalPlayer:GetAttribute(Inside) == true and v3 == nil and not v6 and not (os.clock() < n2) then
        local v35 = ManorInterior.Marker(Markers.Exit)
        local v36 = Player.FindRootPart(LocalPlayer)
        local v37 = Player.FindHumanoid(LocalPlayer)

        if v35 ~= nil and v36 ~= nil and v37 ~= nil and not (v37.Health <= 0) and ManorInterior.Within(v35, v36.Position, 0.5) then
            v6 = true
            task.spawn(requestExit)
        end
    end
end

function t1.Start() -- line: 318
    -- upvalues: RunService (copy), Ambience (copy), Door (copy), Remotes (copy), Transition (copy), LocalPlayer (copy), Inside (copy), v1 (copy), v2 (ref), v3 (ref), n1 (ref), v5 (ref), applyLighting (copy), sync (copy), unlockDoors (copy), travel (copy), coverRespawn (copy), watchExit (copy)
    if v5 then
        return
    end

    v5 = true
    v1:Connect(Remotes.ManorInterior.Travel.OnClientEvent, function(p13, p14, p15) -- line: 325
        -- upvalues: Transition (copy), v3 (ref), n1 (ref), travel (copy)
        if p13 == "Cancel" then
            if p14 ~= n1 then
                return
            end

            n1 = 0
            Transition.Abort()

            local v38 = v3

            v3 = nil

            if v38 ~= nil then
                v38:Destroy()
            end
        elseif (p13 == "Enter" or p13 == "Exit") and type(p14) == "number" then
            travel(p13, p14, p15)
        end
    end)
    v1:Connect(LocalPlayer:GetAttributeChangedSignal(Inside), sync)
    v1:Connect(LocalPlayer.CharacterRemoving, coverRespawn)
    Door.Start(v1, unlockDoors)

    local n3 = 0

    v1:Connect(RunService.Heartbeat, function(p16) -- line: 337
        -- upvalues: n3 (ref), watchExit (copy)
        n3 += p16

        if not (n3 < 0.05) then
            n3 = 0
            watchExit()
        end
    end)

    if LocalPlayer:GetAttribute(Inside) == true then
        if v2 == nil then
            local v39 = v1:Extend()

            v2 = v39
            applyLighting(v39)
            Ambience.Start(v39)
        end
    else
        local v40 = v2

        v2 = nil

        if v40 ~= nil then
            v40:Destroy()
        end
    end
end

return t1
