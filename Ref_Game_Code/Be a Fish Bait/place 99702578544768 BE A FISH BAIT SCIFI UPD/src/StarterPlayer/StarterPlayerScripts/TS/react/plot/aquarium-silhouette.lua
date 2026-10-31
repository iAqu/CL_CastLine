-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect = react.useEffect
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local ReplicatedStorage, Workspace = services.ReplicatedStorage, services.Workspace
local getAquariumData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "aquariums").getAquariumData

return {
    default = function(p1) -- AquariumSilhouette | line: 10
        -- upvalues: react (copy), useEffect (copy), ReplicatedStorage (copy), Workspace (copy), getAquariumData (copy)
        local aquariumLevel, plotInstance = p1.aquariumLevel, p1.plotInstance

        useEffect(function() -- line: 13
            -- upvalues: aquariumLevel (copy), plotInstance (copy), ReplicatedStorage (copy), Workspace (copy), getAquariumData (copy)
            local model = getAquariumData(aquariumLevel).model
            local BoundingBox, BoundingBox2 = model:GetBoundingBox()
            local Pivot = model:GetPivot()
            local v1 = Pivot:ToObjectSpace(BoundingBox)
            local WorldCFrame = plotInstance.AquariumPos.WorldCFrame
            local WorldCFramePosition, RightVector = WorldCFrame.Position, WorldCFrame.RightVector
            local v2 = WorldCFrame.Rotation * CFrame.Angles(0, -1.5707963267948966, 0)
            local v3 = WorldCFramePosition + RightVector * (BoundingBox2.Z / 2)
            local v4 = BoundingBox.Position.Y - BoundingBox2.Y / 2
            local v5 = WorldCFramePosition.Y + (Pivot.Position.Y - v4)
            local v6 = CFrame.new(v3.X, v5, v3.Z) * v2 * v1
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.CanTouch = false
            Part.CastShadow = false
            Part.Color = Color3.fromRGB(0, 0, 0)
            Part.Material = Enum.Material.Neon
            Part.Size = BoundingBox2 + Vector3.new(1, 1, 1)
            Part.CFrame = v6
            Part.Parent = Workspace

            local QuestionMark = ReplicatedStorage:FindFirstChild("QuestionMark")
            local v7 = BoundingBox2.X / 2 + 0.5
            local v8 = BoundingBox2.Z / 2 + 0.5
            local t1 = {
                normal = Vector3.new(-1, 0, 0),
                offset = Vector3.new(-v7, 0, 0)
            }
            local t2 = {
                normal = Vector3.new(1, 0, 0),
                offset = Vector3.new(v7, 0, 0)
            }
            local t3 = {
                normal = Vector3.new(0, 0, -1),
                offset = Vector3.new(0, 0, -v8)
            }
            local t4 = {
                normal = Vector3.new(0, 0, 1),
                offset = Vector3.new(0, 0, v8)
            }
            local t5 = {}

            for _, v11 in { t1, t2, t3, t4 } do
                local offset, normal = v11.offset, v11.normal
                local Position = (v6 * CFrame.new(offset)).Position
                local v12 = v6:VectorToWorldSpace(normal)
                local clone = QuestionMark:Clone()

                clone.Anchored = true
                clone.CanCollide = false
                clone.CanQuery = false
                clone.CanTouch = false
                clone.CastShadow = false
                clone.CFrame = CFrame.lookAt(Position, Position - v12)
                clone.Parent = Workspace
                table.insert(t5, clone)
            end

            return function() -- line: 80
                -- upvalues: Part (copy), t5 (copy)
                Part:Destroy()

                for _, v13 in t5 do
                    v13:Destroy()
                end
            end
        end, { aquariumLevel, plotInstance })

        return react.createElement(react.Fragment)
    end
}
