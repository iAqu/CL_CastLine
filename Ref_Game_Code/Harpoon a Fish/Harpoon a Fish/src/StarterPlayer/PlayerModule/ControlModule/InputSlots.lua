-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local FlagUtil = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

UserSettings():GetService("UserGameSettings")

local UserInputService = game:GetService("UserInputService")
local InputReplication = require(script.Parent:WaitForChild("InputReplication"))
local v1 = require(script.Parent:WaitForChild("AvatarAbilitiesInterface")).get(Players.LocalPlayer)
local v2 = FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2") or FlagUtil.getUserFlag("UserPlayerScriptsPlayerControlState2GA")
local UserAbilitiesUserInterfaceB = FlagUtil.getUserFlag("UserAbilitiesUserInterfaceB")
local UserPSUseBindToAnimation = FlagUtil.getUserFlag("UserPSUseBindToAnimation")
local v3 = if UserAbilitiesUserInterfaceB then "ControlState" else "PlayerControlState"
local t1 = {}

t1.__index = t1

local t2 = {}
local t3 = {}
local t4 = {}
local n1 = 0
local t5 = {}
local t6 = {}
local t7 = {}
local BindableEvent = Instance.new("BindableEvent")
local n2 = 0
local BindableEvent2 = Instance.new("BindableEvent")

local function shallow_equal(p1, p2) -- line: 44
    if p1 == p2 then
        return true
    end

    for v4, v5 in p1 do
        if p2[v4] ~= v5 then
            return false
        end
    end

    for v6, _ in p2 do
        if p1[v6] == nil then
            return false
        end
    end

    return true
end

local function findInSparseTable(p3, p4) -- line: 61
    for v7, v8 in p3 do
        if v8 == p4 then
            return v7
        end
    end

    return nil
end

local t8 = {
    "ButtonAssetId",
    "ButtonPressedAssetId",
    "ButtonInvalidAssetId"
}

local function updateAbilityActionMetadata() -- line: 72
    -- upvalues: v1 (copy), t2 (copy), t5 (copy), t6 (copy), t8 (copy)
    for i = 1, 11 do
        local v9 = t5[i]

        if v9 then
            local v10 = t2[i]
            local v11 = v10 ~= nil and v10 ~= ""
            local v12, v13

            if v11 then
                v13 = v10
                v12 = v1:GetAbilityConfig(v10)
            else
                v13 = ""
            end

            local function updateAction(p5) -- line: 81
                -- upvalues: v11 (copy), v12 (ref), v13 (ref), t8 (copy)
                p5.Enabled = v11
                p5.DisplayName = v13

                for _, v14 in t8 do
                    local v15 = if v12 then v12[v14] else nil

                    if type(v15) ~= "string" then
                        v15 = ""
                    end

                    p5:SetAttribute(v14, v15)
                end
            end

            updateAction(v9)

            local v16 = t6[i]

            if v16 and v16 ~= v9 then
                updateAction(v16)
            end
        end
    end
end

function t1.GetNumAbilitySlots() -- line: 102
    return 11
end

function t1.GetNumOverflowSlots() -- line: 106
    return 3
end

function t1.getOverflowScrollIndex() -- line: 110
    -- upvalues: n2 (ref)
    return n2
end

