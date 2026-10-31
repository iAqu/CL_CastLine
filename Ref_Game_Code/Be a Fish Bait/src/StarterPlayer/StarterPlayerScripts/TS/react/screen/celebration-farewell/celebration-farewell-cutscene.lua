-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Lighting, Players, ReplicatedStorage, RunService = services.Lighting, services.Players, services.ReplicatedStorage, services.RunService
local Workspace = services.Workspace
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local useTheme = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-theme").useTheme

local function findGiantRig() -- line: 21
    -- upvalues: ReplicatedStorage (copy), Workspace (copy)
    local GiantRigR15 = ReplicatedStorage:FindFirstChild("GiantRigR15")

    if if GiantRigR15 == nil then GiantRigR15 else GiantRigR15:IsA("Model") then
        return GiantRigR15
    end

    local GiantRigCutscene = Workspace:FindFirstChild("GiantRigCutscene")

    if GiantRigCutscene ~= nil then
        GiantRigCutscene = GiantRigCutscene:FindFirstChild("GiantRigR15", true)
    end

    if if GiantRigCutscene == nil then GiantRigCutscene else GiantRigCutscene:IsA("Model") then
        return GiantRigCutscene
    end

    local GiantRigR15_2 = Workspace:FindFirstChild("GiantRigR15")

    return if if GiantRigR15_2 == nil then GiantRigR15_2 else GiantRigR15_2:IsA("Model") then GiantRigR15_2 else nil
end

local function prepareClone(p1) -- line: 50
    local clone = p1:Clone()

    clone.Name = "CelebrationFarewellGiantRig"

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
        elseif descendant:IsA("Script") or descendant:IsA("LocalScript") then
            descendant:Destroy()
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") then
            descendant.Enabled = false
        end
    end

    local Humanoid = clone:FindFirstChildOfClass("Humanoid")

    if Humanoid ~= nil then
        Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
    end

    local v1 = clone:FindFirstChild("HumanoidRootPart", true)

    if if v1 == nil then v1 else v1:IsA("BasePart") then
        v1.Anchored = true
    end

    return clone
end

local function createFartPropulsion(p2) -- line: 80
    local v2 = p2:FindFirstChild("LowerTorso", true)
    local v3 = p2:FindFirstChild("HumanoidRootPart", true)

    if not (if v2 == nil then v2 else v2:IsA("BasePart")) then
        v2 = if if v3 == nil then v3 else v3:IsA("BasePart") then v3 else nil
    end

    if v2 == nil then
        return {}
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "CelebrationFartNozzle"
    Attachment.Position = Vector3.new(0, -v2.Size.Y * 0.22, v2.Size.Z * 0.55)
    Attachment.Parent = v2

    local ParticleEmitter = Instance.new("ParticleEmitter")

    ParticleEmitter.Name = "FartCloud"
    ParticleEmitter.Acceleration = Vector3.new(0, 7, 0)
    ParticleEmitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(198, 255, 63)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(74, 220, 92)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(86, 93, 54))
    })
    ParticleEmitter.Drag = 2
    ParticleEmitter.EmissionDirection = Enum.NormalId.Back
    ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.45)
    ParticleEmitter.LightEmission = 0.25
    ParticleEmitter.LightInfluence = 0
    ParticleEmitter.Orientation = Enum.ParticleOrientation.FacingCamera
    ParticleEmitter.Rate = 0
    ParticleEmitter.Rotation = NumberRange.new(0, 360)
    ParticleEmitter.RotSpeed = NumberRange.new(-100, 100)
    ParticleEmitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 4),
        NumberSequenceKeypoint.new(0.4, 11),
        NumberSequenceKeypoint.new(1, 22)
    })
    ParticleEmitter.Speed = NumberRange.new(16, 30)
    ParticleEmitter.SpreadAngle = Vector2.new(48, 48)
    ParticleEmitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
    ParticleEmitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.08),
        NumberSequenceKeypoint.new(0.7, 0.35),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter.Parent = Attachment

    local ParticleEmitter2 = Instance.new("ParticleEmitter")

    ParticleEmitter2.Name = "FartSparks"
    ParticleEmitter2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 236, 48)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 82, 193)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 255, 129))
    })
    ParticleEmitter2.EmissionDirection = Enum.NormalId.Back
    ParticleEmitter2.Lifetime = NumberRange.new(0.35, 0.75)
    ParticleEmitter2.LightEmission = 1
    ParticleEmitter2.LightInfluence = 0
    ParticleEmitter2.Orientation = Enum.ParticleOrientation.VelocityParallel
    ParticleEmitter2.Rate = 0
    ParticleEmitter2.Rotation = NumberRange.new(0, 360)
    ParticleEmitter2.RotSpeed = NumberRange.new(-240, 240)
    ParticleEmitter2.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 4),
        NumberSequenceKeypoint.new(1, 0)
    })
    ParticleEmitter2.Speed = NumberRange.new(30, 58)
    ParticleEmitter2.SpreadAngle = Vector2.new(38, 38)
    ParticleEmitter2.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    ParticleEmitter2.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    ParticleEmitter2.Parent = Attachment

    return { ParticleEmitter, ParticleEmitter2 }
