-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local HarpoonSkins = require(script.Parent:WaitForChild("HarpoonSkins"))
local t1 = {}
local t2 = {
    ANGLE = 45,
    FOV = 20,
    FILL = 0.9,
    LEAN = 14,
    POP = 1.14,
    LIGHT = Vector3.new(-0.6, -1, -0.8),
    SPIN = TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    POP_IN = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    POP_OUT = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    AMBIENT = Color3.fromRGB(185, 185, 195)
}

local function pose(p1, p2, p3) -- line: 26
    -- upvalues: t2 (copy)
    p1:PivotTo(CFrame.Angles(0, 0, -math.rad(t2.ANGLE)) * CFrame.Angles(math.rad(p3), 0, 0) * CFrame.Angles(0, p2, 0))
end

function t1.Mount(p4, p5, p6) -- line: 31
    -- upvalues: HarpoonSkins (copy), t2 (copy), pose (copy)
    local HarpoonView = p4:FindFirstChild("HarpoonView")

    if HarpoonView then
        if HarpoonView:GetAttribute("Skin") == p5 then
            return HarpoonView
        end

        HarpoonView:Destroy()
    end

    local v1 = HarpoonSkins.Model(p5)

    if not v1 then
        return nil
    end

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Name = "HarpoonView"
    ViewportFrame.BackgroundTransparency = 1
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ViewportFrame.Position = UDim2.fromScale(0.5, 0.5)
    ViewportFrame.Size = UDim2.fromScale(1, 1)
    ViewportFrame.ZIndex = p6 or p4.ZIndex
    ViewportFrame.Ambient = t2.AMBIENT
    ViewportFrame.LightColor = Color3.new(1, 1, 1)
    ViewportFrame.LightDirection = t2.LIGHT
    ViewportFrame:SetAttribute("Skin", p5)

    local clone = v1:Clone()

    clone.Name = "Skin"

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("Attachment") or descendant:IsA("Trail") then
            descendant:Destroy()
        end
    end

    clone.Parent = ViewportFrame

    local Y = clone.PrimaryPart.Size.Y
    local Camera = Instance.new("Camera")

    Camera.FieldOfView = t2.FOV

    local v7 = Y * math.sin((math.rad(t2.ANGLE))) / (t2.FILL * 2 * math.tan((math.rad(t2.FOV / 2))))

    Camera.CFrame = CFrame.lookAt(Vector3.new(0, 0, v7), (Vector3.new(0, 0, 0)))
    Camera.Parent = ViewportFrame
    ViewportFrame.CurrentCamera = Camera
    pose(clone, 0, 0)

    local UIScale = Instance.new("UIScale")

    UIScale.Name = "Pop"
    UIScale.Parent = ViewportFrame
    ViewportFrame.Parent = p4

    return ViewportFrame
end

function t1.Unmount(p7) -- line: 71
    local HarpoonView = p7 and p7:FindFirstChild("HarpoonView")

    if HarpoonView then
        HarpoonView:Destroy()
    end
end

function t1.Spin(p8) -- line: 77
    -- upvalues: TweenService (copy), t2 (copy), pose (copy)
    if p8 and p8.Parent and not p8:FindFirstChild("Turn") then
        local Skin = p8:FindFirstChild("Skin")

        if not Skin then
            return
        end

        local NumberValue = Instance.new("NumberValue")

        NumberValue.Name = "Turn"
        NumberValue.Parent = p8

        local connection = NumberValue.Changed:Connect(function(p9) -- line: 84
            -- upvalues: Skin (copy), t2 (copy), pose (copy)
            pose(Skin, p9 * 3.141592653589793 * 2, t2.LEAN * math.sin(3.141592653589793 * math.clamp(p9, 0, 1)))
        end)
        local tween = TweenService:Create(NumberValue, t2.SPIN, {
            Value = 1
        })

        tween.Completed:Once(function() -- line: 88
            -- upvalues: Skin (copy), NumberValue (copy), connection (copy), pose (copy)
            connection:Disconnect()
            NumberValue:Destroy()

            if Skin.Parent then
                pose(Skin, 0, 0)
            end
        end)
        tween:Play()

        local Pop = p8:FindFirstChild("Pop")

        if Pop then
            local tween = TweenService:Create(Pop, t2.POP_IN, {
                Scale = t2.POP
            })

            tween.Completed:Once(function() -- line: 97
                -- upvalues: Pop (copy), TweenService (copy), t2 (copy)
                TweenService:Create(Pop, t2.POP_OUT, {
                    Scale = 1
                }):Play()
            end)
            tween:Play()
        end
    end
end

return t1
