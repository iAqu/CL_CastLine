-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Directory = require(ReplicatedStorage.Data.Assets).Directory
local ItemDisplay = require(ReplicatedStorage.Shared.Modules.ItemDisplay)
local AssetItem = require(ReplicatedStorage.Shared.Types.AssetItem)
local Trove = require(ReplicatedStorage.Packages.Trove)
local AssetModels = require(ReplicatedStorage.Shared.Modules.AssetModels)
local t = require(ReplicatedStorage.Packages.t)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local v1 = require(ReplicatedStorage.Packages.Log).new()
local Unit = (Vector3.new(-1, 0, -1)).Unit
local v2 = Color3.fromRGB(300, 300, 300)
local v3 = t.strict(t.instanceIsA("GuiObject"))
local v4 = t.strict(t.instanceIsA("Model"))
local v5 = t.strict(t.Instance)
local v6 = t.strict(t.CFrame)
local v7 = t.strict(t.Vector3)
local v8 = t.strict(t.number)
local v9 = t.strict(t.string)
local t1 = {}

local function raise(p1, p2, p3, p4) -- line: 40
    -- upvalues: Trove (copy), ModelBounds (copy), Unit (copy), t1 (copy)
    local v10 = Trove.new()

    v10:Add(p2)

    if p4 then
        local WorldModel = Instance.new("WorldModel")

        WorldModel.Parent = p3
        v10:Add(WorldModel)
        p2.Parent = WorldModel

        local v11 = t1.LoopIdle(p1, p2)

        if v11 ~= nil then
            v10:Add(v11)
        end
    else
        p2.Parent = p3
    end

    local Camera = Instance.new("Camera")

    Camera.FieldOfView = 50
    Camera.Parent = p3
    p3.CurrentCamera = Camera
    v10:Add(Camera)

    local v12, v13 = ModelBounds(p2)
    local v14 = math.max(v13.X, v13.Y, v13.Z)
    local v15 = v14 * 0.5 / 0.5773502691896257 * 0.75
    local v17 = v12.Position + Vector3.new(0, -0.15000000000000002 * v13.Y, 0)
    local Position2 = (v12 * CFrame.new(Unit * (v15 + v14 * 0.7))).Position

    Camera.CFrame = CFrame.new(Position2, v17)
    v10:AttachToInstance(p3)

    return v10, Camera, p2
end

function t1.Mount(p5) -- line: 79
    -- upvalues: v2 (copy), v3 (copy)
    v3(p5)

    local ViewportFrame = Instance.new("ViewportFrame")
    local v18 = p5.ZIndex + 1

    ViewportFrame.Name = "AssetViewport"
    ViewportFrame.ZIndex = v18
    ViewportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    ViewportFrame.BackgroundTransparency = 1

    local v19 = UDim2.fromScale(0.5, 0.5)
    local v20 = UDim2.fromScale(1, 1)

    ViewportFrame.Position = v19
    ViewportFrame.Size = v20
    ViewportFrame.Parent = p5
    ViewportFrame.LightColor = v2
    ViewportFrame.Ambient = v2

    return ViewportFrame
end

function t1.LoopIdle(p6, p7) -- line: 92
    -- upvalues: Directory (copy), v4 (copy), v9 (copy)
    v9(p6)
    v4(p7)

    local Idle = Directory[p6].Animations.Idle
    local v21 = p7:FindFirstChildWhichIsA("Animator", true)

    if Idle == nil or v21 == nil or p7:GetAttribute("AnimationsDisabled") == true then
        return nil
    end

    local track = v21:LoadAnimation(Idle)

    track.Looped = true
    track:Play(0)

    return track
end

