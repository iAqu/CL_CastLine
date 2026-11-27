-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local Poses = require(script.Parent.Parent.Character.Poses)
local TripUi = require(script.Parent.TripUi)
local TripSet = require(script.Parent.TripSet)
local t1 = {}

local function lerp(p1, p2, p3) -- line: 15
    return p1 + (p2 - p1) * p3
end

local function smooth(p4) -- line: 18
    local v1 = math.clamp(p4, 0, 1)

    return v1 * v1 * (3 - v1 * 2)
end

local function loop(p5, p6, p7) -- line: 24
    -- upvalues: UIUtil (copy)
    local v2 = UIUtil.sound(p5, p6, p7, 300)

    if v2 then
        v2.Looped = true
    end

    return v2
end

function t1.play(p8) -- line: 32
    -- upvalues: RunService (copy), UIUtil (copy), Settings (copy), Poses (copy), TripUi (copy), TripSet (copy)
    local Cave = workspace.EventHole.Cave
    local sub = p8.sub
    local v3 = sub.home * CFrame.Angles(0, 3.141592653589793, 0)
    local camera, root, humanoid = p8.camera, p8.root, p8.humanoid
    local v4 = Cave:GetAttribute("BoardAt") or Vector3.new(-254, 0.6, 17)
    local v5 = humanoid.HipHeight + root.Size.Y / 2

    TripSet.placeSub(sub, v3, 0, 0)

    local elapsed = os.clock()
    local v6 = v3.Position + Vector3.new(0, 2, -8)
    local connection = RunService.RenderStepped:Connect(function() -- line: 47
        -- upvalues: camera (copy), root (copy), elapsed (copy), v6 (copy)
        local v8 = math.clamp((os.clock() - elapsed) / 5, 0, 1)
        local v9 = v8 * v8 * (3 - v8 * 2)

        camera.CFrame = CFrame.lookAt((Vector3.new(-214, 26, 64)):Lerp(Vector3.new(-224, 19, 52), v9), v6:Lerp(root.Position, 0.35))
        camera.Focus = camera.CFrame
    end)

    TripUi.fade(false, 0.6)

    local PoolBlockers = Cave:FindFirstChild("PoolBlockers")

    local function block(p9) -- line: 55
        -- upvalues: PoolBlockers (copy)
        local v10 = if PoolBlockers then PoolBlockers:GetChildren() else {}

        for _, v11 in v10 do
            if v11:IsA("BasePart") then
                v11.CanCollide = p9
            end
        end
    end

    block(false)
    humanoid.WalkSpeed = 14
    humanoid.AutoRotate = true
    humanoid:MoveTo((Vector3.new(v4.X, root.Position.Y, v4.Z)))

    local v12 = false
    local connection2 = humanoid.MoveToFinished:Connect(function() -- line: 67
        -- upvalues: v12 (ref)
        v12 = true
    end)

    while not v12 and os.clock() - elapsed < 4.5 do
        if p8.skipped() then
            break
        end

        RunService.RenderStepped:Wait()
    end

    connection2:Disconnect()
    block(true)
    humanoid.WalkSpeed = 0
    humanoid.AutoRotate = false
    humanoid:Move((Vector3.new(0, 0, 0)))

    while os.clock() - elapsed < 2.2 and not p8.skipped() do
        RunService.RenderStepped:Wait()
    end

    connection:Disconnect()

    if p8.skipped() then
        return
    end

    root.Anchored = true

    local v13 = Vector3.new(v4.X, root.Position.Y, v4.Z)
    local v14 = TripSet.hatchHole(sub, v3)
    local Unit = Vector3.new(v13.X - v14.X, 0, v13.Z - v14.Z).Unit
    local v17 = v14 + Unit * 3.6
    local v18 = RaycastParams.new()

    v18.FilterType = Enum.RaycastFilterType.Include
    v18.FilterDescendantsInstances = { Cave:FindFirstChild("Submarine") }

    local v19 = workspace:Raycast(v17 + Vector3.new(0, 30, 0), Vector3.new(0, -60, 0), v18)
    local v21 = Vector3.new(v17.X, (if v19 then v19.Position.Y else v14.Y - 0.6) + v5, v17.Z)
    local v22 = v14 + Vector3.new(0, v5, 0)
    local Unit2 = Vector3.new(v14.X - v13.X, 0, v14.Z - v13.Z).Unit
    local t2 = {}

    for _, descendant in p8.character:GetDescendants() do
        if descendant:IsA("BasePart") and descendant ~= root and not descendant:FindFirstAncestor("RodModel") and not descendant:FindFirstAncestor("HeldAnimal") then
            table.insert(t2, descendant)
        end
    end

    local function hideBelow(p10) -- line: 108
        -- upvalues: t2 (copy)
        for _, v25 in t2 do
            v25.LocalTransparencyModifier = p10 and v25.Position.Y < p10 and 1 or 0
        end
    end

    local elapsed2 = os.clock()

    local function u() -- line: 114
        -- upvalues: elapsed2 (copy)
        return os.clock() - elapsed2
    end

    local t3 = {}

    local function once(p11, p12) -- line: 118
        -- upvalues: t3 (copy)
        if not t3[p11] then
            t3[p11] = true
            p12()
        end
    end

    local n1 = 0
    local n2 = 0
    local v26, v27
    local n3 = 0
    local v28 = v14.Y + 0.1
    local connection3 = RunService.RenderStepped:Connect(function(p13) -- line: 128
        -- upvalues: p8 (copy), sub (copy), v3 (copy), camera (copy), root (copy), v4 (copy), v5 (copy), v13 (copy), v14 (copy), Unit (copy), v21 (copy), v22 (copy), Unit2 (copy), t2 (copy), elapsed2 (copy), t3 (copy), n1 (ref), n2 (ref), v26 (ref), v27 (ref), n3 (ref), v28 (copy), UIUtil (copy), Settings (copy), Poses (copy), TripSet (copy)
        local v29 = os.clock() - elapsed2

        if v29 < 0.3 then
            local v30 = CFrame.lookAt(v13, v13 + Unit2)
            local v32 = math.clamp(v29 / 0.3, 0, 1)

            root.CFrame = v30 - Vector3.new(0, v32 * v32 * (3 - v32 * 2) * 0.6, 0)
        elseif v29 < 1 then
            local v34 = (v29 - 0.3) / 0.7

            local function v35() -- line: 136
                -- upvalues: UIUtil (copy), Poses (copy)
                Poses.play("Leap")
                UIUtil.sound("Whoosh", 0.5, 1.2)
            end

            if not t3.leap then
                t3.leap = true
                Poses.play("Leap")
                UIUtil.sound("Whoosh", 0.5, 1.2)
            end

            local v36 = math.clamp(v34, 0, 1)
            local v37 = v13:Lerp(v21, v36 * v36 * (3 - v36 * 2))
            local X = v37.X
            local Y = v13.Y
            local v41 = Vector3.new(X, Y + (v21.Y - Y) * v34 + math.sin(v34 * 3.141592653589793) * 6, v37.Z)

            root.CFrame = CFrame.lookAt(v41, v41 + Unit2)
        elseif v29 < 1.6 then
            if not t3.land then
                t3.land = true
                Poses.clear()
                UIUtil.sound("Clank", 0.7, 0.8)
                n3 = 0.4
            end

            local v43 = math.clamp((v29 - 1) / 0.25, 0, 1)
            local v44 = v43 * v43 * (3 - v43 * 2)

            root.CFrame = CFrame.lookAt(v21, v21 + Unit2) - Vector3.new(0, (1 - v44) * 0.5, 0)
        elseif v29 < 1.95 then
            local v48 = math.clamp((v29 - 1.6) / 0.35, 0, 1)
            local v49 = v48 * v48 * (3 - v48 * 2)
            local v53 = v21:Lerp(v22, v49) + Vector3.new(0, math.sin(v49 * 3.141592653589793) * 1.5, 0)

            root.CFrame = CFrame.lookAt(v53, v53 + Unit2)
        elseif v29 < 2.75 then
            local v55 = math.clamp((v29 - 1.95) / 0.8, 0, 1)
            local v56 = v55 * v55 * (3 - v55 * 2)

            root.CFrame = CFrame.lookAt(v22, v22 + Unit2) - Vector3.new(0, v56 * (v5 * 2 + 4), 0)

            for _, v59 in t2 do
                v59.LocalTransparencyModifier = v28 and v59.Position.Y < v28 and 1 or 0
            end
        else
            if not t3.seat then
                t3.seat = true

                for _, v60 in t2 do
                    v60.LocalTransparencyModifier = 0
                end

                Poses.play("Drive")
            end

            root.CFrame = TripSet.seat(sub, p8.subCF) * CFrame.new(0, p8.sitAbove, 0)
        end

        local v61

        if v29 < 1.2 then
            v61 = 0
        elseif v29 < 1.6 then
            local v63 = math.clamp((v29 - 1.2) / 0.4, 0, 1)

            v61 = v63 * v63 * (3 - v63 * 2)
        elseif v29 < 2.9 then
            v61 = 1
        else
            local v65 = math.clamp((v29 - 2.9) / 0.2, 0, 1)

            v61 = 1 - v65 * v65 * (3 - v65 * 2)
        end

        if v29 > 1.2 then
            local function v66() -- line: 172
                -- upvalues: UIUtil (copy)
                UIUtil.sound("ChairCreak", 0.6, 0.8)
            end

            if not t3.open then
                t3.open = true
                UIUtil.sound("ChairCreak", 0.6, 0.8)
            end
        end

        if v29 > 3.1 and not t3.slam then
            t3.slam = true
            UIUtil.sound("MetalClang", 0.9, 0.75)
            UIUtil.sound("Clank", 0.6, 0.6)
            n3 = 0.6
        end

        if v29 > 3.6 then
            if not t3.engine then
                t3.engine = true

                local v67 = UIUtil.sound("Reel", 0.35, 0.35, 300)

                if v67 then
                    v67.Looped = true
                end

                v26 = v67
                UIUtil.sound("SubBoom", 0.5, 0.5)
                v27 = true
            end

            local v69 = n2

            n2 = math.min(v69 + p13 * 6, 14)

            if v26 then
                v26.PlaybackSpeed = n2 / 40 + 0.35
            end
        end

        n1 += n2 * p13

        if sub.bubbles then
            local bubbles = sub.bubbles

            if v27 then
                bubbles.Rate = n2 * 6 + 30
            else
                bubbles.Rate = 0
            end
        end

        local v73 = math.max(v29 - 5, 0)
        local v74 = if not (v29 > 4.4 and v29 < 5.2) then 0 else math.sin((v29 - 4.4) / 0.8 * 3.141592653589793) * 4
        local v76 = v73 * v73 * 3.2
        local v78 = math.clamp((v73 - 1.2) / 2.6, 0, 1)
        local v79 = v78 * v78 * (3 - v78 * 2) * 13
        local v85 = (v3 + v3.LookVector * v76 - Vector3.new(0, v79, 0)) * CFrame.Angles(math.rad(v74 - v79 * 0.6), 0, (math.rad(math.sin(v29 * 1.3) * 1.2)))

        p8.subCF = v85
        TripSet.placeSub(sub, v85, n1, v61)

        if v29 > 7 then
            local function v86() -- line: 208
                -- upvalues: UIUtil (copy)
                UIUtil.sound("BigSplash", 0.6, 0.7)
                UIUtil.sound("Bubbles", 0.7, 0.7)
            end

            if not t3.splashdown then
                t3.splashdown = true
                UIUtil.sound("BigSplash", 0.6, 0.7)
                UIUtil.sound("Bubbles", 0.7, 0.7)
            end
        end

        local v88 = n3

        n3 = math.max(0, v88 - p13 * 2)

        local v89

        if v29 < 1.6 then
            local v93 = Vector3.new(v4.X + 12, v4.Y + 11, v4.Z - 10)

            v89 = CFrame.lookAt(v93, root.Position:Lerp(v14, 0.35) + Vector3.new(0, 1, 0))
        elseif v29 < 3.3 then
            local v94 = v14 - Unit * 9 + Vector3.new(-2, 7.5, 0)

            v89 = CFrame.lookAt(v94, v14 + Vector3.new(0, 1.2, 0))
        elseif v29 < 5.4 then
            local Position = (v85 * CFrame.new(0, 0, 17)).Position

            v89 = CFrame.lookAt(v3.Position + Vector3.new(-10, 14.5, 21), v85.Position:Lerp(Position, 0.4) + Vector3.new(0, 1, 0))
        else
            v89 = CFrame.lookAt(Vector3.new(-318, 0.8, 24), v85.Position + Vector3.new(0, 2, 0))

            local function v95() -- line: 232
                -- upvalues: UIUtil (copy)
                task.delay(1.6, function() -- line: 233
                    -- upvalues: UIUtil (copy)
                    UIUtil.sound("Whoosh", 0.8, 0.7)
                end)
            end

            if not t3.passby then
                t3.passby = true
                task.delay(1.6, function() -- line: 233
                    -- upvalues: UIUtil (copy)
                    UIUtil.sound("Whoosh", 0.8, 0.7)
                end)
            end
        end

        if n3 > 0 and Settings.get("Shake") then
            v89 *= CFrame.new((math.random() - 0.5) * n3, (math.random() - 0.5) * n3, 0)
        end

        camera.CFrame = v89
        camera.Focus = v89
    end)

    while os.clock() - elapsed2 < 8.2 and not p8.skipped() do
        RunService.RenderStepped:Wait()
    end

    TripUi.fade(true, 0.6)
    connection3:Disconnect()

    for _, v96 in t2 do
        v96.LocalTransparencyModifier = 0
    end

    if v26 then
        v26:Destroy()
    end

    if sub.bubbles then
        sub.bubbles.Rate = 0
    end
end

return t1
