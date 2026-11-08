-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t1 = {}
local v1

local function build(p1) -- line: 6
    -- upvalues: ReplicatedStorage (copy), v1 (ref)
    local SammyPortraitRig = ReplicatedStorage.Assets.UI.Notifs:FindFirstChild("SammyPortraitRig")

    if not SammyPortraitRig then
        return nil
    end

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "SammyViewport"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.Size = UDim2.fromScale(1, 1)
    ViewportFrame.Ambient = Color3.fromRGB(180, 205, 180)
    ViewportFrame.LightColor = Color3.fromRGB(217, 255, 212)
    ViewportFrame.LightDirection = Vector3.new(-1, -0.4, -1)
    ViewportFrame.ZIndex = 6
    ViewportFrame.Parent = p1

    local WorldModel = Instance.new("WorldModel")

    WorldModel.Parent = ViewportFrame

    local clone = SammyPortraitRig:Clone()

    clone.Parent = WorldModel
    clone:PivotTo(CFrame.identity)

    local Head = clone:FindFirstChild("Head")
    local v3 = Vector3.new(0, if Head then Head.Position.Y + 0.2 else 6.2, 0)
    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 24
    Camera.CFrame = CFrame.lookAt(v3 + Vector3.new(0, 2.4, -32), v3)
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera

    local Humanoid = clone:FindFirstChildOfClass("Humanoid")
    local Animator = if Humanoid then Humanoid:FindFirstChildOfClass("Animator") else nil
    local Idle = clone:FindFirstChild("Idle")
    local result

    if Animator and Idle and Idle:IsA("Animation") then
        local function v4() -- line: 40
            -- upvalues: Idle (copy), Animator (copy)
            return Animator:LoadAnimation(Idle)
        end

        local ok

        ok, result = pcall(v4)

        if ok then
            result.Looped = true
            result.Priority = Enum.AnimationPriority.Idle
        else
            result = nil
        end
    end

    ViewportFrame.Destroying:Connect(function() -- line: 50
        -- upvalues: ViewportFrame (copy), v1 (ref)
        if v1 and v1.Viewport == ViewportFrame then
            v1 = nil
        end
    end)

    return {
        Viewport = ViewportFrame,
        Model = clone,
        Track = result,
        Owner = p1
    }
end

function t1.Mount(p2) -- line: 59
    -- upvalues: v1 (ref), build (copy)
    v1 = v1 or build(p2)

    local v5 = v1

    if not v5 then
        return function() -- line: 65
        end, function() -- line: 65
        end
    end

    v5.Owner = p2
    v5.Viewport.Parent = p2
    v5.Viewport.Visible = true
    v5.Model:PivotTo(CFrame.Angles(0, -1.7453292519943295, 0))

    if v5.Track then
        v5.Track:Play(0.15, 1, 0.8)
    end

    local v6 = false

    return function(p3) -- step | line: 77
        -- upvalues: p2 (copy), v5 (copy), v6 (ref)
        if not v6 and v5.Owner == p2 then
            local v9 = math.clamp(p3 / 0.62, 0, 1)
            local v10 = v9 - 1
            local v7 = (1 - (v10 * 2.15 * v10 * v10 + 1 + v10 * 1.15 * v10)) * -100

            if v9 >= 1 then
                v7 = math.sin((p3 - 0.62) * 0.8) * 2
            end

            v5.Model:PivotTo(CFrame.Angles(0, math.rad(v7), 0))
        end
    end, function() -- stop | line: 91
        -- upvalues: p2 (copy), v5 (copy), v6 (ref)
        if v6 then
            return
        end

        v6 = true

        if v5.Owner == p2 then
            if v5.Track then
                v5.Track:Stop(0)
            end

            v5.Viewport.Visible = false
            v5.Viewport.Parent = nil
            v5.Owner = nil
        end
    end
end

return t1