function t1.ShowModel(p8, p9) -- line: 110
    -- upvalues: ModelBounds (copy), v4 (copy), raise (copy)
    v4(p8)
    assert(p9:IsA("ViewportFrame"), "ShowModel requires a ViewportFrame")

    local v22, v23, v24 = raise("", p8:Clone(), p9, false)
    local v25, v26 = ModelBounds(v24)
    local v27 = v25:VectorToWorldSpace((Vector3.new(-1, 0.25, -1)).Unit)
    local v28 = CFrame.lookAt(Vector3.new(0, 0, 0), -v27)
    local AbsoluteSize = p9.AbsoluteSize
    local v29 = if not (AbsoluteSize.X > 0 and AbsoluteSize.Y > 0) then 1 else AbsoluteSize.X / AbsoluteSize.Y
    local v32 = math.tan((math.rad(v23.FieldOfView * 0.5)))
    local v33 = v32 * v29
    local n1 = 0

    for _, v34 in { -1, 1 } do
        local v35 = n1

        for _, v36 in { -1, 1 } do
            for _, v38 in { -1, 1 } do
                local v42 = v28:VectorToObjectSpace((v25:VectorToWorldSpace(Vector3.new(v26.X * v34, v26.Y * v36, v26.Z * v38) * 0.5)))

                v35 = math.max(v35, v42.Z + math.abs(v42.X) / v33, v42.Z + math.abs(v42.Y) / v32)
            end

            n1 = v35
        end
    end

    v23.CFrame = CFrame.lookAt(v25.Position + v27 * math.max(0.5, n1 * 1.1), v25.Position)

    return v22, v23, v24
end

function t1.ShowAsset(p10, p11, p12) -- line: 141
    -- upvalues: Trove (copy), AssetModels (copy), v1 (copy), raise (copy)
    local v46 = AssetModels.GetAssetModelIfReplicated(p10)

    if v46 then
        return raise(p10, v46:Clone(), p11, p12)
    end

    v1:AtWarning():Log("No replicated model to put in a viewport", {
        AssetId = p10
    })

    return Trove.new(), nil, nil
end

function t1.ShowItem(p13, p14, p15, p16) -- line: 157
    -- upvalues: ItemDisplay (copy), AssetItem (copy), v5 (copy), v8 (copy), raise (copy)
    assert(AssetItem.AssetItemData(p13))
    v5(p14)
    v8(p15)

    local v47 = table.clone(p13)

    v47.Scale = 1

    local v48, v49, v50 = raise(p13.Category, ItemDisplay.CreateActiveModel(nil, v47, true, true), p14, p16)

    ItemDisplay.ApplyModelScale(v50, p13.Category, p15)

    return v48, v49, v50
end

function t1.Orbit(p17, p18, p19, p20) -- line: 175
    -- upvalues: v6 (copy), v7 (copy), v8 (copy)
    v6(p17)
    v7(p18)
    v8(p19)
    v8(p20)

    local v51 = CFrame.new(p18)
    local v52 = v51 * CFrame.Angles(p20, p19, 0) * v51:ToObjectSpace(p17)

    return CFrame.lookAt(v52.Position, p18)
end

function t1.AimOrbit(p21, p22, p23, p24, p25) -- line: 186
    -- upvalues: v5 (copy), t1 (copy)
    v5(p21)
    p21.CFrame = t1.Orbit(p22, p23, p24, p25)
end

function t1.AimLocalOrbit(p26, p27, p28, p29, p30, p31, p32) -- line: 194
    -- upvalues: v5 (copy), v6 (copy), v7 (copy), v8 (copy)
    v5(p26)
    v6(p27)
    v7(p28)
    v8(p29)
    v8(p30)
    v8(p31)
    v8(p32)

    local v55 = CFrame.Angles(0, p31, 0):VectorToWorldSpace((Vector3.new(0, 0, -p29)))
    local v57 = Vector3.new(0, p30 + math.tan(p32) * p29, 0)

    p26.CFrame = CFrame.lookAt(p28 + p27:VectorToWorldSpace(v55 + v57), p28, p27.UpVector)
end

return t1
