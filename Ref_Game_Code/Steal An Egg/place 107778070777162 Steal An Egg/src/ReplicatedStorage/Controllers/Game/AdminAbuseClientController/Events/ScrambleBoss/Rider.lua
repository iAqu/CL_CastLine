-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")

return {
    Mount = function(p1, p2) -- Mount | line: 14
        -- upvalues: RunService (copy)
        local v1 = true

        p1:Add(function() -- line: 16
            -- upvalues: v1 (ref)
            v1 = false
        end)
        task.spawn(function() -- line: 20
            -- upvalues: p1 (copy), p2 (copy), v1 (ref), RunService (copy)
            local v2 = p2.PrimaryPart or p2:WaitForChild("RootPart", 5)
            local v3 = v2 and v2:WaitForChild("RiderFollow", 5)
            local v4, v5

            if not v1 or v2 == nil or v3 == nil then
                v5 = true
            else
                local FollowBone = v3:GetAttribute("FollowBone")

                if typeof(FollowBone) == "string" then
                    v4 = v2:FindFirstChild(FollowBone, true)
                end

                v5 = false
            end

            if v5 or v4 == nil then
                return
            end

            local v6 = v2.CFrame:ToObjectSpace(v4.WorldCFrame):Inverse() * v3.C0 * v3.C1:Inverse()

            p1:Connect(RunService.PreSimulation, function() -- line: 39
                -- upvalues: v2 (copy), v4 (ref), v6 (copy), v3 (copy), p2 (copy)
                if p2.Parent ~= nil and v3.Parent == v2 then
                    local v7 = v4.TransformedWorldCFrame * v6

                    v3.Transform = v3.C0:Inverse() * v2.CFrame:ToObjectSpace(v7) * v3.C1
                end
            end)
        end)
    end
}
