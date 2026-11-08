-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ambience = require(script.Ambience)
local LightingController = require(script.Parent.LightingController)
local Log = require(ReplicatedStorage.Packages.Log)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local SewerCave = require(ReplicatedStorage.Shared.Util.SewerCave)
local Transition = require(script.Transition)
local Trove = require(ReplicatedStorage.Packages.Trove)
local Worker = require(script.Worker)
local LocalPlayer = Players.LocalPlayer
local Markers = SewerCave.Markers
local Inside = SewerCave.Attributes.Inside
local Warning = Log.new():LimitUnderLevel("Warning")
local v1
local v2 = nil
local v3 = Trove.new()
local n1 = 0
local v4 = false
local v5 = false
local t1 = {}

local function isInside() -- line: 49
    -- upvalues: LocalPlayer (copy), Inside (copy)
    return LocalPlayer:GetAttribute(Inside) == true
end

local function lockControls(p1) -- line: 53
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
                p1:Add(function() -- line: 66
                    -- upvalues: Controls (copy)
                    Controls:Enable()
                end)
            end
        end
    end
end

local function applyLighting(p2) -- line: 72
    -- upvalues: LightingController (copy), SewerCave (copy), Warning (copy), v5 (ref)
    if LightingController.Presets[SewerCave.LightingPreset] ~= nil then
        LightingController.SetLayer("SewerCave", SewerCave.LightingPreset, 200, 0)
    else
        local v6 = SewerCave.Cave()
        local v7 = v6 and v6:FindFirstChild(SewerCave.LightingPresetName)

        if v7 ~= nil then
            LightingController.SetAuthoredLayer("SewerCave", v7, 200, 0)
        elseif not v5 then
            v5 = true
            Warning:AtWarning():Log("[SewerCave] no SewerCave lighting preset found")
        end
    end

    p2:Add(function() -- line: 95
        -- upvalues: LightingController (copy)
        LightingController.ClearLayer("SewerCave", 0)
    end)
end

local function enterInside() -- line: 100
    -- upvalues: Ambience (copy), MusicDirector (copy), Trove (copy), Worker (copy), v1 (ref), applyLighting (copy)
    if v1 ~= nil then
        return
    end

    local v8 = Trove.new()

    v1 = v8
    applyLighting(v8)
    v8:Add(MusicDirector.Suppress())
    Ambience.Start(v8)
    task.spawn(Worker.Start, v8)
end

local function leaveInside() -- line: 112
    -- upvalues: v1 (ref)
    local v9 = v1

    v1 = nil

    if v9 ~= nil then
        v9:Destroy()
    end
end

local function sync() -- line: 120
    -- upvalues: LocalPlayer (copy), Inside (copy), v1 (ref), enterInside (copy)
    if LocalPlayer:GetAttribute(Inside) == true then
        enterInside()
    else
        local v10 = v1

        v1 = nil

        if v10 ~= nil then
            v10:Destroy()
        end
    end
end

local function markerFrame(p3) -- line: 128
    -- upvalues: SewerCave (copy)
    local v11 = SewerCave.Marker(p3)

    return if v11 ~= nil then v11.CFrame else nil
end

local function fallbackFrame() -- line: 133
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v12 = Player.FindRootPart(LocalPlayer)

    if v12 == nil then
        return CFrame.identity
    end

    return v12.CFrame
end

local function buildContext(p4, p5) -- line: 138
    -- upvalues: Player (copy), SewerCave (copy), LocalPlayer (copy), Markers (copy)
    local v13 = if typeof(p4) == "table" then p4 else {}
    local Spawn = v13.Spawn
    local v14

    if typeof(Spawn) == "CFrame" then
        v14 = v13.Spawn
    else
        local Spawn = Markers.Spawn
        local v15 = SewerCave.Marker(Spawn)

        if v15 ~= nil then
            v14 = v15.CFrame
        end

        if not v14 then
            local v16 = Player.FindRootPart(LocalPlayer)

            v14 = if v16 ~= nil then v16.CFrame else CFrame.identity
        end
    end

    local Surface = v13.Surface
    local v17

    if typeof(Surface) == "CFrame" then
        v17 = v13.Surface
    else
        local Surface = Markers.Surface
        local v18 = SewerCave.Marker(Surface)

        v17 = (if v18 == nil then nil else v18.CFrame) or v14
    end

    local Whirlpool, Pipe, Destination = v13.Whirlpool, v13.Pipe, v13.Destination

    if typeof(Whirlpool) ~= "Instance" or not Whirlpool:IsA("Model") then
        Whirlpool = nil
    end

    return {
        Whirlpool = Whirlpool,
        Spawn = v14,
        Surface = v17,
        Pipe = if typeof(Pipe) ~= "Instance" or not Pipe:IsA("BasePart") then nil else Pipe,
        Destination = if typeof(Destination) ~= "CFrame" then nil else Destination,
        Arrive = p5
    }
