-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Kit = require(script.Parent.Kit)
local Vfx = require(script.Parent.Vfx)
local v1 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local t1 = {
    0, 3.141592653589793, 0.7853981633974483, -0.7853981633974483, 3.9269908169872414, 2.356194490192345
}

local function flat(p1) -- line: 45
    return (Vector3.new(p1.X, 0, p1.Z))
end

local function visibleBounds(p2) -- line: 49
    if p2 == nil or p2.Parent == nil then
        return nil, nil
    end

    local v3, v4

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") and not (descendant.Transparency >= 1) then
            local CFrame = descendant.CFrame
            local v5 = descendant.Size / 2
            local v6 = CFrame.XVector:Abs() * v5.X + CFrame.YVector:Abs() * v5.Y + CFrame.ZVector:Abs() * v5.Z
            local v7 = CFrame.Position - v6
            local v8 = CFrame.Position + v6

            v3 = if v3 then v3:Min(v7) else v7
            v4 = if v4 then v4:Max(v8) else v8
        end
    end

    return v3, v4
end

local function subjectCorners(p3, p4) -- line: 78
    -- upvalues: visibleBounds (copy)
    table.clear(p4)

    local v9, v10

    for _, v11 in p3 do
        local v12, v13 = visibleBounds(v11.Model)

        if v12 == nil or v13 == nil then
            v12 = v11.Fallback - Vector3.new(1.5, 0, 1.5)
            v13 = v12 + Vector3.new(3, 5, 3)
        end

        for _, v14 in {
                v12.X,
                v13.X
            } do
            for _, v15 in {
                    v12.Y,
                    v13.Y
                } do
                for _, v16 in {
                        v12.Z,
                        v13.Z
                    } do
                    table.insert(p4, (Vector3.new(v14, v15, v16)))
                end
            end
        end

        v9 = if v9 then v9:Min(v12) else v12
        v10 = if v10 then v10:Max(v13) else v13
    end

    return (v9 + v10) / 2
end

local function frameBasis(p5, p6) -- line: 109
    local v18 = p6 * 0.9781476007338057 + Vector3.new(0, 0.20791169, 0)

    return CFrame.lookAt(p5 + v18, p5)
end

local function fitDistance(p7, p8, p9, p10, p11) -- line: 115
    local v20 = math.tan(math.rad(p10) / 2)
    local v21 = v20 * p11
    local n1 = 6

    for _, v22 in p7 do
        local v23 = v22 - p8
        local v24 = -v23:Dot(p9.LookVector)

        n1 = math.max(n1, math.abs((v23:Dot(p9.RightVector))) / (v21 * 0.8) + v24, math.abs((v23:Dot(p9.UpVector))) / (v20 * 0.42) + v24)
    end

    return n1 * 1.12
end

local function freeDistance(p12, p13, p14, p15) -- line: 138
    -- upvalues: Workspace (copy)
    local v29 = RaycastParams.new()

    v29.FilterType = Enum.RaycastFilterType.Exclude
    v29.FilterDescendantsInstances = p15

    for _ = 1, 8 do
        local v30 = Workspace:Raycast(p12, p13 * p14, v29)

        if v30 == nil then
            return p14
        end

        local Instance = v30.Instance

        if not (Instance:IsA("BasePart") and Instance.Transparency >= 0.9) then
            return v30.Distance
        end

        v29:AddToFilter(Instance)
    end

    return p14
end

local function yawed(p16, p17) -- line: 165
    return CFrame.fromAxisAngle(Vector3.new(0, 1, 0), p17):VectorToWorldSpace(p16)
end

local function setBars(p18, p19) -- line: 169
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy)
    local BarTop = p18:FindFirstChild("BarTop")
    local BarBottom = p18:FindFirstChild("BarBottom")

    if BarTop == nil or BarBottom == nil then
        return
    end

    BarTop.Visible = true
    BarBottom.Visible = true

    local v31 = if p19 then v1 else v2

    TweenService:Create(BarTop, v31, {
        Position = UDim2.fromScale(0, p19 and 0 or -0.13)
    }):Play()
    TweenService:Create(BarBottom, v31, {
        Position = UDim2.fromScale(0, p19 and 0.87 or 1)
    }):Play()
