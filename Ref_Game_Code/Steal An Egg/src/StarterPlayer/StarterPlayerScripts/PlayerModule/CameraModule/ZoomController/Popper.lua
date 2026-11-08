-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local CommonUtils = script.Parent.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraWrapper = require(CommonUtils:WaitForChild("CameraWrapper"))
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
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

local min, tan, rad, _ = math.min, math.tan, math.rad, Ray.new
local v2 = RaycastParams.new()

v2.IgnoreWater = true
v2.FilterType = Enum.RaycastFilterType.Exclude
v2.RespectCanCollide = true
v2.CollisionGroup = "Players"

local v3 = RaycastParams.new()

v3.IgnoreWater = true
v3.FilterType = Enum.RaycastFilterType.Include

local v4 = if UserPlayerConnectionMemoryLeak then ConnectionUtil.new() else nil
local v5
local n1 = 1e999
local v6 = ""
local v7, v8

local function _debugResetLimiter() -- line: 54
    -- upvalues: v5 (ref), n1 (ref), v6 (ref), v7 (ref), v8 (ref)
    v5 = nil
    n1 = 1e999
    v6 = ""
    v7 = nil
    v8 = nil
end

local function _debugConsiderLimiter(_, _, _, _, _) -- line: 62
end

local function _debugFlushLimiter(_, _) -- line: 78
end

local function getTotalTransparency(p8) -- line: 109
    return 1 - (1 - p8.Transparency) * (1 - p8.LocalTransparencyModifier)
end

local function eraseFromEnd(p9, p10) -- line: 113
    for i = #p9, p10 + 1, -1 do
        p9[i] = nil
    end
end

local v9, v10, NearPlaneZ

if UserCurrentCameraUpdate2 then
    local function updateProjection() -- line: 123
        -- upvalues: tan (copy), rad (copy), v9 (ref), v10 (ref), v1 (copy)
        local v11 = v1:getCamera()
        local v12 = rad(v11.FieldOfView)
        local ViewportSize = v11.ViewportSize
        local v13 = ViewportSize.X / ViewportSize.Y

        v10 = tan(v12 / 2) * 2
        v9 = v13 * v10
    end

    v1:Connect("FieldOfView", updateProjection)
    v1:Connect("ViewportSize", updateProjection)

    local v15 = v1:getCamera()
    local v16 = rad(v15.FieldOfView)
    local ViewportSize = v15.ViewportSize
    local v17 = ViewportSize.X / ViewportSize.Y

    v10 = tan(v16 / 2) * 2
    v9 = v17 * v10
    NearPlaneZ = v1:getCamera().NearPlaneZ
    v1:Connect("NearPlaneZ", function() -- line: 139
        -- upvalues: NearPlaneZ (ref), v1 (copy)
        NearPlaneZ = v1:getCamera().NearPlaneZ
    end)
else
    local function updateProjection() -- line: 145
        -- upvalues: t1 (copy), tan (copy), rad (copy), v9 (ref), v10 (ref)
        local v18 = rad(t1[1].FieldOfView)
        local ViewportSize = t1[1].ViewportSize
        local v19 = ViewportSize.X / ViewportSize.Y

        v10 = tan(v18 / 2) * 2
        v9 = v19 * v10
    end

    t1[1]:GetPropertyChangedSignal("FieldOfView"):Connect(updateProjection)
    t1[1]:GetPropertyChangedSignal("ViewportSize"):Connect(updateProjection)

    local v21 = rad(t1[1].FieldOfView)
    local ViewportSize = t1[1].ViewportSize
    local v22 = ViewportSize.X / ViewportSize.Y

    v10 = tan(v21 / 2) * 2
    v9 = v22 * v10
    NearPlaneZ = t1[1].NearPlaneZ
    t1[1]:GetPropertyChangedSignal("NearPlaneZ"):Connect(function() -- line: 159
        -- upvalues: t1 (copy), NearPlaneZ (ref)
        NearPlaneZ = t1[1].NearPlaneZ
    end)
end

local t2 = {}
local t3 = {}

local function refreshIgnoreList() -- line: 168
    -- upvalues: t2 (ref), t3 (copy)
    t2 = {}

    local n2 = 1

    for _, v23 in pairs(t3) do
        local t4 = t2

        t4[n2] = v23
        n2 += 1
    end
end

