-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TripSet = require(script.Parent.TripSet)
local t1 = {}

local function part(p1, p2) -- line: 7
    local v1 = Instance.new(p2.Class or "Part")

    p2.Class = nil
    v1.Anchored = true
    v1.CanCollide = false
    v1.CanQuery = false
    v1.CanTouch = false

    local Smooth, Smooth2 = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth

    v1.TopSurface = Smooth
    v1.BottomSurface = Smooth2
    v1.Material = Enum.Material.Plastic

    for v2, v3 in p2 do
        v1[v2] = v3
    end

    v1.Parent = p1

    return v1
end

function t1.stars(p3, p4) -- line: 25
    -- upvalues: TripSet (copy), part (copy)
    local t2 = {}

    for _ = 1, p4 do
        local v4 = part(p3, {
            Name = "Star",
            Size = Vector3.new(1, 1, 1),
            Transparency = 1
        })

        TripSet.bubble(v4, "★", Color3.fromRGB(255, 225, 60), 9, (Vector3.new(0, 0, 0)))
        table.insert(t2, v4)
    end

    return t2
end

function t1.birds(p5, p6) -- line: 38
    -- upvalues: part (copy)
    local t3 = {}
    local v5 = Color3.fromRGB(255, 220, 60)
    local v6 = Color3.fromRGB(255, 140, 40)
    local v7 = Color3.fromRGB(20, 20, 30)

    for _ = 1, p6 do
        local t4 = {
            pieces = {}
        }

        local function add(p7, p8, p9) -- line: 43
            -- upvalues: p5 (copy), t4 (copy), part (copy)
            p8.Name = p7
            p8.CastShadow = false
            p8.Size *= 2.5

            local v8 = CFrame.new(p9.Position * 2.5) * p9.Rotation
            local v9 = part(p5, p8)

            table.insert(t4.pieces, {
                part = v9,
                rel = v8,
                name = p7
            })

            return v9
        end

        add("Body", {
            Size = Vector3.new(4, 4, 4),
            Shape = Enum.PartType.Ball,
            Color = v5,
            Material = Enum.Material.SmoothPlastic
        }, CFrame.identity)
        add("Head", {
            Size = Vector3.new(2.8, 2.8, 2.8),
            Shape = Enum.PartType.Ball,
            Color = v5,
            Material = Enum.Material.SmoothPlastic
        }, CFrame.new(0, 1.6, -1.8))
        add("Beak", {
            Class = "WedgePart",
            Size = Vector3.new(0.8, 0.8, 1.4),
            Color = v6
        }, CFrame.new(0, 1.4, -3.5) * CFrame.Angles(0, 3.141592653589793, 0))

        for i = -1, 1, 2 do
            add("Eye", {
                Size = Vector3.new(0.6, 0.6, 0.6),
                Shape = Enum.PartType.Ball,
                Color = v7
            }, CFrame.new(i * 0.7, 2, -2.9))
            add("Wing" .. (i < 0 and "L" or "R"), {
                Size = Vector3.new(3, 0.3, 2),
                Color = v5:Lerp(v6, 0.3),
                Material = Enum.Material.SmoothPlastic
            }, CFrame.new(i * 1.8, 0.4, 0))
        end

        add("Tail", {
            Size = Vector3.new(1.6, 0.3, 1.6),
            Color = v6
        }, CFrame.new(0, 0.6, 2.2) * CFrame.Angles(-0.4363323129985824, 0, 0))
        table.insert(t3, t4)
    end

    return t3
end

function t1.placeBird(p10, p11, p12) -- line: 66
    local t6 = {}
    local t7 = {}
    local v11 = math.sin(p12 * 22) * 0.7

    for _, v12 in p10.pieces do
        local rel = v12.rel

        if v12.name == "WingL" or v12.name == "WingR" then
            local v13 = if v12.name == "WingL" then -1 else 1

            rel = CFrame.new(v13 * 0.9 * 2.5, 1, 0) * CFrame.Angles(0, 0, v13 * v11) * CFrame.new(v13 * 0.9 * 2.5, 0, 0)
        end

        table.insert(t6, v12.part)
        table.insert(t7, p11 * rel)
    end

    workspace:BulkMoveTo(t6, t7, Enum.BulkMoveMode.FireCFrameChanged)
end

function t1.showBirds(p13, p14) -- line: 82
    for _, v15 in p13 do
        for _, v16 in v15.pieces do
            v16.part.LocalTransparencyModifier = p14 and 0 or 1
        end
    end
end

function t1.worried(p15) -- line: 95
    local Head = p15:FindFirstChild("Head")

    if not Head then
        return function() -- line: 98
        end
    end

    local t8 = {}
    local face = Head:FindFirstChild("face")

    if face and face:IsA("Decal") then
        local Texture = face.Texture

        face.Texture = "rbxassetid://59361770"
        table.insert(t8, function() -- line: 105
            -- upvalues: face (copy), Texture (copy)
            face.Texture = Texture
        end)
    end

    local FaceControls = Head:FindFirstChildOfClass("FaceControls")

    if FaceControls then
        for v18, v19 in {
                LeftInnerBrowRaiser = 1,
                LeftOuterBrowRaiser = 0.8,
                RightInnerBrowRaiser = 0.4,
                RightBrowLowerer = 0.7,
                LeftLipCornerDown = 0.8,
                RightLipCornerDown = 0.8,
                LeftLipStretcher = 0.5,
                RightLipStretcher = 0.5,
                LeftEyeUpperLidRaiser = 0.6,
                RightEyeUpperLidRaiser = 0.6,
                Corrugator = 0.4
            } do
            local function v20() -- line: 118
                -- upvalues: FaceControls (copy), v18 (copy)
                return FaceControls[v18]
            end

            local ok, result = pcall(v20)

            if ok then
                local function v21() -- line: 121
                    -- upvalues: FaceControls (copy), v18 (copy), v19 (copy)
                    FaceControls[v18] = v19
                end

                if pcall(v21) then
                    table.insert(t8, function() -- line: 124
                        -- upvalues: FaceControls (copy), v18 (copy), result (copy)
                        local function v23() -- line: 125
                            -- upvalues: FaceControls (copy), v18 (copy), result (copy)
                            FaceControls[v18] = result
                        end

                        pcall(v23)
                    end)
                end
            end
        end
    end

    return function() -- line: 132
        -- upvalues: t8 (copy)
        for _, v24 in t8 do
            v24()
        end
    end
end

return t1
