-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Heartbeat = game:GetService("RunService").Heartbeat
local Assets = require(ReplicatedStorage.Data.Assets)
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local t = require(ReplicatedStorage.Packages.t)
local ModelBounds = require(ReplicatedStorage.Shared.Utils.ModelBounds)
local AssetModels = ReplicatedStorage.AssetModels
local t1 = {}
local t2 = {}
local t3 = {}

local function asModel(p1, p2) -- line: 30
    local v2 = assert(p1, (("the AssetModels folder holds nothing named %*"):format(p2)))

    assert(v2:IsA("Model"), (("AssetModels.%* is a %*, not a Model"):format(p2, v2.ClassName)))

    return v2
end

local function present(p3) -- line: 36
    -- upvalues: AssetModels (copy)
    local v4 = AssetModels:FindFirstChild(p3)

    if v4 then
        v4 = assert(v4, (("the AssetModels folder holds nothing named %*"):format(p3)))
        assert(v4:IsA("Model"), (("AssetModels.%* is a %*, not a Model"):format(p3, v4.ClassName)))
    end

    return v4
end

local function awaited(p4, p5) -- line: 42
    -- upvalues: AssetModels (copy)
    local v9 = assert(AssetModels:WaitForChild(p4, p5 or 30), (("the AssetModels folder holds nothing named %*"):format(p4)))

    assert(v9:IsA("Model"), (("AssetModels.%* is a %*, not a Model"):format(p4, v9.ClassName)))

    return v9
end

function t3.Resolve(p6) -- line: 47
    -- upvalues: Constants (copy), t (copy), AssetModels (copy)
    t.strict(t.string)(p6)

    if Constants.IS_CLIENT then
        local v13 = assert(AssetModels:WaitForChild(p6, 30), (("the AssetModels folder holds nothing named %*"):format(p6)))

        assert(v13:IsA("Model"), (("AssetModels.%* is a %*, not a Model"):format(p6, v13.ClassName)))

        return v13
    end

    local v15 = AssetModels:FindFirstChild(p6)

    if v15 then
        v15 = assert(v15, (("the AssetModels folder holds nothing named %*"):format(p6)))
        assert(v15:IsA("Model"), (("AssetModels.%* is a %*, not a Model"):format(p6, v15.ClassName)))
    end

    return v15
end

local function measure(p7) -- line: 52
    -- upvalues: t (copy), ModelBounds (copy), t3 (copy)
    t.strict(t.string)(p7)

    local v20 = assert(t3.Resolve(p7), (("no template replicated for %*"):format(p7)))
    local v21 = v20.PrimaryPart or v20:FindFirstChild("HumanoidRootPart")

    assert(v21 ~= nil and v21:IsA("BasePart"), (("the %* template has no root part"):format(p7)))

    local Scale = v20:GetScale()

    assert(Scale > 0, (("the %* template is scaled to %*, which is not usable"):format(p7, Scale)))

    local v26, v27 = ModelBounds(v20)
    local v29 = v26.Position - Vector3.new(0, v27.Y * 0.5, 0)

    return {
        RelativeCFrame = (v21.CFrame.Rotation + v29):ToObjectSpace(v26),
        Size = v27,
        TemplateScale = Scale
    }
end

function t3.GetVisibleBoundsData(p8) -- line: 72
    -- upvalues: t (copy), t1 (copy), measure (copy)
    t.strict(t.string)(p8)

    local v30 = t1[p8] or measure(p8)

    t1[p8] = v30

    return v30
end

function t3.Await(p9, p10) -- line: 81
    -- upvalues: t (copy), AssetModels (copy)
    t.strict(t.string)(p9)
    t.strict(t.optional(t.number))(p10)

    local v33 = assert(AssetModels:WaitForChild(p9, p10 or 30), (("the AssetModels folder holds nothing named %*"):format(p9)))

    assert(v33:IsA("Model"), (("AssetModels.%* is a %*, not a Model"):format(p9, v33.ClassName)))

    return v33
end

function t3.GetAssetModelIfReplicated(p11) -- line: 88
    -- upvalues: t (copy), AssetModels (copy)
    t.strict(t.string)(p11)

    local v35 = AssetModels:FindFirstChild(p11)

    if v35 then
        v35 = assert(v35, (("the AssetModels folder holds nothing named %*"):format(p11)))
        assert(v35:IsA("Model"), (("AssetModels.%* is a %*, not a Model"):format(p11, v35.ClassName)))
    end

    return v35
end

function t3.SyncScaleFor(p12) -- line: 93
    -- upvalues: Assets (copy), t (copy), AssetModels (copy), t2 (copy)
    t.strict(t.string)(p12)

    local v38 = Assets.Directory[p12]

    if v38 then
        v38 = AssetModels:FindFirstChild(p12)

        if v38 then
            v38 = assert(v38, (("the AssetModels folder holds nothing named %*"):format(p12)))
            assert(v38:IsA("Model"), (("AssetModels.%* is a %*, not a Model"):format(p12, v38.ClassName)))
        end
    end

    if v38 then
        t2[p12] = v38:GetScale()
    end
end

function t3.GetBaseModelScale(p13) -- line: 103
    -- upvalues: Assets (copy), t (copy), t2 (copy)
    t.strict(t.string)(p13)

    local v43 = assert(Assets.Directory[p13], (("unknown asset species %*"):format(p13)))

    return t2[p13] or v43.BaseModelScale
end

function t3.SyncAllScales() -- line: 110
    -- upvalues: Assets (copy), t3 (copy)
    for v44 in pairs(Assets.Directory) do
        t3.SyncScaleFor(v44)
    end
end

function t3.GetAssetModelsFolder() -- line: 116
    -- upvalues: AssetModels (copy)
    return AssetModels
end

local function clearQueryFlagsOverFrames(p14) -- line: 123
    -- upvalues: Heartbeat (copy)
    task.spawn(function() -- line: 124
        -- upvalues: p14 (copy), Heartbeat (copy)
        local t4 = {
            p14
        }
        local v45 = 1
        local v46 = 0
        local v47 = os.clock() + 0.002

        while v45 <= #t4 do
            local v48 = t4[v45]

            t4[v45] = nil
            v45 += 1

            if v48:IsA("BasePart") then
                v48.CanQuery = false
                v48.CanTouch = false
            end

            for _, child in v48:GetChildren() do
                t4[#t4 + 1] = child
            end

            v46 += 1

            if v46 >= 64 then
                if v47 <= os.clock() then
                    Heartbeat:Wait()
                    v46 = 0
                    v47 = os.clock() + 0.002
                else
                    v46 = 0
                end
            end
        end
    end)
end

if Constants.IS_SERVER then
    task.spawn(function() -- line: 124
        -- upvalues: Heartbeat (copy), AssetModels (copy)
        local t5 = {
            AssetModels
        }
        local v49 = 1
        local v50 = 0
        local v51 = os.clock() + 0.002

        while v49 <= #t5 do
            local v52 = t5[v49]

            t5[v49] = nil
            v49 += 1

            if v52:IsA("BasePart") then
                v52.CanQuery = false
                v52.CanTouch = false
            end

            for _, child in v52:GetChildren() do
                t5[#t5 + 1] = child
            end

            v50 += 1

            if v50 >= 64 then
                if v51 <= os.clock() then
                    Heartbeat:Wait()
                    v50 = 0
                    v51 = os.clock() + 0.002
                else
                    v50 = 0
                end
            end
        end
    end)
    t3.SyncAllScales()
end

return t3