end

local function invoke(p6, p7) -- line: 161
    -- upvalues: n1 (ref)
    if n1 ~= p7 then
        return false
    end

    local function v19() -- line: 165
        -- upvalues: p6 (copy), p7 (copy)
        return p6:InvokeServer(p7)
    end

    local ok, result = pcall(v19)

    if ok then
        ok = result == true and n1 == p7
    end

    return ok
end

local function travel(p8, p9, p10) -- line: 171
    -- upvalues: MusicDirector (copy), Remotes (copy), Transition (copy), Trove (copy), Warning (copy), v2 (ref), n1 (ref), lockControls (copy), buildContext (copy)
    local v20 = v2

    if v20 ~= nil then
        v20:Destroy()
    end

    local v21 = Trove.new()

    v2 = v21
    n1 = p9
    lockControls(v21)

    if p8 == "Enter" then
        v21:Add(MusicDirector.Suppress())
    end

    local v22 = if p8 == "Enter" then Remotes.SewerCave.Arrive else Remotes.SewerCave.Leave
    local v23 = buildContext(p10, function() -- line: 184
        -- upvalues: p9 (copy), v22 (copy), n1 (ref)
        if n1 ~= p9 then
            return false
        end

        local function v24() -- line: 165
            -- upvalues: p9 (copy), v22 (copy)
            return v22:InvokeServer(p9)
        end

        local ok, result = pcall(v24)

        if ok then
            ok = result == true and n1 == p9
        end

        return ok
    end)

    task.spawn(function() -- line: 187
        -- upvalues: p8 (copy), v21 (copy), v23 (copy), Transition (copy), Warning (copy), v2 (ref)
        local function v25() -- line: 188
            -- upvalues: p8 (copy), v23 (copy), Transition (copy)
            if p8 == "Enter" then
                Transition.Enter(v23)
            else
                Transition.Exit(v23)
            end
        end

        local ok, result = pcall(v25)

        if not ok then
            Warning:AtWarning():Log((("[SewerCave] %* transition failed: %*"):format(p8, result)))
            Transition.Abort()
        end

        if v2 == v21 then
            v2 = nil
            v21:Destroy()
        end
    end)
end

local function coverRespawn() -- line: 219
    -- upvalues: Player (copy), SewerCave (copy), Transition (copy), LocalPlayer (copy), Markers (copy), Inside (copy), v3 (copy)
    if LocalPlayer:GetAttribute(Inside) ~= true then
        return
    end

    v3:Clean()
    Transition.Cover()

    local elapsed = os.clock()

    v3:Add(task.spawn(function() -- line: 226
        -- upvalues: elapsed (copy), Player (copy), SewerCave (copy), Transition (copy), LocalPlayer (copy), Markers (copy), Inside (copy)
        while true do
            if os.clock() - elapsed < 20 then
                task.wait(0.1)

                if LocalPlayer:GetAttribute(Inside) == true then
                    local v26 = SewerCave.Marker(Markers.Spawn)
                    local v27 = Player.FindRootPart(LocalPlayer)
                    local v28 = Player.FindHumanoid(LocalPlayer)

                    if v26 ~= nil and v27 ~= nil and v28 ~= nil and v28.Health > 0 and (v27.Position - v26.Position).Magnitude <= 30 then
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

function t1.Start() -- line: 254
    -- upvalues: Remotes (copy), Transition (copy), LocalPlayer (copy), Inside (copy), v1 (ref), v2 (ref), n1 (ref), v4 (ref), enterInside (copy), sync (copy), travel (copy), coverRespawn (copy)
    if v4 then
        return
    end

    v4 = true
    Remotes.SewerCave.Travel.OnClientEvent:Connect(function(p11, p12, p13) -- line: 260
        -- upvalues: Transition (copy), v2 (ref), n1 (ref), travel (copy)
        if p11 == "Cancel" then
            if p12 ~= n1 then
                return
            end

            n1 = 0
            Transition.Abort()

            local v29 = v2

            v2 = nil

            if v29 ~= nil then
                v29:Destroy()
            end
        elseif (p11 == "Enter" or p11 == "Exit") and type(p12) == "number" then
            travel(p11, p12, p13)
        end
    end)
    LocalPlayer:GetAttributeChangedSignal(Inside):Connect(sync)
    LocalPlayer.CharacterRemoving:Connect(coverRespawn)

    if LocalPlayer:GetAttribute(Inside) == true then
        enterInside()
    else
        local v30 = v1

        v1 = nil

        if v30 ~= nil then
            v30:Destroy()
        end
    end
end

return t1