function t1.setOverflowScrollIndex(p6) -- line: 114
    -- upvalues: t3 (ref), n2 (ref), BindableEvent2 (copy)
    local v17 = n2

    n2 = math.max(0, (math.min(#t3 - 3, p6)))

    if n2 ~= v17 then
        BindableEvent2:Fire()
    end
end

function t1.getScrollIndexChangedEvent() -- line: 122
    -- upvalues: BindableEvent2 (copy)
    return BindableEvent2.Event
end

function t1.setupSlotActions(p7, p8, p9) -- line: 126
    -- upvalues: StarterPlayer (copy), RunService (copy), UserInputService (copy), InputReplication (copy), v1 (copy), UserAbilitiesUserInterfaceB (copy), UserPSUseBindToAnimation (copy), t1 (copy), t2 (copy), t3 (ref), t4 (copy), n1 (ref), t5 (copy), t6 (copy), t7 (copy), BindableEvent (copy), n2 (ref), updateAbilityActionMetadata (copy), v3 (copy), v2 (copy)
    local function getAbilityAction(p10) -- line: 127
        -- upvalues: p7 (copy), p8 (ref), v2 (copy)
        if p10 then
            local InputContexts = if not v2 or p8 then p7:FindFirstChild("InputContexts") else script.Parent.Parent:FindFirstChild("InputContexts")

            if InputContexts then
                local CharacterContext = InputContexts:FindFirstChild("CharacterContext")

                if CharacterContext then
                    return (CharacterContext:FindFirstChild(p10 .. "Action"))
                end
            end
        end

        return nil
    end

    if not v2 then
        if UserPSUseBindToAnimation then
            RunService:BindToAnimation(function(_) -- line: 148
                -- upvalues: p7 (copy), InputReplication (copy), v1 (copy)
                if v1:isEnabled() then
                    InputReplication.FireCustomInputs(p7)
                    InputReplication.SendInputToCCLCharacter(p7)
                end
            end, Enum.StepFrequency.Hz60)
        else
            RunService:BindToSimulation(function(_) -- line: 155
                -- upvalues: p7 (copy), InputReplication (copy), v1 (copy)
                if v1:isEnabled() then
                    InputReplication.FireCustomInputs(p7)
                    InputReplication.SendInputToCCLCharacter(p7)
                end
            end, Enum.StepFrequency.Hz60)
        end
    end

    local t9 = {}

    local function updateSlotMap() -- line: 166
        -- upvalues: t9 (copy), StarterPlayer (copy), UserInputService (copy), v1 (copy), t1 (copy), t2 (copy), t3 (ref), t4 (copy), n1 (ref), BindableEvent (copy), updateAbilityActionMetadata (copy)
        local v20 = table.clone(t2)
        local v21 = table.clone(t3)
        local Abilities = v1:GetAbilities()
        local v22 = if UserInputService.PreferredInput == Enum.PreferredInput.Touch then 7 else 11

        for v23, v24 in t2 do
            local v25 = false
            local v26

            for v27, v28 in Abilities do
                if v28 == v24 then
                    v26 = v27
                    v25 = true
                    break
                end
            end

            if not v25 then
                v26 = nil
            end

            if not v26 or v22 < v23 then
                t2[v23] = nil
            end
        end

        t3 = {}

        local t10 = {}

        for _, v29 in Abilities do
            local v30 = false
            local v31

            for v32, v33 in t2 do
                if v33 == v29 then
                    v31 = v32
                    v30 = true
                    break
                end
            end

            if not v30 then
                v31 = nil
            end

            if not v31 then
                table.insert(t10, v29)
            end
        end

        local AbilitySlotConflictFifo = StarterPlayer:FindFirstChild("AbilitySlotConflictFifo")
        local v34 = AbilitySlotConflictFifo ~= nil and AbilitySlotConflictFifo:IsA("BoolValue") and AbilitySlotConflictFifo.Value

        for _, v35 in t10 do
            local AbilityConfig = v1:GetAbilityConfig(v35)

            if AbilityConfig then
                local v36 = tonumber(AbilityConfig.Slot)

                if v36 > 0 then
                    local v37 = t2[v36]
                    local v38 = false
                    local v39

                    for v40, v41 in v20 do
                        if v41 == v35 then
                            v39 = v40
                            v38 = true
                            break
                        end
                    end

                    if not v38 then
                        v39 = nil
                    end

                    local v42 = not v39 and not table.find(v21, v35)

                    if not (v36 <= v22) or v37 then
                        if v36 <= v22 and v34 and v42 then
                            table.insert(t3, v37)
                            t2[v36] = v35
                        else
                            table.insert(t3, v35)
                        end
                    else
                        t2[v36] = v35
                    end
                end
            end
        end

        for _, v43 in t10 do
            local AbilityConfig = v1:GetAbilityConfig(v43)

            if AbilityConfig and tonumber(AbilityConfig.Slot) == 0 then
                local v44 = t9[v43]

                if v44 then
                    if not (v44 <= v22) or t2[v44] then
                        table.insert(t3, v43)
                    else
                        t2[v44] = v43
                    end
                else
                    local n3 = -1

                    for i = 1, v22 do
                        if not t2[i] then
                            n3 = i
                            break
                        end
                    end

                    if n3 == -1 then
                        table.insert(t3, v43)
                    else
                        t2[n3] = v43
                        t9[v43] = n3
                    end
                end
            end
        end

        local t18 = {}

        for _, v45 in t3 do
            t18[v45] = true

            if t4[v45] == nil then
                n1 += 1
                t4[v45] = n1
            end
        end

        for v46 in t4 do
            if not t18[v46] then
                t4[v46] = nil
            end
        end

        table.sort(t3, function(p13, p14) -- line: 263
            -- upvalues: t4 (copy)
            return t4[p13] < t4[p14]
        end)

        local t19 = t3
        local v47

        if t19 == v21 then
            v47 = true
        else
            local v48 = false

            for v49, v50 in t19 do
                if v21[v49] ~= v50 then
                    v47 = false
                    v48 = true
                    break
                end
            end

            if not v48 then
                local v51 = false

                for v52, _ in v21 do
                    if t19[v52] == nil then
                        v47 = false
                        v51 = true
                        break
                    end
                end

                if not v51 then
                    v47 = true
                end
            end
        end

        local v53 = not v47

        if v53 then
            t1.setOverflowScrollIndex(#t3 - 3)
        else
            t1.setOverflowScrollIndex(t1.getOverflowScrollIndex())
        end

        local v54

        if t2 == v20 then
            v54 = true
        else
            local v55 = false

            for v56, v57 in t2 do
                if v20[v56] ~= v57 then
                    v54 = false
                    v55 = true
                    break
                end
            end

            if not v55 then
                local v58 = false

                for v59, _ in v20 do
                    if t2[v59] == nil then
                        v54 = false
                        v58 = true
                        break
                    end
                end

                if not v58 then
                    v54 = true
                end
            end
        end

        if not v54 or v53 then
            updateAbilityActionMetadata()
            BindableEvent:Fire()
        end
    end

    v1:GetAbilitiesChangedSignal():Connect(updateSlotMap)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(updateSlotMap)
    updateSlotMap()

    local function UpdateAbilityInPCS(p15, p16, p17) -- line: 285
        -- upvalues: UserAbilitiesUserInterfaceB (copy), v3 (copy)
        local Character = p15.Character

        if Character then
            local v60 = if UserAbilitiesUserInterfaceB then Character:FindFirstChildOfClass(v3) else Character:FindFirstChild(v3)

            if v60 then
                v60:UpdateFields({
                    [p16] = p17
                })
            end
        end
    end

    local t20 = {}
    local t21 = {}

    local function resolveHeldAbility(p18, p19, p20, p21) -- line: 306
        if p21 then
            p18[p19] = p20

            return p20
        end

        local v61 = p18[p19]

        p18[p19] = nil

        if v61 == nil then
            return p20
        end

        return v61
    end

    local t22 = {}
    local n4 = 0

    local function resolveAndWireActions() -- line: 318
        -- upvalues: p7 (copy), p8 (ref), getAbilityAction (copy), UpdateAbilityInPCS (copy), t20 (copy), t21 (copy), t22 (copy), n4 (ref), t2 (copy), t3 (ref), t5 (copy), t6 (copy), t7 (copy), BindableEvent (copy), n2 (ref), updateAbilityActionMetadata (copy), v2 (copy)
        n4 += 1

        local v62 = n4

        for _, v63 in t22 do
            v63:Disconnect()
        end

        table.clear(t22)

        local CharacterContext = (if not v2 or p8 then p7:WaitForChild("InputContexts", 1e999) else script.Parent.Parent:WaitForChild("InputContexts", 1e999)):WaitForChild("CharacterContext")

        if v62 ~= n4 then
            return
        end

        local InputContexts = script.Parent.Parent:FindFirstChild("InputContexts")
        local CharacterContext2 = InputContexts and InputContexts:FindFirstChild("CharacterContext")

        for i = 1, 11 do
            local v64 = CharacterContext:WaitForChild("AbilityAction" .. tostring(i))

            if v62 ~= n4 then
                return
            end

            t5[i] = v64
            t6[i] = if CharacterContext2 then CharacterContext2:FindFirstChild("AbilityAction" .. tostring(i)) else nil
            table.insert(t22, v64.StateChanged:Connect(function(p22) -- line: 352
                -- upvalues: i (copy), p7 (copy), getAbilityAction (copy), UpdateAbilityInPCS (copy), t20 (copy), t2 (copy), v2 (copy)
                local v67 = t2[i]

                if p22 then
                    t20[i] = v67
                else
                    local v68 = t20[i]

                    t20[i] = nil

                    if v68 ~= nil then
                        v67 = v68
                    end
                end

                if v2 then
                    if v67 ~= nil and v67 ~= "" then
                        UpdateAbilityInPCS(p7, v67, p22)
                    end
                else
                    local v69 = getAbilityAction(v67)

                    if v69 then
                        local ScriptableBinding = v69:FindFirstChild("ScriptableBinding")

                        if ScriptableBinding then
                            ScriptableBinding:Fire(p22)
                        end
                    end
                end
            end))
        end

        updateAbilityActionMetadata()

        if v2 then
            for i = 1, 3 do
                local v70 = CharacterContext:WaitForChild("OverflowAction" .. tostring(i))

                if v62 ~= n4 then
                    return
                end

                t7[i] = v70
                table.insert(t22, v70.StateChanged:Connect(function(p23) -- line: 382
                    -- upvalues: i (copy), p7 (copy), UpdateAbilityInPCS (copy), t21 (copy), t3 (ref), n2 (ref)
                    local v72 = t3[i + n2]

                    if p23 then
                        t21[i] = v72
                    else
                        local v73 = t21[i]

                        t21[i] = nil

                        if v73 ~= nil then
                            v72 = v73
                        end
                    end

                    if v72 ~= nil and v72 ~= "" then
                        UpdateAbilityInPCS(p7, v72, p23)
                    end
                end))
            end
        end

        BindableEvent:Fire()
    end

    task.spawn(resolveAndWireActions)

    if p9 then
        p9:subscribe("SERVER_AUTHORITY_CHANGED"):Connect(function(p24) -- line: 403
            -- upvalues: p8 (ref), resolveAndWireActions (copy)
            if p24 ~= p8 then
                p8 = p24
                task.spawn(resolveAndWireActions)
            end
        end)
    end
end

function t1.GetSlotMapChangedSignal() -- line: 413
    -- upvalues: BindableEvent (copy)
    return BindableEvent.Event
end

function t1.GetSlotMap() -- line: 417
    -- upvalues: t2 (copy)
    return t2
end

function t1.GetAbilitiesInOverflow() -- line: 421
    -- upvalues: t3 (ref)
    return t3
end

function t1.GetActionInSlot(p25) -- line: 425
    -- upvalues: t5 (copy)
    return t5[p25]
end

function t1.GetOverflowAction(p26) -- line: 429
    -- upvalues: t7 (copy)
    return t7[p26]
end

return t1
