-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")

game:GetService("StarterPlayer")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

UserSettings():GetService("UserGameSettings")

local UserInputService = game:GetService("UserInputService")
local InputReplication = require(script.Parent:WaitForChild("InputReplication"))
local v1 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface")).get(Players.LocalPlayer)
local UserPlayerScriptsPlayerControlState2 = FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2")
local UserAbilitiesUserInterfaceB = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceB")
local UserPSUseBindToAnimation = FlagUtil.getUserFlag("UserPSUseBindToAnimation")
local v2 = if UserAbilitiesUserInterfaceB then "ControlState" else "PlayerControlState"
local t1 = {}

t1.__index = t1

local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local BindableEvent = Instance.new("BindableEvent")
local n1 = 0
local BindableEvent2 = Instance.new("BindableEvent")

local function shallow_equal(p1, p2) -- line: 33
    if p1 == p2 then
        return true
    end

    for v3, v4 in pairs(p1) do
        if p2[v3] ~= v4 then
            return false
        end
    end

    for v5, _ in pairs(p2) do
        if p1[v5] == nil then
            return false
        end
    end

    return true
end

local function findInSparseTable(p3, p4) -- line: 40
    for v6, v7 in pairs(p3) do
        if v7 == p4 then
            return v6
        end
    end

    return nil
end

function t1.GetNumOverflowSlots() -- line: 49
    return 3
end

function t1.getOverflowScrollIndex() -- line: 53
    -- upvalues: n1 (ref)
    return n1
end