end

local function freezeCharacter(p20) -- line: 187
    local t4 = {}
    local v32 = p20 and p20:FindFirstChildWhichIsA("Animator", true)

    if v32 then
        for _, v33 in v32:GetPlayingAnimationTracks() do
            v33:AdjustSpeed(0)
            table.insert(t4, v33)
        end
    end

    return function() -- line: 197
        -- upvalues: t4 (copy)
        for _, v34 in t4 do
            v34:AdjustSpeed(1)
        end
    end
end

local function attachTrail(p21, p22) -- line: 204
    -- upvalues: Vfx (copy)
    local v35 = p21 and p21.PrimaryPart

    if p21 ~= nil and v35 ~= nil then
        local _, BoundingBox = p21:GetBoundingBox()

        for _, v36 in Vfx.Trail(v35, BoundingBox.X) do
            p22:Add(v36)
        end
    end
end

local function hideBystanders(p23, p24) -- line: 216
    -- upvalues: Players (copy), RunService (copy)
    local t5 = {}
    local t6 = {}
    local t7 = {}
    local v37 = false

    local function hide() -- line: 222
        -- upvalues: p23 (copy), t5 (copy), t6 (copy), t7 (copy), Players (copy)
        for _, player in Players:GetPlayers() do
            local Character = player.Character

            if player ~= p23 and Character ~= nil then
                for _, descendant in Character:GetDescendants() do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        if t5[descendant] == nil then
                            t5[descendant] = descendant.LocalTransparencyModifier
                        end

                        descendant.LocalTransparencyModifier = 1
                    elseif descendant:IsA("BillboardGui") and t6[descendant] == nil then
                        t6[descendant] = descendant.Enabled
                        descendant.Enabled = false
                    elseif descendant:IsA("Humanoid") and t7[descendant] == nil then
                        t7[descendant] = descendant.DisplayDistanceType
                        descendant.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    end
                end
            end
        end
    end

    local function restore() -- line: 246
        -- upvalues: t5 (copy), t6 (copy), t7 (copy), v37 (ref), RunService (copy)
        if v37 then
            return
        end

        v37 = true
        RunService:UnbindFromRenderStep("ScrambleFinalHitHide")

        for v38, v39 in t5 do
            v38.LocalTransparencyModifier = v39
        end

        for v40, v41 in t6 do
            v40.Enabled = v41
        end

        for v42, v43 in t7 do
            v42.DisplayDistanceType = v43
        end
    end

    hide()
    RunService:BindToRenderStep("ScrambleFinalHitHide", Enum.RenderPriority.Camera.Value + 1, hide)
    p24:Add(restore)
    task.delay(7.2, restore)
end

