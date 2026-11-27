-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local v1 = FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationD") or FlagUtil.getUserFlag("UserPlayerScriptsCCLIntegrationDGA")
local v2 = FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2") or FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2GA")
local UserPlayerScriptsTaskDeferSimulation = FlagUtil.getUserFlag("UserPlayerScriptsTaskDeferSimulation")
local UserPlayerScriptsImportWaitForAbilitiesFolder = FlagUtil.getUserFlag("UserPlayerScriptsImportWaitForAbilitiesFolder")
local UserAbilitiesUserInterfaceD = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceD")
local v3

if not UserPlayerScriptsImportWaitForAbilitiesFolder then
    local function waitForChildren(p1, p2, p3) -- line: 26
        if #p2 == 0 then
            return nil
        end

        for _, v4 in p2 do
            local v5 = p1:FindFirstChild(v4)

            if v5 then
                return v5
            end
        end

        local thread = coroutine.running()
        local v6
        local v7 = false

        local function settle(p4) -- line: 45
            -- upvalues: thread (copy), v6 (ref), v7 (ref)
            if v7 then
                return
            end

            v7 = true
            v6 = p4
            task.spawn(thread)
        end

        local connection = p1.ChildAdded:Connect(function(p5) -- line: 58
            -- upvalues: p2 (copy), thread (copy), v6 (ref), v7 (ref)
            if not table.find(p2, p5.Name) or v7 then
                return
            end

            v7 = true
            v6 = p5
            task.spawn(thread)
        end)
        local v8 = if p3 then task.delay(p3, function() -- line: 65
            -- upvalues: thread (copy), v6 (ref), v7 (ref)
            if v7 then
                return
            end

            v7 = true
            v6 = nil
            task.spawn(thread)
        end) else nil

        coroutine.yield()
        connection:Disconnect()

        if v8 and coroutine.status(v8) == "suspended" then
            task.cancel(v8)
        end

        return v6
    end

    v3 = function(p6, p7) -- line: 89
        -- upvalues: waitForChildren (copy)
        if not p6 then
            return nil
        end

        local v9 = if p7 then time() + p7 else nil

        local function getRemainingTime() -- line: 96
            -- upvalues: v9 (copy)
            return if v9 then math.max(v9 - time(), 0) else nil
        end

        local v13 = waitForChildren(p6, {
            "AbilityManagerActor",
            "Abilities"
        }, if v9 then math.max(v9 - time(), 0) else nil)

        if not v13 then
            return nil
        end

        if v13.Name == "Abilities" then
            return if v13:IsA("Folder") then v13 else nil
        end

        local v14 = if v9 then math.max(v9 - time(), 0) else nil
        local v16 = if v14 then v13:WaitForChild("Abilities", v14) else v13:WaitForChild("Abilities")

        return if v16 and v16:IsA("Folder") then v16 else nil
    end
end

