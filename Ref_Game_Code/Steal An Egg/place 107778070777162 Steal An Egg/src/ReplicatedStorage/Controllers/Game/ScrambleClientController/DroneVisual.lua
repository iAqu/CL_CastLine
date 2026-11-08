-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ScrambleDroneMotion = require(game.ReplicatedStorage.Shared.Util.ScrambleDroneMotion)

return {
    new = function(p1, p2, p3) -- new | line: 6
        -- upvalues: ScrambleDroneMotion (copy)
        local clone = p2:Clone()
        local t2 = {}
        local Hitbox = clone:FindFirstChild("Hitbox")

        if Hitbox then
            Hitbox:Destroy()
        end

        clone.Name = "DroneVisual_" .. tostring(p1:GetAttribute("ScrambleDroneId"))

        for _, descendant in clone:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = descendant == clone.PrimaryPart
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.Massless = true
                descendant.LocalTransparencyModifier = 1
                table.insert(t2, descendant)
            end
        end

        local v1 = ScrambleDroneMotion.Read(p1)

        if v1 then
            clone:PivotTo(v1.From)
        end

        clone.Parent = p3

        local t3 = {
            LastAnimation = nil,
            Visible = false,
            Transparency = 1,
            Rig = clone,
            Root = clone.PrimaryPart,
            Tracks = {},
            State = ScrambleDroneMotion.Read(p1)
        }
        local Animator = clone.AnimationController.Animator

        for _, child in clone.Animations:GetChildren() do
            if child:IsA("Animation") then
                local LoadAnimation = Animator.LoadAnimation
                local ok, result = pcall(LoadAnimation, Animator, child)

                if ok then
                    if child.Name == "Idle" then
                        result.Looped = true
                    else
                        result.Looped = child.Name == "Walk"
                    end

                    if child.Name == "Death" then
                        result.Priority = Enum.AnimationPriority.Action4
                    elseif child.Name == "Attack" then
                        result.Priority = Enum.AnimationPriority.Action
                    else
                        result.Priority = Enum.AnimationPriority.Movement
                    end

                    t3.Tracks[child.Name] = result
                else
                    warn("[Scramble] animation failed", child.AnimationId, result)
                end
            end
        end

        local Hitbox2 = p1:FindFirstChild("Hitbox")

        local function latchDeath(p4) -- line: 54
            -- upvalues: p2 (copy), t3 (copy)
            if t3.Dead then
                return
            end

            t3.Dead = true
            t3.Velocity = Vector3.new(0, 0, 0)
            t3.Recoil = Vector3.new(0, 0, 0)
            t3.RecoilVelocity = Vector3.new(0, 0, 0)

            local v2 = if not p4 or p4.Name ~= "Death" then workspace:GetServerTimeNow() else p4.AnimationAt
            local CFrame = t3.Root.CFrame

            t3.State = {
                Name = "Death",
                At = v2,
                AnimationAt = v2,
                Duration = p2.Animations.Death:GetAttribute("Duration") or 3,
                From = CFrame,
                To = CFrame
            }
        end

        local function acceptState(p5) -- line: 72
            -- upvalues: p1 (copy), t3 (copy), Hitbox2 (copy), latchDeath (copy)
            if p5 and p5.Name == "Death" or p1:GetAttribute("DroneState") == "Death" or Hitbox2 and (Hitbox2:GetAttribute("Health") or 1) <= 0 then
                latchDeath(p5)
            elseif not t3.Dead and p5 and (not t3.State or p5.At >= t3.State.At) then
                t3.State = p5
            end
        end

        local function readState() -- line: 82
            -- upvalues: p1 (copy), acceptState (copy), ScrambleDroneMotion (copy)
            acceptState(ScrambleDroneMotion.Read(p1))
        end

        function t3.ReceiveHit(p6, p7) -- line: 83
            -- upvalues: acceptState (copy), ScrambleDroneMotion (copy)
            local v3 = ScrambleDroneMotion.Decode(p7)

            acceptState(v3)

            if p6.Dead or not v3 or p6.State and v3.At < p6.State.At then
                return
            end

            if v3.Name == "Knockback" and v3.At ~= p6.LastImpactAt then
                p6.LastImpactAt = v3.At

                local v5 = v3.To.Position - v3.From.Position
                local v6 = Vector3.new(v5.X, 0, v5.Z)
                local v4

                if v6.Magnitude > 0.01 then
                    local v7 = (Vector3.new(0, 1, 0)):Cross(v6.Unit)

                    v4 = (p6.RecoilVelocity or Vector3.new(0, 0, 0)) + v7 * 3.3

                    if v4.Magnitude > 4.8 then
                        v4 = v4.Unit * 4.8
                    end

                    p6.RecoilVelocity = v4
                end
            end
        end

        t3.Connection = p1:GetAttributeChangedSignal("DroneMotion"):Connect(readState)
        t3.DeathConnection = p1:GetAttributeChangedSignal("DroneState"):Connect(readState)
        t3.HealthConnection = Hitbox2 and Hitbox2:GetAttributeChangedSignal("Health"):Connect(readState)
        acceptState(ScrambleDroneMotion.Read(p1))

        function t3.Step(p8, p9, p10, p11) -- line: 106
            -- upvalues: t2 (copy), ScrambleDroneMotion (copy)
            local State = p8.State
            local v8

            if p11 then
                v8 = 0

                if State and State.Name == "Death" then
                    local v10 = math.clamp((p10 - State.AnimationAt - State.Duration) / ScrambleDroneMotion.DeathFadeSeconds, 0, 1)

                    v8 = v10 * v10 * (3 - v10 * 2)
                end
            else
                v8 = 1
            end

            if p8.Transparency ~= v8 then
                p8.Transparency = v8

                for _, v11 in t2 do
                    v11.LocalTransparencyModifier = v8
                end
            end

            local v12 = ScrambleDroneMotion.Pose(State, p9, p10)
            local v14 = math.max(0, p10 - (p8.LastStepAt or p10))

            p8.LastStepAt = p10

            if (not State or State.Name ~= "Death") and p11 and p8.Visible and p8.Presented and not (v14 > 0.25) then
                local v15 = p8.Presented.Position - v12.Position
                local v16 = p8.Velocity or Vector3.new(0, 0, 0)
                local v17 = v16 + v15 * 12
                local v19 = math.exp(v14 * -12)
                local v20 = v12.Position + (v15 + v17 * v14) * v19

                p8.Velocity = (v16 - v17 * 12 * v14) * v19

                local v21 = p8.Presented.Rotation:Lerp(v12.Rotation, 1 - v19)

                p8.Presented = CFrame.new(v20) * v21
                v12 = p8.Presented
            else
                p8.Presented = v12
                p8.Velocity = Vector3.new(0, 0, 0)
            end

            if not p8.Dead and p11 and v14 <= 0.25 then
                local v22 = p8.Recoil or Vector3.new(0, 0, 0)
                local v23 = p8.RecoilVelocity or Vector3.new(0, 0, 0)
                local v24 = v23 + v22 * 11
                local v26 = math.exp(v14 * -11)
                local v27 = (v22 + v24 * v14) * v26

                p8.RecoilVelocity = (v23 - v24 * 11 * v14) * v26
                p8.Recoil = v27

                local Magnitude = v27.Magnitude

                if Magnitude > 1E-04 then
                    v12 = CFrame.new(v12.Position) * CFrame.fromAxisAngle(v27.Unit, (math.min(Magnitude, 0.20943951023931956))) * v12.Rotation
                end
            else
                p8.Recoil = Vector3.new(0, 0, 0)
                p8.RecoilVelocity = Vector3.new(0, 0, 0)
            end

            local v28 = if not State then "Idle"
                elseif State.Name == "Knockback" then "Idle"
                elseif State.Name == "Chase" or State.Name == "Return" then "Walk"
                else State.Name
            local v29 = if v28 == "Idle" or v28 == "Walk" then v28 else v28 .. ":" .. tostring(State and State.AnimationAt or 0)

            if p11 then
                if p8.LastAnimation ~= v29 then
                    for v31, v32 in p8.Tracks do
                        if v31 ~= v28 then
                            v32:Stop(0.12)
                        end
                    end

                    local v33 = p8.Tracks[v28]

                    if v33 then
                        v33:Play(0.12, 1, 1)
                        p8.SyncTrack = v33

                        local v35 = math.max(0, p10 - (State and State.AnimationAt or p10))

                        if v33.Length > 0 then
                            p8.SyncTrack = nil

                            if v33.Looped then
                                v33.TimePosition = v35 % v33.Length
                            else
                                v33.TimePosition = math.min(v35, (math.max(0, v33.Length - 0.02)))
                            end
                        end
                    end

                    p8.LastAnimation = v29
                end
            elseif p8.Visible then
                for _, v38 in p8.Tracks do
                    v38:Stop(0)
                end

                p8.LastAnimation = nil
            end

            local SyncTrack = p8.SyncTrack

            if p11 and SyncTrack and SyncTrack.Length > 0 then
                local v40 = math.max(0, p10 - (State and State.AnimationAt or p10))

                if SyncTrack.Looped then
                    SyncTrack.TimePosition = v40 % SyncTrack.Length
                else
                    SyncTrack.TimePosition = math.min(v40, (math.max(0, SyncTrack.Length - 0.02)))
                end

                p8.SyncTrack = nil
            end

            p8.Visible = p11

            local Death = p8.Tracks.Death

            if p11 and v28 == "Death" and Death and Death.Length > 0 and p10 - State.AnimationAt >= Death.Length - 0.08 then
                if not Death.IsPlaying then
                    Death:Play(0, 1, 1)
                end

                Death.TimePosition = math.max(0, Death.Length - 0.03)
                Death:AdjustSpeed(0)
            end

            return v12
        end

        function t3.Destroy(p12) -- line: 219
            p12.Connection:Disconnect()
            p12.DeathConnection:Disconnect()

            if p12.HealthConnection then
                p12.HealthConnection:Disconnect()
            end

            for _, v44 in p12.Tracks do
                v44:Stop(0)
                v44:Destroy()
            end

            p12.Rig:Destroy()
        end

        return t3
    end
}
