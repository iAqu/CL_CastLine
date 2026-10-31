-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes")
local charmTierConfigs, getCharmTierFlag, isCharmTierId = v1.charmTierConfigs, v1.getCharmTierFlag, v1.isCharmTierId

local function ensureCharmPodiumBillboardMount(p1) -- line: 24
    local v2 = p1.PrimaryPart or p1:FindFirstChildWhichIsA("BasePart", true)

    if not v2 then
        return nil
    end

    local v3 = p1:FindFirstChild("CharmPodiumBillboard", true)

    if not (if v3 == nil then v3 else v3:IsA("BillboardGui")) then
        v3 = Instance.new("BillboardGui")
    end

    v3.Name = "CharmPodiumBillboard"
    v3.Adornee = v2
    v3.AlwaysOnTop = true
    v3.MaxDistance = 65
    v3.Size = UDim2.fromOffset(380, 160)
    v3.StudsOffsetWorldSpace = Vector3.new(0, 11, 0)
    v3.Parent = v2

    return v3
end

local t1 = {
    Color3.fromRGB(84, 196, 255),
    Color3.fromRGB(75, 239, 222),
    Color3.fromRGB(193, 92, 255),
    Color3.fromRGB(255, 189, 71),
    (Color3.fromRGB(255, 82, 151))
}
local formatCash
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 56
        return "CharmPodiumComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 62
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p2, ...) -- line: 66
    -- upvalues: BaseComponent (copy), Maid (copy)
    BaseComponent.constructor(p2, ...)
    p2._maid = Maid.new()
    p2._billboardReadyListeners = {}
end

function self.getBillboard(p3) -- line: 71
    return p3._billboard
end

function self.subscribeBillboard(p4, p5) -- line: 74
    p4._billboardReadyListeners[p5] = true

    if p4._billboard ~= nil then
        p5(p4._billboard)
    end

    return function() -- line: 81
        -- upvalues: p4 (copy), p5 (copy)
        local _billboardReadyListeners = p4._billboardReadyListeners
        local v6 = _billboardReadyListeners[p5] ~= nil

        _billboardReadyListeners[p5] = nil

        return v6
    end
end

function self.onStart(p6) -- line: 91
    -- upvalues: clientProducer (copy), isCharmTierId (copy)
    local CharmTierId = p6.instance:GetAttribute("CharmTierId")

    if type(CharmTierId) ~= "number" or not isCharmTierId(CharmTierId) then
        return nil
    end

    p6._tierId = CharmTierId
    p6._prompt = p6:_resolvePrompt()
    p6:_prepareBillboardMount()
    p6:_refresh()
    p6._maid:GiveTask(clientProducer:subscribe(function() -- line: 100
        -- upvalues: p6 (copy)
        return p6:_refresh()
    end))
end

function self.onDestroy(p7) -- line: 106
    table.clear(p7._billboardReadyListeners)
    p7._maid:Destroy()
end

function self._resolvePrompt(p8) -- line: 110
    local v7 = p8.instance:FindFirstChildWhichIsA("ProximityPrompt", true)

    if v7 then
        return v7
    end

    local v8 = p8.instance.PrimaryPart or p8.instance:FindFirstChildWhichIsA("BasePart", true)

    if not v8 then
        return nil
    end

    local ProximityPrompt = Instance.new("ProximityPrompt")

    ProximityPrompt.HoldDuration = 0.25
    ProximityPrompt.KeyboardKeyCode = Enum.KeyCode.E
    ProximityPrompt.MaxActivationDistance = 16
    ProximityPrompt.RequiresLineOfSight = false
    ProximityPrompt.Parent = v8

    return ProximityPrompt
end

function self._prepareBillboardMount(p9) -- line: 127
    -- upvalues: ensureCharmPodiumBillboardMount (copy)
    local v9 = ensureCharmPodiumBillboardMount(p9.instance)

    if v9 == nil then
        return nil
    end

    p9._billboard = v9

    for v10 in p9._billboardReadyListeners do
        v10(v9)
    end
end

function self._refresh(p10) -- line: 137
    -- upvalues: Players (copy), clientProducer (copy), charmTierConfigs (copy), getCharmTierFlag (copy), t1 (copy), formatCash (ref)
    local _tierId, _prompt = p10._tierId, p10._prompt
    local v11, v12, v13, v14

    if _tierId ~= nil then
        if _prompt then
            v11 = charmTierConfigs[_tierId]

            local v15 = tostring(Players.LocalPlayer.UserId)
            local v16 = clientProducer:getState()

            v12 = v16.playerData.charms[v15]
            v13 = v16.playerData.rebirth[v15]

            if v13 ~= nil then
                v13 = v13.rebirthCount
            end

            v14 = false
        else
            v14 = true
        end
    else
        v14 = true
    end

    if v14 then
        return nil
    end

    if v13 == nil then
        v13 = 0
    end

    local v17 = v11.rebirthRequirement <= v13
    local v18 = (if v12 == nil then v12 else v12.pendingCharmCandidate) ~= nil

    if v12 ~= nil then
        v12 = v12.firstRollClaimedByTier
    end

    if v12 == nil then
        v12 = { false, false, false, false, false }
    end

    local v19 = not getCharmTierFlag(v12, _tierId)
    local v20 = t1[_tierId]

    _prompt.Enabled = v17

    if v18 then
        _prompt.ActionText = "Resolve Roll"
    elseif v17 then
        _prompt.ActionText = "Roll Attributes"
    else
        _prompt.ActionText = "Rebirth Required"
    end

    if v17 then
        _prompt.ObjectText = ("%* · %*"):format(v11.displayName, if v19 then "FREE" else formatCash(v11.cost))
    else
        _prompt.ObjectText = ("%* · Requires Rebirth %*"):format(v11.displayName, v11.rebirthRequirement)
    end

    local v21 = p10.instance:FindFirstChild("CharmCore", true)

    if not (if v21 == nil then v21 else v21:IsA("BasePart")) then
        return
    end

    if v17 then
        v21.Color = v20
    else
        v21.Color = v20:Lerp(Color3.fromRGB(22, 25, 31), 0.7)
    end

    local PointLight = v21:FindFirstChildWhichIsA("PointLight")

    if PointLight then
        PointLight.Enabled = v17
    end
end

Reflect.defineMetadata(self, "identifier", "client/components/charm-podium-component@CharmPodiumComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "CharmPodium",
        defaults = {},
        attributes = {},
        instanceGuard = t.instanceIsA("Model")
    }
})

function formatCash(p11) -- line: 202
    if p11 >= 1E+09 then
        return (`{ p11 / 1E+09 }B Cash`)
    end

    return (`{ p11 / 1E+06 }M Cash`)
end

return {
    ensureCharmPodiumBillboardMount = ensureCharmPodiumBillboardMount,
    CharmPodiumComponent = self
}
