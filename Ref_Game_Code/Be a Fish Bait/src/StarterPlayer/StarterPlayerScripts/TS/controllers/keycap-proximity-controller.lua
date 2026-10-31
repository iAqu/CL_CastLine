-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 20
        return "KeycapProximityController"
    end
})

self.__index = self

function self.new(...) -- line: 25
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1) -- line: 29
    p1._keycaps = {}
    p1._timeSinceLastCheck = 0
end

function self.register(p2, p3) -- line: 33
    p2._keycaps[p3] = true
end

function self.unregister(p4, p5) -- line: 38
    p4._keycaps[p5] = nil
end

function self.onTick(p6, p7) -- line: 43
    -- upvalues: Players (copy)
    p6._timeSinceLastCheck += p7

    if not (p6._timeSinceLastCheck < 0.05) then
        p6._timeSinceLastCheck = 0

        local n1 = 0

        for _ in p6._keycaps do
            n1 += 1
        end

        if n1 ~= 0 then
            local Character = Players.LocalPlayer.Character

            if Character ~= nil then
                Character = Character:FindFirstChild("HumanoidRootPart")
            end

            if Character then
                local CharacterPosition = Character.Position

                for v3 in p6._keycaps do
                    v3:setIsPlayerOnKeycap(p6:_isPlayerOnKeycap(v3, CharacterPosition))
                end

                return
            end

            for v4 in p6._keycaps do
                v4:setIsPlayerOnKeycap(false)
            end
        end
    end

    return nil
end

function self._isPlayerOnKeycap(_, p9, p10) -- line: 75
    local instance = p9.instance
    local v5 = instance.CFrame:PointToObjectSpace(p10)
    local v6 = instance.Size / 2

    if math.abs(v5.X) > v6.X or math.abs(v5.Z) > v6.Z then
        return false
    end

    return not (v5.Y < -v6.Y or v5.Y > v6.Y + 4)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/keycap-proximity-controller@KeycapProximityController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    KeycapProximityController = self
}