if v1 then
    local t2 = {}

    t2.__index = t2

    local t3 = {}

    Players.PlayerRemoving:Connect(function(p8) -- line: 129
        -- upvalues: t3 (copy)
        wait(1)

        local v17 = t3[p8.UserId]

        if v17 then
            v17:destroy()
            t3[p8.UserId] = nil
        end
    end)

    local function createAbilitiesByInputNameTable(p9) -- line: 139
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

    local function notifyAbilitiesChanged(p10, p11) -- line: 152
        local connection = p10.ChildAdded:Connect(function(p12) -- line: 153
            -- upvalues: p11 (copy)
            if p12:IsA("Configuration") then
                p11(p12, "added")
            end
        end)
        local connection2 = p10.ChildRemoved:Connect(function(p13) -- line: 158
            -- upvalues: p11 (copy)
            if p13:IsA("Configuration") then
                p11(p13, "removed")
            end
        end)

        return function() -- line: 163
            -- upvalues: connection (copy), connection2 (copy)
            connection:Disconnect()
            connection2:Disconnect()
        end
    end

    function t2._new(p14) -- line: 169
        -- upvalues: UserPlayerScriptsTaskDeferSimulation (copy), t2 (copy), v2 (copy)
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

        if not v2 or UserPlayerScriptsTaskDeferSimulation then
            self._characterAddedConnection = p14.CharacterAdded:Connect(function(p15) -- line: 192
                -- upvalues: self (copy)
                self:_onCharacterAdded(p15)
            end)
        else
            task.spawn(function() -- line: 186
                -- upvalues: p14 (copy), self (copy)
                self._characterAddedConnection = p14.CharacterAdded:Connect(function(p16) -- line: 187
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

    local v19

    function t2._avatarAbilities() -- line: 206
        -- upvalues: v19 (ref)
        if v19 then
            return v19
        end

        local Packages = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        local AvatarAbilities = if Packages then Packages:FindFirstChild("AvatarAbilities") else nil

        v19 = if AvatarAbilities then require(AvatarAbilities) else nil
        v19 = v19 or require("@rbx/AvatarAbilities")

        return v19
    end

    function t2.get(p17) -- line: 219
        -- upvalues: t2 (copy), t3 (copy)
        if p17 and p17.UserId ~= 0 then
            local v20 = t3[p17.UserId]

            if not v20 then
                v20 = t2._new(p17)
                t3[p17.UserId] = v20
            end

            return v20
        end

        return nil
    end

    function t2._hookUpAbilityChangedEvent(p18, p19, p20) -- line: 231
        local v21 = p18._abilitiesByInputName[p19]

        if v21 then
            local SyncedState = v21:FindFirstChild("SyncedState")

            if SyncedState then
                if not p18._abilityChangedConnections[p20] then
                    p18._abilityChangedConnections[p20] = {}
                end

                if p18._abilityChangedConnections[p20][p19] then
                    p18._abilityChangedConnections[p20][p19]:Disconnect()
                    p18._abilityChangedConnections[p20][p19] = nil
                end

                p18._abilityChangedConnections[p20][p19] = SyncedState:GetAttributeChangedSignal(p20):Connect(function() -- line: 251
                    -- upvalues: p18 (copy), p19 (copy), p20 (copy)
                    p18._abilityChangedEvents[p20][p19]:Fire()
                end)
            end
        end
    end

    function t2._onCharacterAdded(p21, p22) -- line: 256
        -- upvalues: UserPlayerScriptsImportWaitForAbilitiesFolder (copy), v3 (ref), createAbilitiesByInputNameTable (copy), notifyAbilitiesChanged (copy)
        p21._humanoid = nil
        p21._character = p22
        p21._abilitiesByInputName = {}
        p21._data = {}

        if p21._disconnectAbilitiesChanged then
            p21._disconnectAbilitiesChanged()
            p21._disconnectAbilitiesChanged = nil
        end

        for _, v23 in p21._abilityChangedConnections do
            for _, v24 in v23 do
                v24:Disconnect()
            end
        end

        p21._abilityChangedConnections = {}

        if p21._evaluateStateMachineChangedConnection then
            p21._evaluateStateMachineChangedConnection:Disconnect()
            p21._evaluateStateMachineChangedConnection = nil
        end

        if p21._character then
            local function isStale() -- line: 283
                -- upvalues: p21 (copy), p22 (copy)
                return p21._character ~= p22
            end

            task.spawn(function() -- line: 288
                -- upvalues: p21 (copy), p22 (copy), UserPlayerScriptsImportWaitForAbilitiesFolder (copy), v3 (ref), createAbilitiesByInputNameTable (copy), notifyAbilitiesChanged (copy)
                local v25 = if UserPlayerScriptsImportWaitForAbilitiesFolder then p21._avatarAbilities().waitForAbilitiesFolder(p22) else v3(p22)

                if not v25 or p21._character ~= p22 then
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

                local function enabledChanged() -- line: 313
                    -- upvalues: v25 (copy), p21 (copy), createAbilitiesByInputNameTable (copy), notifyAbilitiesChanged (copy)
                    if p21._disconnectAbilitiesChanged then
                        p21._disconnectAbilitiesChanged()
                        p21._disconnectAbilitiesChanged = nil
                    end

                    if p21:isEnabled() then
                        p21._disconnectAbilitiesChanged = notifyAbilitiesChanged(v25, function(p23, p24) -- line: 320
                            -- upvalues: p21 (copy)
                            local InputName = p23:GetAttribute("InputName")

                            if InputName then
                                if p24 == "added" then
                                    p21._abilitiesByInputName[InputName] = p23

                                    for v26, v27 in p21._abilityChangedEvents do
                                        if v27[InputName] then
                                            p21:_hookUpAbilityChangedEvent(InputName, v26)
                                        end
                                    end
                                elseif p21._abilitiesByInputName[InputName] == p23 then
                                    p21._abilitiesByInputName[InputName] = nil

                                    for _, v28 in p21._abilityChangedConnections do
                                        local v29 = v28[InputName]

                                        if v29 then
                                            v29:Disconnect()
                                            v28[InputName] = nil
                                        end
                                    end
                                end

                                p21._abilitiesChangedEvent:Fire()
                            end
                        end)
                        p21._abilitiesByInputName = createAbilitiesByInputNameTable(v25)
                        p21._abilitiesChangedEvent:Fire()

                        for v30, v31 in p21._abilityChangedEvents do
                            for v32, v33 in v31 do
                                v33:Fire()
                                p21:_hookUpAbilityChangedEvent(v32, v30)
                            end
                        end
                    end

                    p21._enabledChangedEvent:Fire()
                end

                p21._evaluateStateMachineChangedConnection = p21._humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function() -- line: 370
                    -- upvalues: enabledChanged (copy)
                    enabledChanged()
                end)
                enabledChanged()
            end)
        end
    end

    function t2.isEnabled(p25) -- line: 377
        return p25._humanoid ~= nil and not p25._humanoid.EvaluateStateMachine
    end

    function t2.GetEnabledChangedSignal(p26) -- line: 381
        return p26._enabledChangedEvent.Event
    end

    function t2.SendInput(p27, p28, p29) -- line: 385
        if p27:isEnabled() and p29 ~= p27._data[p28] then
            p27._data[p28] = p29
            p27._avatarAbilities().setAbilityManagerCommand(p27._character, p28, p29)
        end
    end

    function t2.GetAbilityAttribute(p30, p31, p32, p33) -- line: 396
        local v34 = p30._abilitiesByInputName[p31]

        if not v34 then
            return p33
        end

        local SyncedState = v34:FindFirstChild("SyncedState")

        if not SyncedState then
            return p33
        end

        local Attribute = SyncedState:GetAttribute(p32)

        if Attribute == nil then
            return p33
        end

        return Attribute
    end

    function t2.GetAbilityAttributeChangedSignal(p34, p35, p36) -- line: 412
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

    function t2.GetAbilityUIState(p37, p38) -- line: 428
        return p37:GetAbilityAttribute(p38, "UIState", nil)
    end

    function t2.GetAbilityUIStateChangedSignal(p39, p40) -- line: 432
        return p39:GetAbilityAttributeChangedSignal(p40, "UIState")
    end

    if not UserAbilitiesUserInterfaceD then
        function t2.GetAbilityActive(p41, p42) -- line: 437
            return p41:GetAbilityAttribute(p42, "Active", false)
        end

        function t2.GetAbilityActiveChangedSignal(p43, p44) -- line: 441
            return p43:GetAbilityAttributeChangedSignal(p44, "Active")
        end

        function t2.GetAbilityValid(p45, p46) -- line: 445
            return p45:GetAbilityAttribute(p46, "IsValid", true)
        end

        function t2.GetAbilityValidChangedSignal(p47, p48) -- line: 449
            return p47:GetAbilityAttributeChangedSignal(p48, "IsValid")
        end
    end

    function t2.GetAbilities(p49) -- line: 454
        local t6 = {}

        for v35 in p49._abilitiesByInputName do
            table.insert(t6, v35)
        end

        return t6
    end

    function t2.GetAbilitiesChangedSignal(p50) -- line: 462
        return p50._abilitiesChangedEvent.Event
    end

    function t2.GetAbilityConfig(p51, p52) -- line: 466
        local t7 = {
            Slot = -1
        }
        local v36 = p51._abilitiesByInputName[p52]

        if v36 then
            local ActionSlot = v36:GetAttribute("ActionSlot")

            if ActionSlot then
                return {
                    Slot = tonumber(ActionSlot),
                    ButtonAssetId = v36:GetAttribute("CustomIcon"),
                    ButtonPressedAssetId = v36:GetAttribute("CustomIconActive"),
                    ButtonInvalidAssetId = v36:GetAttribute("CustomIconInvalid")
                }
            end
        end

        return t7
    end

    function t2.destroy(p53) -- line: 492
        if p53._characterAddedConnection then
            p53._characterAddedConnection:Disconnect()
            p53._characterAddedConnection = nil
        end

        if p53._evaluateStateMachineChangedConnection then
            p53._evaluateStateMachineChangedConnection:Disconnect()
            p53._evaluateStateMachineChangedConnection = nil
        end

        if p53._disconnectAbilitiesChanged then
            p53._disconnectAbilitiesChanged()
            p53._disconnectAbilitiesChanged = nil
        end

        for _, v37 in p53._abilityChangedConnections do
            for _, v38 in v37 do
                v38:Disconnect()
            end
        end

        p53._abilityChangedConnections = {}
    end

    return t2
end

local Players2 = game:GetService("Players")
local t8 = {}
local AbilityManagerActor, Humanoid
local BindableEvent = Instance.new("BindableEvent")
local connection
local v39 = false

local function characterAdded(p54) -- line: 524
    -- upvalues: AbilityManagerActor (ref), Humanoid (ref), BindableEvent (copy), connection (ref)
    AbilityManagerActor = nil
    Humanoid = nil

    if connection then
        connection:Disconnect()
        connection = nil
    end

    if not p54 then
        return
    end

    AbilityManagerActor = p54:FindFirstChild("AbilityManagerActor")
    Humanoid = p54:FindFirstChildOfClass("Humanoid")

    while not Humanoid do
        p54.ChildAdded:wait()
        Humanoid = p54:FindFirstChildOfClass("Humanoid")
    end

    BindableEvent:Fire()
    connection = Humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function() -- line: 543
        -- upvalues: BindableEvent (copy)
        BindableEvent:Fire()
    end)
end

local function lazyInit() -- line: 549
    -- upvalues: Players2 (copy), v39 (ref), characterAdded (copy)
    if v39 then
        return
    end

    v39 = true

    local LocalPlayer = Players2.LocalPlayer

    if LocalPlayer then
        LocalPlayer.characterAdded:Connect(characterAdded)

        if LocalPlayer.Character then
            characterAdded(LocalPlayer.Character)
        end
    end
end

function t8.isEnabled() -- line: 564
    -- upvalues: Players2 (copy), AbilityManagerActor (ref), Humanoid (ref), v39 (ref), characterAdded (copy)
    if not v39 then
        v39 = true

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

function t8.GetEnabledChangedSignal() -- line: 569
    -- upvalues: Players2 (copy), BindableEvent (copy), v39 (ref), characterAdded (copy)
    if v39 then
        return BindableEvent.Event
    end

    v39 = true

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
