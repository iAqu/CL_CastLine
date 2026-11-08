-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PetMountGeometry = require(ReplicatedStorage.Shared.Modules.PetMountGeometry)
local t1 = {}

function t1.CheckReach(p1, p2, p3) -- line: 5
    -- upvalues: PetMountGeometry (copy)
    local t2 = {}
    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart")

    assert(HumanoidRootPart, "Reference rider needs a HumanoidRootPart")

    local v1 = HumanoidRootPart.CFrame * CFrame.new(0, -1, 0)

    for _, v2 in { "Left", "Right" } do
        for _, v3 in { "Arm", "Leg" } do
            local v4 = if v3 == "Arm" then "Hand" else "Foot"
            local v5 = p2:FindFirstChild(v2 .. "Upper" .. v3)
            local v6 = p2:FindFirstChild(v2 .. "Lower" .. v3)
            local v7 = p2:FindFirstChild(v2 .. v4)

            assert(v5 and v6 and v7, "Reference rider must be R15")

            local v9, v10 = PetMountGeometry.LimbReach(v5, v6, v7, v2, v3)

            assert(v9, "Reference rider is missing joint attachments")

            local v11 = v1:PointToObjectSpace(v9.WorldPosition)

            if v3 == "Arm" then
                local v12 = v1:PointToObjectSpace(p2.UpperTorso.WaistRigAttachment.WorldPosition)

                v11 = v12 + CFrame.Angles(-math.rad(p3), 0, 0):VectorToWorldSpace(v11 - v12)
            end

            local v13 = v2 .. v4
            local Magnitude = (p1.Seat:PointToObjectSpace(p1[v13].Position) - v11).Magnitude

            t2[v13] = {
                Distance = Magnitude,
                Reach = v10,
                Ratio = Magnitude / v10,
                Pass = Magnitude <= v10
            }
        end
    end

    return t2
end

function t1.Inspect(p4, p5, p6) -- line: 33
    -- upvalues: PetMountGeometry (copy), t1 (copy)
    local t3 = {
        Name = p4.Name,
        Issues = {},
        Warnings = {},
        Sizes = {}
    }

    if p4:GetAttribute("MountSetupVersion") ~= 1 then
        table.insert(t3.Issues, "MountSetupVersion must be 1")
    end

    if p4:GetAttribute("MountNeedsReview") ~= false then
        table.insert(t3.Warnings, "Seat and animations need visual review")
    end

    local v14 = table.clone(p5)

    v14.AllowPrototypeAttachments = true

    for _, v15 in PetMountGeometry.AttachmentNames do
        local FindAttachment = PetMountGeometry.FindAttachment
        local ok, result = pcall(FindAttachment, p4, v15)

        if ok then
            if not result then
                table.insert(t3.Issues, "Missing " .. v15)
            end
        else
            table.insert(t3.Issues, (tostring(result)))
        end
    end

    for _, v18 in {
            p5.MinimumPetScale,
            1,
            (p5.MinimumPetScale + p5.MaximumPetScale) * 0.5,
            p5.MaximumPetScale
        } do
        local function v19() -- line: 45
            -- upvalues: p4 (copy), p5 (copy), p6 (copy), t3 (copy), v14 (copy), v18 (copy), PetMountGeometry (copy), t1 (copy)
            local v20 = PetMountGeometry.Measure(p4, v18, v14)
            local v21 = t1.CheckReach(v20, p6, p5.TorsoLeanDegrees or 25)

            for v22, v23 in v21 do
                if not v23.Pass then
                    table.insert(t3.Issues, v22 .. " is out of reach at pet scale " .. tostring(v18))
                end
            end

            return {
                Scale = v18,
                Height = v20.Height,
                Reach = v21
            }
        end

        local ok, result = pcall(v19)

        if not ok then
            table.insert(t3.Issues, (tostring(result)))
            break
        end

        table.insert(t3.Sizes, result)
    end

    t3.Pass = #t3.Issues == 0
    t3.Ready = t3.Pass and #t3.Warnings == 0

    return t3
end

return t1
