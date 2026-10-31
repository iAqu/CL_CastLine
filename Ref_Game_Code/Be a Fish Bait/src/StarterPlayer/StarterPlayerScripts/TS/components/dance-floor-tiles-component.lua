-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local t1 = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 140, 0),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 200, 0),
    Color3.fromRGB(0, 200, 255),
    Color3.fromRGB(255, 0, 220),
    Color3.fromRGB(255, 255, 255)
}

local function worldHalfExtents(p1) -- line: 17
    local CFrame = p1.CFrame
    local v1 = p1.Size * 0.5
    local RightVector, UpVector, LookVector = CFrame.RightVector, CFrame.UpVector, CFrame.LookVector

    return (Vector3.new(math.abs(RightVector.X) * v1.X + math.abs(UpVector.X) * v1.Y + math.abs(LookVector.X) * v1.Z, math.abs(RightVector.Y) * v1.X + math.abs(UpVector.Y) * v1.Y + math.abs(LookVector.Y) * v1.Z, math.abs(RightVector.Z) * v1.X + math.abs(UpVector.Z) * v1.Y + math.abs(LookVector.Z) * v1.Z))
end

local function axisOverlap(p2, p3, p4, p5) -- line: 26
    local v11 = p2 - p3
    local v12 = p2 + p3
    local v13 = p4 - p5

    return math.min(v12, p4 + p5) - math.max(v11, v13)
end

local function shuffledIndices(p6) -- line: 35
    local t2 = {}
    local n1 = 0
    local v15 = false

    while true do
        if v15 then
            n1 += 1
        else
            v15 = true
        end

        if n1 < p6 then
            table.insert(t2, n1)
            continue
        end

        break
    end

    for i = #t2 - 1, 1, -1 do
        local v16 = math.random(0, i)
        local v17 = t2[i + 1]

        t2[i + 1] = t2[v16 + 1]
        t2[v16 + 1] = v17
    end

    return t2
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 65
        return "DanceFloorTilesComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 71
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p7, ...) -- line: 75
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p7, ...)
    p7._elapsed = 0
end

function self.onStart(p8) -- line: 79
    p8:_randomizeColors()
end

function self.onTick(p9, p10) -- line: 82
    p9._elapsed += p10

    if p9._elapsed < 1 then
        return nil
    end

    p9._elapsed = 0
    p9:_randomizeColors()
end

function self._randomizeColors(p11) -- line: 90
    -- upvalues: t1 (copy), shuffledIndices (copy)
    local Children = p11.instance:GetChildren()
    local t6 = {}

    local function v20(p12) -- line: 94
        return p12:IsA("BasePart")
    end

    local n2 = 0

    for v21, v22 in Children do
        local _ = v21 - 1

        if v22:IsA("BasePart") == true then
            n2 += 1
            t6[n2] = v22
        end
    end

    if #t6 == 0 then
        return nil
    end

    local v23 = p11:_buildAdjacency(t6)
    local v24 = shuffledIndices(#t6)
    local v25 = table.create(#t6)

    local function v26() -- line: 116
        return -1
    end

    for v27, _ in t6 do
        local _ = v27 - 1

        v25[v27] = -1
    end

    for _, v28 in v24 do
        local t7 = {}

        for _, v29 in v23[v28 + 1] do
            local v30 = v25[v29 + 1]

            if v30 ~= -1 then
                t7[v30] = true
            end
        end

        local t8 = {}

        for i = 0, #t1 - 1 do
            if t7[i] == nil then
                table.insert(t8, i)
            end
        end

        v25[v28 + 1] = t8[math.random(0, #t8 - 1) + 1]
    end

    for v31, v32 in t6 do
        v32.Color = t1[v25[v31 - 1 + 1] + 1]
    end
end

function self._buildAdjacency(_, p14) -- line: 151
    -- upvalues: worldHalfExtents (copy)
    local v34 = table.create(#p14)

    local function v35(p15) -- line: 154
        return p15.Position
    end

    for v36, v37 in p14 do
        local _ = v36 - 1

        v34[v36] = v37.Position
    end

    local v38 = table.create(#p14)

    local function v39(p16) -- line: 164
        -- upvalues: worldHalfExtents (copy)
        return (worldHalfExtents(p16))
    end

    for v40, v41 in p14 do
        local _ = v40 - 1

        v38[v40] = worldHalfExtents(v41)
    end

    local v42 = table.create(#p14)

    local function v43() -- line: 174
        return {}
    end

    for v44, _ in p14 do
        local _ = v44 - 1

        v42[v44] = {}
    end

    for i = 0, #p14 - 1 do
        local v45 = i + 1
        local v46 = false

        while true do
            if v46 then
                v45 += 1
            else
                v46 = true
            end

            if not (v45 < #p14) then
                break
            end

            local X = v34[i + 1].X
            local X2 = v38[i + 1].X
            local X3 = v34[v45 + 1].X
            local X4 = v38[v45 + 1].X
            local v47 = X - X2
            local v48 = X + X2
            local v49 = X3 - X4
            local v51 = math.min(v48, X3 + X4) - math.max(v47, v49)
            local Z = v34[i + 1].Z
            local Z2 = v38[i + 1].Z
            local Z3 = v34[v45 + 1].Z
            local Z4 = v38[v45 + 1].Z
            local v52 = Z - Z2
            local v53 = Z + Z2
            local v54 = Z3 - Z4
            local v56 = math.min(v53, Z3 + Z4) - math.max(v52, v54)
            local v57 = v51 > 0.5 and math.abs(v56) <= 0.5
            local v58 = v56 > 0.5 and math.abs(v51) <= 0.5

            if v57 or v58 then
                table.insert(v42[i + 1], v45)
                table.insert(v42[v45 + 1], i)
            end
        end
    end

    return v42
end

Reflect.defineMetadata(self, "identifier", "client/components/dance-floor-tiles-component@DanceFloorTilesComponent")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "DanceFloorTiles",
        attributes = {},
        instanceGuard = t.instanceIsA("Folder")
    }
})

return {
    DanceFloorTilesComponent = self
}