function t1.setOverflowScrollIndex(p5) -- line: 57
    -- upvalues: t3 (ref), n1 (ref), BindableEvent2 (copy)
    local v8 = n1

    n1 = math.max(0, (math.min(#t3 - 3, p5)))

    if n1 ~= v8 then
        BindableEvent2:Fire()
    end
end

function t1.getScrollIndexChangedEvent() -- line: 65
    -- upvalues: BindableEvent2 (copy)
    return BindableEvent2.Event
end

function t1.setupSlotActions(p6, p7) -- line: 69
    -- upvalues: RunService (copy), UserInputService (copy), InputReplication (copy), v1 (copy), UserPlayerScriptsPlayerControlState2 (copy), UserAbilitiesUserInterfaceB (copy), UserPSUseBindToAnimation (copy), t1 (copy), t2 (copy), t3 (ref), t4 (copy), t5 (copy), BindableEvent (copy), n1 (ref), shallow_equal (copy), v2 (copy)
    local function getAbilityAction(p8) -- line: 70
        -- upvalues: p6 (copy), p7 (copy), UserPlayerScriptsPlayerControlState2 (copy)
        if p8 then
            local InputContexts = if not UserPlayerScriptsPlayerControlState2 or p7 then p6:FindFirstChild("InputContexts") else script.Parent.Parent:FindFirstChild("InputContexts")

            if InputContexts then
                local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

                if CharacterContext then
                    return (CharacterContext:FindFirstChild(p8 .. "Action"))
                end
            end
        end

        return nil
    end

    if not UserPlayerScriptsPlayerControlState2 then
        if UserPSUseBindToAnimation then
            RunService:BindToAnimation(function(_) -- line: 85
                -- upvalues: p6 (copy), InputReplication (copy), v1 (copy)
                if v1:isEnabled() then
                    InputReplication.FireCustomInputs(p6)
                    InputReplication.SendInputToCCLCharacter(p6)
                end
            end, Enum.StepFrequency.Hz60)
        else
            RunService:BindToSimulation(function(_) -- line: 92
                -- upvalues: p6 (copy), InputReplication (copy), v1 (copy)
                if v1:isEnabled() then
                    InputReplication.FireCustomInputs(p6)
                    InputReplication.SendInputToCCLCharacter(p6)
                end
            end, Enum.StepFrequency.Hz60)
        end
    end

    local t6 = {}

    local function updateSlotMap() -- line: 103
        -- upvalues: t6 (copy), UserInputService (copy), v1 (copy), t1 (copy), t2 (copy), t3 (ref), BindableEvent (copy), shallow_equal (copy)
        local v11 = table.clone(t2)
        local v12 = table.clone(t3)
        local Abilities = v1:GetAbilities()
        local v13 = if UserInputService.PreferredInput == Enum.PreferredInput.Touch then 7 else 11

        for v14, v15 in pairs(t2) do
            local v16 = false
            local v17

            for v18, v19 in pairs(Abilities) do
                if v19 == v15 then
                    v17 = v18
                    v16 = true
                    break
                end
            end

            if not v16 then
                v17 = nil
            end

            if not v17 or v13 < v14 then
                t2[v14] = nil
            end
        end

        t3 = {}

        local t7 = {}

        for _, v20 in ipairs(Abilities) do
            local v21 = false
            local v22

            for v23, v24 in pairs(t2) do
                if v24 == v20 then
                    v22 = v23
                    v21 = true
                    break
                end
            end

            if not v21 then
                v22 = nil
            end

            if not v22 then
                table.insert(t7, v20)
            end
        end

        for _, v25 in ipairs(t7) do
            local AbilityConfig = v1:GetAbilityConfig(v25)

            if AbilityConfig then
                local v26 = tonumber(AbilityConfig.Slot)

                if v26 > 0 then
                    if t2[v26] then
                        table.insert(t3, v25)
                    elseif v26 <= v13 then
                        t2[v26] = v25
                    else
                        table.insert(t3, v25)
                    end
                end
            end
        end

        for _, v27 in ipairs(t7) do
            local AbilityConfig = v1:GetAbilityConfig(v27)

            if AbilityConfig and tonumber(AbilityConfig.Slot) == 0 then
                local v28 = t6[v27]

                if not v28 or not (v28 > 0) or not (v28 <= v13) or t2[v28] then
                    local n3 = -1

                    for j = 1, v13 do
                        if not t2[j] then
                            n3 = j
                            break
                        end
                    end

                    if n3 == -1 then
                        table.insert(t3, v27)
                    else
                        t2[n3] = v27
                        t6[v27] = n3
                    end
                else
                    t2[v28] = v27
                end
            end
        end

        t1.setOverflowScrollIndex(t1.getOverflowScrollIndex())

        if not (shallow_equal(t2, v11) and shallow_equal(t3, v12)) then
            BindableEvent:Fire()
        end
    end

    v1:GetAbilitiesChangedSignal():Connect(updateSlotMap)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(updateSlotMap)
    updateSlotMap()
    task.spawn(function() -- line: 186
        -- upvalues: p6 (copy), p7 (copy), getAbilityAction (copy), UserPlayerScriptsPlayerControlState2 (copy), UserAbilitiesUserInterfaceB (copy), t2 (copy), t3 (ref), t4 (copy), t5 (copy), n1 (ref), v2 (copy)
        local function UpdateAbilityInPCS(p11, p12, p13) -- line: 187
            -- upvalues: UserAbilitiesUserInterfaceB (copy), v2 (copy)
            local Character = p11.Character

            if Character then
                local v29 = if UserAbilitiesUserInterfaceB then Character:FindFirstChildOfClass(v2) else Character:FindFirstChild(v2)

                if v29 then
                    v29:UpdateFields({
                        [p12] = p13
                    })
                end
            end
        end

        local CharacterContext = (if not UserPlayerScriptsPlayerControlState2 or p7 then p6:WaitForChild("InputContexts", 1e999) else script.Parent.Parent:FindFirstChild("InputContexts")):WaitForChild("CharacterContext")

        for i = 1, 11 do
            local v30 = CharacterContext:WaitForChild("AbilityAction" .. tostring(i))

            t4[i] = v30
            v30.StateChanged:Connect(function(p14) -- line: 208
                -- upvalues: UpdateAbilityInPCS (copy), i (copy), p6 (copy), getAbilityAction (copy), UserPlayerScriptsPlayerControlState2 (copy), t2 (copy)
                if UserPlayerScriptsPlayerControlState2 then
                    if t2[i] ~= nil and t2[i] ~= "" then
                        UpdateAbilityInPCS(p6, t2[i], p14)
                    end
                else
                    local v31 = getAbilityAction(t2[i])

                    if v31 then
                        local ScriptableBinding = v31:FindFirstChild("ScriptableBinding")

                        if ScriptableBinding then
                            ScriptableBinding:Fire(p14)
                        end
                    end
                end
            end)
        end

        if UserPlayerScriptsPlayerControlState2 then
            for i = 1, 3 do
                local v32 = CharacterContext:WaitForChild("OverflowAction" .. tostring(i))

                t5[i] = v32
                v32.StateChanged:Connect(function(p15) -- line: 229
                    -- upvalues: UpdateAbilityInPCS (copy), i (copy), p6 (copy), t3 (ref), n1 (ref)
                    local v33 = t3[i + n1]

                    if v33 ~= nil and v33 ~= "" then
                        UpdateAbilityInPCS(p6, v33, p15)
                    end
                end)
            end
        end
    end)
end

function t1.GetSlotMapChangedSignal() -- line: 240
    -- upvalues: BindableEvent (copy)
    return BindableEvent.Event
end

function t1.GetSlotMap() -- line: 244
    -- upvalues: t2 (copy)
    return t2
end

function t1.GetAbilitiesInOverflow() -- line: 248
    -- upvalues: t3 (ref)
    return t3
end

function t1.GetActionInSlot(p16) -- line: 252
    -- upvalues: t4 (copy)
    return t4[p16]
end

function t1.GetOverflowAction(p17) -- line: 256
    -- upvalues: t5 (copy)
    return t5[p17]
end

return t1
