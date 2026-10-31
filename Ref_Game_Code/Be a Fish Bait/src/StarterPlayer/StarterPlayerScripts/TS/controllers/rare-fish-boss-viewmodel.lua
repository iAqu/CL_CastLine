-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Maid = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "maid", "Maid")
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local activeBaitAuraVfxName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-vfx-utils").activeBaitAuraVfxName
local t1 = {
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftHand",
    "RightUpperArm",
    "RightLowerArm",
    "RightHand"
}

return {
    createBossArmViewmodel = function(p1, p2) -- createBossArmViewmodel | line: 23
        -- upvalues: Maid (copy), Workspace (copy), activeBaitAuraVfxName (copy), t1 (copy)
        local v1 = p1:FindFirstChild("Head", true) or p1:FindFirstChild("UpperTorso", true) or p1:FindFirstChild("HumanoidRootPart", true)

        if v1 == nil or not v1:IsA("BasePart") then
            return nil
        end

        local v2 = Maid.new()
        local Model = Instance.new("Model")

        Model.Name = "BossArmViewmodel"
        Model.Parent = Workspace
        v2:GiveTask(Model)

        local t2 = {}

        for _, v3 in t1 do
            local v4 = p1:FindFirstChild(v3, true)

            if v4 ~= nil and v4:IsA("BasePart") then
                local clone = v4:Clone()

                for _, child in clone:GetChildren() do
                    if child:IsA("Motor6D") or child:IsA("Weld") or child:IsA("WeldConstraint") or child:IsA("Attachment") or child.Name == activeBaitAuraVfxName then
                        child:Destroy()
                    end
                end

                clone.Anchored = true
                clone.CanCollide = false
                clone.CanQuery = false
                clone.CanTouch = false
                clone.Massless = true
                clone.Size = v4.Size * p2.scale
                clone.LocalTransparencyModifier = 0
                clone.Parent = Model
                table.insert(t2, {
                    clone = clone,
                    source = v4
                })

                local LocalTransparencyModifier = v4.LocalTransparencyModifier

                v4.LocalTransparencyModifier = 1
                v2:GiveTask(function() -- line: 68
                    -- upvalues: v4 (copy), LocalTransparencyModifier (copy)
                    v4.LocalTransparencyModifier = LocalTransparencyModifier
                end)
            end
        end

        if #t2 == 0 then
            v2:Destroy()

            return nil
        end

        return {
            update = function(_, p4) -- update | line: 77
                -- upvalues: p2 (copy), v1 (copy), t2 (copy)
                local v5 = p4.CFrame * CFrame.new(0, p2.offsetY, p2.offsetZ)

                for _, v6 in t2 do
                    local v7 = v1.CFrame:ToObjectSpace(v6.source.CFrame)
                    local v8 = if string.find(v6.source.Name, "Left") == nil then 1 else -1
                    local Position = v7.Position
                    local scale = p2.scale
                    local v10 = Vector3.new(v8 * p2.sideOffsetX, 0, 0)
                    local v11 = Position * scale + v10
                    local v12 = v7 - v7.Position
                    local v13 = CFrame.new(v11)

                    v6.clone.CFrame = v5 * v13 * v12
                end
            end,
            destroy = function(_) -- destroy | line: 97
                -- upvalues: v2 (copy)
                v2:Destroy()
            end
        }
    end
}
