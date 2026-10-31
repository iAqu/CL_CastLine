-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local isInVipTrainingAreaAtom = RuntimeLib.import(script, script.Parent.Parent, "vip-training-atom").isInVipTrainingAreaAtom
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 11
        return "VipTrainingAreaController"
    end
})

self.__index = self

function self.new(...) -- line: 16
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 20
    p1._components = p2
    p1._timeLastChecked = 0
end

function self.onTick(p3) -- line: 24
    -- upvalues: isInVipTrainingAreaAtom (copy)
    if os.clock() - p3._timeLastChecked < 0.2 then
        return nil
    end

    p3._timeLastChecked = os.clock()

    local v3 = p3._components:getAllComponents("client/components/vip-only-part-component@VipOnlyPartComponent")

    local function v4(p4) -- line: 33
        return p4:isPlayerInside()
    end

    local v5 = false

    for v6, v7 in v3 do
        local _ = v6 - 1

        if v7:isPlayerInside() then
            v5 = true
            break
        end
    end

    if v5 == p3._lastIsInside then
        return nil
    end

    p3._lastIsInside = v5
    isInVipTrainingAreaAtom(v5)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/vip-training-area-controller@VipTrainingAreaController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    VipTrainingAreaController = self
}
