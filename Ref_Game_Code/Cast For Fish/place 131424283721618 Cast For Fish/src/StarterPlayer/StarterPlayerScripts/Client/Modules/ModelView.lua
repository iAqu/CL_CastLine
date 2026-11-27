-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Show = function(p1, p2, p3, p4) -- Show | line: 6
        local ViewportFrame = Instance.new("ViewportFrame")

        ViewportFrame.Name = "ModelPicture"
        ViewportFrame.BackgroundTransparency = 1
        ViewportFrame.Size = UDim2.fromScale(1, 1)
        ViewportFrame.Ambient = Color3.new(1, 1, 1)
        ViewportFrame.LightColor = Color3.new(1, 1, 1)
        ViewportFrame.LightDirection = Vector3.new(-1, -1, -0.4)
        ViewportFrame.ZIndex = p1.ZIndex + 1

        local clone = p2:Clone()

        for _, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
                descendant:Destroy()
            end
        end

        clone:PivotTo(CFrame.new())
        clone.Parent = ViewportFrame

        local BoundingBox, BoundingBox2 = clone:GetBoundingBox()
        local Camera = Instance.new("Camera")

        Camera.FieldOfView = 30

        local v1 = BoundingBox2.Magnitude / 2 / 0.25881904510252074 * (p4 or 0.8)
        local Unit = (p3 or Vector3.new(0.75, 0.35, -1)).Unit

        Camera.CFrame = CFrame.lookAt(BoundingBox.Position + Unit * v1, BoundingBox.Position)
        Camera.Parent = ViewportFrame
        ViewportFrame.CurrentCamera = Camera
        ViewportFrame.Parent = p1

        return ViewportFrame
    end
}
local t2 = {}

function t1.Queue(p5, p6, p7, p8, p9, p10) -- line: 42
    -- upvalues: t2 (copy)
    t2[p5] = t2[p5] or {}
    t2[p5][p6] = { p7, p8, p9, p10 }
end

function t1.Flush(p11, p12, p13) -- line: 47
    -- upvalues: t1 (copy), t2 (copy)
    local v2 = t2[p11]

    if not v2 or next(v2) == nil then
        return
    end

    local t3 = {}

    for v3 in pairs(v2) do
        table.insert(t3, v3)
    end

    local v4 = p12 or 1

    table.sort(t3, function(p14, p15) -- line: 57
        -- upvalues: v4 (copy)
        return math.abs(p14 - v4) < math.abs(p15 - v4)
    end)

    local function make(p16) -- line: 60
        -- upvalues: v2 (copy), t1 (copy)
        local v8 = v2[p16]

        if v8 then
            v2[p16] = nil

            if v8[1].Parent then
                t1.Show(v8[1], v8[2], v8[3], v8[4])
            end
        end
    end

    local v9 = p13 or 10

    for i = 1, math.min(v9, #t3) do
        local v11 = t3[i]
        local v12 = v2[v11]

        if v12 then
            v2[v11] = nil

            if v12[1].Parent then
                t1.Show(v12[1], v12[2], v12[3], v12[4])
            end
        end
    end

    if v9 < #t3 then
        task.spawn(function() -- line: 74
            -- upvalues: v2 (copy), t3 (copy), v9 (copy), t1 (copy)
            local RunService = game:GetService("RunService")

            for i = v9 + 1, #t3, 6 do
                RunService.Heartbeat:Wait()

                local v13 = #t3

                for j = i, math.min(i + 5, v13) do
                    local v14 = t3[j]
                    local v15 = v2[v14]

                    if v15 then
                        v2[v14] = nil

                        if v15[1].Parent then
                            t1.Show(v15[1], v15[2], v15[3], v15[4])
                        end
                    end
                end
            end
        end)
    end
end

return t1
