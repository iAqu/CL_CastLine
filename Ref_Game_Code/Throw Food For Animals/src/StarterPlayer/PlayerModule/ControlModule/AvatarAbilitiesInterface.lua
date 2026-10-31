-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local UserPlayerScriptsCCLIntegrationD = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD")
local UserPlayerScriptsPlayerControlState2 = FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2")
local UserPlayerScriptsTaskDeferSimulation = FlagUtil.getUserFlag("UserPlayerScriptsTaskDeferSimulation")
local UserPlayerScriptsImportWaitForAbilitiesFolder = FlagUtil.getUserFlag("UserPlayerScriptsImportWaitForAbilitiesFolder")
local v1

if not UserPlayerScriptsImportWaitForAbilitiesFolder then
    local function waitForChildren(p1, p2, p3) -- line: 22
        if #p2 == 0 then
            return nil
        end

        for _, v2 in p2 do
            local v3 = p1:FindFirstChild(v2)

            if v3 then
                return v3
            end
        end

        local thread = coroutine.running()
        local v4
        local v5 = false

        local function settle(p4) -- line: 41
            -- upvalues: thread (copy), v4 (ref), v5 (ref)
            if v5 then
                return
            end

            v5 = true
            v4 = p4
            task.spawn(thread)
        end

        local connection = p1.ChildAdded:Connect(function(p5) -- line: 54
            -- upvalues: p2 (copy), thread (copy), v4 (ref), v5 (ref)
            if not table.find(p2, p5.Name) or v5 then
                return
            end

            v5 = true
            v4 = p5
            task.spawn(thread)
        end)
        local v6 = if p3 then task.delay(p3, function() -- line: 61
            -- upvalues: thread (copy), v4 (ref), v5 (ref)
            if v5 then
                return
            end

            v5 = true
            v4 = nil
            task.spawn(thread)
        end) else nil

        coroutine.yield()
        connection:Disconnect()

        if v6 and coroutine.status(v6) == "suspended" then
            task.cancel(v6)
        end

        return v4
    end

    v1 = function(p6, p7) -- line: 85
        -- upvalues: waitForChildren (copy)
        if not p6 then
            return nil
        end

        local v7 = if p7 then time() + p7 else nil

        local function getRemainingTime() -- line: 92
            -- upvalues: v7 (copy)
            return if v7 then math.max(v7 - time(), 0) else nil
        end

        local v11 = waitForChildren(p6, {
            "AbilityManagerActor",
            "Abilities"
        }, if v7 then math.max(v7 - time(), 0) else nil)

        if not v11 then
            return nil
        end

        if v11.Name == "Abilities" then
            return if v11:IsA("Folder") then v11 else nil
        end

        local v12 = if v7 then math.max(v7 - time(), 0) else nil
        local v14 = if v12 then v11:WaitForChild("Abilities", v12) else v11:WaitForChild("Abilities")

        return if v14 and v14:IsA("Folder") then v14 else nil
    end
end

