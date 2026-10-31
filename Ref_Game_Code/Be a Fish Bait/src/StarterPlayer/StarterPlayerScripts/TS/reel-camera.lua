-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local shake = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxutil", "shake")
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local TweenService, Workspace = services.TweenService, services.Workspace
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "fishing-hook-utils")
local waterSurfaceY, computeReelArcDurations, reelDropDuration, catchFadeDuration = v1.waterSurfaceY, v1.computeReelArcDurations, v1.reelDropDuration, v1.catchFadeDuration
local skipReelArcToLanding = v1.skipReelArcToLanding
local catchFadeAtom = RuntimeLib.import(script, script.Parent, "fishing-phase-atom").catchFadeAtom
local cameraShakeEnabledAtom = RuntimeLib.import(script, script.Parent, "haptics").cameraShakeEnabledAtom
local t1 = {
    overheadCamHeight = 4,
    overheadCamSideOffset = 20,
    overheadCamCastOffset = 20,
    overheadCamLookY = 7,
    overheadCamLookCast = -15,
    landingCamHeight = 18,
    landingCamBackOffset = 10,
    diagonalCamHeight = 12,
    diagonalCamBackOffset = 6,
    diagonalTweenDuration = 0.5
}

return {
    overheadCamHeight = 4,
    overheadCamSideOffset = 20,
    overheadCamCastOffset = 20,
    overheadCamLookY = 7,
    overheadCamLookCast = -15,
    landingCamHeight = 18,
    landingCamBackOffset = 10,
    diagonalCamHeight = 12,
    diagonalCamBackOffset = 6,
    diagonalTweenDuration = 0.5,
    playReelCamera = function(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10) -- playReelCamera | line: 37
        -- upvalues: shake (copy), TweenService (copy), Workspace (copy), waterSurfaceY (copy), computeReelArcDurations (copy), reelDropDuration (copy), catchFadeDuration (copy), skipReelArcToLanding (copy), catchFadeAtom (copy), cameraShakeEnabledAtom (copy), t1 (copy)
        local v2 = p10
        local v3 = p10

        if p10 == nil then
            v3 = t1
            v2 = t1
        end

        local v4 = computeReelArcDurations(p3, p4, p6, p7)
        local cameraCutTime, total = v4.cameraCutTime, v4.total
        local v5 = if skipReelArcToLanding then 0 else cameraCutTime

        if skipReelArcToLanding then
            total -= cameraCutTime
        end

        local v6 = Vector3.new(p5.X, 0, p5.Z)
        local v7 = if v6.Magnitude > 0.01 then v6:Cross((Vector3.new(0, 1, 0))).Unit else Vector3.new(1, 0, 0)
        local Unit = Vector3.new(-p5.X, 0, -p5.Z).Unit
        local v10 = Vector3.new(p3.X, waterSurfaceY, p3.Z)
        local v12 = math.clamp(p7 / 40, 0.6, 1)
        local v13 = v3.overheadCamSideOffset * v12
        local v14 = v3.overheadCamCastOffset * v12
        local v15 = v3.overheadCamLookCast * v12
        local v16 = v10 + v7 * v13
        local v17 = Unit * v14
        local v18 = Vector3.new(0, v3.overheadCamHeight, 0)
        local v19 = v16 + v17 + v18
        local v20 = p4 + p5.Unit * 8
        local v21 = Unit * v3.landingCamBackOffset
        local v22 = Vector3.new(0, v3.landingCamHeight, 0)
        local v23 = p4 + v21 + v22

        p1.CameraType = Enum.CameraType.Scriptable

        if not skipReelArcToLanding then
            local v24 = v10 + Vector3.new(0, v3.overheadCamLookY, 0)
            local v25 = Unit * -v15

            p1.CFrame = CFrame.lookAt(v19, v24 + v25)
        end

        local v26 = false
        local v27 = task.delay(0, function() -- line: 78
            -- upvalues: p1 (copy), v26 (ref), shake (copy), skipReelArcToLanding (copy), cameraShakeEnabledAtom (copy)
            if v26 or skipReelArcToLanding or not cameraShakeEnabledAtom() then
                return nil
            end

            local v28 = shake.new()

            v28.Amplitude = 3
            v28.Frequency = 0.16666666666666666
            v28.FadeInTime = 0
            v28.FadeOutTime = 0.4
            v28.SustainTime = 0.05
            v28.PositionInfluence = Vector3.new(0.15, 0.15, 0.15)
            v28.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
            v28:Start()
            v28:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p11, p12) -- line: 94
                -- upvalues: p1 (copy), v26 (ref)
                if v26 then
                    return
                end

                local _CFrame = p1.CFrame
                local v29 = CFrame.new(p11)
                local v30 = CFrame.Angles(p12.X, p12.Y, p12.Z)

                p1.CFrame = _CFrame * v29 * v30
            end)
            task.delay(0.6, function() -- line: 102
                -- upvalues: v28 (copy)
                return v28:Destroy()
            end)
        end)
        local elapsed = os.clock()

        print((`[cam] start — cutAt={ math.round(v5 * 100) / 100 }s  total={ math.round(total * 100) / 100 }s`))

        local v35 = math.max(0, v5 - catchFadeDuration)
        local v36 = v5 + reelDropDuration - v35
        local v37 = task.delay(v35, function() -- line: 115
            -- upvalues: v2 (ref), p1 (copy), p2 (copy), p4 (copy), p8 (copy), p9 (copy), total (ref), Unit (copy), v20 (copy), v23 (copy), v26 (ref), elapsed (copy), v36 (copy), v5 (copy), shake (copy), TweenService (copy), Workspace (copy), catchFadeAtom (copy), cameraShakeEnabledAtom (copy)
            if v26 then
                return nil
            end

            print((`[ReelCam] fade start — cutTime={ math.round(v5 * 100) / 100 }s total={ math.round(total * 100) / 100 }s`))
            catchFadeAtom({
                onBlack = function() -- onBlack | line: 121
                    -- upvalues: p1 (copy), p8 (copy), v20 (copy), v23 (copy), v26 (ref), elapsed (copy)
                    if v26 then
                        return nil
                    end

                    print((`[ReelCam] onBlack — camera cuts to pier at +{ math.round((os.clock() - elapsed) * 100) / 100 }s`))
                    p8()
                    p1.CFrame = CFrame.lookAt(v23, v20)
                end
            })
            task.delay(v36, function() -- line: 132
                -- upvalues: v2 (ref), p1 (copy), p2 (copy), p4 (copy), p9 (copy), Unit (copy), v20 (copy), v26 (ref), shake (copy), TweenService (copy), Workspace (copy), cameraShakeEnabledAtom (copy)
                if v26 then
                    return nil
                end

                print("[ReelCam] fish landed — shake starting")

                local _CFrame = p1.CFrame
                local v42, v43

                if cameraShakeEnabledAtom() then
                    v43 = shake.new()
                    v42 = v43
                    v43.Amplitude = 4
                    v43.Frequency = 0.2
                    v43.FadeInTime = 0
                    v43.FadeOutTime = 0.5
                    v43.SustainTime = 0.05
                    v43.PositionInfluence = Vector3.new(0.2, 0.2, 0.2)
                    v43.RotationInfluence = Vector3.new(0.1, 0.1, 0.1)
                    v43:Start()
                    v43:BindToRenderStep(shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p13, p14) -- line: 149
                        -- upvalues: _CFrame (copy), p1 (copy), v26 (ref)
                        if v26 then
                            return
                        end

                        p1.CFrame = _CFrame * CFrame.new(p13) * CFrame.Angles(p14.X, p14.Y, p14.Z)
                    end)
                end

                task.delay(v43 == nil and 0 or 0.7, function() -- line: 158
                    -- upvalues: _CFrame (copy), v42 (ref), v2 (ref), p1 (copy), p2 (copy), p4 (copy), p9 (copy), Unit (copy), v20 (copy), v26 (ref), TweenService (copy), Workspace (copy)
                    local v48 = v42

                    if v48 ~= nil then
                        v48:Destroy()
                    end

                    if v26 then
                        return nil
                    end

                    p1.CFrame = _CFrame

                    local v49 = Unit * v2.diagonalCamBackOffset
                    local v50 = Vector3.new(0, v2.diagonalCamHeight, 0)
                    local v51 = p4 + v49 + v50
                    local v52 = CFrame.lookAt(v51, v20)
                    local CFrameValue = Instance.new("CFrameValue")

                    CFrameValue.Value = _CFrame
                    CFrameValue.Parent = Workspace

                    local connection = CFrameValue:GetPropertyChangedSignal("Value"):Connect(function() -- line: 176
                        -- upvalues: CFrameValue (copy), p1 (copy), v26 (ref)
                        if not v26 then
                            p1.CFrame = CFrameValue.Value
                        end
                    end)
                    local v53 = TweenService:Create(CFrameValue, TweenInfo.new(v2.diagonalTweenDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Value = v52
                    })

                    v53.Completed:Connect(function() -- line: 184
                        -- upvalues: CFrameValue (copy), connection (copy), p1 (copy), p2 (copy), p9 (copy), v26 (ref)
                        connection:Disconnect()
                        CFrameValue:Destroy()

                        if v26 then
                            return
                        end

                        print("[ReelCam] diagonal tween done — camera Custom, session ends")

                        local Character = p2.Character

                        if Character ~= nil then
                            Character = Character:FindFirstChildOfClass("Humanoid")
                        end

                        if Character then
                            p1.CameraSubject = Character
                        end

                        p1.CameraType = Enum.CameraType.Custom
                        p9()
                    end)
                    v53:Play()
                end)
            end)
        end)

        return function() -- line: 205
            -- upvalues: p1 (copy), p2 (copy), v26 (ref), v27 (copy), v37 (copy)
            v26 = true
            task.cancel(v27)
            task.cancel(v37)

            local Character = p2.Character

            if Character ~= nil then
                Character = Character:FindFirstChildOfClass("Humanoid")
            end

            if Character then
                p1.CameraSubject = Character
            end

            p1.CameraType = Enum.CameraType.Custom
        end
    end,
    defaultReelCameraConfig = t1
}