local function playerAdded(p11) -- line: 177
    -- upvalues: UserPlayerConnectionMemoryLeak (copy), t2 (ref), t3 (copy), v4 (copy)
    local function characterAdded(p12) -- line: 178
        -- upvalues: p11 (copy), t2 (ref), t3 (copy)
        t3[p11] = p12
        t2 = {}

        local n3 = 1

        for _, v24 in pairs(t3) do
            t2[n3] = v24
            n3 += 1
        end
    end

    local function characterRemoving() -- line: 182
        -- upvalues: p11 (copy), t2 (ref), t3 (copy)
        t3[p11] = nil
        t2 = {}

        local n4 = 1

        for _, v25 in pairs(t3) do
            t2[n4] = v25
            n4 += 1
        end
    end

    if UserPlayerConnectionMemoryLeak then
        v4:trackConnection(("%*CharacterAdded"):format(p11.UserId), p11.CharacterAdded:Connect(characterAdded))
        v4:trackConnection(("%*CharacterRemoving"):format(p11.UserId), p11.CharacterRemoving:Connect(characterRemoving))
    else
        p11.CharacterAdded:Connect(characterAdded)
        p11.CharacterRemoving:Connect(characterRemoving)
    end

    if p11.Character then
        t3[p11] = p11.Character
        t2 = {}

        local n5 = 1

        for _, v26 in pairs(t3) do
            local t7 = t2

            t7[n5] = v26
            n5 += 1
        end
    end
end

local function playerRemoving(p13) -- line: 200
    -- upvalues: UserPlayerConnectionMemoryLeak (copy), t2 (ref), t3 (copy), v4 (copy)
    t3[p13] = nil
    t2 = {}

    local n6 = 1

    for _, v27 in pairs(t3) do
        t2[n6] = v27
        n6 += 1
    end

    if UserPlayerConnectionMemoryLeak then
        v4:disconnect((("%*CharacterAdded"):format(p13.UserId)))
        v4:disconnect((("%*CharacterRemoving"):format(p13.UserId)))
    end
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

for _, player in ipairs(Players:GetPlayers()) do
    playerAdded(player)
end

t2 = {}

local n7 = 1

for _, v28 in pairs(t3) do
    local t9 = t2

    t9[n7] = v28
    n7 += 1
end

local v29 = nil
local v30

if UserCurrentCameraUpdate2 then
    v1:Connect("CameraSubject", function() -- line: 240
        -- upvalues: v30 (ref), v1 (copy)
        local CameraSubject = v1:getCamera().CameraSubject

        if not (CameraSubject and CameraSubject:IsA("Humanoid")) then
            local BasePart = if CameraSubject then CameraSubject:IsA("BasePart") else nil

            v30 = if not CameraSubject or not BasePart then nil else CameraSubject
        else
            v30 = CameraSubject.RootPart
        end
    end)
else
    t1[1]:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- line: 251
        -- upvalues: t1 (copy), v30 (ref)
        local CameraSubject = t1[1].CameraSubject

        v30 = if CameraSubject:IsA("Humanoid") then CameraSubject.RootPart elseif CameraSubject:IsA("BasePart") then CameraSubject else nil
    end)
end

local t10 = {
    Vector2.new(0.4, 0),
    Vector2.new(-0.4, 0),
    Vector2.new(0, -0.4),
    Vector2.new(0, 0.4),
    Vector2.new(0, 0.2)
}

local function getCollisionPoint(p14, p15) -- line: 291
    -- upvalues: v2 (copy), t2 (ref)
    v2.FilterDescendantsInstances = t2

    local v31

    while true do
        v31 = workspace:Raycast(p14, p15, v2)

        if v31 then
            if v31.Instance.CanCollide then
                break
            else
                v2:AddToFilter(v31.Instance)
            end
        end

        if v31 then
            continue
        end

        return p14 + p15, false
    end

    return v31.Position, true
end