end

return {
    default = function(p3) -- CelebrationFarewellCutscene | line: 147
        -- upvalues: react (copy), useEffect (copy), useRef (copy), useState (copy), Lighting (copy), Players (copy), RunService (copy), Workspace (copy), default (copy), useTheme (copy), findGiantRig (copy), prepareClone (copy), createFartPropulsion (copy)
        local onDone = p3.onDone
        local v6 = useTheme()
        local v7, v8 = useState("THE CELEBRATION IS NOW OVER")
        local v9 = useRef()

        useEffect(function() -- line: 152
            -- upvalues: onDone (copy), v8 (copy), v9 (copy), Lighting (copy), Players (copy), RunService (copy), Workspace (copy), findGiantRig (copy), prepareClone (copy), createFartPropulsion (copy)
            local CurrentCamera = Workspace.CurrentCamera
            local v10 = findGiantRig()

            if CurrentCamera ~= nil and v10 ~= nil then
                local t1 = {
                    cameraSubject = CurrentCamera.CameraSubject,
                    cameraType = CurrentCamera.CameraType,
                    cframe = CurrentCamera.CFrame,
                    fieldOfView = CurrentCamera.FieldOfView,
                    focus = CurrentCamera.Focus
                }
                local t2 = {}
                local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

                if PlayerGui ~= nil then
                    PlayerGui = PlayerGui:GetChildren()
                end

                if PlayerGui == nil then
                    PlayerGui = {}
                end

                for _, v11 in PlayerGui do
                    if v11:IsA("ScreenGui") and v11 ~= v9.current and v11.Enabled then
                        v11.Enabled = false
                        table.insert(t2, v11)
                    end
                end

                local t3 = {}

                for _, child in Lighting:GetChildren() do
                    if (child:IsA("DepthOfFieldEffect") or child:IsA("BlurEffect")) and child.Enabled then
                        child.Enabled = false
                        table.insert(t3, child)
                    end
                end

                local v12 = prepareClone(v10)

                v12.Parent = Workspace

                local ExtentsSize = v12:GetExtentsSize()
                local v13 = math.max(ExtentsSize.Y, 20)
                local v14 = math.max(ExtentsSize.X, 20)
                local v17 = math.max(v13 * 1.05, v14 * 1.55)
                local v18 = CFrame.new(0, 50000, 0)
                local v19 = v18.Position + v18.UpVector * (v13 * 0.08)
                local v20 = v19 + v18.LookVector * v17 + v18.RightVector * (v14 * 0.08)
                local v21 = CFrame.lookAt(v20, v19)

                v12:PivotTo(v18)
                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                CurrentCamera.FieldOfView = 55
                CurrentCamera.CFrame = v21
                CurrentCamera.Focus = CFrame.new(v19)

                local v22 = v12:FindFirstChild("RightShoulder", true)

                if not (if v22 == nil then v22 else v22:IsA("Motor6D")) then
                    v22 = nil
                end

                local v23 = if v22 == nil then v22 else v22.Transform
                local v24 = createFartPropulsion(v12)
                local elapsed = os.clock()
                local v25 = false
                local v26 = false
                local v27 = false
                local connection

                local function v28() -- line: 239
                    -- upvalues: CurrentCamera (copy), t1 (copy), t2 (copy), t3 (copy), v12 (copy), v27 (ref), connection (ref), Workspace (copy)
                    if v27 then
                        return nil
                    end

                    v27 = true
                    connection:Disconnect()
                    v12:Destroy()

                    for _, v29 in t2 do
                        if v29.Parent ~= nil then
                            v29.Enabled = true
                        end
                    end

                    for _, v30 in t3 do
                        if v30.Parent ~= nil then
                            v30.Enabled = true
                        end
                    end

                    if Workspace.CurrentCamera ~= CurrentCamera then
                        return nil
                    end

                    CurrentCamera.CameraSubject = t1.cameraSubject
                    CurrentCamera.CameraType = t1.cameraType
                    CurrentCamera.FieldOfView = t1.fieldOfView
                    CurrentCamera.CFrame = t1.cframe
                    CurrentCamera.Focus = t1.focus
                end

                connection = RunService.RenderStepped:Connect(function() -- line: 265
                    -- upvalues: CurrentCamera (copy), v12 (copy), v13 (copy), v14 (copy), v17 (copy), v18 (copy), v19 (copy), v20 (copy), v21 (copy), v22 (ref), v23 (copy), v24 (copy), elapsed (copy), v25 (ref), v26 (ref)
                    local v31 = os.clock() - elapsed

                    if not v25 and v31 >= 2.3 then
                        v25 = true

                        for _, v32 in v24 do
                            v32.Rate = v32.Name == "FartCloud" and 55 or 35
                            v32:Emit(v32.Name == "FartCloud" and 24 or 16)
                        end
                    end

                    if not v26 and v31 >= 2.95 then
                        v26 = true

                        for _, v33 in v24 do
                            v33:Emit(v33.Name == "FartCloud" and 90 or 70)
                        end
                    end

                    if v31 < 2.3 then
                        local v35 = math.sin(v31 * 3.8) * v13 * 0.012
                        local v37 = math.sin(v31 * 2.6) * 0.04363323129985824

                        v12:PivotTo(v18 * CFrame.new(0, v35, 0) * CFrame.Angles(0, v37, 0))

                        if v22 ~= nil and v23 ~= nil then
                            local v42 = math.sin(v31 * 10) * 0.3839724354387525
                            local v43 = CFrame.Angles(0, 0, v42 + 2.059488517353309)

                            v22.Transform = v23 * v43
                        end

                        CurrentCamera.CFrame = v21
                        CurrentCamera.FieldOfView = 55

                        return nil
                    end

                    local v45 = math.clamp((v31 - 2.3) / 3.9000000000000004, 0, 1)
                    local v46 = math.pow(v45, 1.6)

                    for _, v47 in v24 do
                        if v47.Name == "FartCloud" then
                            v47.Rate = v46 * 255 + 55
                        else
                            v47.Rate = v46 * 185 + 35
                        end
                    end

                    if v31 < 2.95 then
                        local v49 = math.clamp((v31 - 2.3) / 0.6500000000000004, 0, 1)
                        local RightVector = v21.RightVector
                        local v50 = -v14 * 0.18 * v49
                        local UpVector = v21.UpVector
                        local v51 = -v13 * 0.12 * v49
                        local v52 = RightVector * v50 + UpVector * v51
                        local v53 = v14 * (v49 * 0.035 + 0.01)
                        local RightVector2 = v21.RightVector
                        local v55 = math.sin(v31 * 74) * v53
                        local UpVector2 = v21.UpVector
                        local v57 = math.cos(v31 * 91) * v53
                        local v58 = RightVector2 * v55 + UpVector2 * v57
                        local v60 = CFrame.Angles(math.sin(v31 * 55) * 0.08726646259971647, 0, v49 * 0.3141592653589793)

                        v12:PivotTo(CFrame.new(v18.Position + v52 + v58) * v60)

                        local v62 = math.sin(v49 * 3.141592653589793)
                        local v64 = math.rad(v49 * 1.1 + 0.35)
                        local v65 = v62 * 5 + 55
                        local v67 = math.sin(v31 * 47) * v64
                        local v69 = math.cos(v31 * 53) * v64
                        local v70 = math.pow(v45, 1.35)
                        local v71 = v17 * 0.85 * v70
                        local v73 = v20 - v21.LookVector * v71

                        CurrentCamera.FieldOfView = v65
                        CurrentCamera.CFrame = CFrame.lookAt(v73, v19) * CFrame.Angles(v67, v69, 0)

                        return nil
                    end

                    if v31 < 4.75 then
                        local v77 = math.clamp((v31 - 2.95) / 1.7999999999999998, 0, 1)
                        local v78 = v77 * v77
                        local v79 = v77 * 0.55 + 0.45
                        local v81 = math.sin(v78 * 3.141592653589793 * 6) * v14 * 0.78 * v79
                        local v83 = math.sin(v78 * 3.141592653589793 * 5) * v13 * 0.42 + v77 * v13 * 0.3
                        local v85 = -math.sin(v77 * 3.141592653589793) * v17 * 0.22
                        local v86 = v21.RightVector * v81
                        local v87 = v21.UpVector * v83
                        local v88 = v21.LookVector * v85
                        local v89 = v86 + v87 + v88
                        local v91 = CFrame.Angles(math.sin(v78 * 3.141592653589793 * 7) * 0.6632251157578453, v78 * 12.566370614359172, v78 * -18.84955592153876)

                        v12:PivotTo(CFrame.new(v18.Position + v89) * v91)

                        local v93 = math.rad(1.25 - v77 * 0.35)
                        local v96 = v45 * 5 + 57 + math.sin(v78 * 3.141592653589793 * 6) * 2
                        local v98 = math.sin(v31 * 43) * v93
                        local v100 = math.cos(v31 * 37) * v93
                        local v101 = math.pow(v45, 1.35)
                        local v102 = v17 * 0.85 * v101
                        local v104 = v20 - v21.LookVector * v102

                        CurrentCamera.FieldOfView = v96
                        CurrentCamera.CFrame = CFrame.lookAt(v104, v19) * CFrame.Angles(v98, v100, 0)

                        return nil
                    end

                    local v108 = math.clamp((v31 - 4.75) / 1.4500000000000002, 0, 1)
                    local v109 = v108 * v108 * v108
                    local v110 = v108 * v108 * 3.141592653589793 * 10
                    local v111 = 1 - v108
                    local RightVector = v21.RightVector
                    local v112 = v14 * 4.8 * v109 + math.sin(v110) * v14 * 0.42 * v111
                    local UpVector = v21.UpVector
                    local v113 = v13 * 0.3 + v13 * 3.8 * v109 + math.cos(v110) * v13 * 0.24 * v111
                    local LookVector = v21.LookVector
                    local v114 = v17 * 0.35 * v109
                    local v115 = RightVector * v112 + UpVector * v113 + LookVector * v114
                    local v116 = v108 * v108
                    local v117 = CFrame.Angles(v108 * -1.1344640137963142, v116 * 12.566370614359172, v116 * -25.132741228718345)

                    v12:PivotTo(CFrame.new(v18.Position + v115) * v117)

                    local v118 = (1 - v108) * 0.024434609527920613
                    local v119 = v109 * 3 + 62
                    local v121 = math.sin(v31 * 57) * v118
                    local v123 = math.cos(v31 * 49) * v118
                    local v124 = math.pow(v45, 1.35)
                    local v125 = v17 * 0.85 * v124
                    local v127 = v20 - v21.LookVector * v125

                    CurrentCamera.FieldOfView = v119
                    CurrentCamera.CFrame = CFrame.lookAt(v127, v19) * CFrame.Angles(v121, v123, 0)
                end)

                local v130 = task.delay(1.05, function() -- line: 355
                    -- upvalues: v8 (copy)
                    return v8("THANKS FOR CELEBRATING WITH US!")
                end)
                local v131 = task.delay(2.3, function() -- line: 358
                    -- upvalues: v8 (copy)
                    return v8("THE PARTY IS OVER... TIME TO GO!")
                end)
                local v132 = task.delay(2.95, function() -- line: 361
                    -- upvalues: v8 (copy)
                    return v8("PFFFFT! GOODBYE!")
                end)
                local v133 = task.delay(6.2, function() -- line: 364
                    -- upvalues: v28 (copy), onDone (copy)
                    v28()
                    onDone()
                end)

                return function() -- line: 368
                    -- upvalues: v28 (copy), v130 (copy), v131 (copy), v132 (copy), v133 (copy)
                    task.cancel(v130)
                    task.cancel(v131)
                    task.cancel(v132)
                    task.cancel(v133)
                    v28()
                end
            end

            warn("[CelebrationFarewell] Missing CurrentCamera or GiantRigR15 (checked ReplicatedStorage and Workspace.GiantRigCutscene)")
            task.defer(onDone)

            return nil
        end, { onDone })

        return react.createElement("screengui", {
            DisplayOrder = 500,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ScreenInsets = Enum.ScreenInsets.None,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ref = v9
        }, react.createElement("frame", {
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.fromScale(1, 0.085)
        }), react.createElement("frame", {
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 0.1)
        }), react.createElement("frame", {
            BackgroundTransparency = 0.32,
            BorderSizePixel = 0,
            ZIndex = 5,
            BackgroundColor3 = Color3.fromRGB(10, 4, 20),
            Position = UDim2.fromScale(0, 0.075),
            Size = UDim2.fromScale(1, 0.225)
        }), react.createElement(default, {
            shadowYScale = 0.08,
            text = "FOMO ISLAND EVENT HAS ENDED!",
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 91, 72),
            overrideProps = {
                TextScaled = true,
                ZIndex = 12,
                Font = v6.textFont2,
                Size = UDim2.fromScale(0.88, 0.115)
            },
            popoutColor = Color3.fromRGB(255, 196, 54),
            position = UDim2.fromScale(0.5, 0.145),
            strokeProps = {
                Thickness = 0.09,
                Color = Color3.fromRGB(0, 0, 0)
            }
        }), react.createElement(default, {
            shadowYScale = 0.08,
            anchorPoint = Vector2.new(0.5, 0.5),
            color = Color3.fromRGB(255, 238, 98),
            overrideProps = {
                TextScaled = true,
                ZIndex = 12,
                Font = v6.textFont2,
                Size = UDim2.fromScale(0.72, 0.065)
            },
            popoutColor = Color3.fromRGB(91, 34, 125),
            position = UDim2.fromScale(0.5, 0.248),
            strokeProps = {
                Thickness = 0.09,
                Color = Color3.fromRGB(0, 0, 0)
            },
            text = v7
        }))
    end
}
