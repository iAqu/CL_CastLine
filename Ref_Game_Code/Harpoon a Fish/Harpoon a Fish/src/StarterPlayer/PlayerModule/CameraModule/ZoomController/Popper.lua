-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local CommonUtils = require(script.Parent.Parent.Parent:WaitForChild("CommonUtils"))
local FlagUtil = CommonUtils.get("FlagUtil")
local CameraWrapper = CommonUtils.get("CameraWrapper")
local ConnectionUtil = CommonUtils.get("ConnectionUtil")
local UserRaycastUpdateAPI2 = FlagUtil.getUserFlag("UserRaycastUpdateAPI2")
local UserCurrentCameraUpdate2 = FlagUtil.getUserFlag("UserCurrentCameraUpdate2")
local UserPlayerConnectionMemoryLeak = FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak")
local v1 = if UserCurrentCameraUpdate2 then CameraWrapper.new() else nil
local t1 = {}

if UserCurrentCameraUpdate2 then
    t1[1] = nil
    v1:Enable()
else
    t1[1] = game.Workspace.CurrentCamera
end

local min, tan, rad, new = math.min, math.tan, math.rad, Ray.new
local v2 = RaycastParams.new()

v2.IgnoreWater = true
v2.FilterType = Enum.RaycastFilterType.Exclude
v2.RespectCanCollide = true

local v3 = RaycastParams.new()

v3.IgnoreWater = true
v3.FilterType = Enum.RaycastFilterType.Include

local v4 = if UserPlayerConnectionMemoryLeak then ConnectionUtil.new() else nil

local function getTotalTransparency(p1) -- line: 43
    return 1 - (1 - p1.Transparency) * (1 - p1.LocalTransparencyModifier)
end

local function eraseFromEnd(p2, p3) -- line: 47
    for i = #p2, p3 + 1, -1 do
        p2[i] = nil
    end
end

local v5, v6, NearPlaneZ

if UserCurrentCameraUpdate2 then
    local function updateProjection() -- line: 57
        -- upvalues: tan (copy), rad (copy), v5 (ref), v6 (ref), v1 (copy)
        local v7 = v1:getCamera()
        local v8 = rad(v7.FieldOfView)
        local ViewportSize = v7.ViewportSize
        local v9 = ViewportSize.X / ViewportSize.Y

        v6 = tan(v8 / 2) * 2
        v5 = v9 * v6
    end

    v1:Connect("FieldOfView", updateProjection)
    v1:Connect("ViewportSize", updateProjection)

    local v11 = v1:getCamera()
    local v12 = rad(v11.FieldOfView)
    local ViewportSize = v11.ViewportSize
    local v13 = ViewportSize.X / ViewportSize.Y

    v6 = tan(v12 / 2) * 2
    v5 = v13 * v6
    NearPlaneZ = v1:getCamera().NearPlaneZ
    v1:Connect("NearPlaneZ", function() -- line: 73
        -- upvalues: NearPlaneZ (ref), v1 (copy)
        NearPlaneZ = v1:getCamera().NearPlaneZ
    end)
else
    local function updateProjection() -- line: 79
        -- upvalues: t1 (copy), tan (copy), rad (copy), v5 (ref), v6 (ref)
        local v14 = rad(t1[1].FieldOfView)
        local ViewportSize = t1[1].ViewportSize
        local v15 = ViewportSize.X / ViewportSize.Y

        v6 = tan(v14 / 2) * 2
        v5 = v15 * v6
    end

    t1[1]:GetPropertyChangedSignal("FieldOfView"):Connect(updateProjection)
    t1[1]:GetPropertyChangedSignal("ViewportSize"):Connect(updateProjection)

    local v17 = rad(t1[1].FieldOfView)
    local ViewportSize = t1[1].ViewportSize
    local v18 = ViewportSize.X / ViewportSize.Y

    v6 = tan(v17 / 2) * 2
    v5 = v18 * v6
    NearPlaneZ = t1[1].NearPlaneZ
    t1[1]:GetPropertyChangedSignal("NearPlaneZ"):Connect(function() -- line: 93
        -- upvalues: t1 (copy), NearPlaneZ (ref)
        NearPlaneZ = t1[1].NearPlaneZ
    end)