local function queryPoint(p16, p17, p18, p19) -- line: 329
    -- upvalues: v2 (copy), v3 (copy), NearPlaneZ (ref), t2 (ref), v29 (ref)
    debug.profilebegin("queryPoint")

    local _ = #t2
    local v32 = p18 + NearPlaneZ
    local v33 = p16 + p17 * v32

    v2.FilterDescendantsInstances = t2

    local n8 = 1e999
    local n9 = 1e999
    local v34 = p16
    local n10 = 0

    while true do
        local v35 = workspace:Raycast(v34, v33 - v34, v2)

        if v35 then
            n10 += 1

            local Instance, Position = v35.Instance, v35.Position
            local Magnitude = (Position - p16).Magnitude

            if n10 >= 64 then
                n9 = Magnitude

                local _ = Magnitude - NearPlaneZ
            else
                local CanCollide

                if 1 - (1 - Instance.Transparency) * (1 - Instance.LocalTransparencyModifier) < 0.25 then
                    CanCollide = Instance.CanCollide

                    if CanCollide then
                        local v36 = v29

                        CanCollide = v36 ~= (Instance:GetRootPart() or Instance) and not Instance:IsA("TrussPart")
                    end
                else
                    CanCollide = false
                end

                if CanCollide then
                    v3.FilterDescendantsInstances = { Instance }

                    if not workspace:Raycast(v33, Position - v33, v3) or p19 and (workspace:Raycast(p19, v33 - p19, v3) or workspace:Raycast(v33, p19 - v33, v3)) then
                        n9 = Magnitude

                        local _ = Magnitude - NearPlaneZ
                    elseif v32 < n8 then
                        n8 = Magnitude

                        local _ = Magnitude - NearPlaneZ
                    end
                end
            end

            v2:AddToFilter(Instance)
            v34 = Position - p17 * 0.001

            if not (n9 < 1e999) and Instance then
                continue
            end
        end

        break
    end

    debug.profileend()

    return n8 - NearPlaneZ, n9 - NearPlaneZ
end

local function queryViewport(p20, p21) -- line: 438
    -- upvalues: UserCurrentCameraUpdate2 (copy), t1 (copy), v9 (ref), v10 (ref), NearPlaneZ (ref), queryPoint (copy), v1 (copy)
    debug.profilebegin("queryViewport")

    local p, rightVector, upVector = p20.p, p20.rightVector, p20.upVector
    local v37 = -p20.lookVector

    t1[1] = if UserCurrentCameraUpdate2 then v1:getCamera() else t1[1]

    local ViewportSize = t1[1].ViewportSize
    local n11 = 1e999
    local n12 = 1e999

    for i = 0, 1 do
        local v39 = rightVector * ((i - 0.5) * v9)

        for j = 0, 1 do
            local v40 = upVector * ((j - 0.5) * v10)
            local NearPlaneZ2 = NearPlaneZ
            local v42, v43 = queryPoint(p + NearPlaneZ2 * (v39 + v40), v37, p21, t1[1]:ViewportPointToRay(ViewportSize.x * i, ViewportSize.y * j).Origin)

            if v43 < n11 then
                n11 = v43
            end

            if v42 < n12 then
                n12 = v42
            end
        end
    end

    debug.profileend()

    return n12, n11
end

local function testPromotion(p22, p23, p24) -- line: 481
    -- upvalues: min (copy), t10 (copy), getCollisionPoint (copy), queryPoint (copy)
    debug.profilebegin("testPromotion")

    local p, rightVector, upVector = p22.p, p22.rightVector, p22.upVector
    local v44 = -p22.lookVector

    debug.profilebegin("extrapolate")

    local Magnitude = (getCollisionPoint(p, p24.posVelocity * 1.25) - p).Magnitude
    local magnitude = p24.posVelocity.magnitude

    for i = 0, min(1.25, p24.rotVelocity.magnitude + Magnitude / magnitude), 0.0625 do
        local v46 = p24.extrapolate(i)

        if p23 <= queryPoint(v46.p, -v46.lookVector, p23) then
            return false
        end
    end

    debug.profileend()
    debug.profilebegin("testOffsets")

    for _, v47 in ipairs(t10) do
        local v48 = getCollisionPoint(p, rightVector * v47.x + upVector * v47.y)

        if queryPoint(v48, (p + v44 * p23 - v48).Unit, p23) == 1e999 then
            return false
        end
    end

    debug.profileend()
    debug.profileend()

    return true
end

return function(p25, p26, p27) -- Popper | line: 530
    -- upvalues: v5 (ref), n1 (ref), v6 (ref), v7 (ref), v8 (ref), v29 (ref), v30 (ref), queryViewport (copy), testPromotion (copy)
    debug.profilebegin("popper")
    v5 = nil
    n1 = 1e999
    v6 = ""
    v7 = nil
    v8 = nil
    v29 = v30 and v30:GetRootPart() or v30

    local v49, v50 = queryViewport(p25, p26)

    if not (v50 < p26) then
        v50 = p26
    end

    if not (v49 < v50 and testPromotion(p25, p26, p27)) then
        v49 = v50
    end

    v29 = nil
    debug.profileend()

    return v49
end
