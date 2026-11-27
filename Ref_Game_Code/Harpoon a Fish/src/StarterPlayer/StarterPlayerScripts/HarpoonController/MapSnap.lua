-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local HarpoonConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("HarpoonConfig"))
local t1 = {}
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Include

local v2 = RaycastParams.new()

v2.FilterType = Enum.RaycastFilterType.Exclude
v2.IgnoreWater = true

function t1.Find(p1, p2, p3, p4) -- line: 16
    -- upvalues: Players (copy), HarpoonConfig (copy), v1 (copy), v2 (copy)
    local MapPieces = workspace:FindFirstChild("MapPieces")

    if not MapPieces or not p1 or not p2 or not p4 or p3 <= 0 then
        return nil
    end

    local v3 = p3
    local descendant

    for _, descendant2 in ipairs(MapPieces:GetDescendants()) do
        if descendant2:IsA("BasePart") and descendant2:GetAttribute("MapPiece") and descendant2.CanQuery and descendant2.LocalTransparencyModifier < 1 then
            local v4 = descendant2.Position - p1
            local Magnitude = v4.Magnitude

            if Magnitude > 1 and (descendant2.Position - p4).Magnitude <= HarpoonConfig.SpearRange then
                local v8 = math.deg((math.acos((math.clamp(v4:Dot(p2) / Magnitude, -1, 1)))))

                if v8 < v3 then
                    v3 = v8
                    descendant = descendant2
                end
            end
        end
    end

    if descendant then
        v1.FilterDescendantsInstances = { descendant }

        local v9 = descendant.Position - p4
        local v10 = workspace:Raycast(p4, v9.Unit * (v9.Magnitude + descendant.Size.Magnitude), v1)
        local Position = v10 and v10.Position or descendant.Position
        local t2 = {
            MapPieces,
            Players.LocalPlayer.Character
        }

        for _, v11 in ipairs({ "Plots", "Fish" }) do
            local v12 = workspace:FindFirstChild(v11)

            if v12 then
                t2[#t2 + 1] = v12
            end
        end

        v2.FilterDescendantsInstances = t2

        local v13 = Position - p4
        local v14 = workspace:Raycast(p4, v13, v2)

        if not (v14 and v14.Distance < v13.Magnitude - 0.5) then
            return Position
        end
    end

    return nil
end

return t1
