-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

game:GetService("RunService")

local t2 = {
    Low = {
        Resolution = 128,
        Compression = 80,
        Format = "PNG",
        Mipmaps = false
    },
    Medium = {
        Resolution = 512,
        Compression = 60,
        Format = "PNG",
        Mipmaps = true
    },
    High = {
        Resolution = 1024,
        Compression = 40,
        Format = "PNG",
        Mipmaps = true
    },
    Ultra = {
        Resolution = 2048,
        Compression = 20,
        Format = "PNG",
        Mipmaps = true
    }
}
local t3 = {
    Decal = {
        Class = "Decal",
        DefaultProperties = {
            Face = "Top",
            Texture = "",
            Transparency = 0
        }
    },
    Texture = {
        Class = "Texture",
        DefaultProperties = {
            OffsetStudsU = 0,
            OffsetStudsV = 0,
            StudsPerTileU = 2,
            StudsPerTileV = 2
        }
    },
    SurfaceAppearance = {
        Class = "SurfaceAppearance",
        DefaultProperties = {
            AlphaMode = "Overlay",
            ColorMap = "",
            MetalnessMap = "",
            NormalMap = "",
            RoughnessMap = ""
        }
    }
}
local t4 = {}

setmetatable(t4, {
    __mode = "k"
})

local function ApplyProperties(p1, p2) -- line: 75
    assert(type(p2) == "table", "Properties must be a table")

    for v2, v3 in pairs(p2) do
        if type(v2) == "number" then
            if typeof(v3) == "Instance" then
                v3.Parent = p1
            end
        else
            local function v4() -- line: 87
                -- upvalues: p1 (copy), v2 (copy)
                return p1[v2]
            end

            if pcall(v4) then
                p1[v2] = v3
            end
        end
    end

    return p1
end

local function CreateTextureAsset(p3, p4) -- line: 96
    -- upvalues: t3 (copy), ApplyProperties (copy)
    local v5 = t3[p3]

    if not v5 then
        error("Unsupported texture type: " .. tostring(p3), 2)
    end

    return (ApplyProperties(Instance.new(v5.Class), p4 or v5.DefaultProperties))
end

function t1.AnalyzeTextureUsage(p5) -- line: 108
    -- upvalues: t3 (copy)
    local t6 = {
        totalTextures = 0,
        memoryUsage = 0,
        missingTextures = 0,
        byType = {}
    }

    local function scanHierarchy(p6) -- line: 117
        -- upvalues: t6 (copy), scanHierarchy (copy), t3 (copy)
        if t3[p6.ClassName] then
            t6.totalTextures += 1
            t6.byType[p6.ClassName] = (t6.byType[p6.ClassName] or 0) + 1

            if p6:IsA("Decal") and p6.Texture == "" then
                t6.missingTextures += 1
            end
        end

        for _, child in ipairs(p6:GetChildren()) do
            scanHierarchy(child)
        end
    end

    scanHierarchy(p5)

    return t6
end

function t1.GenerateMissingTextures(p7, p8) -- line: 139
    -- upvalues: t3 (copy), ApplyProperties (copy)
    local n1 = 0

    for v7, v8 in pairs(p8) do
        local v9 = p7:FindFirstChild(v7)

        if v9 then
            if v9.ClassName ~= v8.Type then
                warn("[TextureConfiguration] - Texture type mismatch for '" .. v7 .. "'. Expected: " .. v8.Type .. ", Found: " .. v9.ClassName)
            end
        else
            local Type, Properties = v8.Type, v8.Properties
            local v10 = t3[Type]

            if not v10 then
                error("Unsupported texture type: " .. tostring(Type), 2)
            end

            local v12 = ApplyProperties(Instance.new(v10.Class), Properties or v10.DefaultProperties)

            v12.Name = v7
            v12.Parent = p7
            n1 += 1
        end
    end

    print("[TextureConfiguration] - Generated " .. n1 .. " missing textures")

    return n1
end

function t1.CreateTextureLayer(p9, p10) -- line: 160
    local v13 = p10:FindFirstChild(p9)

    if not v13 then
        v13 = Instance.new("Folder")
        v13.Name = p9
        v13.Archivable = false
        v13.Parent = p10
    end

    return v13
end

