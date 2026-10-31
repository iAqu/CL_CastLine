-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local AvatarEditorService, GroupService, Players = services.AvatarEditorService, services.GroupService, services.Players
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectCurrentWindow = RuntimeLib.import(script, script.Parent.Parent, "reflex", "slices", "selectors", "current-window.selectors").selectCurrentWindow
local effect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").effect
local communityRewardGroupId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "community-rewards-utils").communityRewardGroupId
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 17
        return "CommunityRewardsController"
    end
})

self.__index = self

function self.new(...) -- line: 22
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 26
    p1._reflexController = p2
end

function self.promptToFavoriteGame(_) -- line: 29
    -- upvalues: AvatarEditorService (copy)
    AvatarEditorService:PromptSetFavorite(99702578544768, Enum.AvatarItemType.Asset, true)
end

self.promptToJoinCommunity = RuntimeLib.async(function(p4) -- line: 34
    -- upvalues: GroupService (copy), communityRewardGroupId (copy)
    local v4 = GroupService:PromptJoinAsync(communityRewardGroupId) ~= Enum.GroupMembershipStatus.None

    p4._reflexController:getClientProducer().communityGroupMembershipUpdated({
        isInCommunityGroup = v4
    })

    return v4
end)

function self._checkIfPlayerIsInGroup(_) -- line: 43
    -- upvalues: Players (copy), communityRewardGroupId (copy)
    return Players.LocalPlayer:IsInGroupAsync(communityRewardGroupId)
end

self._updateGroupMembership = RuntimeLib.async(function(p6) -- line: 46
    -- upvalues: RuntimeLib (copy)
    local v6 = RuntimeLib.await(p6:_checkIfPlayerIsInGroup())

    p6._reflexController:getClientProducer().communityGroupMembershipUpdated({
        isInCommunityGroup = v6
    })
end)

function self.onStart(p7) -- line: 53
    -- upvalues: reflexStateToAtom (copy), selectCurrentWindow (copy), effect (copy), events (copy)
    local v7 = p7._reflexController:getClientProducer()
    local v8 = reflexStateToAtom(v7, selectCurrentWindow)[1]

    p7:_updateGroupMembership()
    effect(function() -- line: 58
        -- upvalues: p7 (copy), v8 (copy)
        if v8() == "communityReward" then
            p7:_updateGroupMembership()
        end
    end)
    events.openCommunityRewardWindow:connect(function() -- line: 64
        -- upvalues: v7 (copy)
        v7.windowOpened({
            currentWindow = "communityReward"
        })
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/community-rewards-controller@CommunityRewardsController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    CommunityRewardsController = self
}