if UserPlayerScriptsCCLIntegrationD then
    local t2 = {}

    t2.__index = t2

    local t3 = {}

    Players.PlayerRemoving:Connect(function(p8) -- line: 125
        -- upvalues: t3 (copy)
        wait(1)

        local v15 = t3[p8.UserId]

        if v15 then
            v15:destroy()
            t3[p8.UserId] = nil
        end
    end)

    local function createAbilitiesByInputNameTable(p9) -- line: 135
        local t4 = {}

        for _, child in p9:GetChildren() do
            if child:IsA("Configuration") then
                local InputName = child:GetAttribute("InputName")

                if InputName then
                    t4[InputName] = child
                end
            end
        end

        return t4
    end

    local function notifyAbilitiesChanged(p10, p11) -- line: 148
        local connection = p10.ChildAdded:Connect(function(p12) -- line: 149
            -- upvalues: p11 (copy)
            if p12:IsA("Configuration") then
                p11(p12, "added")
            end
        end)
        local connection2 = p10.ChildRemoved:Connect(function(p13) -- line: 154
            -- upvalues: p11 (copy)
            if p13:IsA("Configuration") then
                p11(p13, "removed")
            end
        end)

        return function() -- line: 159
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end
    end

    function t2._new(p14) -- line: 165
        -- upvalues: UserPlayerScriptsPlayerControlState2 (copy), UserPlayerScriptsTaskDeferSimulation (copy), t2 (copy)
        local self = setmetatable({}, t2)

        self._player = p14
        self._data = {}
        self._character = nil
        self._humanoid = nil
        self._enabledChangedEvent = Instance.new("BindableEvent")
        self._abilitiesChangedEvent = Instance.new("BindableEvent")
        self._evaluateStateMachineChangedConnection = nil
        self._abilityChangedEvents = {}
        self._abilityChangedConnections = {}
        self._abilitiesByInputName = {}
        self._disconnectAbilitiesChanged = nil

        if not UserPlayerScriptsPlayerControlState2 or UserPlayerScriptsTaskDeferSimulation then
            self._characterAddedConnection = p14.CharacterAdded:Connect(function(p15) -- line: 188
                -- upvalues: self (copy)
                self:_onCharacterAdded(p15)
            end)
        else
            task.spawn(function() -- line: 182
                -- upvalues: p14 (copy), self (copy)
                self._characterAddedConnection = p14.CharacterAdded:Connect(function(p16) -- line: 183
                    -- upvalues: self (copy)
                    self:_onCharacterAdded(p16)
                end)
            end)
        end

        if p14.Character then
            self:_onCharacterAdded(p14.Character)
        end

        return self
    end

    local v17

    function t2._avatarAbilities() -- line: 202
        -- upvalues: v17 (ref)
        if v17 then
            return v17
        end

        local Packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        local AvatarAbilities = if Packages then Packages:FindFirstChild("AvatarAbilities") else nil

        v17 = if AvatarAbilities then require(AvatarAbilities) else nil
        v17 = v17 or require("@rbx/AvatarAbilities")

        return v17
    end

    function t2.get(p17) -- line: 215
        -- upvalues: t2 (copy), t3 (copy)
        if p17 and p17.UserId ~= 0 then
            local v18 = t3[p17.UserId]

            if not v18 then
                v18 = t2._new(p17)
                t3[p17.UserId] = v18
            end

            return v18
        end

        return nil
    end

    function t2._hookUpAbilityChangedEvent(p18, p19, p20) -- line: 225
        local v19 = p18._abilitiesByInputName[p19]

        if v19 then
            local SyncedState = v19:FindFirstChild("SyncedState")

            if SyncedState then
                if not p18._abilityChangedConnections[p20] then
                    p18._abilityChangedConnections[p20] = {}
                end

                if p18._abilityChangedConnections[p20][p19] then
                    p18._abilityChangedConnections[p20][p19]:Disconnect()
                    p18._abilityChangedConnections[p20][p19] = nil
                end

                p18._abilityChangedConnections[p20][p19] = SyncedState:GetAttributeChangedSignal(p20):Connect(function() -- line: 239
                    -- upvalues: p18 (copy), p19 (copy), p20 (copy)
                    p18._abilityChangedEvents[p20][p19]:Fire()
                end)
            end
        end
    end

    function t2._onCharacterAdded(p21, p22) -- line: 244
        -- upvalues: UserPlayerScriptsImportWaitForAbilitiesFolder (copy), v1 (ref), createAbilitiesByInputNameTable (copy), notifyAbilitiesChanged (copy)
        p21._humanoid = nil
        p21._character = p22
        p21._abilitiesByInputName = {}
        p21._data = {}

        if p21._disconnectAbilitiesChanged then
            p21._disconnectAbilitiesChanged()
            p21._disconnectAbilitiesChanged = nil
        end

        for _, v21 in p21._abilityChangedConnections do
            for _, v22 in v21 do
                v22:Disconnect()
            end
        end

        p21._abilityChangedConnections = {}

        if p21._evaluateStateMachineChangedConnection then
            p21._evaluateStateMachineChangedConnection:Disconnect()
            p21._evaluateStateMachineChangedConnection = nil
        end

        if p21._character then
            local function isStale() -- line: 271
                -- upvalues: p21 (copy), p22 (copy)
                return p21._character ~= p22
            end

            task.spawn(function() -- line: 276
                -- upvalues: p21 (copy), p22 (copy), UserPlayerScriptsImportWaitForAbilitiesFolder (copy), v1 (ref), createAbilitiesByInputNameTable (copy), notifyAbilitiesChanged (copy)
                local v23 = if UserPlayerScriptsImportWaitForAbilitiesFolder then p21._avatarAbilities().waitForAbilitiesFolder(p22) else v1(p22)

                if not v23 or p21._character ~= p22 then
                    return
                end

                p21._humanoid = p22:FindFirstChildOfClass("Humanoid")

                while not p21._humanoid do
                    p22.ChildAdded:Wait()

                    if p21._character ~= p22 then
                        return
                    end

                    p21._humanoid = p22:FindFirstChildOfClass("Humanoid")
                end

                if p21._evaluateStateMachineChangedConnection then
                    p21._evaluateStateMachineChangedConnection:Disconnect()
                    p21._evaluateStateMachineChangedConnection = nil
                end

                local function enabledChanged() -- line: 297
                    -- upvalues: v23 (copy), p21 (copy), createAbilitiesByInputNameTable (copy), notifyAbilitiesChanged (copy)
                    if p21._disconnectAbilitiesChanged then
                        p21._disconnectAbilitiesChanged()
                        p21._disconnectAbilitiesChanged = nil
                    end

                    if p21:isEnabled() then
                        p21._disconnectAbilitiesChanged = notifyAbilitiesChanged(v23, function(p23, p24) -- line: 304
                            -- upvalues: p21 (copy)
                            local InputName = p23:GetAttribute("InputName")

                            if InputName then
                                if p24 == "added" then
                                    p21._abilitiesByInputName[InputName] = p23

                                    for v24, v25 in p21._abilityChangedEvents do
                                        if v25[InputName] then
                                            p21:_hookUpAbilityChangedEvent(InputName, v24)
                                        end
                                    end
                                elseif p21._abilitiesByInputName[InputName] == p23 then
                                    p21._abilitiesByInputName[InputName] = nil

                                    for _, v26 in p21._abilityChangedConnections do
                                        local v27 = v26[InputName]

                                        if v27 then
                                            v27:Disconnect()
                                            v26[InputName] = nil
                                        end
                                    end
                                end

                                p21._abilitiesChangedEvent:Fire()
                            end
                        end)
                        p21._abilitiesByInputName = createAbilitiesByInputNameTable(v23)
                        p21._abilitiesChangedEvent:Fire()

                        for v28, v29 in p21._abilityChangedEvents do
                            for v30, v31 in v29 do
                                v31:Fire()
                                p21:_hookUpAbilityChangedEvent(v30, v28)
                            end
                        end
                    end

                    p21._enabledChangedEvent:Fire()
                end

                p21._evaluateStateMachineChangedConnection = p21._humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function() -- line: 350
                    -- upvalues: enabledChanged (copy)
                    enabledChanged()
                end)
                enabledChanged()
            end)
        end
    end

    function t2.isEnabled(p25) -- line: 357
        return p25._humanoid ~= nil and not p25._humanoid.EvaluateStateMachine
    end

    function t2.GetEnabledChangedSignal(p26) -- line: 361
        return p26._enabledChangedEvent.Event
    end

    function t2.SendInput(p27, p28, p29) -- line: 365
        if p27:isEnabled() and p29 ~= p27._data[p28] then
            p27._data[p28] = p29
            p27._avatarAbilities().setAbilityManagerCommand(p27._character, p28, p29)
        end
    end

    function t2.GetAbilityAttribute(p30, p31, p32, p33) -- line: 374
        local v32 = p30._abilitiesByInputName[p31]

        if not v32 then
            return p33
        end

        local SyncedState = v32:FindFirstChild("SyncedState")

        if not SyncedState then
            return p33
        end

        local Attribute = SyncedState:GetAttribute(p32)

        if Attribute == nil then
            return p33
        end

        return Attribute
    end

    function t2.GetAbilityAttributeChangedSignal(p34, p35, p36) -- line: 384
        if not p34._abilityChangedEvents[p36] then
            p34._abilityChangedEvents[p36] = {}
        end

        if p34._abilityChangedEvents[p36][p35] then
            return p34._abilityChangedEvents[p36][p35].Event
        end

        local BindableEvent = Instance.new("BindableEvent")

        p34._abilityChangedEvents[p36][p35] = BindableEvent
        p34:_hookUpAbilityChangedEvent(p35, p36)

        return BindableEvent.Event
    end

    function t2.GetAbilityEnabled(p37, p38) -- line: 400
        return p37:GetAbilityAttribute(p38, "Enabled", false)
    end

    function t2.GetAbilityEnabledChangedSignal(p39, p40) -- line: 404
        return p39:GetAbilityAttributeChangedSignal(p40, "Enabled")
    end

    function t2.GetAbilitySuspended(p41, p42) -- line: 408
        return p41:GetAbilityAttribute(p42, "Suspended", false)
    end

    function t2.GetAbilitySuspendedChangedSignal(p43, p44) -- line: 412
        return p43:GetAbilityAttributeChangedSignal(p44, "Suspended")
    end

    function t2.GetAbilityActive(p45, p46) -- line: 416
        return p45:GetAbilityAttribute(p46, "Active", false)
    end

    function t2.GetAbilityActiveChangedSignal(p47, p48) -- line: 420
        return p47:GetAbilityAttributeChangedSignal(p48, "Active")
    end

    function t2.GetAbilityValid(p49, p50) -- line: 424
        return p49:GetAbilityAttribute(p50, "IsValid", true)
    end

    function t2.GetAbilityValidChangedSignal(p51, p52) -- line: 428
        return p51:GetAbilityAttributeChangedSignal(p52, "IsValid")
    end

    function t2.GetAbilities(p53) -- line: 432
        local t6 = {}

        for v33 in p53._abilitiesByInputName do
            table.insert(t6, v33)
        end

        return t6
    end

    function t2.GetAbilitiesChangedSignal(p54) -- line: 440
        return p54._abilitiesChangedEvent.Event
    end

    function t2.GetAbilityConfig(p55, p56) -- line: 444
        local t7 = {
            Slot = -1
        }
        local v34 = p55._abilitiesByInputName[p56]

        if v34 then
            local ActionSlot = v34:GetAttribute("ActionSlot")

            if ActionSlot then
                return {
                    Slot = tonumber(ActionSlot),
                    ButtonAssetId = v34:GetAttribute("CustomIcon"),
                    ButtonPressedAssetId = v34:GetAttribute("CustomIconActive"),
                    ButtonInvalidAssetId = v34:GetAttribute("CustomIconInvalid")
                }
            end
        end

        return t7
    end

    function t2.destroy(p57) -- line: 466
        if p57._characterAddedConnection then
            p57._characterAddedConnection:Disconnect()
            p57._characterAddedConnection = nil
        end

        if p57._evaluateStateMachineChangedConnection then
            p57._evaluateStateMachineChangedConnection:Disconnect()
            p57._evaluateStateMachineChangedConnection = nil
        end

        if p57._disconnectAbilitiesChanged then
            p57._disconnectAbilitiesChanged()
            p57._disconnectAbilitiesChanged = nil
        end

        for _, v35 in p57._abilityChangedConnections do
            for _, v36 in v35 do
                v36:Disconnect()
            end
        end

        p57._abilityChangedConnections = {}
    end

    return t2
