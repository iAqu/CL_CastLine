-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, Workspace = services.Players, services.Workspace
local charmData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charms").charmData
local selectPlayerDisplayedCharmId = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerDisplayedCharmId
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "charm-model-utils")
local createCharmModel, getCharmTargetCFrame, stepCharmCFrame = v1.createCharmModel, v1.getCharmTargetCFrame, v1.stepCharmCFrame
local v2 = Random.new()
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 29
        return "CharmController"
    end
})

self.__index = self

function self.new(...) -- line: 34
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 38
    p1._reflexController = p2
    p1._attachedVisuals = {}
    p1._visuals = {}
end

function self.onStart(p3) -- line: 43
    -- upvalues: Players (copy), Workspace (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "CharmVisuals"
    Folder.Parent = Workspace
    p3._visualsFolder = Folder

    for _, player in Players:GetPlayers() do
        p3:_setupPlayer(player)
    end

    Players.PlayerAdded:Connect(function(p4) -- line: 51
        -- upvalues: p3 (copy)
        return p3:_setupPlayer(p4)
    end)
    Players.PlayerRemoving:Connect(function(p5) -- line: 54
        -- upvalues: p3 (copy)
        return p3:_removePlayer(p5)
    end)
end

function self.onRender(p6, p7) -- line: 58
    -- upvalues: Workspace (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()

    for _, v5 in p6._visuals do
        p6:_stepVisual(v5, ServerTimeNow, p7)
    end

    for v6 in p6._attachedVisuals do
        p6:_stepVisual(v6, ServerTimeNow, p7)
    end
end

function self.attachCharmToCharacter(p8, p9, p10, p11, p12) -- line: 67
    local v7 = if p12 == nil then ("Attached_%*"):format(p10) else p12
    local t4

    t4 = {
        phase = 0,
        charmId = p10,
        resolveRootPart = function() -- resolveRootPart | line: 75
            -- upvalues: p8 (copy), p9 (copy), t4 (ref)
            return p8:_resolveCachedRootPart(t4, function() -- line: 76
                -- upvalues: p9 (copy)
                local HumanoidRootPart = p9:FindFirstChild("HumanoidRootPart")

                return if if HumanoidRootPart == nil then HumanoidRootPart else HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
            end)
        end
    }

    local v8 = p8:_createModel(t4, p11, v7)

    if v8 == nil then
        return nil
    end

    p8._attachedVisuals[t4] = true

    local v9 = false

    return {
        destroy = function() -- destroy | line: 93
            -- upvalues: p8 (copy), t4 (ref), v9 (ref)
            if v9 then
                return nil
            end

            v9 = true
            p8._attachedVisuals[t4] = nil
            p8:_destroyModel(t4)
        end,
        model = v8
    }
end

function self._setupPlayer(p13, p14) -- line: 104
    -- upvalues: Maid (copy), selectPlayerDisplayedCharmId (copy)
    if p13._visuals[p14] ~= nil then
        return nil
    end

    local v10 = Maid.new()
    local t8

    t8 = {
        maid = v10,
        phase = p14.UserId % 100 * 0.13,
        player = p14,
        resolveRootPart = function() -- resolveRootPart | line: 116
            -- upvalues: p13 (copy), p14 (copy), t8 (ref)
            return p13:_resolveCachedRootPart(t8, function() -- line: 117
                -- upvalues: p14 (copy)
                local Character = p14.Character

                if Character ~= nil then
                    Character = Character:FindFirstChild("HumanoidRootPart")
                end

                return if if Character == nil then Character else Character:IsA("BasePart") then Character else nil
            end)
        end
    }
    p13._visuals[p14] = t8

    local v11 = p13._reflexController:getClientProducer()
    local v12 = selectPlayerDisplayedCharmId((tostring(p14.UserId)))
    local v13 = v12(v11:getState())

    t8.charmId = v13
    v10:GiveTask(v11:subscribe(v12, function(p15) -- line: 137
        -- upvalues: p13 (copy), t8 (ref)
        local t10 = t8

        t10.charmId = p15
        p13:_refreshVisual(t10)
    end))
    v10:GiveTask(p14.CharacterAdded:Connect(function(p16) -- line: 141
        -- upvalues: p13 (copy), t8 (ref)
        return p13:_handleCharacterAdded(t8, p16)
    end))
    v10:GiveTask(p14.CharacterRemoving:Connect(function() -- line: 144
        -- upvalues: p13 (copy), t8 (ref)
        local characterMaid = t8.characterMaid

        if characterMaid ~= nil then
            characterMaid:Destroy()
        end

        local t11 = t8

        t11.characterMaid = nil
        p13:_destroyModel(t11)
    end))

    local Character = p14.Character

    if Character ~= nil then
        p13:_handleCharacterAdded(t8, Character)
    end
end

function self._handleCharacterAdded(p17, p18, p19) -- line: 157
    -- upvalues: Maid (copy)
    local characterMaid = p18.characterMaid

    if characterMaid ~= nil then
        characterMaid:Destroy()
    end

    local v14 = Maid.new()

    p18.characterMaid = v14
    p17:_destroyModel(p18)

    local HumanoidRootPart = p19:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart ~= nil then
        HumanoidRootPart = HumanoidRootPart:IsA("BasePart")
    end

    if HumanoidRootPart then
        p17:_refreshVisual(p18)

        return nil
    end

    v14:GiveTask(p19.ChildAdded:Connect(function(p20) -- line: 174
        -- upvalues: p17 (copy), p18 (copy), p19 (copy)
        if p20.Name ~= "HumanoidRootPart" or not p20:IsA("BasePart") or p18.player.Character ~= p19 then
            return nil
        end

        p17:_refreshVisual(p18)
    end))
end

function self._refreshVisual(p21, p22) -- line: 184
    p21:_destroyModel(p22)

    local charmId = p22.charmId

    if charmId == nil or not p21._visualsFolder then
        return nil
    end

    p21:_createModel(p22, p21._visualsFolder, (("%*_%*"):format(p22.player.Name, charmId)))
end

function self._createModel(p23, p24, p25, p26) -- line: 192
    -- upvalues: charmData (copy), createCharmModel (copy)
    local charmId = p24.charmId
    local v15 = if charmId == nil then nil else charmData[charmId]
    local v16 = p24.resolveRootPart()

    if charmId == nil or v15 == nil or v16 == nil then
        return nil
    end

    local v17 = createCharmModel(v15)

    v17.Name = p26

    for _, descendant in v17:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
        end
    end

    local v18 = p23:_getInitialCFrame(v16, v15)

    v17:PivotTo(v18)
    v17.Parent = p25
    p24.currentCFrame = v18
    p24.model = v17

    return v17
end

function self._resolveCachedRootPart(_, p28, p29) -- line: 218
    local cachedRootPart = p28.cachedRootPart

    if cachedRootPart ~= nil and cachedRootPart.Parent ~= nil then
        return cachedRootPart
    end

    local v19 = p29()

    p28.cachedRootPart = v19

    return v19
end

function self._stepVisual(p30, p31, p32, p33) -- line: 227
    -- upvalues: charmData (copy), getCharmTargetCFrame (copy), stepCharmCFrame (copy)
    local model = p31.model
    local v20 = if p31.charmId ~= nil then charmData[p31.charmId] else nil
    local v21 = p31.resolveRootPart()

    if not model or not v20 or v21 == nil then
        return nil
    end

    local v22 = getCharmTargetCFrame(v21.CFrame, v20, p32 + p31.phase)
    local v24 = stepCharmCFrame(p31.currentCFrame or v22, v22, v20, p33)
    local v25 = p30:_stepIdleMotion(p31, v21.Position, p32, p33)

    p31.currentCFrame = v24
    model:PivotTo((v24 + v25.flightOffset) * CFrame.Angles(0, v25.spinY, 0))
end

function self._stepIdleMotion(p34, p35, p36, p37, p38) -- line: 251
    local lastRootPosition = p35.lastRootPosition

    p35.lastRootPosition = p36

    if (if lastRootPosition == nil or not (p38 > 0) then 0 else (p36 - lastRootPosition).Magnitude / p38) > 0.5 then
        p34:_resetIdleMotion(p35)
    else
        if p35.idleStartedAt == nil then
            p35.idleStartedAt = p37
        end

        local idleStartedAt = p35.idleStartedAt

        if idleStartedAt ~= nil and not (p37 < idleStartedAt + 5) then
            return {
                flightOffset = p34:_stepRandomFlight(p35, p37),
                spinY = p34:_stepRandomSpin(p35, p37)
            }
        end
    end

    return {
        flightOffset = Vector3.new(0, 0, 0),
        spinY = 0
    }
end

function self._stepRandomFlight(p39, p40, p41) -- line: 276
    -- upvalues: v2 (copy)
    if p40.idleFlightStartedAt == nil or p40.idleFlightDuration == nil or p40.idleFlightStartOffset == nil or p40.idleFlightTargetOffset == nil then
        p40.idleFlightStartedAt = p41
        p40.idleFlightDuration = v2:NextNumber(1.2, 2.4)
        p40.idleFlightStartOffset = p40.idleFlightCurrentOffset or Vector3.new(0, 0, 0)
        p40.idleFlightTargetOffset = p39:_getRandomFlightOffset()
    end

    local idleFlightStartedAt, idleFlightDuration, idleFlightStartOffset, idleFlightTargetOffset = p40.idleFlightStartedAt, p40.idleFlightDuration, p40.idleFlightStartOffset, p40.idleFlightTargetOffset
    local v27 = math.clamp((p41 - idleFlightStartedAt) / idleFlightDuration, 0, 1)
    local v28 = idleFlightStartOffset:Lerp(idleFlightTargetOffset, v27 * v27 * (3 - v27 * 2))

    p40.idleFlightCurrentOffset = v28

    if v27 >= 1 then
        p40.idleFlightStartedAt = nil
        p40.idleFlightDuration = nil
        p40.idleFlightStartOffset = nil
        p40.idleFlightTargetOffset = nil
    end

    return v28
end

function self._getRandomFlightOffset(_) -- line: 299
    -- upvalues: v2 (copy)
    local v29 = v2:NextNumber(0, 6.283185307179586)
    local v31 = math.sqrt((v2:NextNumber())) * 2

    return (Vector3.new(math.cos(v29) * v31, v2:NextNumber(-1, 1), math.sin(v29) * v31))
end

function self._stepRandomSpin(_, p44, p45) -- line: 304
    -- upvalues: v2 (copy)
    if p44.randomSpinStartedAt == nil then
        local idleStartedAt = p44.idleStartedAt

        if idleStartedAt == nil then
            return 0
        end

        if p44.nextRandomSpinAt == nil then
            p44.nextRandomSpinAt = idleStartedAt + 5
        end

        if p45 < p44.nextRandomSpinAt then
            return 0
        end

        p44.randomSpinStartedAt = p45
        p44.randomSpinDuration = v2:NextNumber(0.65, 1.1)
        p44.randomSpinDirection = v2:NextInteger(0, 1) == 0 and -1 or 1
        p44.nextRandomSpinAt = nil
    end

    local randomSpinStartedAt, randomSpinDuration = p44.randomSpinStartedAt, p44.randomSpinDuration

    if randomSpinDuration == nil then
        randomSpinDuration = 0.65
    end

    local randomSpinDirection = p44.randomSpinDirection

    if randomSpinDirection == nil then
        randomSpinDirection = 1
    end

    local v36 = math.clamp((p45 - randomSpinStartedAt) / randomSpinDuration, 0, 1)

    if v36 >= 1 then
        p44.randomSpinStartedAt = nil
        p44.randomSpinDuration = nil
        p44.randomSpinDirection = nil

        if p44.idleStartedAt ~= nil then
            p44.nextRandomSpinAt = p45 + v2:NextNumber(3, 8)
        end

        return 0
    end

    local v37 = v36 * v36 * (3 - v36 * 2)

    return randomSpinDirection * 3.141592653589793 * 2 * v37
end

function self._resetIdleMotion(_, p47) -- line: 345
    p47.idleFlightCurrentOffset = nil
    p47.idleFlightDuration = nil
    p47.idleFlightStartedAt = nil
    p47.idleFlightStartOffset = nil
    p47.idleFlightTargetOffset = nil
    p47.idleStartedAt = nil
    p47.nextRandomSpinAt = nil
    p47.randomSpinDirection = nil
    p47.randomSpinDuration = nil
    p47.randomSpinStartedAt = nil
end

function self._getInitialCFrame(_, p49, p50) -- line: 357
    return p49.CFrame * CFrame.new(p50.followOffset)
end

function self._destroyModel(p51, p52) -- line: 362
    local model = p52.model

    if model ~= nil then
        model:Destroy()
    end

    p52.model = nil
    p52.currentCFrame = nil
    p52.lastRootPosition = nil
    p52.cachedRootPart = nil
    p51:_resetIdleMotion(p52)
end

function self._removePlayer(p53, p54) -- line: 373
    local v38 = p53._visuals[p54]

    if not v38 then
        return nil
    end

    local characterMaid = v38.characterMaid

    if characterMaid ~= nil then
        characterMaid:Destroy()
    end

    v38.characterMaid = nil
    p53:_destroyModel(v38)
    v38.maid:Destroy()
    p53._visuals[p54] = nil
end

Reflect.defineMetadata(self, "identifier", "client/controllers/charm-controller@CharmController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnRender" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    CharmController = self
}
