-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, Players = services.CollectionService, services.Players
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 15
        return "AquariumLodController"
    end
})

self.__index = self

function self.new(...) -- line: 20
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 24
    p1._components = p2
    p1._nextCheckAt = 0
end

function self.onTick(p3, _) -- line: 28
    if os.clock() < p3._nextCheckAt then
        return nil
    end

    p3._nextCheckAt = os.clock() + 0.5
    p3:_updateLod()
end

function self._updateLod(p5) -- line: 35
    -- upvalues: CollectionService (copy), Players (copy)
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not Character then
        return nil
    end

    local CharacterPosition = Character.Position
    local t4 = {}

    for _, v3 in p5._components:getAllComponents("client/components/plot-component@PlotComponent") do
        t4[v3.attributes.ownerUserId] = v3
    end

    local t5 = {}

    for _, v4 in CollectionService:GetTagged("AquariumFish") do
        local ownerUserId = v4:GetAttribute("ownerUserId")

        if ownerUserId ~= nil then
            local v5 = t5[ownerUserId]

            if v5 == nil then
                v5 = {}
                t5[ownerUserId] = v5
            end

            table.insert(v5, v4)
        end
    end

    local t6 = {}
    local n1 = 1e999
    local v6

    for v7 in t5 do
        local v8 = t4[v7]

        if v8 ~= nil then
            local Magnitude = (CharacterPosition - v8.instance.AquariumPos.WorldPosition).Magnitude

            t6[v7] = Magnitude

            if Magnitude < n1 then
                n1 = Magnitude
                v6 = v7
            end
        end
    end

    for v9, v10 in t5 do
        if t4[v9] ~= nil then
            local v12 = t6[v9]

            if v9 == v6 and v12 < 120 then
                for _, v13 in v10 do
                    v13:SetAttribute("shouldMove", true)
                end
            elseif v12 < 150 then
                for i = 0, #v10 - 1 do
                    v10[i + 1]:SetAttribute("shouldMove", i < 3)
                end
            else
                for _, v14 in v10 do
                    v14:SetAttribute("shouldMove", false)
                end
            end
        else
            for _, v11 in v10 do
                v11:SetAttribute("shouldMove", false)
            end
        end
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/aquarium-lod-controller@AquariumLodController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    AquariumLodController = self
}
