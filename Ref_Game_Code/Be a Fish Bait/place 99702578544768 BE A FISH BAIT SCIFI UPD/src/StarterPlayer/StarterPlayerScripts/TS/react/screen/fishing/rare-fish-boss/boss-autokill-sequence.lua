-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useBinding, useEffect = react.useBinding, react.useEffect
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService
local useConfig = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "context", "config-context").useConfig
local vfx = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent.Parent, "vfx")
local playClonedSound, playClonedVfxAtCFrame = vfx.playClonedSound, vfx.playClonedVfxAtCFrame
local default = RuntimeLib.import(script, script.Parent.Parent, "rare-fish-skillcheck-countdown").default
local bossAutokillTuning = RuntimeLib.import(script, script.Parent, "boss-config").bossAutokillTuning

return {
    default = function(p1) -- BossAutokillSequence | line: 14
        -- upvalues: react (copy), useBinding (copy), useEffect (copy), RunService (copy), useConfig (copy), playClonedSound (copy), playClonedVfxAtCFrame (copy), default (copy), bossAutokillTuning (copy)
        local onComplete, onSuccessCutscene, getVfxCFrame, startDelayMs = p1.onComplete, p1.onSuccessCutscene, p1.getVfxCFrame, p1.startDelayMs
        local v1 = startDelayMs

        if startDelayMs == nil then
            v1 = 0
        end

        local getSound = useConfig().getSound
        local v2, v3 = react.useState(bossAutokillTuning.countdownSteps[1])
        local v4, v5 = useBinding(0.45)
        local v6 = useBinding(0)

        useEffect(function() -- line: 27
            -- upvalues: onComplete (copy), onSuccessCutscene (copy), getVfxCFrame (copy), v1 (ref), getSound (copy), v3 (copy), v5 (copy), RunService (copy), playClonedSound (copy), playClonedVfxAtCFrame (copy), bossAutokillTuning (copy)
            local v7 = true
            local v8 = false
            local connection, v9, v10

            local function v11() -- line: 33
                -- upvalues: v7 (ref), v8 (ref), connection (ref), v9 (ref), v10 (ref), onComplete (copy), onSuccessCutscene (copy), getVfxCFrame (copy), getSound (copy), v3 (copy), v5 (copy), RunService (copy), playClonedSound (copy), playClonedVfxAtCFrame (copy), bossAutokillTuning (copy)
                if not v7 then
                    return nil
                end

                v10 = getSound("3-2-1Countdown")

                local function v12() -- line: 38
                    -- upvalues: v10 (ref)
                    local v13 = v10

                    if v13 ~= nil then
                        v13 = v13:Play()
                    end

                    return v13
                end

                pcall(v12)

                local n1 = 0
                local n2 = 0

                connection = RunService.Heartbeat:Connect(function(p2) -- line: 47
                    -- upvalues: n1 (ref), n2 (ref), v7 (ref), v8 (ref), connection (ref), v9 (ref), v10 (ref), onComplete (copy), onSuccessCutscene (copy), getVfxCFrame (copy), v3 (copy), v5 (copy), playClonedSound (copy), playClonedVfxAtCFrame (copy), bossAutokillTuning (copy)
                    if not v7 then
                        return nil
                    end

                    n1 += p2 * 1000

                    local v16 = n1
                    local v17 = math.floor(v16 / bossAutokillTuning.countdownStepMs)
                    local v18, v19

                    if v17 ~= n2 and v17 < #bossAutokillTuning.countdownSteps then
                        n2 = v17
                        v3(bossAutokillTuning.countdownSteps[n2 + 1])
                        v18 = v5
                        v19 = if n2 == 3 then 0.6 else 0.45
                        v18(v19)
                    end

                    local v20 = n2 >= 3

                    v20 = v20 and n1 >= bossAutokillTuning.countdownStepMs * 3 + bossAutokillTuning.goDurationMs

                    if not v20 then
                        return
                    end

                    local connection2 = connection

                    if connection2 ~= nil then
                        connection2:Disconnect()
                    end

                    if v8 then
                        return nil
                    end

                    v8 = true
                    v3("")

                    local function v22() -- line: 68
                        -- upvalues: v10 (ref)
                        local v23 = v10

                        if v23 ~= nil then
                            v23 = v23:Stop()
                        end

                        return v23
                    end

                    pcall(v22)

                    local v24 = getVfxCFrame

                    if getVfxCFrame ~= nil then
                        v24 = getVfxCFrame()
                    end

                    local v25 = `[BossAutokill] presentation vfxTargetExists={ v24 ~= nil } `
                    local vfxName = bossAutokillTuning.vfxName

                    if vfxName == nil then
                        vfxName = "none"
                    end

                    print(v25 .. ("vfx=%*"):format(vfxName))

                    if bossAutokillTuning.vfxName ~= nil and v24 ~= nil then
                        local v26 = v24

                        local function v27() -- line: 87
                            -- upvalues: v26 (copy), playClonedVfxAtCFrame (copy), bossAutokillTuning (copy)
                            return playClonedVfxAtCFrame(bossAutokillTuning.vfxName, v26, nil, bossAutokillTuning.vfxDurationSec)
                        end

                        pcall(v27)
                    end

                    if bossAutokillTuning.sfxCue ~= nil then
                        local function v28() -- line: 92
                            -- upvalues: playClonedSound (copy), bossAutokillTuning (copy)
                            return playClonedSound(bossAutokillTuning.sfxCue)
                        end

                        pcall(v28)
                    end

                    onSuccessCutscene()
                    v9 = task.delay(bossAutokillTuning.flipDurationSec, function() -- line: 97
                        -- upvalues: v7 (ref), onComplete (copy)
                        if v7 then
                            onComplete()
                        end
                    end)
                end)
            end

            local v29 = task.delay(v1 / 1000, v11)

            return function() -- line: 106
                -- upvalues: v7 (ref), connection (ref), v9 (ref), v10 (ref), v29 (copy)
                v7 = false

                local connection2 = connection

                if connection2 ~= nil then
                    connection2:Disconnect()
                end

                local function v30() -- line: 112
                    -- upvalues: v10 (ref)
                    local v31 = v10

                    if v31 ~= nil then
                        v31 = v31:Stop()
                    end

                    return v31
                end

                pcall(v30)
                task.cancel(v29)

                if v9 ~= nil then
                    task.cancel(v9)
                end
            end
        end, {})

        return react.createElement(default, {
            fade = v6,
            isGo = v2 == "GO!",
            scale = v4,
            text = v2
        })
    end
}