end

local Players2 = game:GetService("Players")
local t8 = {}
local AbilityManagerActor, Humanoid
local BindableEvent = Instance.new("BindableEvent")
local connection
local v37 = false

local function characterAdded(p58) -- line: 500
    -- upvalues: AbilityManagerActor (ref), Humanoid (ref), BindableEvent (copy), connection (ref)
    AbilityManagerActor = nil
    Humanoid = nil

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if not p58 then
        return
    end

    AbilityManagerActor = p58:FindFirstChild("AbilityManagerActor")
    Humanoid = p58:FindFirstChildOfClass("Humanoid")

    while not Humanoid do
        p58.ChildAdded:wait()
        Humanoid = p58:FindFirstChildOfClass("Humanoid")
    end

    BindableEvent:Fire()
    connection = Humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function() -- line: 517
        -- upvalues: BindableEvent (copy)
        BindableEvent:Fire()
    end)
end

local function lazyInit() -- line: 523
    -- upvalues: Players2 (copy), v37 (ref), characterAdded (copy)
    if v37 then
        return
    end

    v37 = true

    local LocalPlayer = Players2.LocalPlayer

    if LocalPlayer then
        LocalPlayer.characterAdded:Connect(characterAdded)

        if LocalPlayer.Character then
            characterAdded(LocalPlayer.Character)
        end
    end
end

function t8.isEnabled() -- line: 538
    -- upvalues: Players2 (copy), AbilityManagerActor (ref), Humanoid (ref), v37 (ref), characterAdded (copy)
    if not v37 then
        v37 = true

        local LocalPlayer = Players2.LocalPlayer

        if LocalPlayer then
            LocalPlayer.characterAdded:Connect(characterAdded)

            if LocalPlayer.Character then
                characterAdded(LocalPlayer.Character)
            end
        end
    end

    return AbilityManagerActor ~= nil and Humanoid and not Humanoid.EvaluateStateMachine
end

function t8.GetEnabledChangedSignal() -- line: 543
    -- upvalues: Players2 (copy), BindableEvent (copy), v37 (ref), characterAdded (copy)
    if v37 then
        return BindableEvent.Event
    end

    v37 = true

    local LocalPlayer = Players2.LocalPlayer

    if LocalPlayer then
        LocalPlayer.characterAdded:Connect(characterAdded)

        if LocalPlayer.Character then
            characterAdded(LocalPlayer.Character)
        end
    end

    return BindableEvent.Event
end

return t8
