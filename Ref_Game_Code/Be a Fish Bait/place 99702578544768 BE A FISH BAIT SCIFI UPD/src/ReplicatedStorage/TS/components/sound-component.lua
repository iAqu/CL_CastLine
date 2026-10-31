-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local t1 = {
    "ButtonClick",
    "ButtonHover",
    "Mining",
    "Mined",
    "Crumble",
    "MoneyPickup",
    "MoneyPickup2",
    "PhysicalButtonClick",
    "Lobby",
    "Lobby1",
    "Lobby2",
    "GemObtained1",
    "GemObtained2",
    "PlaceGem",
    "RemoveGem",
    "OreLevelUp",
    "LavaBucketLevelUp",
    "PourLava1",
    "PourLava2",
    "Abyss",
    "Fahhh",
    "WowAnime",
    "BonusUpgrade",
    "FishSwimWaterSound",
    "ZoneChange",
    "DivingIntoWater",
    "WaterSkip",
    "ComboTierSFX1",
    "ComboTierSFX2",
    "ComboFailSFX",
    "PurchaseSuccess",
    "LandingImpact",
    "JackpotLandingImpact",
    "FallingSound",
    "Heartbeat",
    "3-2-1Countdown",
    "FishNibble",
    "WindSFX",
    "LifeInAnElevator",
    "EventIslandMusic",
    "CastComplete",
    "AuraFarm",
    "WLSScream",
    "BarbellSound",
    "PopSound",
    "CrateTapSound",
    "CuteLevelUp",
    "ButtonSuccess",
    "Rebirth",
    "FrenzyMusic",
    "TickSound",
    "HeavyMetalSound",
    "ThockyKeyboard",
    "LeavingNotif",
    "OpenExclusiveShop",
    "PartyPopper",
    "PartyBlower",
    "RiftPortalEnter",
    "RareFishEncounter",
    "FrostwyrmMinigame",
    "Slap",
    "KeycapSound",
    "FishTakeoutSound",
    "FishingRodTakeoutSound",
    "WeightTakeoutSound"
}
local v1 = table.create(#t1)

local function v2(p1) -- line: 12
    -- upvalues: t (copy)
    return t.literal(p1)
end

for v3, v4 in t1 do
    local _ = v3 - 1

    v1[v3] = t.literal(v4)
end

local v5 = t.union(unpack(v1))
local v6 = t.interface({})
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 25
        return "SoundComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.constructor(p2, ...) -- line: 31
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p2, ...)
end

function self.onStart(p3) -- line: 34
    p3.soundGroup = p3:_validateIsInSoundGroup()
    p3.instance.SoundGroup = p3.soundGroup
    p3.instance.Playing = false
end

function self._validateIsInSoundGroup(p4) -- line: 39
    -- upvalues: ReplicatedStorage (copy)
    local instanceParent = p4.instance.Parent

    while true do
        if instanceParent then
            if instanceParent == ReplicatedStorage then
                error("[src/shared/components/sound-component.ts:108]" .. ("%* Sound %* is not in a SoundGroup."):format(p4:_getDebugPrefix(), (p4.instance:GetFullName())))

                return
            end

            if not (instanceParent:HasTag("SoundGroup") and instanceParent:IsA("SoundGroup")) then
                instanceParent = instanceParent.Parent
                continue
            end

            break
        end

        error("[src/shared/components/sound-component.ts:108]" .. ("%* Sound %* is not in a SoundGroup."):format(p4:_getDebugPrefix(), (p4.instance:GetFullName())))

        return
    end

    return instanceParent
end

function self._getDebugPrefix(p5) -- line: 49
    return (("SoundComponent %*:"):format((p5.instance:GetFullName())))
end

Reflect.defineMetadata(self, "identifier", "shared/components/sound-component@SoundComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "Sound",
        ancestorWhitelist = { ReplicatedStorage },
        attributes = {},
        instanceGuard = t.instanceIsA("Sound")
    }
})

return {
    soundNames = t1,
    soundNameGuard = v5,
    soundAttributesGuard = v6,
    SoundComponent = self
}
