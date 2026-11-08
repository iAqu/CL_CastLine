-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
local SubBiomeCycle = require(ReplicatedStorage.Shared.Util.SubBiomeCycle)
local t1 = {
    Waterfalls = 10,
    Lavafalls = 4
}
local t2 = {
    Water = 2,
    Lava = 0.8
}

return {
    Start = function() -- Start | line: 29
        -- upvalues: ReplicatedStorage (copy), RunService (copy), Workspace (copy), AreaEggCycle (copy), SubBiomeCycle (copy), t1 (copy), t2 (copy)
        local v1 = Workspace:WaitForChild("World", 30)

        assert(v1 ~= nil, "Workspace.World is required")

        local v3 = v1:WaitForChild("Areas", 30)

        assert(v3 ~= nil, "Workspace.World.Areas is required")

        local v5 = v3:WaitForChild("LightDark", 30)

        assert(v5 ~= nil, "Workspace.World.Areas.LightDark is required")

        local v7 = v5:WaitForChild("Bounds", 30)

        assert(v7 ~= nil and v7:IsA("BasePart"), "LightDark.Bounds must be a BasePart")

        local v9 = ReplicatedStorage.Assets.VFX:WaitForChild("SubBiomes", 30)

        assert(v9 ~= nil, "ReplicatedStorage.Assets.VFX.SubBiomes is required")

        local v11 = v1:WaitForChild("Build", 30)

        assert(v11 ~= nil, "Workspace.World.Build is required")

        local v13 = v11:WaitForChild("Props", 30):WaitForChild("Zone12Props", 30)

        assert(v13 ~= nil, "Workspace.World.Build.Props.Zone12Props is required")

        local v15 = ReplicatedStorage.Assets:WaitForChild("SubBiomeBuilds", 30)

        assert(v15 ~= nil, "ReplicatedStorage.Assets.SubBiomeBuilds is required")

        local function zoneFloorParts() -- line: 53
            -- upvalues: v11 (copy)
            local LightDarkZone = v11:FindFirstChild("LightDarkZone")
            local v17 = if LightDarkZone == nil then nil else LightDarkZone:FindFirstChild("1")
            local BOTTOMS = if v17 == nil then nil else v17:FindFirstChild("BOTTOMS")

            if BOTTOMS ~= nil then
                local t4 = {}

                for _, child in BOTTOMS:GetChildren() do
                    assert(child:IsA("BasePart"), (("LightDarkZone.1.BOTTOMS.%* must be a BasePart"):format(child.Name)))
                    table.insert(t4, child)
                end

                if #t4 > 0 then
                    return t4
                end
            end

            return nil
        end

        local Folder = Instance.new("Folder")

        Folder.Name = "LightDarkSubBiomeVfx"
        Folder.Parent = Workspace

        local t5 = {}

        for _, v19 in { v13, v15 } do
            for _, child in v19:GetChildren() do
                t5[child.Name] = child
            end
        end

        local Id
        local t6 = {}

        local function emitterPoints() -- line: 90
            -- upvalues: v7 (copy)
            local v21 = math.max(v7.Size.X - 110, 1)
            local v22 = v7.CFrame.Position.Y + v7.Size.Y * 0.5 + 14
            local t7 = {}

            for i = 1, 9 do
                local v23 = (i - 0.5) / 9
                local v25 = Vector3.new(-v21 * 0.5 + v21 * v23, 0, 0)
                local Position = (v7.CFrame * CFrame.new(v25)).Position

                t7[i] = Vector3.new(Position.X, v22, Position.Z)
            end

            return t7
        end

        local function collectScrollingTextures(p1) -- line: 105
            -- upvalues: t6 (copy), t1 (copy), t2 (copy)
            table.clear(t6)

            if p1 ~= nil then
                for _, descendant in p1:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        local v26 = t1[descendant.Name]
                        local v27 = t2[descendant.Name]

                        if v26 ~= nil or v27 ~= nil then
                            local n2 = 0

                            for _, child in descendant:GetChildren() do
                                if child:IsA("Texture") then
                                    local v29

                                    if v26 ~= nil then
                                        v29 = v26 * (if child.Transparency <= 0.5 then 1 else 0.55)
                                    else
                                        n2 += 1
                                        v29 = v27 * (if n2 == 1 then 1 else 0.55)
                                    end

                                    table.insert(t6, {
                                        texture = child,
                                        speed = v29
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end

        local function scrollTextures() -- line: 136
            -- upvalues: t6 (copy), Workspace (copy)
            local ServerTimeNow = Workspace:GetServerTimeNow()

            for _, v30 in t6 do
                v30.texture.OffsetStudsV = -(ServerTimeNow * v30.speed) % v30.texture.StudsPerTileV
            end
        end

        local function rebuildVfx(p2) -- line: 144
            -- upvalues: v9 (copy), Folder (copy), emitterPoints (copy)
            Folder:ClearAllChildren()

            local Vfx = p2.Vfx

            if Vfx == nil then
                return
            end

            local v31 = v9:FindFirstChild(Vfx)

            assert(v31 ~= nil, (("No sub-biome VFX named \"%*\" in ReplicatedStorage.Assets.VFX.SubBiomes"):format(Vfx)))

            for _, v34 in emitterPoints() do
                local clone = v31:Clone()

                clone:PivotTo(CFrame.new(v34))
                clone.Parent = Folder
            end
        end

        local function showProps(p3) -- line: 164
            -- upvalues: v13 (copy), v15 (copy), zoneFloorParts (copy), t5 (copy), t6 (copy), collectScrollingTextures (copy)
            local v35 = zoneFloorParts()

            if v35 == nil then
                return false
            end

            local v36 = p3.HidesZoneFloor == true

            for _, v37 in v35 do
                v37.LocalTransparencyModifier = v36 and 1 or 0
            end

            local Props = p3.Props

            if Props ~= nil then
                assert(t5[Props] ~= nil, (("No biome build named \"%*\" under Build.Props.Zone12Props or Assets.SubBiomeBuilds"):format(Props)))

                for v40, v41 in t5 do
                    if v40 == Props then
                        v41.Parent = v13
                    else
                        v41.Parent = v15
                    end
                end

                collectScrollingTextures(t5[Props])
            else
                table.clear(t6)
            end

            return true
        end

        local function parkAll() -- line: 193
            -- upvalues: v15 (copy), Folder (copy), t5 (copy), t6 (copy)
            for _, v42 in t5 do
                v42.Parent = v15
            end

            Folder:ClearAllChildren()
            table.clear(t6)
        end

        local function step() -- line: 201
            -- upvalues: v15 (copy), Folder (copy), t5 (copy), Id (ref), t6 (copy), rebuildVfx (copy), showProps (copy), Workspace (copy), SubBiomeCycle (copy)
            local ServerTimeNow = Workspace:GetServerTimeNow()

            if SubBiomeCycle.RevealPhaseAt("Light Dark", ServerTimeNow) == "Sealed" then
                Id = nil

                for _, v43 in t5 do
                    v43.Parent = v15
                end

                Folder:ClearAllChildren()
                table.clear(t6)
            else
                local v44 = SubBiomeCycle.ActiveAt("Light Dark", ServerTimeNow)

                if v44 ~= nil and v44.Id ~= Id then
                    if not showProps(v44) then
                        return
                    end

                    Id = v44.Id
                    rebuildVfx(v44)
                end
            end
        end

        if SubBiomeCycle.IsRotating("Light Dark") then
            RunService.RenderStepped:Connect(scrollTextures)

            while true do
                step()
                task.wait(AreaEggCycle.SchedulePollSeconds)
            end
        end
    end
}
