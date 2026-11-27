-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    DIST = 0.75,
    TIME = 0.2,
    COOLDOWN = 1.5,
    LINE = 0.45,
    DUCK_AT = 0.2,
    BLINK_LINE = 0.33
}

function t1.offset(p1, p2, p3, p4, p5) -- line: 21
    -- upvalues: t1 (copy)
    local v1 = p1 - (p4 + p5 * (p1 - p4):Dot(p5))
    local v2 = v1 - p2 * v1:Dot(p2)

    if v2.Magnitude < 0.5 then
        v2 = p5:Cross(p2)

        if v2.Magnitude < 0.001 then
            v2 = p5:Cross((Vector3.new(0, 1, 0)))
        end
    end

    return v2.Unit * (t1.DIST * p3)
end

function t1.progress(p6) -- line: 34
    -- upvalues: t1 (copy)
    return 1 - (1 - math.clamp(p6 / t1.TIME, 0, 1)) ^ 3
end

function t1.onLine(p7, p8, p9, p10) -- line: 40
    -- upvalues: t1 (copy)
    local v4 = (p7 - p9):Dot(p10)

    if v4 < 0 then
        return false
    end

    return (p7 - (p9 + p10 * v4)).Magnitude < t1.LINE * p8
end

function t1.predict(p11, p12, p13, p14) -- line: 55
    -- upvalues: t1 (copy)
    local Fish = workspace:FindFirstChild("Fish")

    if Fish then
        local ServerTimeNow = workspace:GetServerTimeNow()

        for _, child in ipairs(Fish:GetChildren()) do
            local BlinkReady = child:GetAttribute("BlinkReady")
            local PrimaryPart = child.PrimaryPart

            if BlinkReady and BlinkReady <= ServerTimeNow - p13.renderLag() and p13.blink and not p13.blink[child] and child:GetAttribute("OnlyFor") == p14.UserId and not child:GetAttribute("Hooked") and PrimaryPart then
                local v5 = (PrimaryPart.Position - p11):Dot(p12)
                local Size = PrimaryPart.Size

                if v5 > 0 and (PrimaryPart.Position - (p11 + p12 * v5)).Magnitude < t1.BLINK_LINE * math.max(Size.X, Size.Y, Size.Z) then
                    p13.blink[child] = {
                        clock = os.clock(),
                        server = ServerTimeNow
                    }

                    return
                end
            end

            local JoltReady = child:GetAttribute("JoltReady")
            local JoltBy = child:GetAttribute("JoltBy")
            local AnatomyInverse = child:GetAttribute("AnatomyInverse")

            if JoltReady and type(JoltBy) == "number" and PrimaryPart and typeof(AnatomyInverse) == "CFrame" and child:GetAttribute("OnlyFor") == p14.UserId and not child:GetAttribute("Hooked") then
                local RightVector = (child:GetPivot() * AnatomyInverse:Inverse()).RightVector
                local CFrame, Size = PrimaryPart.CFrame, PrimaryPart.Size
                local v11 = Size.X * math.abs((CFrame.RightVector:Dot(RightVector))) + Size.Y * math.abs((CFrame.UpVector:Dot(RightVector))) + Size.Z * math.abs((CFrame.LookVector:Dot(RightVector)))

                if t1.onLine(PrimaryPart.Position, v11, p11, p12) then
                    p13.nudge[child] = {
                        at = os.clock(),
                        off = RightVector * JoltBy,
                        lag = p13.renderLag() + (p13.clientAge or 0)
                    }

                    return
                end
            end

            local NcEvade = child:GetAttribute("NcEvade")
            local AnatomyInverse2 = child:GetAttribute("AnatomyInverse")
            local PrimaryPart2 = child.PrimaryPart

            if NcEvade and NcEvade <= ServerTimeNow and child:GetAttribute("OnlyFor") == p14.UserId and not child:GetAttribute("Hooked") and PrimaryPart2 and typeof(AnatomyInverse2) == "CFrame" then
                local v12 = child:GetPivot() * AnatomyInverse2:Inverse()
                local CFrame, Size = PrimaryPart2.CFrame, PrimaryPart2.Size
                local RightVector = v12.RightVector
                local v18 = Size.X * math.abs((CFrame.RightVector:Dot(RightVector))) + Size.Y * math.abs((CFrame.UpVector:Dot(RightVector))) + Size.Z * math.abs((CFrame.LookVector:Dot(RightVector)))
                local NcDuck = child:GetAttribute("NcDuck")
                local v19 = type(NcDuck) == "number" and PrimaryPart2.Position + RightVector * (t1.DUCK_AT * v18) or PrimaryPart2.Position

                if t1.onLine(v19, v18, p11, p12) then
                    local v20 = type(NcDuck) == "number" and -RightVector * NcDuck or t1.offset(PrimaryPart2.Position, v12.UpVector, v18, p11, p12)

                    p13.nudge[child] = {
                        at = os.clock(),
                        off = v20,
                        lag = p13.renderLag() + (p13.clientAge or 0)
                    }

                    return
                end
            end
        end
    end
end

return t1
