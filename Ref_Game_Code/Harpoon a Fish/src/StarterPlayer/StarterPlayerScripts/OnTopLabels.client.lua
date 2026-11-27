-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Plots = workspace:WaitForChild("Plots")
local Fish = workspace:WaitForChild("Fish")
local t1 = {}
local v1 = LocalPlayer:GetAttribute("CameraUnderwater") == true

local function anchorOf(p1) -- line: 37
    local v2 = p1.Adornee or p1.Parent

    return if v2 and (v2:IsA("BasePart") or v2:IsA("Attachment") or v2:IsA("Model")) then v2 else nil
end

local function heightOf(p2) -- line: 42
    if p2:IsA("BasePart") then
        return p2.Position.Y
    end

    if p2:IsA("Attachment") then
        return p2.WorldPosition.Y
    end

    return p2:GetPivot().Position.Y
end

local function ownerOf(p3) -- line: 48
    -- upvalues: Plots (copy)
    local v3 = if p3:IsA("Model") and p3 then p3 else p3:FindFirstAncestorWhichIsA("Model")

    while v3 and v3.Parent and v3.Parent:IsA("Model") do
        if v3.Parent.Parent == Plots then
            break
        end

        v3 = v3.Parent
    end

    return v3
end

local function apply(p4, p5) -- line: 54
    if p5.under or p5.blocked then
        p4.MaxDistance = 0.001
    else
        p4.MaxDistance = p5.own
    end
end

local function track(p6) -- line: 58
    -- upvalues: t1 (copy), v1 (ref), ownerOf (copy)
    if t1[p6] or not p6:IsA("BillboardGui") and not p6:IsA("SurfaceGui") or not p6.AlwaysOnTop then
        return
    end

    local v4 = p6.Adornee or p6.Parent

    if not (v4 and (v4:IsA("BasePart") or v4:IsA("Attachment") or v4:IsA("Model"))) then
        v4 = nil
    end

    if v4 and not ((if v4:IsA("BasePart") then v4.Position.Y elseif v4:IsA("Attachment") then v4.WorldPosition.Y else v4:GetPivot().Position.Y) <= 0) then
        local t2 = {
            blocked = false,
            own = p6.MaxDistance,
            under = v1,
            sign = p6:IsA("SurfaceGui"),
            model = ownerOf(v4)
        }

        t1[p6] = t2

        if t2.under then
            p6.MaxDistance = if t2.under or t2.blocked then 0.001 else t2.own
        end

        p6.AncestryChanged:Connect(function(_, p8) -- line: 65
            -- upvalues: p6 (copy), t1 (copy)
            if not p8 then
                t1[p6] = nil
            end
        end)
    end
end

for _, v6 in ipairs({ PlayerGui, Plots }) do
    for _, descendant in ipairs(v6:GetDescendants()) do
        track(descendant)
    end

    v6.DescendantAdded:Connect(function(p9) -- line: 72
        -- upvalues: track (copy)
        task.defer(track, p9)
    end)
end

LocalPlayer:GetAttributeChangedSignal("CameraUnderwater"):Connect(function() -- line: 76
    -- upvalues: LocalPlayer (copy), t1 (copy), v1 (ref)
    v1 = LocalPlayer:GetAttribute("CameraUnderwater") == true

    for v7, v8 in pairs(t1) do
        if v8.under ~= v1 then
            v8.under = v1

            if v8.under or v8.blocked then
                v7.MaxDistance = 0.001
            else
                v7.MaxDistance = v8.own
            end
        end
    end
end)

local v9 = RaycastParams.new()

v9.FilterType = Enum.RaycastFilterType.Exclude
v9.IgnoreWater = true

local function isBlocked(p10, p11, p12, p13) -- line: 90
    -- upvalues: v9 (copy)
    local v10 = p10.Adornee or p10.Parent

    if not (v10 and v10:IsA("BasePart")) then
        return false
    end

    local v11 = Vector3.FromNormalId(p10.Face)
    local v12 = v10.Size / 2
    local v15 = math.abs(v11.X) * v12.X + math.abs(v11.Y) * v12.Y + math.abs(v11.Z) * v12.Z
    local v16 = v10.CFrame:VectorToWorldSpace(v11)
    local v17 = v10.Position + v16 * (v15 + 0.1)

    if (p12 - v17):Dot(v16) < 0 then
        return true
    end

    local v18 = table.clone(p13)

    table.insert(v18, v10)

    if p11.model then
        table.insert(v18, p11.model)
    end

    for _ = 1, 4 do
        v9.FilterDescendantsInstances = v18

        local v19 = workspace:Raycast(p12, v17 - p12, v9)

        if not v19 then
            return false
        end

        if v19.Instance.Transparency < 0.9 then
            return true
        end

        table.insert(v18, v19.Instance)
    end

    return false
end

local n1 = 0

RunService.Heartbeat:Connect(function(p14) -- line: 113
    -- upvalues: Players (copy), Fish (copy), t1 (copy), isBlocked (copy), n1 (ref)
    n1 += p14

    if n1 < 0.2 then
        return
    end

    n1 = 0

    local CurrentCamera = workspace.CurrentCamera

    if not CurrentCamera then
        return
    end

    local CFramePosition = CurrentCamera.CFrame.Position
    local t3 = {
        Fish
    }

    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            table.insert(t3, player.Character)
        end
    end

    for v20, v21 in pairs(t1) do
        if v21.sign and not v21.under then
            local v22 = v20.Adornee or v20.Parent
            local v23 = v22 and v22:IsA("BasePart") and (v22.Position - CFramePosition).Magnitude <= v21.own and isBlocked(v20, v21, CFramePosition, t3) or false

            if v23 ~= v21.blocked then
                v21.blocked = v23

                if v21.under or v21.blocked then
                    v20.MaxDistance = 0.001
                else
                    v20.MaxDistance = v21.own
                end
            end
        end
    end
end)
