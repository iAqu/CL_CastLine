-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage, Workspace = services.Players, services.ReplicatedStorage, services.Workspace
local selectPlayerDanceFloorAuraExpiresAt = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerDanceFloorAuraExpiresAt
local danceFloorAuraModelsAtom = RuntimeLib.import(script, script.Parent.Parent, "dance-floor-aura-models-atom").danceFloorAuraModelsAtom
local v1 = CFrame.Angles(-0.5235987755982988, 3.141592653589793, 0)
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 43
        return "DanceFloorAuraController"
    end
})

self.__index = self

function self.new(...) -- line: 48
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 52
    p1._reflexController = p2
    p1._activeAuras = {}
end

function self.onStart(p3) -- line: 56
    -- upvalues: Players (copy)
    Players.PlayerRemoving:Connect(function(p4) -- line: 57
        -- upvalues: p3 (copy)
        return p3:_despawnAura(p4)
    end)
end

function self.onRender(p5, p6) -- line: 61
    -- upvalues: Players (copy), Workspace (copy), selectPlayerDanceFloorAuraExpiresAt (copy), v1 (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v4 = p5._reflexController:getClientProducer():getState()

    for _, player in Players:GetPlayers() do
        local v5 = ServerTimeNow < selectPlayerDanceFloorAuraExpiresAt((tostring(player.UserId)))(v4)
        local v6 = p5._activeAuras[player]

        if v5 then
            local Character = player.Character

            if Character ~= nil then
                Character = Character:FindFirstChild("HumanoidRootPart")
            end

            if v6 then
                if v6.model.Parent and v6.rootPart.Parent and v6.rootPart == Character then
                    v6.angleDegrees = (v6.angleDegrees + 90 * p6) % 360

                    local v7 = math.rad(v6.angleDegrees)
                    local v9 = math.sin(v7 * 2) * 1.5 + 3
                    local v12 = Vector3.new(math.cos(v7) * 4, v9, math.sin(v7) * 4)
                    local v13 = v6.rootPart.Position + v12

                    v6.model:PivotTo(CFrame.lookAt(v13, v6.rootPart.Position) * v1)
                else
                    p5:_despawnAura(player)
                    p5:_spawnAura(player)
                end
            else
                p5:_spawnAura(player)
            end
        elseif v6 then
            p5:_despawnAura(player)
        end
    end
end

function self._spawnAura(p7, p8) -- line: 94
    -- upvalues: ReplicatedStorage (copy), Workspace (copy)
    local Character = p8.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    if not (Character and Character:IsA("BasePart")) then
        return nil
    end

    local VFX = ReplicatedStorage:FindFirstChild("VFX")

    if VFX ~= nil then
        VFX = VFX:FindFirstChild("DanceFloorAuraModel")
    end

    if not (VFX and VFX:IsA("Model")) then
        return nil
    end

    local clone = VFX:Clone()

    clone:PivotTo(Character.CFrame)
    clone.Parent = Workspace
    p7._activeAuras[p8] = {
        angleDegrees = 0,
        model = clone,
        rootPart = Character
    }
    p7:_syncModelsAtom()
end

function self._despawnAura(p9, p10) -- line: 124
    local v14 = p9._activeAuras[p10]

    if not v14 then
        return nil
    end

    v14.model:Destroy()
    p9._activeAuras[p10] = nil
    p9:_syncModelsAtom()
end

function self._syncModelsAtom(p11) -- line: 137
    -- upvalues: danceFloorAuraModelsAtom (copy)
    local t4 = {}

    for _, v15 in p11._activeAuras do
        table.insert(t4, v15.model)
    end

    danceFloorAuraModelsAtom(t4)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/dance-floor-aura-controller@DanceFloorAuraController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    DanceFloorAuraController = self
}
