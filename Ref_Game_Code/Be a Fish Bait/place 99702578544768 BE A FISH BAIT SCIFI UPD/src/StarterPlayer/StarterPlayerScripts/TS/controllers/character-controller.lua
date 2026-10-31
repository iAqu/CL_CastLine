-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local charm = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm")
local atom, effect, subscribe = charm.atom, charm.effect, charm.subscribe
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local GuiService, Players, Workspace = services.GuiService, services.Players, services.Workspace
local v1 = RuntimeLib.import(script, script.Parent.Parent, "character-utils")
local listenForCharacter, listenForHumanoid = v1.listenForCharacter, v1.listenForHumanoid
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local fishingMovementLockedAtom = RuntimeLib.import(script, script.Parent.Parent, "fishing-phase-atom").fishingMovementLockedAtom
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "character-constants")
local authoritativeWalkspeedAttribute, baseCharacterWalkspeed = v2.authoritativeWalkspeedAttribute, v2.baseCharacterWalkspeed
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 25
        return "CharacterController"
    end
})

self.__index = self

function self.new(...) -- line: 30
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2) -- line: 34
    -- upvalues: atom (copy), Maid (copy), baseCharacterWalkspeed (copy)
    p1._reflexController = p2
    p1._animationMaid = Maid.new()
    p1._animationMap = {}
    p1._movementOptions = atom({
        enabled = true,
        touchControlsEnabled = true
    })
    p1._movementRevision = 0
    p1.character = atom(nil)
    p1.humanoid = atom(nil)
    p1.isPlayerDead = atom(nil)
    p1.equippedTools = atom({})
    p1._authoritativeWalkspeed = atom(baseCharacterWalkspeed)
end

function self.onInit(p3) -- line: 49
    p3:_handleMovementToggle()
    p3:_syncAuthoritativeWalkspeed()
    p3:_clearAnimationsMapOnHumanoidChanged()
    p3:_listenForCharacter()
    p3:_listenForHumanoid()
    p3:_listenForEquippedTools()
    p3:_listenForDeath()
    p3:_listenForMovementEvents()
end

function self.onStart(_) -- line: 59
end

function self._disableMovement(p5, p6) -- line: 61
    local v5 = if p6 == nil then {
        touchControlsEnabled = false
    } else p6

    p5._movementRevision += 1
    p5._movementOptions({
        enabled = false,
        touchControlsEnabled = v5.touchControlsEnabled
    })
end

function self._enableMovement(p7) -- line: 73
    p7._movementRevision += 1
    p7._movementOptions({
        enabled = true,
        touchControlsEnabled = true
    })
end

function self.acquireMovementLock(p8) -- line: 80
    local v6 = p8._movementOptions()

    p8._movementRevision += 1

    local _movementRevision = p8._movementRevision

    p8._movementOptions({
        enabled = false,
        touchControlsEnabled = false
    })

    local v7 = false

    return function() -- line: 89
        -- upvalues: p8 (copy), v6 (copy), _movementRevision (copy), v7 (ref)
        if v7 then
            return nil
        end

        v7 = true

        if p8._movementRevision ~= _movementRevision then
            return nil
        end

        p8._movementRevision += 1
        p8._movementOptions(v6)
    end
end

self.playAnimation = RuntimeLib.async(function(p9, p10, p11, p12, p13, p14) -- line: 101
    -- upvalues: Players (copy)
    local v9 = p13 ~= nil and p13
    local Character = Players.LocalPlayer.Character

    if not Character then
        return nil
    end

    local v10 = Character:WaitForChild("Humanoid", 10)

    if not (v10 and v10:IsA("Humanoid")) then
        return nil
    end

    local v11 = v10:WaitForChild("Animator", 10)

    if not (v11 and v11:IsA("Animator")) then
        return nil
    end

    local v12 = p9:_getAnimationTrack(v11, p10)

    v12.Looped = v9
    v12.Priority = p11

    local v13 = if p14 == nil then 1 else p14

    if p12 ~= nil then
        v13 = v12.Length / p12
    end

    v12:Play(0.1, 1, v13)
    p9._animationMaid:GiveTask(function() -- line: 129
        -- upvalues: v12 (copy)
        v12:Stop()
    end)

    return v12
end)

function self.stopAllAnimations(p15) -- line: 134
    -- upvalues: Maid (copy)
    p15._animationMaid:Destroy()
    p15._animationMaid = Maid.new()
end

function self.stopAnimationsById(p16, p17) -- line: 138
    for _, v14 in p17 do
        local v15 = p16._animationMap[v14]

        if v15 then
            v15:Stop()
        end
    end
end

function self.isAnimationPlaying(p18, p19) -- line: 147
    local v16 = p18._animationMap[p19]

    return v16 ~= nil and v16.IsPlaying
end

function self.unequipAllTools(p20) -- line: 153
    local v17 = p20.humanoid()

    if not v17 then
        return nil
    end

    v17:UnequipTools()
end

function self._getAnimationTrack(p21, p22, p23) -- line: 160
    local v18 = p21._animationMap[p23]

    if v18 then
        return v18
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = p23

    local track = p22:LoadAnimation(Animation)

    p21._animationMap[p23] = track

    return track
end

function self._handleMovementToggle(p24) -- line: 176
    -- upvalues: effect (copy), GuiService (copy)
    effect(function() -- line: 177
        -- upvalues: p24 (copy), GuiService (copy)
        local v19 = p24.humanoid()

        if not v19 then
            return nil
        end

        local v20 = p24._movementOptions()

        if v20.enabled then
            v19.WalkSpeed = p24._authoritativeWalkspeed()
            v19.JumpPower = 50
            GuiService.TouchControlsEnabled = true
        else
            v19.WalkSpeed = 0
            v19.JumpPower = 0
            GuiService.TouchControlsEnabled = v20.touchControlsEnabled
        end
    end)
