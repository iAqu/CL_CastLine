-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local services = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local CollectionService, RunService = services.CollectionService, services.RunService

return {
    autoRotateTag = "autorotate",
    rotateSpeedAttribute = "rotatespeed",
    startAutoRotatingMeshParts = function(p1) -- startAutoRotatingMeshParts | line: 14
        -- upvalues: CollectionService (copy), RunService (copy)
        local t1 = {}

        local function v1(p2) -- line: 16
            -- upvalues: p1 (copy), CollectionService (copy)
            local Parent = p2.Parent

            while true do
                if Parent == nil then
                    return false
                end

                if not (Parent:IsA("Model") and CollectionService:HasTag(Parent, "autorotate")) then
                    if Parent == p1 then
                        return false
                    end

                    Parent = Parent.Parent
                    continue
                end

                break
            end

            return true
        end

        local function v2(p3) -- line: 29
            -- upvalues: t1 (copy), v1 (copy), CollectionService (copy)
            if not CollectionService:HasTag(p3, "autorotate") then
                return nil
            end

            if p3:IsA("Model") then
                t1[p3] = true

                return nil
            end

            if p3:IsA("MeshPart") and not v1(p3) then
                t1[p3] = true
            end
        end

        v2(p1)

        for _, descendant in p1:GetDescendants() do
            v2(descendant)
        end

        local connection = CollectionService:GetInstanceAddedSignal("autorotate"):Connect(v2)
        local connection2 = p1.DescendantAdded:Connect(v2)
        local connection3 = RunService.RenderStepped:Connect(function(p4) -- line: 49
            -- upvalues: p1 (copy), t1 (copy), v1 (copy)
            for v3 in t1 do
                if v3 ~= p1 and not v3:IsDescendantOf(p1) or v3:IsA("MeshPart") and v1(v3) then
                    t1[v3] = nil
                else
                    local rotatespeed = v3:GetAttribute("rotatespeed")

                    if typeof(rotatespeed) == "Vector3" then
                        local v9 = CFrame.Angles(math.rad(rotatespeed.X * p4), math.rad(rotatespeed.Y * p4), (math.rad(rotatespeed.Z * p4)))

                        if v3:IsA("Model") then
                            v3:PivotTo(v3:GetPivot() * v9)
                        else
                            v3.CFrame *= v9
                        end
                    end
                end
            end
        end)

        return function() -- line: 71
            -- upvalues: t1 (copy), connection (copy), connection2 (copy), connection3 (copy)
            connection:Disconnect()
            connection2:Disconnect()
            connection3:Disconnect()
            table.clear(t1)
        end
    end
}