return {
    FinalHit = function(p25, p26, p27, p28) -- FinalHit | line: 272
        -- upvalues: Lighting (copy), Players (copy), RunService (copy), TweenService (copy), Workspace (copy), HiddenUIHandler (copy), Kit (copy), Vfx (copy), t1 (copy), visibleBounds (copy), subjectCorners (copy), fitDistance (copy), freeDistance (copy), setBars (copy), freezeCharacter (copy), attachTrail (copy), hideBystanders (copy)
        local CurrentCamera = Workspace.CurrentCamera

        if CurrentCamera == nil then
            return
        end

        local PlayerByUserId = Players:GetPlayerByUserId(p28.UserId or 0)
        local v44 = p28.At or Vector3.new(0, 0, 0)
        local v45 = p28.From or v44
        local v46 = v44 - v45
        local v47 = Vector3.new(v46.X, 0, v46.Z)

        if v47.Magnitude < 0.1 then
            v47 = Vector3.new(0, 0, 1)
        end

        local Unit = v47.Unit
        local v48 = Unit:Cross((Vector3.new(0, 1, 0)))
        local CameraType, FieldOfView, CameraSubject = CurrentCamera.CameraType, CurrentCamera.FieldOfView, CurrentCamera.CameraSubject
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

        ColorCorrectionEffect.Name = "ScrambleFinalHit"
        ColorCorrectionEffect.Parent = Lighting

        local BlurEffect = Instance.new("BlurEffect")

        BlurEffect.Name = "ScrambleFinalHitBlur"
        BlurEffect.Size = 0
        BlurEffect.Parent = Lighting

        local v49 = p25:Extend()
        local v50 = HiddenUIHandler.Acquire()

        v49:Add(ColorCorrectionEffect)
        v49:Add(BlurEffect)
        v49:Add(v50)
        v49:Add(function() -- line: 310
            -- upvalues: p27 (copy), CurrentCamera (copy), CameraType (copy), FieldOfView (copy), CameraSubject (copy), setBars (copy)
            CurrentCamera.CameraType = CameraType
            CurrentCamera.FieldOfView = FieldOfView

            if CameraSubject and CameraSubject.Parent then
                CurrentCamera.CameraSubject = CameraSubject
            end

            setBars(p27.Gui, false)
        end)

        local ScrambleHuman = p26:FindFirstChild("ScrambleHuman")

        hideBystanders(PlayerByUserId, v49)

        local v51 = freezeCharacter(PlayerByUserId and PlayerByUserId.Character)

        v49:Add(v51)
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        setBars(p27.Gui, true)
        p27:FlashScreen(Color3.new(1, 1, 1), 0.3, 1)
        Kit.Sound("FinalHit", nil, 1.5)
        Kit.Sound("Boom", nil, 1.2, 0.8)
        ColorCorrectionEffect.Saturation = -1
        ColorCorrectionEffect.Contrast = 0.9
        BlurEffect.Size = 6
        task.delay(0.14, function() -- line: 332
            -- upvalues: ColorCorrectionEffect (copy), BlurEffect (copy)
            ColorCorrectionEffect.Saturation = 0.35
            ColorCorrectionEffect.Contrast = 0.25
            BlurEffect.Size = 0
        end)
        Vfx.Burst("SpiderSlashes", Vfx.Frame("SpiderSlashes", v44, Unit), 0.8, 0.3)
        p27:Say(if PlayerByUserId then ("%*!"):format((string.upper(PlayerByUserId.DisplayName))) else "FINAL HIT!", "FINAL HIT", 2.4)

        local t9 = {
            {
                Model = PlayerByUserId and PlayerByUserId.Character,
                Fallback = v45 - Vector3.new(0, 3, 0)
            },
            {
                Model = ScrambleHuman,
                Fallback = v44
            }
        }
        local t12 = {}

        for _, player in Players:GetPlayers() do
            if player.Character then
                table.insert(t12, player.Character)
            end
        end

        if ScrambleHuman then
            table.insert(t12, ScrambleHuman)
        end

        local t13 = {}
        local v53 = subjectCorners(t9, t13)
        local v54 = CurrentCamera.ViewportSize.X / math.max(CurrentCamera.ViewportSize.Y, 1)
        local v55 = t9[2].Fallback - t9[1].Fallback
        local v56 = Vector3.new(v55.X, 0, v55.Z)

        if ScrambleHuman and PlayerByUserId and PlayerByUserId.Character then
            local v57, v58 = visibleBounds(ScrambleHuman)
            local v59, v60 = visibleBounds(PlayerByUserId.Character)

            if v57 and v58 and v59 and v60 then
                local v61 = (v57 + v58) / 2 - (v59 + v60) / 2

                v56 = Vector3.new(v61.X, 0, v61.Z)
            end
        end

        local v62 = if v56.Magnitude > 0.1 then v56.Unit:Cross((Vector3.new(0, 1, 0))) else v48
        local v63 = v62
        local n2 = -1
        local v64 = v62
        local n3 = -1
        local n4 = 38

        for _, v65 in t1 do
            v64 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v65):VectorToWorldSpace(v62)

            local v66 = v64 * 0.9781476007338057 + Vector3.new(0, 0.20791169, 0)
            local v67 = CFrame.lookAt(v53 + v66, v53)
            local v68 = fitDistance(t13, v53, v67, 38, v54)

            n3 = freeDistance(v53, -v67.LookVector, v68 + 2, t12)

            if v68 + 0.75 <= n3 then
                break
            end

            if n2 < n3 then
                n2 = n3
                v63 = v64
            end

            v64 = v63
            n3 = n2
        end

        while n4 < 80 do
            local v69 = v64 * 0.9781476007338057 + Vector3.new(0, 0.20791169, 0)

            if fitDistance(t13, v53, CFrame.lookAt(v53 + v69, v53), n4, v54) + 0.75 <= n3 then
                break
            end

            n4 += 4
        end

        local v71 = math.max(52, n4)
        local elapsed = os.clock()

        while os.clock() - elapsed < 2.6 do
            local v72 = 1 - (1 - (os.clock() - elapsed) / 2.6) ^ 3

            v53 = v53:Lerp(subjectCorners(t9, t13), 0.25)

            local v73 = v71 + (n4 - v71) * v72
            local v74 = 0.2792526803190927 * (0.5 - v72)
            local v75 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v74):VectorToWorldSpace(v64) * 0.9781476007338057 + Vector3.new(0, 0.20791169, 0)
            local v76 = CFrame.lookAt(v53 + v75, v53)
            local v77 = -v76.LookVector
            local v78 = fitDistance(t13, v53, v76, v73, v54)
            local v81 = math.max(math.min(v78, freeDistance(v53, v77, v78 + 1, t12) - 0.75), 1)
            local v83 = math.tan(math.rad(v73) / 2)
            local v84 = v53 + v77 * v81
            local v85 = v53 - v76.UpVector * (v83 * 0.3 * v81)

            CurrentCamera.CFrame = CFrame.lookAt(v84, v85) * CFrame.Angles(0, 0, (math.rad(-4 - v72 * 5)))
            CurrentCamera.FieldOfView = v73
            RunService.RenderStepped:Wait()
        end

        v51()
        ColorCorrectionEffect.Saturation = 0.2
        ColorCorrectionEffect.Contrast = 0.1
        p27:FlashScreen(Color3.new(1, 1, 1), 0.25, 0.6)
        Kit.Shake(10, 18, 1.4)
        Vfx.Burst("Slam", CFrame.new(Vfx.Ground(v44, p26:GetAttribute("FloorY"))), 0.6)
        Vfx.Burst("SpiderSlashes", Vfx.Frame("SpiderSlashes", v44, Unit), 0.8, 0.4)
        attachTrail(ScrambleHuman, v49)
        p27:Say("BYE BYE SCRAMBLE!", nil, 2.5)

        local elapsed2 = os.clock()
        local v88 = CurrentCamera.CFrame

        while os.clock() - elapsed2 < 1.6 do
            local v89 = (os.clock() - elapsed2) / 1.6
            local PrimaryPart = if ScrambleHuman then ScrambleHuman.PrimaryPart else nil
            local v90 = if not ScrambleHuman or not PrimaryPart then v44 else ScrambleHuman.PrimaryPart.Position
            local v93 = v90 - Unit * (40 + v89 * 30) + Vector3.new(0, 12 + v89 * 16, 0) + v48 * 16

            v88 = v88:Lerp(CFrame.lookAt(v93, v90), 0.18)
            CurrentCamera.CFrame = v88
            CurrentCamera.FieldOfView = math.min(CurrentCamera.FieldOfView + 1.2, 62)
            RunService.RenderStepped:Wait()
        end

        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.5), {
            Saturation = 0,
            Contrast = 0
        }):Play()
        v49:Destroy()
    end
}