function t1.GetTextureManager(p11) -- line: 175
    -- upvalues: t3 (copy), t4 (copy), ApplyProperties (copy)
    if t4[p11] then
        return t4[p11]
    end

    local t7 = {}

    local function FindTexture(p12) -- line: 183
        -- upvalues: p11 (copy)
        return p11:FindFirstChild(p12)
    end

    setmetatable(t7, {
        __index = function(_, p14) -- __index | line: 188
            -- upvalues: p11 (copy), FindTexture (copy), t3 (copy), ApplyProperties (copy)
            local v14 = p14:lower()

            if v14 == "addtexture" or v14 == "create" then
                return function(p15, p16) -- line: 192
                    -- upvalues: p11 (copy), t3 (copy), ApplyProperties (copy)
                    local v15 = p16 and p16.Name

                    if not v15 or type(v15) ~= "string" then
                        error("[TextureConfiguration] - Texture configuration must include a valid Name property", 2)
                    end

                    local v16 = p11:FindFirstChild(v15)

                    if v16 and v16.ClassName ~= p15 then
                        warn("[TextureConfiguration] - Replacing existing texture '" .. v15 .. "' of type " .. v16.ClassName .. " with new type " .. p15)
                        v16:Destroy()
                        v16 = nil
                    end

                    if v16 then
                        return
                    end

                    local v17 = t3[p15]

                    if not v17 then
                        error("Unsupported texture type: " .. tostring(p15), 2)
                    end

                    ApplyProperties(Instance.new(v17.Class), p16 or v17.DefaultProperties).Parent = p11
                end
            end

            if v14 == "gettexture" or v14 == "find" then
                return function(p17) -- line: 213
                    -- upvalues: FindTexture (copy)
                    return FindTexture(p17)
                end
            end

            if v14 == "getlayer" then
                return function(p18) -- line: 218
                    -- upvalues: p11 (copy)
                    return p11:FindFirstChild(p18)
                end
            end

            local v19 = p11:FindFirstChild(p14)

            if v19 and t3[v19.ClassName] then
                return v19
            end

            error("[TextureConfiguration] - Texture '" .. p14 .. "' not found or unsupported type", 2)
        end,
        __newindex = function(_, p20, p21) -- __newindex | line: 233
            -- upvalues: p11 (copy), t3 (copy), ApplyProperties (copy)
            local v20 = p11:FindFirstChild(p20)

            if not (v20 and t3[v20.ClassName]) then
                error("[TextureConfiguration] - Cannot configure non-existent texture: " .. p20, 2)
            else
                ApplyProperties(v20, p21)
            end
        end
    })
    t4[p11] = t7

    return t7
end

require(script:WaitForChild("Texture"):WaitForChild("Extras"):WaitForChild("RigidConstraint"):WaitForChild("Pose").Value)

function t1.OptimizeTextures(p22, p23) -- line: 250
    -- upvalues: t2 (copy), t3 (copy)
    local v21 = t2[p23] or t2.Medium
    local n2 = 0

    local function processTexture(p24) -- line: 255
        -- upvalues: n2 (ref), v21 (copy)
        if p24:IsA("Decal") then
            p24.ZIndex = v21.Resolution / 256
        elseif p24:IsA("Texture") then
            p24.StudsPerTileU = math.max(1, v21.Resolution / 512)
            p24.StudsPerTileV = math.max(1, v21.Resolution / 512)
        end

        n2 += 1
    end

    local function scanTextures(p25) -- line: 268
        -- upvalues: n2 (ref), v21 (copy), scanTextures (copy), t3 (copy)
        if t3[p25.ClassName] then
            if p25:IsA("Decal") then
                p25.ZIndex = v21.Resolution / 256
            elseif p25:IsA("Texture") then
                p25.StudsPerTileU = math.max(1, v21.Resolution / 512)
                p25.StudsPerTileV = math.max(1, v21.Resolution / 512)
            end

            n2 += 1
        end

        for _, child in ipairs(p25:GetChildren()) do
            scanTextures(child)
        end
    end

    scanTextures(p22)
    print("[TextureConfiguration] - Optimized " .. n2 .. " textures with " .. p23 .. " preset")

    return n2
end

function t1.UpgradeTextureQuality(p26, p27) -- line: 283
    -- upvalues: t3 (copy)
    local n3 = 0

    local function upgradeTexture(p28) -- line: 287
        -- upvalues: n3 (ref)
        if p28:IsA("Decal") and p28.Texture ~= "" then
            n3 += 1
        end
    end

    local function scanTextures(p29) -- line: 295
        -- upvalues: n3 (ref), scanTextures (copy), t3 (copy)
        if t3[p29.ClassName] and p29:IsA("Decal") and p29.Texture ~= "" then
            n3 += 1
        end

        for _, child in ipairs(p29:GetChildren()) do
            scanTextures(child)
        end
    end

    scanTextures(p26)
    print("[TextureConfiguration] - Upgraded " .. n3 .. " textures to " .. p27 .. " resolution")

    return n3
end

t1.CreateLayer = t1.CreateTextureLayer
t1.GetManager = t1.GetTextureManager
t1.Analyze = t1.AnalyzeTextureUsage
t1.GenerateMissing = t1.GenerateMissingTextures
t1.Optimize = t1.OptimizeTextures
t1.Upgrade = t1.UpgradeTextureQuality

return t1
