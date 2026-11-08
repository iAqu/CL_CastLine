-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Kit = require(script.Parent.Kit)
local Vfx = require(script.Parent.Vfx)

local function headParts(p1) -- line: 28
    local t1 = {}

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") and descendant:GetAttribute("Head") == true then
            table.insert(t1, descendant)
        end
    end

    return t1
end

local function largest(p2) -- line: 38
    local n1 = -1
    local v1

    for _, v2 in p2 do
        local v3 = v2.Size.X * v2.Size.Y * v2.Size.Z

        if n1 < v3 then
            n1 = v3
            v1 = v2
        end
    end

    return v1
end

local function restRotation(p3, p4) -- line: 51
    for _, child in p3:GetChildren() do
        if child:IsA("Motor6D") and child.Part0 == p4 and child.Part1 == p3 then
            return (child.C0 * child.C1:Inverse()).Rotation
        end
    end

    if p4 then
        return p4.CFrame:ToObjectSpace(p3.CFrame).Rotation
    end

    return CFrame.identity
end

local function impact(p5, p6, p7) -- line: 60
    -- upvalues: Kit (copy), Vfx (copy)
    Vfx.Play(Vfx.PhaseTwo, { "HeadExplode" }, CFrame.new(p6), p7)
    Kit.Poof(p5, p7 * 2.5)
    Kit.Burst(p5, p7 * 18, Color3.fromRGB(150, 120, 90), 0.4)
    Kit.ShakeFrom(p6, 12, 320)
end

local function standIn(p8) -- line: 67
    -- upvalues: Kit (copy), Vfx (copy)
    local v4 = Vfx.Library()
    local PumpkinBruteHead = v4 and v4:FindFirstChild("PumpkinBruteHead")
    local PrimaryPart = if not (PumpkinBruteHead and PumpkinBruteHead:IsA("Model")) then nil else PumpkinBruteHead.PrimaryPart

    if PumpkinBruteHead == nil or not PumpkinBruteHead:IsA("Model") or PrimaryPart == nil then
        return nil, 1
    end

    local clone = PumpkinBruteHead:Clone()

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    local v5 = p8.Size.X / math.max(PrimaryPart.Size.X, 0.001)

    clone:ScaleTo(clone:GetScale() * v5)
    clone.Parent = Kit.Debris()

    return clone, v5
end

return {
    Play = function(p9, p10, p11, p12, _, p14) -- Play | line: 92
        -- upvalues: RunService (copy), Workspace (copy), Kit (copy), headParts (copy), largest (copy), restRotation (copy), impact (copy), standIn (copy)
        local v6, v7

        if p9 then
            v7 = headParts(p9)
            v6 = p9:FindFirstChild("Pumpkin Monster Main.001", true)
        else
            v7 = {}
        end

        if not (v6 and v6:IsA("BasePart")) then
            v6 = largest(v7)
        end

        local v8
        local n2 = 1
        local v9

        if v6 then
            local v10, v11 = standIn(v6)

            v9 = v10
            v8 = v10
            n2 = v11
        end

        if v9 ~= nil and v6 ~= nil then
            local v12 = v9.PrimaryPart.CFrame:ToObjectSpace(v9:GetPivot())
            local v13 = v6.CFrame * v12

            for _, v14 in v7 do
                v14.LocalTransparencyModifier = 1
            end

            local v15 = Kit.Flat(p11)
            local v16 = CFrame.lookAt(Vector3.new(0, 0, 0), if v15.Magnitude > 0.001 then v15.Unit else Vector3.new(-0, -0, -1, -0)) * restRotation(v6, p9 and p9.PrimaryPart) * v12.Rotation

            v9:PivotTo(CFrame.new(p10) * v16)

            local BoundingBox, BoundingBox2 = v9:GetBoundingBox()
            local v17 = p10.Y - (BoundingBox.Position.Y - BoundingBox2.Y / 2)
            local v18 = CFrame.new(p10 + Vector3.new(0, v17, 0)) * v16
            local v19 = BoundingBox.Position + Vector3.new(0, v17, 0)

            if v13.Position.Y < v18.Position.Y then
                v13 = CFrame.new((Vector3.new(v13.Position.X, v18.Position.Y, v13.Position.Z))) * v13.Rotation
            end

            local v21 = Vector3.new(v18.Position.X, math.max(v13.Position.Y, v18.Position.Y) + BoundingBox2.Y * 2, v18.Position.Z)

            v9:PivotTo(v13)

            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 146
                -- upvalues: p10 (copy), p12 (copy), p14 (copy), v8 (ref), n2 (ref), v13 (ref), v18 (copy), v19 (copy), v21 (copy), connection (ref), Workspace (copy), impact (copy)
                if v8.Parent ~= nil then
                    local v23 = math.clamp((Workspace:GetServerTimeNow() - p14) / math.max(p12, 0.001), 0, 1)

                    if v23 < 1 then
                        local v24

                        if v23 < 0.45 then
                            local v25 = v23 / 0.45

                            v24 = v13.Position:Lerp(v21, 1 - (1 - v25) ^ 2)
                        else
                            local v26 = (v23 - 0.45) / 0.55

                            v24 = v21:Lerp(v18.Position, v26 ^ 3)
                        end

                        local v27 = 18.84955592153876 * (1 - (1 - v23) ^ 2)
                        local v29 = v13.Rotation:Lerp(v18.Rotation, (math.min(v23 * 2, 1)))

                        v8:PivotTo(CFrame.new(v24) * v29 * CFrame.Angles(math.sin(v23 * 3.141592653589793) * 0.6108652381980153, v27, 0))
                    else
                        connection:Disconnect()
                        v8:Destroy()
                        impact(p10, v19, n2)
                    end
                else
                    connection:Disconnect()
                end
            end)
        else
            local v33 = p10 + Vector3.new(0, 4, 0)

            task.delay(math.max(p14 + p12 - Workspace:GetServerTimeNow(), 0), impact, p10, v33, 1)
        end
    end
}