end

local t2 = {}
local t3 = {}

local function refreshIgnoreList() -- line: 103
    -- upvalues: t2 (ref), t3 (copy)
    t2 = {}

    local n1 = 1

    for _, v19 in pairs(t3) do
        local t4 = t2

        t4[n1] = v19
        n1 += 1
    end
end

local function playerAdded(p4) -- line: 112
    -- upvalues: UserPlayerConnectionMemoryLeak (copy), t2 (ref), t3 (copy), v4 (copy)
    local function characterAdded(p5) -- line: 113
        -- upvalues: p4 (copy), t2 (ref), t3 (copy)
        t3[p4] = p5
        t2 = {}

        local n2 = 1

        for _, v20 in pairs(t3) do
            t2[n2] = v20
            n2 += 1
        end
    end

    local function characterRemoving() -- line: 117
        -- upvalues: p4 (copy), t2 (ref), t3 (copy)
        t3[p4] = nil
        t2 = {}

        local n3 = 1

        for _, v21 in pairs(t3) do
            t2[n3] = v21
            n3 += 1
        end
    end

    if UserPlayerConnectionMemoryLeak then
        v4:trackConnection(("%*CharacterAdded"):format(p4.UserId), p4.CharacterAdded:Connect(characterAdded))
        v4:trackConnection(("%*CharacterRemoving"):format(p4.UserId), p4.CharacterRemoving:Connect(characterRemoving))
    else
        p4.CharacterAdded:Connect(characterAdded)
        p4.CharacterRemoving:Connect(characterRemoving)
    end

    if p4.Character then
        t3[p4] = p4.Character
        t2 = {}

        local n4 = 1

        for _, v22 in pairs(t3) do
            local t7 = t2

            t7[n4] = v22
            n4 += 1
        end
    end
end

local function playerRemoving(p6) -- line: 141
    -- upvalues: UserPlayerConnectionMemoryLeak (copy), t2 (ref), t3 (copy), v4 (copy)
    t3[p6] = nil
    t2 = {}

    local n5 = 1

    for _, v23 in pairs(t3) do
        t2[n5] = v23
        n5 += 1
    end

    if UserPlayerConnectionMemoryLeak then
        v4:disconnect((("%*CharacterAdded"):format(p6.UserId)))
        v4:disconnect((("%*CharacterRemoving"):format(p6.UserId)))
    end
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

for _, player in ipairs(Players:GetPlayers()) do
    playerAdded(player)
end

t2 = {}

local n6 = 1

for _, v24 in pairs(t3) do
    local t9 = t2

    t9[n6] = v24
    n6 += 1
end

local v25 = nil
local v26

if UserCurrentCameraUpdate2 then
    v1:Connect("CameraSubject", function() -- line: 181
        -- upvalues: v26 (ref), v1 (copy)
        local CameraSubject = v1:getCamera().CameraSubject

        if not (CameraSubject and CameraSubject:IsA("Humanoid")) then
            local BasePart = if CameraSubject then CameraSubject:IsA("BasePart") else nil

            v26 = if not CameraSubject or not BasePart then nil else CameraSubject
        else
            v26 = CameraSubject.RootPart
        end
    end)
else
    t1[1]:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 192
        -- upvalues: t1 (copy), v26 (ref)
        local CameraSubject = t1[1].CameraSubject

        v26 = if CameraSubject:IsA("Humanoid") then CameraSubject.RootPart elseif CameraSubject:IsA("BasePart") then CameraSubject else nil
    end)
end

local t10 = {
    Vector2.new(0.4, 0),
    Vector2.new(-0.4, 0),
    Vector2.new(0, -0.4),
    Vector2.new(0, 0.4),
    Vector2.new(0, 0.2)
}

