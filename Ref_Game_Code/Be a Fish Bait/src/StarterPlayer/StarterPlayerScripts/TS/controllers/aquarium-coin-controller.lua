-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, HttpService, Players, ReplicatedStorage = services.CollectionService, services.HttpService, services.Players, services.ReplicatedStorage
local Workspace = services.Workspace
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local pendingMoneyAtom = RuntimeLib.import(script, script.Parent.Parent, "money-fly-atom").pendingMoneyAtom

local function getMoneyUiWorldTarget() -- line: 20
    -- upvalues: Workspace (copy)
    local CurrentCamera = Workspace.CurrentCamera

    if not CurrentCamera then
        return (Vector3.new())
    end

    local ViewportSize = CurrentCamera.ViewportSize
    local v1 = CurrentCamera:ScreenPointToRay(0.05 * ViewportSize.X, 0.72 * ViewportSize.Y)

    return v1.Origin + v1.Direction * 5
end

local function evenSplit(p1, p2) -- line: 31
    if p2 <= 0 then
        return {}
    end

    if p2 == 1 then
        return { p1 }
    end

    local v3 = math.floor(p1 / p2)
    local t1 = {}
    local n1 = 0
    local v4 = false

    while true do
        if v4 then
            n1 += 1
        else
            v4 = true
        end

        if n1 < p2 - 1 then
            table.insert(t1, v3)
            continue
        end

        break
    end

    table.insert(t1, p1 - v3 * (p2 - 1))

    return t1
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 62
        return "AquariumCoinController"
    end
})

self.__index = self

function self.new(...) -- line: 67
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p3, p4) -- line: 71
    p3._components = p4
end

function self.onStart(p5) -- line: 74
    -- upvalues: Players (copy), events (copy)
    local LocalPlayer = Players.LocalPlayer

    events.spawnAquariumCoins:connect(function(p6, p7) -- line: 76
        -- upvalues: p5 (copy), LocalPlayer (copy)
        if p6 ~= tostring(LocalPlayer.UserId) or p7 <= 0 then
            return nil
        end

        p5:_spawnCoins(p7)
    end)
end

function self._spawnCoins(p8, p9) -- line: 86
    -- upvalues: CollectionService (copy), HttpService (copy), Players (copy), ReplicatedStorage (copy), Workspace (copy), pendingMoneyAtom (copy), getMoneyUiWorldTarget (copy), evenSplit (copy)
    pendingMoneyAtom(function(p10) -- line: 87
        -- upvalues: p9 (copy)
        return p10 + p9
    end)

    local AquariumFish = CollectionService:GetTagged("AquariumFish")
    local v8 = tostring(Players.LocalPlayer.UserId)
    local t5 = {}

    local function v9(p11) -- line: 94
        -- upvalues: v8 (copy), Workspace (copy)
        local Parent = p11.Parent

        while Parent ~= nil and Parent ~= Workspace do
            local ownerUserId = Parent:GetAttribute("ownerUserId")

            if ownerUserId ~= nil then
                return tostring(ownerUserId) == v8
            end

            Parent = Parent.Parent
        end

        return true
    end

    local n2 = 0

    for v10, v11 in AquariumFish do
        if v9(v11, v10 - 1, AquariumFish) == true then
            n2 += 1
            t5[n2] = v11
        end
    end

    local t6 = {}
    local v12 = #t5
    local v14 = math.min(v12 * 3, 20)
    local v15 = if v12 > 0 then math.max(1, (math.floor(v14 / v12))) else 1

    for _, v18 in t5 do
        local t7 = {}
        local n3 = 0
        local v19 = false

        while true do
            if v19 then
                n3 += 1
            else
                v19 = true
            end

            if n3 < v15 then
                table.insert(t7, v18:GetPivot().Position)
                continue
            end

            break
        end

        table.insert(t6, t7)
    end

    if #t6 == 0 then
        local Character = Players.LocalPlayer.Character

        if Character ~= nil then
            Character = Character:FindFirstChild("HumanoidRootPart")
        end

        if Character then
            table.insert(t6, {
                Character.Position
            })
        end
    end

    if #t6 ~= 0 then
        local CollectableCoin = ReplicatedStorage:FindFirstChild("CollectableCoin")

        if CollectableCoin then
            local n4 = 0

            for _, v20 in t6 do
                n4 += #v20
            end

            local v21 = evenSplit(p9, n4)
            local v22 = #t6 - 1
            local n5 = 0

            for i = 0, v22 do
                local v23 = t6[i + 1]
                local v24 = n5 + #v23
                local delay = task.delay
                local v25 = i * 0.25
                local v26 = n5

                n5 = v24
                delay(v25, function() -- line: 168
                    -- upvalues: p8 (copy), CollectableCoin (copy), v21 (copy), v23 (copy), v26 (copy), CollectionService (copy), HttpService (copy), Players (copy), Workspace (copy), getMoneyUiWorldTarget (copy)
                    if not Players.LocalPlayer:IsDescendantOf(game) then
                        return nil
                    end

                    for i = 0, #v23 - 1 do
                        local v27 = v23[i + 1]
                        local v28 = HttpService:GenerateGUID(false)
                        local clone = CollectableCoin:Clone()

                        clone:SetAttribute("coinId", v28)
                        clone:SetAttribute("isVisualOnly", true)
                        clone:SetAttribute("autoMagnet", true)
                        clone:SetAttribute("coinAmount", v21[v26 + i + 1])
                        clone:PivotTo(CFrame.new(v27))
                        clone.Parent = Workspace
                        CollectionService:AddTag(clone, "CollectableCoin")

                        local v29 = nil

                        v29 = p8._components:onComponentAdded(function(p12) -- line: 185
                            -- upvalues: clone (copy), v29 (ref), getMoneyUiWorldTarget (copy)
                            if p12.instance ~= clone then
                                return nil
                            end

                            p12:setWorldTarget(getMoneyUiWorldTarget)
                            v29:Disconnect()
                        end, "client/components/collectable-coin-component@CollectableCoinComponent")

                        local v30 = p8._components:getComponent(clone, "client/components/collectable-coin-component@CollectableCoinComponent")

                        if v30 then
                            v30:setWorldTarget(getMoneyUiWorldTarget)
                            v29:Disconnect()
                        end
                    end
                end)
            end

            return
        end

        warn("AquariumCoinController: CollectableCoin prefab not found in ReplicatedStorage")
    end

    return nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/aquarium-coin-controller@AquariumCoinController")
Reflect.defineMetadata(self, "flamework:parameters", { "$c:components@Components" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    AquariumCoinController = self
}
