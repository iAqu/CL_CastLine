-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useState = react.useState
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "training-boost-atom")
local trainingIsFrenzyAtom, latestTrainingPowerFlyIdAtom = v1.trainingIsFrenzyAtom, v1.latestTrainingPowerFlyIdAtom
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "network").functions
local v2 = RuntimeLib.import(script, script.Parent, "stat-display")
local default, PowerFlyItem = v2.default, v2.PowerFlyItem
local useRootSelector = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "reflex").useRootSelector
local selectors = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors")
local selectPlayerStat, selectActiveRodPowerCap = selectors.selectPlayerStat, selectors.selectActiveRodPowerCap
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "utils").localPlayerUserId
local n1 = 0

return {
    default = function(p1) -- PowerFeedback | line: 21
        -- upvalues: react (copy), useState (copy), trainingIsFrenzyAtom (copy), latestTrainingPowerFlyIdAtom (copy), functions (copy), default (copy), PowerFlyItem (copy), useRootSelector (copy), selectPlayerStat (copy), selectActiveRodPowerCap (copy), localPlayerUserId (copy), n1 (ref)
        local isCelebrationPlace = p1.isCelebrationPlace

        if isCelebrationPlace == nil then
            isCelebrationPlace = false
        end

        local isTraining = p1.isTraining
        local v3 = useRootSelector(selectPlayerStat(localPlayerUserId, "power"))

        if v3 == nil then
            v3 = 0
        end

        local v4 = useRootSelector(selectActiveRodPowerCap(localPlayerUserId))
        local v5 = useRootSelector(selectPlayerStat(localPlayerUserId, "money"))
        local v6, v7 = useState({})
        local v8, v9 = useState(0)

        local function v10(p2) -- line: 36
            -- upvalues: isTraining (copy), v7 (copy), trainingIsFrenzyAtom (copy), latestTrainingPowerFlyIdAtom (copy), n1 (ref)
            local v11 = n1

            n1 += 1

            if isTraining then
                latestTrainingPowerFlyIdAtom(v11)
            end

            local v12 = if isTraining then trainingIsFrenzyAtom() else false

            v7(function(p3) -- line: 45
                -- upvalues: p2 (copy), v11 (copy), v12 (copy), isTraining (copy)
                local t1 = {}
                local v13 = #t1
                local v14 = #p3

                table.move(p3, 1, v14, v13 + 1, t1)
                t1[v13 + v14 + 1] = {
                    id = v11,
                    amount = p2,
                    isTraining = isTraining,
                    isFrenzy = v12
                }

                return t1
            end)
        end

        local function v15(p4) -- line: 60
            -- upvalues: v7 (copy)
            v7(function(p5) -- line: 61
                -- upvalues: p4 (copy)
                local t2 = {}
                local n2 = 0

                for v16, v17 in p5 do
                    local _ = v16 - 1

                    if v17.id ~= p4 == true then
                        n2 += 1
                        t2[n2] = v17
                    end
                end

                return t2
            end)
        end

        local function v18(_) -- line: 78
            -- upvalues: functions (copy)
            functions.trainingSkillcheckBonus()
        end

        local v19 = v5 ~= nil

        if v19 then
            local t3 = {
                money = if v5 == nil then 0 else v5,
                onPowerAdded = v10,
                power = v3,
                powerBounceTrigger = v8,
                powerCap = v4,
                variant = isCelebrationPlace and "celebration" or "default"
            }

            v19 = react.createElement(default, t3)
        end

        local v20 = table.create(#v6)

        local function v21(p7) -- line: 98
            -- upvalues: v9 (copy), v15 (copy), v18 (copy), react (copy), PowerFlyItem (copy)
            return react.createElement(PowerFlyItem, {
                amount = p7.amount,
                id = if p7.isTraining then p7.id else nil,
                isFrenzy = if p7.isTraining then p7.isFrenzy else nil,
                key = tostring(p7.id),
                onArrive = function() -- onArrive | line: 104
                    -- upvalues: v9 (copy)
                    return v9(function(p8) -- line: 105
                        return p8 + 1
                    end)
                end,
                onIntercepted = if p7.isTraining then v18 else nil,
                onRemove = function() -- onRemove | line: 110
                    -- upvalues: p7 (copy), v15 (copy)
                    return v15(p7.id)
                end
            })
        end

        for v22, v23 in v6 do
            v20[v22] = v21(v23, v22 - 1, v6)
        end

        return react.createElement("canvasgroup", {
            BackgroundTransparency = 1,
            GroupTransparency = 0,
            Size = UDim2.fromScale(1, 1)
        }, v19, v20)
    end
}
