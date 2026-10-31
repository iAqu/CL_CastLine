-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "centurion", "out")
local Register, Command, CenturionType = out.Register, out.Command, out.CenturionType
local loggerMiddleware = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "reflex", "src").loggerMiddleware
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Players = services.HttpService, services.Players
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local defaultPeakBias = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils").defaultPeakBias
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local animations = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "animation-utils").animations
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 19
        return "DebugCommands"
    end
})
local v2 = self

self.__index = self

local function new(...) -- line: 24
    -- upvalues: v2 (ref)
    local self = setmetatable({}, v2)

    return self:constructor(...) or self
end

local v5 = v2

v5.new = new

function v5.constructor(_) -- line: 28
end

v5.logReflexActions = RuntimeLib.async(function(_, _) -- line: 30
    -- upvalues: loggerMiddleware (copy), clientProducer (copy)
    clientProducer:applyMiddleware(loggerMiddleware)
end)
v5.printClientState = RuntimeLib.async(function(_, _, p6) -- line: 33
    -- upvalues: HttpService (copy), clientProducer (copy)
    local v6 = clientProducer:getState()[p6]

    print(HttpService:JSONEncode(v6))
end)
v5.playAnimation = RuntimeLib.async(function(_, _, p9, p10, p11) -- line: 38
    -- upvalues: Flamework (copy), animations (copy)
    local v7 = animations[p9]

    if v7 == nil then
        v7 = p9
    end

    Flamework.resolveDependency("client/controllers/custom-animation-controller@CustomAnimationController"):playAnimation(v7, {
        pauseAtLastFrame = p10,
        looped = p11
    }):andThen(function(p12) -- line: 47
        local v8 = if p12 == nil then p12 else p12.Length

        print("[src/client/centurion-commands/debug-commands.ts:85] track?.Length =", v8)
    end)
end)
v5.stopAllAnimations = RuntimeLib.async(function(_, _) -- line: 55
    -- upvalues: Flamework (copy)
    Flamework.resolveDependency("client/controllers/custom-animation-controller@CustomAnimationController"):stopAllAnimations()
end)
v5.forceAfkTeleportClient = RuntimeLib.async(function(_, _) -- line: 59
    -- upvalues: events (copy)
    events.requestAfkTeleport:fire()
end)

function v5.castHook(_, p18) -- line: 62
    -- upvalues: Players (copy), events (copy), defaultPeakBias (copy)
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not Character then
        return p18:error("No character")
    end

    events.castFishingHook:fire({
        skillCheckStrength = 100,
        direction = Character.CFrame.LookVector,
        peakBias = defaultPeakBias,
        startPosition = Character.Position
    })
    p18:reply("Cast hook")
end

function v5.stopFishing(_, p20) -- line: 80
    -- upvalues: events (copy)
    events.stopFishing:fire()
    p20:reply("Stopped fishing")
end

function v5.debugUnstreamCaughtFish(_, p22, p23) -- line: 84
    -- upvalues: Flamework (copy)
    Flamework.resolveDependency("client/controllers/fishing-rod-controller@FishingRodController"):setDebugUnstreamCaughtFish(p23)
    p22:reply((("Caught-fish unstream repro %*"):format(p23 and "ENABLED" or "disabled")))
end

function v5.openFishDisplay(_, p25) -- line: 89
    -- upvalues: clientProducer (copy)
    clientProducer.windowOpened({
        currentWindow = "fishDisplayMenu"
    })
    p25:reply("Opened fish display menu")
end

local v9 = Command({
    name = "log_client",
    description = "Log all reflex actions"
})(v2, "logReflexActions", {
    value = v2.logReflexActions
})

if v9 then
    local value = v9.value

    v2.logReflexActions = value
end

local v10 = Command({
    name = "print_client_state",
    description = "Print all client state",
    arguments = {
        {
            name = "key",
            description = "The key to print",
            type = CenturionType.String
        }
    }
})(v2, "printClientState", {
    value = v2.printClientState
})

if v10 then
    local value = v10.value

    v2.printClientState = value
end

local v11 = Command({
    name = "play_animation",
    description = "Play an animation by ID",
    arguments = {
        {
            name = "Animation ID",
            description = "The ID of the animation to play",
            type = CenturionType.String
        },
        {
            name = "Pause At Last Frame",
            description = "Whether to pause the animation at the last frame",
            optional = true,
            type = CenturionType.Boolean
        },
        {
            name = "Looped",
            description = "Whether to loop the animation",
            optional = true,
            type = CenturionType.Boolean
        }
    }
})(v2, "playAnimation", {
    value = v2.playAnimation
})

if v11 then
    local value = v11.value

    v2.playAnimation = value
end

local v12 = Command({
    name = "stop_all_animations",
    description = "Stop all animations"
})(v2, "stopAllAnimations", {
    value = v2.stopAllAnimations
})

if v12 then
    local value = v12.value

    v2.stopAllAnimations = value
end

local v13 = Command({
    name = "forceAfkTeleportClient",
    description = "Force a AFK teleport on the client"
})(v2, "forceAfkTeleportClient", {
    value = v2.forceAfkTeleportClient
})

if v13 then
    local value = v13.value

    v2.forceAfkTeleportClient = value
end

local v14 = Command({
    name = "cast_hook",
    description = "Cast fishing hook (dev)"
})(v2, "castHook", {
    value = v2.castHook
})

if v14 then
    local value = v14.value

    v2.castHook = value
end

local v15 = Command({
    name = "stop_fishing",
    description = "Stop fishing (dev)"
})(v2, "stopFishing", {
    value = v2.stopFishing
})

if v15 then
    local value = v15.value

    v2.stopFishing = value
end

local v16 = Command({
    name = "debug_unstream_caught_fish",
    description = "Repro: forcefully unstream (destroy locally) the caught fish model on every catch, so the reward lookup misses it — reproduces the reeled-nothing / stuck-underwater bug",
    arguments = {
        {
            name = "enabled",
            description = "Whether to unstream the caught fish model on every catch",
            type = CenturionType.Boolean
        }
    }
})(v2, "debugUnstreamCaughtFish", {
    value = v2.debugUnstreamCaughtFish
})

if v16 then
    local value = v16.value

    v2.debugUnstreamCaughtFish = value
end

local v17 = Command({
    name = "open_fish_display",
    description = "Open the fish display menu (dev) — no in-game trigger exists for it yet"
})(v2, "openFishDisplay", {
    value = v2.openFishDisplay
})

if v17 then
    local value = v17.value

    v2.openFishDisplay = value
end

v2 = Register()(v2) or v5

return {
    DebugCommands = v2
}
