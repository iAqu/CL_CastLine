-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    new = function() -- new | line: 4
        local Brock = nil
        local result
        local v1 = false
        local v2 = false
        local v3 = false

        return {
            Tick = function(p1) -- Tick | line: 15
                -- upvalues: Brock (ref), result (ref), v1 (ref), v2 (ref), v3 (ref)
                local DrScrambleEvent = workspace:FindFirstChild("DrScrambleEvent")
                local Brock2 = DrScrambleEvent and DrScrambleEvent:FindFirstChild("Brock")

                if Brock2 ~= Brock then
                    if result then
                        result:Stop(0)
                        result:Destroy()
                        result = nil
                    end

                    Brock = nil
                    v1 = false
                    v3 = false

                    local Model = if Brock2 then Brock2:IsA("Model") else nil

                    if not Brock2 or not Model then
                        Brock2 = nil
                    end

                    Brock = Brock2
                end

                local Brock3 = Brock

                if Brock3 and Brock3.PrimaryPart then
                    local Humanoid = Brock3:FindFirstChildOfClass("Humanoid")
                    local Animator = Humanoid and Humanoid:FindFirstChildOfClass("Animator")
                    local ScrambleSleeping = Humanoid and Humanoid:FindFirstChild("ScrambleSleeping")

                    if not result and not v2 and not v3 and Animator and ScrambleSleeping and ScrambleSleeping:IsA("Animation") then
                        v2 = true
                        task.spawn(function() -- line: 26
                            -- upvalues: Brock3 (copy), Animator (copy), ScrambleSleeping (copy), Brock (ref), result (ref), v2 (ref), v3 (ref)
                            local LoadAnimation = Animator.LoadAnimation
                            local ok, result2 = pcall(LoadAnimation, Animator, ScrambleSleeping)

                            v2 = false

                            if not ok then
                                v3 = Brock == Brock3
                                warn("[Scramble] Brock sleeping animation failed:", result2)

                                return
                            end

                            if Brock ~= Brock3 or not Brock3:IsDescendantOf(workspace) then
                                result2:Destroy()
                            else
                                result2.Looped = true
                                result2.Priority = Enum.AnimationPriority.Action
                                result = result2
                            end
                        end)
                    end

                    local CurrentCamera = workspace.CurrentCamera
                    local v4 = p1 and CurrentCamera ~= nil and (CurrentCamera.CFrame.Position - Brock3:GetPivot().Position).Magnitude <= 160

                    if result and v4 ~= v1 then
                        v1 = v4

                        if v4 then
                            result:Play(0.2)
                        else
                            result:Stop(0.2)
                        end
                    end
                end
            end,
            Destroy = function() -- Destroy | line: 43
                -- upvalues: Brock (ref), result (ref), v1 (ref), v3 (ref)
                if result then
                    result:Stop(0)
                    result:Destroy()
                    result = nil
                end

                Brock = nil
                v1 = false
                v3 = false
            end
        }
    end
}
