-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local reflexStateToAtom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "reflex-utils").reflexStateToAtom
local selectEquippedInventoryItem = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectEquippedInventoryItem
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local t1 = {
    fishingRod = "FishingRodTakeoutSound",
    trainingWeight = "WeightTakeoutSound",
    fish = "FishTakeoutSound"
}
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 17
        return "ItemEquipSoundController"
    end
})

self.__index = self

function self.new(...) -- line: 22
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 26
    p1._reflexController = p2
    p1._soundController = p3
end

function self.onInit(p4) -- line: 30
    -- upvalues: subscribe (copy), reflexStateToAtom (copy), selectEquippedInventoryItem (copy), localPlayerUserId (copy), t1 (copy)
    subscribe(reflexStateToAtom(p4._reflexController:getClientProducer(), selectEquippedInventoryItem(localPlayerUserId))[1], function(p5, p6) -- line: 33
        -- upvalues: p4 (copy), t1 (copy)
        local v4 = p5 == nil

        if not v4 then
            v4 = p5.itemId == (if p6 == nil then p6 else p6.itemId)
        end

        if v4 then
            return nil
        end

        local v5 = t1[p5.itemType]

        if v5 ~= nil then
            p4._soundController:playSound(v5)
        end
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/item-equip-sound-controller@ItemEquipSoundController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController", "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ItemEquipSoundController = self
}
