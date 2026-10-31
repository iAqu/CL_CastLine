-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserRaycastUpdateAPI2 = require(script.Parent.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserRaycastUpdateAPI2")
local t1 = {
    LIMBS = 2,
    MOVEMENT = 3,
    CORNERS = 4,
    CIRCLE1 = 5,
    CIRCLE2 = 6,
    LIMBMOVE = 7,
    SMART_CIRCLE = 8,
    CHAR_OUTLINE = 9
}
local t2 = {
    Head = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftLowerArm = true,
    RightLowerArm = true,
    LeftUpperLeg = true,
    RightUpperLeg = true
}
local t3 = {
    (Vector3.new(1, 1, -1)),
    (Vector3.new(1, -1, -1)),
    (Vector3.new(-1, -1, -1)),
    (Vector3.new(-1, 1, -1))
}
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Exclude

local v2 = RaycastParams.new()

v2.FilterType = Enum.RaycastFilterType.Include

local function AssertTypes(p1, ...) -- line: 71
    local t4 = {}
    local v3 = ""

    for _, v4 in pairs({ ... }) do
        t4[v4] = true
        v3 ..= (if v3 == "" then "" else " or ") .. v4
    end

    local v5 = type(p1)

    assert(t4[v5], v3 .. " type expected, got: " .. v5)
end

local function Det3x3(p2, p3, p4, p5, p6, p7, p8, p9, p10) -- line: 83
    return p2 * (p6 * p10 - p7 * p9) - p3 * (p5 * p10 - p7 * p8) + p4 * (p5 * p9 - p6 * p8)
end

local function RayIntersection(p11, p12, p13, p14) -- line: 91
    local v8 = p12:Cross(p14)
    local v9 = p13.X - p11.X
    local v10 = p13.Y - p11.Y
    local v11 = p13.Z - p11.Z
    local X = p12.X
    local v12 = -p14.X
    local X2 = v8.X
    local Y = p12.Y
    local v13 = -p14.Y
    local Y2 = v8.Y
    local Z = p12.Z
    local v14 = -p14.Z
    local Z2 = v8.Z
    local v15 = X * (v13 * Z2 - Y2 * v14) - v12 * (Y * Z2 - Y2 * Z) + X2 * (Y * v14 - v13 * Z)

    if v15 ~= 0 then
        local v16 = -p14.X
        local X = v8.X
        local v17 = -p14.Y
        local Y = v8.Y
        local v18 = -p14.Z
        local Z = v8.Z
        local v19 = (v9 * (v17 * Z - Y * v18) - v16 * (v10 * Z - Y * v11) + X * (v10 * v18 - v17 * v11)) / v15
        local X2 = p12.X
        local X3 = v8.X
        local Y2 = p12.Y
        local Y3 = v8.Y
        local Z2 = p12.Z
        local Z3 = v8.Z
        local v20 = (X2 * (v10 * Z3 - Y3 * v11) - v9 * (Y2 * Z3 - Y3 * Z2) + X3 * (Y2 * v11 - v10 * Z2)) / v15
        local v21 = p11 + v19 * p12
        local v22 = p13 + v20 * p14
        local v23 = v21 + (v22 - v21) * 0.5

        if (v22 - v21).Magnitude < 0.25 then
            return v23
        end
    end

    return (Vector3.new(0, 0, 0))
end

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local self = setmetatable({}, BaseOcclusion)

self.__index = self

function self.new() -- line: 124
    -- upvalues: t1 (copy), BaseOcclusion (copy), self (copy)
    local v26 = setmetatable(BaseOcclusion.new(), self)

    v26.char = nil
    v26.humanoidRootPart = nil
    v26.torsoPart = nil
    v26.headPart = nil
    v26.childAddedConn = nil
    v26.childRemovedConn = nil
    v26.behaviors = {}
    v26.behaviors[t1.LIMBS] = v26.LimbBehavior
    v26.behaviors[t1.MOVEMENT] = v26.MoveBehavior
    v26.behaviors[t1.CORNERS] = v26.CornerBehavior
    v26.behaviors[t1.CIRCLE1] = v26.CircleBehavior
    v26.behaviors[t1.CIRCLE2] = v26.CircleBehavior
    v26.behaviors[t1.LIMBMOVE] = v26.LimbMoveBehavior
    v26.behaviors[t1.SMART_CIRCLE] = v26.SmartCircleBehavior
    v26.behaviors[t1.CHAR_OUTLINE] = v26.CharacterOutlineBehavior
    v26.mode = t1.SMART_CIRCLE
    v26.behaviorFunction = v26.SmartCircleBehavior
    v26.savedHits = {}
    v26.trackedLimbs = {}
    v26.camera = game.Workspace.CurrentCamera
    v26.enabled = false

    return v26
end

function self.Enable(p15, p16) -- line: 157
    p15.enabled = p16

    if not p16 then
        p15:Cleanup()
    end
end

function self.GetOcclusionMode(_) -- line: 165
    return Enum.DevCameraOcclusionMode.Invisicam
end

function self.LimbBehavior(p18, p19) -- line: 170
    for v27, _ in pairs(p18.trackedLimbs) do
        p19[#p19 + 1] = v27.Position
    end
end

function self.MoveBehavior(p20, p21) -- line: 176
    for i = 1, 3 do
        local humanoidRootPartPosition, Velocity = p20.humanoidRootPart.Position, p20.humanoidRootPart.Velocity
        local v28 = Vector3.new(Velocity.X, 0, Velocity.Z).Magnitude / 2
        local v29 = (i - 1) * p20.humanoidRootPart.CFrame.lookVector * v28

        p21[#p21 + 1] = humanoidRootPartPosition + v29
    end
end

function self.CornerBehavior(p22, p23) -- line: 185
    -- upvalues: t3 (copy)
    local CFrame = p22.humanoidRootPart.CFrame
    local CFramePosition = CFrame.Position
    local v30 = CFrame - CFramePosition
    local v31 = p22.char:GetExtentsSize() / 2

    p23[#p23 + 1] = CFramePosition

    for i = 1, #t3 do
        p23[#p23 + 1] = CFramePosition + v30 * (v31 * t3[i])
    end
end

function self.CircleBehavior(p24, p25) -- line: 196
    -- upvalues: t1 (copy)
    local v32

    if p24.mode == t1.CIRCLE1 then
        v32 = p24.humanoidRootPart.CFrame
    else
        local CoordinateFrame = p24.camera.CoordinateFrame

        v32 = CoordinateFrame - CoordinateFrame.Position + p24.humanoidRootPart.Position
    end

    p25[#p25 + 1] = v32.Position

    for i = 0, 9 do
        local v33 = 0.6283185307179586 * i
        local v36 = Vector3.new(math.cos(v33), math.sin(v33), 0) * 3

        p25[#p25 + 1] = v32 * v36
    end
end

function self.LimbMoveBehavior(p26, p27) -- line: 212
    p26:LimbBehavior(p27)
    p26:MoveBehavior(p27)
end

function self.CharacterOutlineBehavior(p28, p29) -- line: 217
    -- upvalues: UserRaycastUpdateAPI2 (copy), v2 (copy)
    local unit = p28.torsoPart.CFrame.upVector.unit
    local unit2 = p28.torsoPart.CFrame.rightVector.unit

    p29[#p29 + 1] = p28.torsoPart.CFrame.Position
    p29[#p29 + 1] = p28.torsoPart.CFrame.Position + unit
    p29[#p29 + 1] = p28.torsoPart.CFrame.Position - unit
    p29[#p29 + 1] = p28.torsoPart.CFrame.Position + unit2
    p29[#p29 + 1] = p28.torsoPart.CFrame.Position - unit2

    if p28.headPart then
        p29[#p29 + 1] = p28.headPart.CFrame.Position
    end

    local v37 = CFrame.new(Vector3.new(0, 0, 0), (Vector3.new(p28.camera.CoordinateFrame.lookVector.X, 0, p28.camera.CoordinateFrame.lookVector.Z)))
    local Position = p28.torsoPart and p28.torsoPart.Position or p28.humanoidRootPart.Position
    local t6 = {
        p28.torsoPart
    }

    if p28.headPart then
        t6[#t6 + 1] = p28.headPart
    end

    for i = 1, 24 do
        local v38 = 6.283185307179586 * i / 24
        local v41 = v37 * (Vector3.new(math.cos(v38), math.sin(v38), 0) * 3)
        local v43 = Vector3.new(v41.X, math.max(v41.Y, -2.25), v41.Z)

        if UserRaycastUpdateAPI2 then
            v2.FilterDescendantsInstances = t6

            local v44 = game.Workspace:Raycast(Position + v43, -3 * v43, v2)

            if v44 then
                local Position2 = v44.Position

                p29[#p29 + 1] = Position2 + 0.2 * (Position - Position2).unit
            end
        else
            local v45 = Ray.new(Position + v43, -3 * v43)
            local v46, v47 = game.Workspace:FindPartOnRayWithWhitelist(v45, t6, false)

            if v46 then
                p29[#p29 + 1] = v47 + 0.2 * (Position - v47).unit
            end
        end
    end
end

function self.SmartCircleBehavior(p30, p31) -- line: 268
    -- upvalues: UserRaycastUpdateAPI2 (copy), v1 (copy), RayIntersection (copy)
    local unit = p30.torsoPart.CFrame.upVector.unit
    local unit2 = p30.torsoPart.CFrame.rightVector.unit

    p31[#p31 + 1] = p30.torsoPart.CFrame.Position
    p31[#p31 + 1] = p30.torsoPart.CFrame.Position + unit
    p31[#p31 + 1] = p30.torsoPart.CFrame.Position - unit
    p31[#p31 + 1] = p30.torsoPart.CFrame.Position + unit2
    p31[#p31 + 1] = p30.torsoPart.CFrame.Position - unit2

    if p30.headPart then
        p31[#p31 + 1] = p30.headPart.CFrame.Position
    end

    local v48 = p30.camera.CFrame - p30.camera.CFrame.Position
    local v49 = Vector3.new(0, 0.5, 0) + (p30.torsoPart and p30.torsoPart.Position or p30.humanoidRootPart.Position)

    for i = 1, 24 do
        local v50 = 0.2617993877991494 * i - 1.5707963267948966
        local v53 = v49 + v48 * (Vector3.new(math.cos(v50), math.sin(v50), 0) * 2.5)
        local v54 = v53 - p30.camera.CFrame.Position

        if UserRaycastUpdateAPI2 then
            v1.FilterDescendantsInstances = { p30.char }

            local v55 = game.Workspace:Raycast(v49, v53 - v49, v1)
            local v56

            if v55 then
                local Position, Normal = v55.Position, v55.Normal
                local v57 = Position + 0.1 * Normal.unit
                local v58 = v57 - v49
                local unit = v58:Cross(v54).unit:Cross(Normal).unit
                local unit2 = (v57 - p30.camera.CFrame.Position).unit

                v56 = v57

                if v58.unit:Dot(-unit) < v58.unit:Dot(unit2) then
                    v56 = RayIntersection(v57, unit, v53, v54)

                    if v56.Magnitude > 0 then
                        local v59 = game.Workspace:Raycast(v57, v56 - v57, v1)

                        if v59 then
                            v56 = v59.Position + 0.1 * v59.Normal.Unit
                        end
                    else
                        v56 = v57
                    end
                end

                local v60 = game.Workspace:Raycast(v49, v56 - v49, v1)

                if v60 then
                    v56 = v60.Position - 0.1 * (v56 - v49).unit
                end
            else
                v56 = v53
            end

            p31[#p31 + 1] = v56
        else
            local v61 = Ray.new(v49, v53 - v49)
            local v62, v63, v64 = game.Workspace:FindPartOnRayWithIgnoreList(v61, { p30.char }, false, false)
            local v65

            if v62 then
                local v66 = v63 + 0.1 * v64.unit
                local v67 = v66 - v49
                local unit = v67:Cross(v54).unit:Cross(v64).unit
                local unit2 = (v66 - p30.camera.CFrame.Position).unit
                local v68 = v66

                if v67.unit:Dot(-unit) < v67.unit:Dot(unit2) then
                    v68 = RayIntersection(v66, unit, v53, v54)

                    if v68.Magnitude > 0 then
                        local v69 = Ray.new(v66, v68 - v66)
                        local v70, v71, v72 = game.Workspace:FindPartOnRayWithIgnoreList(v69, { p30.char }, false, false)

                        if v70 then
                            v68 = v71 + 0.1 * v72.unit
                        end
                    else
                        v68 = v66
                    end
                end

                local v73 = Ray.new(v49, v68 - v49)
                local v74, v75 = game.Workspace:FindPartOnRayWithIgnoreList(v73, { p30.char }, false, false)

                v65 = if v74 then v75 - 0.1 * (v68 - v49).unit else v68
            else
                v65 = v53
            end

            p31[#p31 + 1] = v65
        end
    end
end

function self.CheckTorsoReference(p32) -- line: 403
    if p32.char then
        p32.torsoPart = p32.char:FindFirstChild("Torso")

        if not p32.torsoPart then
            p32.torsoPart = p32.char:FindFirstChild("UpperTorso")

            if not p32.torsoPart then
                p32.torsoPart = p32.char:FindFirstChild("HumanoidRootPart")
            end
        end

        p32.headPart = p32.char:FindFirstChild("Head")
    end
end

function self.CharacterAdded(p33, p34, p35) -- line: 417
    -- upvalues: Players (copy), t2 (copy)
    if p35 ~= Players.LocalPlayer then
        return
    end

    if p33.childAddedConn then
        p33.childAddedConn:Disconnect()
        p33.childAddedConn = nil
    end

    if p33.childRemovedConn then
        p33.childRemovedConn:Disconnect()
        p33.childRemovedConn = nil
    end

    p33.char = p34
    p33.trackedLimbs = {}

    local function childAdded(p36) -- line: 433
        -- upvalues: p33 (copy), t2 (copy)
        if not p36:IsA("BasePart") then
            return
        end

        if t2[p36.Name] then
            p33.trackedLimbs[p36] = true
        end

        if p36.Name == "Torso" or p36.Name == "UpperTorso" then
            p33.torsoPart = p36
        end

        if p36.Name == "Head" then
            p33.headPart = p36
        end
    end

    local function childRemoved(p37) -- line: 449
        -- upvalues: p33 (copy)
        p33.trackedLimbs[p37] = nil
        p33:CheckTorsoReference()
    end

    p33.childAddedConn = p34.ChildAdded:Connect(childAdded)
    p33.childRemovedConn = p34.ChildRemoved:Connect(childRemoved)

    for _, child in pairs(p33.char:GetChildren()) do
        if child:IsA("BasePart") then
            if t2[child.Name] then
                p33.trackedLimbs[child] = true
            end

            if child.Name == "Torso" or child.Name == "UpperTorso" then
                p33.torsoPart = child
            end

            if child.Name == "Head" then
                p33.headPart = child
            end
        end
    end
end

function self.SetMode(p38, p39) -- line: 463
    -- upvalues: t1 (copy), AssertTypes (copy)
    AssertTypes(p39, "number")

    for _, v76 in pairs(t1) do
        if v76 == p39 then
            p38.mode = p39
            p38.behaviorFunction = p38.behaviors[p38.mode]

            return
        end
    end

    error("Invalid mode number")
end

function self.GetObscuredParts(p40) -- line: 475
    return p40.savedHits
end

function self.Cleanup(p41) -- line: 480
    for v77, v78 in pairs(p41.savedHits) do
        v77.LocalTransparencyModifier = v78
    end
end

function self.Update(p42, _, p44, p45) -- line: 486
    if not p42.enabled or not p42.char then
        return p44, p45
    end

    p42.camera = game.Workspace.CurrentCamera

    if not p42.humanoidRootPart then
        local Humanoid = p42.char:FindFirstChildOfClass("Humanoid")

        if not (Humanoid and Humanoid.RootPart) then
            p42.humanoidRootPart = p42.char:FindFirstChild("HumanoidRootPart")

            if not p42.humanoidRootPart then
                return p44, p45
            end
        else
            p42.humanoidRootPart = Humanoid.RootPart
        end

        local connection

        connection = p42.humanoidRootPart.AncestryChanged:Connect(function(p46, p47) -- line: 511
            -- upvalues: p42 (copy), connection (ref)
            if p46 == p42.humanoidRootPart and not p47 then
                p42.humanoidRootPart = nil

                if connection and connection.Connected then
                    connection:Disconnect()
                    connection = nil
                end
            end
        end)
    end

    if not p42.torsoPart then
        p42:CheckTorsoReference()

        if not p42.torsoPart then
            return p44, p45
        end
    end

    local t7 = {}

    p42.behaviorFunction(p42, t7)

    local t8 = {}
    local t9 = {
        p42.char
    }

    local function add(p48) -- line: 537
        -- upvalues: p42 (copy), t8 (copy)
        t8[p48] = true

        if not p42.savedHits[p48] then
            p42.savedHits[p48] = p48.LocalTransparencyModifier
        end
    end

    local t10 = {}
    local Position = p42.headPart and p42.headPart.CFrame.Position or t7[1]
    local Position2 = p42.torsoPart and p42.torsoPart.CFrame.Position or t7[2]
    local PartsObscuringTarget = p42.camera:GetPartsObscuringTarget({ Position, Position2 }, t9)
    local n1 = 0

    for i = 1, #PartsObscuringTarget do
        local v80 = PartsObscuringTarget[i]

        n1 += 1
        t10[v80] = true

        for _, child in pairs(v80:GetChildren()) do
            if child:IsA("Decal") or child:IsA("Texture") then
                n1 += 1
                break
            end
        end
    end

    local v81, v82

    if n1 > 0 then
        v81 = math.pow(0.375 / n1 + 0.375, 1 / n1)
        v82 = math.pow(0.25 / n1 + 0.25, 1 / n1)
    else
        v81 = 0.75
        v82 = 0.75
    end

    local PartsObscuringTarget2 = p42.camera:GetPartsObscuringTarget(t7, t9)
    local t11 = {}

    for i = 1, #PartsObscuringTarget2 do
        local v87 = PartsObscuringTarget2[i]

        if not t10[v87] or not v81 then
            t11[v87] = v82
        else
            t11[v87] = v81
        end

        if v87.Transparency < t11[v87] then
            t8[v87] = true

            if not p42.savedHits[v87] then
                p42.savedHits[v87] = v87.LocalTransparencyModifier
            end
        end

        for _, child in pairs(v87:GetChildren()) do
            if (child:IsA("Decal") or child:IsA("Texture")) and child.Transparency < t11[v87] then
                t11[child] = t11[v87]
                t8[child] = true

                if not p42.savedHits[child] then
                    p42.savedHits[child] = child.LocalTransparencyModifier
                end
            end
        end
    end

    for v88, v89 in pairs(p42.savedHits) do
        if t8[v88] then
            v88.LocalTransparencyModifier = v88.Transparency < 1 and (t11[v88] - v88.Transparency) / (1 - v88.Transparency) or 0
        else
            v88.LocalTransparencyModifier = v89
            p42.savedHits[v88] = nil
        end
    end

    return p44, p45
end

return self