local function getCollisionPoint(p7, p8) -- line: 231
    -- upvalues: UserRaycastUpdateAPI2 (copy), new (copy), v2 (copy), t2 (ref)
    if not UserRaycastUpdateAPI2 then
        local v27 = #t2
        local v28

        while true do
            local v29

            v29, v28 = workspace:FindPartOnRayWithIgnoreList(new(p7, p8), t2, false, true)

            if v29 then
                if v29.CanCollide then
                    break
                else
                    local t11 = t2

                    t11[#t2 + 1] = v29
                end
            end

            if v29 then
                continue
            end

            local t12 = t2

            for i = #t12, v27 + 1, -1 do
                t12[i] = nil
            end

            return p7 + p8, false
        end

        local t13 = t2

        for i = #t13, v27 + 1, -1 do
            t13[i] = nil
        end

        return v28, true
    end

    v2.FilterDescendantsInstances = t2

    local v30 = workspace:Raycast(p7, p8, v2)

    if v30 then
        return v30.Position, true
    end

    return p7 + p8, false
end

local function queryPoint(p9, p10, p11, p12) -- line: 262
    -- upvalues: UserRaycastUpdateAPI2 (copy), new (copy), v2 (copy), v3 (copy), NearPlaneZ (ref), t2 (ref), v25 (ref)
    debug.profilebegin("queryPoint")

    local v31 = #t2
    local v32 = p11 + NearPlaneZ
    local v33 = p9 + p10 * v32
    local v34, v35

    if UserRaycastUpdateAPI2 then
        v35 = 1e999
        v34 = 1e999
        v2.FilterDescendantsInstances = t2

        local v36 = p9
        local n7 = 0

        while true do
            local v37 = workspace:Raycast(v36, v33 - v36, v2)

            if v37 then
                n7 += 1

                local Instance, Position = v37.Instance, v37.Position
                local Magnitude = (Position - p9).Magnitude

                if n7 >= 64 then
                    v34 = Magnitude
                else
                    local CanCollide

                    if 1 - (1 - Instance.Transparency) * (1 - Instance.LocalTransparencyModifier) < 0.25 then
                        if UserRaycastUpdateAPI2 then
                            local v38 = v25

                            CanCollide = v38 ~= (Instance:GetRootPart() or Instance) and not Instance:IsA("TrussPart")
                        else
                            CanCollide = Instance.CanCollide

                            if CanCollide then
                                local v39 = v25

                                CanCollide = v39 ~= (Instance:GetRootPart() or Instance) and not Instance:IsA("TrussPart")
                            end
                        end
                    else
                        CanCollide = false
                    end

                    if CanCollide then
                        v3.FilterDescendantsInstances = { Instance }

                        local v40, v41

                        if workspace:Raycast(v33, Position - v33, v3) then
                            v40 = if p12 then workspace:Raycast(p12, v33 - p12, v3) or workspace:Raycast(v33, p12 - v33, v3) else false
                            v41 = false
                        else
                            v41 = true
                        end

                        if v41 or v40 then
                            v34 = Magnitude
                        elseif v32 < v35 then
                            v35 = Magnitude
                        end
                    end
                end

                v2:AddToFilter(Instance)
                v36 = Position - p10 * 0.001

                if not (v34 < 1e999) and Instance then
                    continue
                end
            end

            break
        end
    else
        local n8 = 1e999
        local n9 = 1e999
        local v42 = p9
        local n10 = 0

        while true do
            local v43, v44 = workspace:FindPartOnRayWithIgnoreList(new(v42, v33 - v42), t2, false, true)

            n10 += 1
            v34 = n9
            v35 = n8

            if v43 then
                local v45 = n10 >= 64
                local v46, v47

                if 1 - (1 - v43.Transparency) * (1 - v43.LocalTransparencyModifier) < 0.25 then
                    if UserRaycastUpdateAPI2 then
                        v47 = false
                    else
                        local CanCollide = v43.CanCollide

                        if CanCollide then
                            v47 = false
                        else
                            v46 = CanCollide
                            v47 = true
                        end
                    end
                else
                    v46 = false
                    v47 = true
                end

                if not v47 then
                    local v48 = v25

                    v46 = v48 ~= (v43:GetRootPart() or v43) and not v43:IsA("TrussPart")
                end

                if v46 or v45 then
                    local t14 = {
                        v43
                    }
                    local v49 = workspace:FindPartOnRayWithWhitelist(new(v33, v44 - v33), t14, true)

                    v34 = (v44 - p9).Magnitude

                    local v50, v51

                    if not v49 or v45 then
                        v51 = true
                    else
                        v50 = if p12 then workspace:FindPartOnRayWithWhitelist(new(p12, v33 - p12), t14, true) or workspace:FindPartOnRayWithWhitelist(new(v33, p12 - v33), t14, true) else false
                        v51 = false
                    end

                    if not v51 and not v50 then
                        if v32 < n8 then
                            v35 = v34
                        end

                        v34 = n9
                    end
                end

                local t15 = t2

                t15[#t2 + 1] = v43
                v42 = v44 - p10 * 0.001
            end

            if not (v34 < 1e999) and v43 then
                n8 = v35
                n9 = v34
                continue
            end

            break
        end

        local t16 = t2

        for i = #t16, v31 + 1, -1 do
            t16[i] = nil
        end
    end

    debug.profileend()

    return v35 - NearPlaneZ, v34 - NearPlaneZ
end

local function queryViewport(p13, p14) -- line: 373
    -- upvalues: UserCurrentCameraUpdate2 (copy), t1 (copy), v5 (ref), v6 (ref), NearPlaneZ (ref), queryPoint (copy), v1 (copy)
    debug.profilebegin("queryViewport")

    local Position, rightVector, upVector = p13.Position, p13.rightVector, p13.upVector
    local v52 = -p13.lookVector

    t1[1] = if UserCurrentCameraUpdate2 then v1:getCamera() else t1[1]

    local ViewportSize = t1[1].ViewportSize
    local n11 = 1e999
    local n12 = 1e999

    for i = 0, 1 do
        local v54 = rightVector * ((i - 0.5) * v5)

        for j = 0, 1 do
            local v55 = upVector * ((j - 0.5) * v6)
            local NearPlaneZ2 = NearPlaneZ
            local v57, v58 = queryPoint(Position + NearPlaneZ2 * (v54 + v55), v52, p14, t1[1]:ViewportPointToRay(ViewportSize.x * i, ViewportSize.y * j).Origin)

            if v58 < n11 then
                n11 = v58
            end

            if v57 < n12 then
                n12 = v57
            end
        end
    end

    debug.profileend()

    return n12, n11
end

local function testPromotion(p15, p16, p17) -- line: 413
    -- upvalues: min (copy), t10 (copy), getCollisionPoint (copy), queryPoint (copy)
    debug.profilebegin("testPromotion")

    local Position, rightVector, upVector = p15.Position, p15.rightVector, p15.upVector
    local v59 = -p15.lookVector

    debug.profilebegin("extrapolate")

    local Magnitude = (getCollisionPoint(Position, p17.posVelocity * 1.25) - Position).Magnitude
    local magnitude = p17.posVelocity.magnitude

    for i = 0, min(1.25, p17.rotVelocity.magnitude + Magnitude / magnitude), 0.0625 do
        local v61 = p17.extrapolate(i)

        if p16 <= queryPoint(v61.Position, -v61.lookVector, p16) then
            return false
        end
    end

    debug.profileend()
    debug.profilebegin("testOffsets")

    for _, v62 in ipairs(t10) do
        local v63 = getCollisionPoint(Position, rightVector * v62.x + upVector * v62.y)

        if queryPoint(v63, (Position + v59 * p16 - v63).Unit, p16) == 1e999 then
            return false
        end
    end

    debug.profileend()
    debug.profileend()

    return true
end

return function(p18, p19, p20) -- Popper | line: 462
    -- upvalues: v25 (ref), v26 (ref), queryViewport (copy), testPromotion (copy)
    debug.profilebegin("popper")
    v25 = v26 and v26:GetRootPart() or v26

    local v64, v65 = queryViewport(p18, p19)

    if not (v65 < p19) then
        v65 = p19
    end

    if not (v64 < v65 and testPromotion(p18, p19, p20)) then
        v64 = v65
    end

    v25 = nil
    debug.profileend()

    return v64
end
