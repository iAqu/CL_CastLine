-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local AssetService = game:GetService("AssetService")
local RunService = game:GetService("RunService")
local t1 = {}
local rad, sin, cos = math.rad, math.sin, math.cos
local v1 = false
local t2 = {
    Spine = {
        side = 34,
        lift = 4,
        speed = 1,
        waves = 0.9,
        taper = 0.65
    },
    Neck = {
        side = 14,
        lift = 9,
        speed = 0.4,
        waves = 0.35,
        taper = 0
    },
    Tentacles = {
        side = 16,
        lift = 20,
        speed = 0.8,
        waves = 0.7,
        taper = 0.5
    },
    Arm = {
        side = 12,
        lift = 28,
        speed = 0.6,
        waves = 0.5,
        taper = 0.6
    }
}

local function styleFor(p1) -- line: 47
    -- upvalues: t2 (copy)
    if p1:find("^Neck") then
        return t2.Neck
    end

    if p1 == "Tentacles" then
        return t2.Tentacles
    end

    return if p1:find("^Arm%d") then t2.Arm else nil
end

local function reach(p2, p3, p4) -- line: 59
    local n1 = 1e999
    local n2 = (-1e999)

    for _, v2 in {
            p2.min.X,
            p2.max.X
        } do
        local v3 = n1
        local v4 = n2

        for _, v5 in {
                p2.min.Y,
                p2.max.Y
            } do
            for _, v8 in {
                    p2.min.Z,
                    p2.max.Z
                } do
                local v9 = (Vector3.new(v2, v5, v8) - p3):Dot(p4)

                v3 = math.min(v3, v9)
                v4 = math.max(v4, v9)
            end

            n2 = v4
            n1 = v3
        end
    end

    return n1, n2
end

function t1.spec(p5, p6) -- line: 74
    -- upvalues: t2 (copy), reach (copy)
    local v10

    if p6 then
        v10 = t2.Spine
    else
        local role = p5.role

        if role:find("^Neck") then
            v10 = t2.Neck
        elseif role == "Tentacles" then
            v10 = t2.Tentacles
        elseif role:find("^Arm%d") then
            v10 = t2.Arm
        end
    end

    if not v10 then
        return nil
    end

    local v11 = (p5.min + p5.max) / 2
    local v12, v13

    if p6 then
        v12 = Vector3.new(v11.X, v11.Y, p5.max.Z)
        v13 = Vector3.new(0, 0, -1)
    else
        local v14 = v11 - p5.joint

        if v14.Magnitude < 0.001 then
            return nil
        end

        v12 = p5.joint
        v13 = v14.Unit
    end

    local _, v15 = reach(p5, v12, v13)

    if v15 < 0.001 then
        return nil
    end

    local Unit = v13:Cross(if math.abs(v13.Y) > 0.8 then Vector3.new(0, 0, 1) else Vector3.new(0, 1, 0)).Unit
    local t3 = {
        live = false,
        origin = v12,
        dir = v13,
        length = v15,
        side = v13:Cross(Unit).Unit,
        lift = Unit,
        style = v10,
        offset = (tonumber(p5.role:match("%d+")) or 0) * 1.3,
        spine = p6,
        meshes = {},
        starts = {},
        sides = {},
        lifts = {},
        recoil = CFrame.identity,
        slices = {}
    }

    for v16, v17 in p5.parts do
        local v18 = p5.offsets[v16]

        if math.abs((v18.RightVector:Dot(v13))) * v17.Size.X + math.abs((v18.UpVector:Dot(v13))) * v17.Size.Y + math.abs((v18.LookVector:Dot(v13))) * v17.Size.Z >= v15 * 0.35 then
            if not v17:IsA("MeshPart") then
                return nil
            end

            table.insert(t3.meshes, v17)
        end
    end

    return t3
end

function t1.along(p7, p8) -- line: 130
    return (math.clamp((p8 - p7.origin):Dot(p7.dir), 0, p7.length))
end

local function turn(p9, p10, p11, p12) -- line: 134
    return CFrame.new(p10) * CFrame.fromAxisAngle(p9.side, p11) * CFrame.fromAxisAngle(p9.lift, p12) * CFrame.new(-p10)
end

function t1.at(p13, p14) -- line: 139
    -- upvalues: turn (copy)
    if not p13.live then
        return CFrame.identity
    end

    local v25 = p13.length / 10
    local v28 = math.clamp(math.floor(p14 / v25) + 1, 1, 10)
    local v30 = math.clamp((p14 - (v28 - 1) * v25) / v25, 0, 1)
    local v31 = p13.origin + p13.dir * ((v28 - 1) * v25)

    return p13.starts[v28] * turn(p13, v31, p13.sides[v28] * v30, p13.lifts[v28] * v30)
end