end

function self._syncAuthoritativeWalkspeed(p25) -- line: 194
    -- upvalues: effect (copy), authoritativeWalkspeedAttribute (copy), baseCharacterWalkspeed (copy)
    effect(function() -- line: 195
        -- upvalues: p25 (copy), authoritativeWalkspeedAttribute (copy), baseCharacterWalkspeed (copy)
        local v21 = p25.humanoid()

        if v21 then
            local function v22() -- line: 201
                -- upvalues: v21 (copy), p25 (copy), authoritativeWalkspeedAttribute (copy), baseCharacterWalkspeed (copy)
                local Attribute = v21:GetAttribute(authoritativeWalkspeedAttribute)
                local _authoritativeWalkspeed = p25._authoritativeWalkspeed

                if type(Attribute) ~= "number" then
                    Attribute = baseCharacterWalkspeed
                end

                _authoritativeWalkspeed(Attribute)
            end

            local Attribute = v21:GetAttribute(authoritativeWalkspeedAttribute)
            local _authoritativeWalkspeed = p25._authoritativeWalkspeed

            if type(Attribute) ~= "number" then
                Attribute = baseCharacterWalkspeed
            end

            _authoritativeWalkspeed(Attribute)

            local connection = v21:GetAttributeChangedSignal(authoritativeWalkspeedAttribute):Connect(v22)

            return function() -- line: 207
                -- upvalues: connection (copy)
                connection:Disconnect()
            end
        end

        p25._authoritativeWalkspeed(baseCharacterWalkspeed)

        return nil
    end)
end

function self._listenForCharacter(p26) -- line: 212
    -- upvalues: Players (copy), listenForCharacter (copy)
    listenForCharacter(Players.LocalPlayer, function(p27) -- line: 213
        -- upvalues: p26 (copy)
        p26.character(p27)
    end)
end

self._listenForHumanoid = RuntimeLib.async(function(p28) -- line: 217
    -- upvalues: effect (copy), listenForHumanoid (copy)
    effect(function() -- line: 218
        -- upvalues: p28 (copy), listenForHumanoid (copy)
        return listenForHumanoid(p28.character(), function(p29) -- line: 220
            -- upvalues: p28 (copy)
            p28.humanoid(p29)
        end)
    end)
end)

function self._listenForEquippedTools(p30) -- line: 225
    -- upvalues: effect (copy)
    effect(function() -- line: 226
        -- upvalues: p30 (copy)
        local v25 = p30.character()

        if not v25 then
            return nil
        end

        local function v26() -- line: 231
            -- upvalues: v25 (copy), p30 (copy)
            local Children = v25:GetChildren()
            local t4 = {}

            local function v27(p31) -- line: 236
                return p31:IsA("Tool")
            end

            local n1 = 0

            for v28, v29 in Children do
                local _ = v28 - 1

                if v29:IsA("Tool") == true then
                    n1 += 1
                    t4[n1] = v29
                end
            end

            p30.equippedTools(t4)
        end

        v26()

        local connection = v25.ChildAdded:Connect(function(p32) -- line: 250
            -- upvalues: v26 (copy)
            if p32:IsA("Tool") then
                v26()
            end
        end)
        local connection2 = v25.ChildRemoved:Connect(function(p33) -- line: 255
            -- upvalues: v26 (copy)
            if p33:IsA("Tool") then
                v26()
            end
        end)

        return function() -- line: 260
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end
    end)
end

function self._clearAnimationsMapOnHumanoidChanged(p34) -- line: 266
    -- upvalues: subscribe (copy)
    subscribe(p34.humanoid, function() -- line: 267
        -- upvalues: p34 (copy)
        table.clear(p34._animationMap)
    end)
end

function self._listenForDeath(p35) -- line: 271
    -- upvalues: effect (copy), subscribe (copy), Workspace (copy)
    effect(function() -- line: 272
        -- upvalues: p35 (copy), Workspace (copy)
        local v30 = p35.humanoid()

        if not v30 then
            return nil
        end

        v30.Died:Once(function() -- line: 277
            -- upvalues: p35 (copy), Workspace (copy)
            p35.isPlayerDead({
                timeDied = Workspace:GetServerTimeNow()
            })
        end)
    end)
    subscribe(p35.character, function(p36, p37) -- line: 283
        -- upvalues: p35 (copy)
        if p36 ~= p37 and p36 then
            p35.isPlayerDead(nil)
        end
    end)
    p35._reflexController:getClientProducer()
    subscribe(p35.isPlayerDead, function(p38, p39) -- line: 291
        if p38 == p39 then
        end
    end)
end

function self.setCharacterParent(_, p41) -- line: 299
    -- upvalues: Players (copy)
    local Character = Players.LocalPlayer.Character

    if not Character then
        return nil
    end

    Character.Parent = p41 or nil
end

function self._listenForMovementEvents(p42) -- line: 306
    -- upvalues: effect (copy), events (copy), fishingMovementLockedAtom (copy)
    events.enableMovement:connect(function() -- line: 307
        -- upvalues: p42 (copy)
        p42:_enableMovement()
    end)
    events.disableMovement:connect(function() -- line: 310
        -- upvalues: p42 (copy)
        p42:_disableMovement()
    end)
    effect(function() -- line: 313
        -- upvalues: p42 (copy), fishingMovementLockedAtom (copy)
        if fishingMovementLockedAtom() then
            p42:_disableMovement({
                touchControlsEnabled = false
            })
        else
            p42:_enableMovement()
        end
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/character-controller@CharacterController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    CharacterController = self
}
