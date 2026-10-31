-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local GroupService, Players = services.GroupService, services.Players
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local freeRewardGroupId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "free-rewards-utils").freeRewardGroupId
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 15
        return "FreeRewardsController"
    end
})

self.__index = self

function self.new(...) -- line: 20
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 24
    p1._reflexController = p2
end

self.promptToJoinGroup = RuntimeLib.async(function(p3) -- line: 27
    -- upvalues: GroupService (copy), freeRewardGroupId (copy)
    if GroupService:PromptJoinAsync(freeRewardGroupId) == Enum.GroupMembershipStatus.None then
        return false
    end

    p3._reflexController:getClientProducer().isInGroupUpdated({
        isInGroup = true
    })

    return true
end)

function self._checkIfPlayerIsInGroup(_) -- line: 40
    -- upvalues: Players (copy), freeRewardGroupId (copy)
    return Players.LocalPlayer:IsInGroupAsync(freeRewardGroupId)
end

self._updateIsInGroup = RuntimeLib.async(function(p5) -- line: 44
    -- upvalues: RuntimeLib (copy)
    local v5 = RuntimeLib.await(p5:_checkIfPlayerIsInGroup())

    p5._reflexController:getClientProducer().isInGroupUpdated({
        isInGroup = v5
    })
end)

function self.onStart(p6) -- line: 51
    -- upvalues: reflexStateToAtom (copy), selectCurrentWindow (copy), effect (copy)
    local v7 = reflexStateToAtom(p6._reflexController:getClientProducer(), selectCurrentWindow)[1]

    p6:_updateIsInGroup()
    effect(function() -- line: 56
        -- upvalues: p6 (copy), v7 (copy)
        if v7() == "freeReward" then
            p6:_updateIsInGroup()
        end
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/free-rewards-controller@FreeRewardsController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    FreeRewardsController = self
}