function t1.update(p15, p16, p17) -- line: 151
    -- upvalues: t1 (copy), rad (copy), sin (copy), cos (copy), turn (copy)
    local v32 = if p15.ready then math.clamp((os.clock() - p15.ready) / 0.6, 0, 1) else 0

    p15.live = v32 > 0

    if p15.live then
        local style = p15.style
        local v35 = math.max(1, 6.283185307179586 * style.waves) / 10 * p17 * v32
        local v36 = p15.length / 10
        local v37 = CFrame.identity
        local n3 = 0
        local n4 = 0
        local n5 = 0
        local n6 = 0

        for i = 1, 10 do
            local v38 = (i - 0.5) / 10
            local v39 = 1 - style.taper + style.taper * v38
            local v40 = p16 * style.speed - 6.283185307179586 * style.waves * v38 + p15.offset
            local v41 = rad(style.side) * v35 * v39 * sin(v40)
            local v44 = rad(style.lift) * v35 * v39 * cos(v40 * 0.8 + 1)

            p15.starts[i] = v37

            local sides, lifts = p15.sides, p15.lifts

            sides[i] = v41
            lifts[i] = v44
            v37 *= turn(p15, p15.origin + p15.dir * ((i - 1) * v36), v41, v44)
            n3 += v41
            n4 += v44
            n5 += n3
            n6 += n4
        end

        if not p15.spine then
            return
        end

        local v45 = Vector3.new(0, 0, 0)
        local v46 = Vector3.new(0, 0, 0)

        for i = 0, 10 do
            local v47 = p15.origin + p15.dir * (i * v36)

            v45 += v47
            v46 += t1.at(p15, i * v36) * v47
        end

        local v48 = v45 / 11
        local v49 = v46 / 11

        p15.recoil = CFrame.new(v48) * CFrame.fromAxisAngle(p15.side, -n5 / 10) * CFrame.fromAxisAngle(p15.lift, -n6 / 10) * CFrame.new(-v49)
    end
end

function t1.deform(p18, p19) -- line: 197
    -- upvalues: t1 (copy)
    if p18.live then
        for v50, v51 in p18.slices do
            local v52 = p19[v50]:Inverse()

            for _, v53 in v51.slices do
                local v54 = v52 * t1.at(p18, v53.d)

                for v55, v56 in v53.ids do
                    v51.editable:SetPosition(v56, v54 * v53.rest[v55] / v51.scale)
                end
            end
        end
    end
end

local function editable(p20, p21, p22) -- line: 213
    -- upvalues: AssetService (copy), t1 (copy)
    local v57 = AssetService:CreateEditableMeshAsync(Content.fromUri(p21.MeshId), {
        FixedSize = true
    })
    local v58 = p21.Size / p21.MeshSize
    local t4 = {}
    local t5 = {}

    local function v59() -- line: 219
        -- upvalues: p20 (copy), p22 (copy), v57 (copy), v58 (copy), t4 (copy), t5 (copy), t1 (copy)
        for _, v60 in v57:GetVertices() do
            local v61 = p22 * (v57:GetPosition(v60) * v58)
            local v63 = math.floor(t1.along(p20, v61) / p20.length * 64 + 0.5)
            local v64 = t4[v63]

            if not v64 then
                v64 = {
                    d = v63 / 64 * p20.length,
                    ids = {},
                    rest = {}
                }
                t4[v63] = v64
                table.insert(t5, v64)
            end

            table.insert(v64.ids, v60)
            table.insert(v64.rest, v61)
        end
    end

    local ok, result = pcall(v59)

    if not ok then
        v57:Destroy()
        error(result, 0)
    end

    local v65 = AssetService:CreateMeshPartAsync(Content.fromObject(v57), {
        CollisionFidelity = Enum.CollisionFidelity.Box
    })

    if p21.Parent and not ((v65.MeshSize - p21.MeshSize).Magnitude > 0.01 * p21.MeshSize.Magnitude) then
        local Size, TextureID = p21.Size, p21.TextureID

        p21:ApplyMesh(v65)
        p21.Size = Size
        p21.TextureID = TextureID
        p21.AncestryChanged:Connect(function() -- line: 246
            -- upvalues: p21 (copy), v57 (copy)
            if not p21:IsDescendantOf(game) then
                v57:Destroy()
            end
        end)

        return {
            editable = v57,
            scale = v58,
            slices = t5
        }
    end

    v57:Destroy()

    return nil
end

function t1.prepare(p23, p24) -- line: 256
    -- upvalues: RunService (copy), v1 (ref), editable (copy)
    if not v1 and RunService:IsClient() then
        if #p23.meshes == 0 then
            p23.ready = 0
        else
            task.spawn(function() -- line: 264
                -- upvalues: p23 (copy), p24 (copy), v1 (ref), editable (copy)
                local function v67() -- line: 265
                    -- upvalues: p23 (copy), p24 (copy), editable (copy)
                    for _, v68 in p23.meshes do
                        local v69 = editable(p23, v68, p24[v68])

                        if not v69 then
                            return
                        end

                        p23.slices[v68] = v69
                    end

                    p23.ready = os.clock()
                end

                local ok, result = pcall(v67)

                if not (ok or v1) then
                    if tostring(result):find("not accessible") then
                        v1 = true
                    end

                    warn("Animal bend unavailable, staying stiff: " .. tostring(result))
                end
            end)
        end
    end
end

return t1
