-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Parent = script.Parent
local ParentParent = Parent.Parent
local Templates = script:WaitForChild("Templates")
local t1 = {
    Templates:WaitForChild("SquareConfetti"),
    Templates:WaitForChild("CircularConfetti")
}
local v1, v2

if UserInputService.TouchEnabled then
    v1 = 22
    v2 = 10
else
    v1 = 34
    v2 = 16
end

local v3 = table.create(6)

for i = 1, 6 do
    v3[i] = Color3.fromHSV(((i - 1) / 6 + 0.14) % 1, 0.68, 1)
end

local v4 = table.create(v1)
local v5 = table.create(v1)
local v6 = table.create(v1)
local v7 = table.create(v1)
local v8 = table.create(v1)
local v9 = table.create(v1)
local v10 = table.create(v1)
local v11 = table.create(v1)
local n1 = 0
local n2 = 0
local n3 = 0
local n4 = 0
local connection
local v12 = Random.new()

local function buildPool() -- line: 84
    -- upvalues: Parent (copy), t1 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), n1 (ref), v1 (ref)
    if n1 >= v1 then
        return
    end

    for i = n1 + 1, v1 do
        local clone = t1[i % 2 + 1]:Clone()

        clone.Name = "P"
        clone.AnchorPoint = Vector2.new(0.5, 0.5)
        clone.ZIndex = 20
        clone.Visible = false
        clone.Parent = Parent
        v4[i] = clone
        v5[i] = 0
        v6[i] = 0
        v7[i] = 0
        v8[i] = 0
        v9[i] = 0
        v10[i] = 0
        v11[i] = 0
    end

    n1 = v1
end

local sleep, emit

local function step(p1) -- line: 108
    -- upvalues: Parent (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), n1 (ref), n3 (ref), n4 (ref), sleep (ref), emit (ref)
    local v13 = if p1 > 0.1 then 0.1 else p1
    local v14 = Parent.AbsoluteSize.Y + 80
    local v15 = 1 - v13 * 0.9

    if v15 < 0 then
        v15 = 0
    end

    local v16 = n1
    local n5 = 0

    for i = 1, v16 do
        local v17 = v11[i]

        if v17 > 0 then
            local v18 = v17 - v13
            local v19 = v6[i] + v8[i] * v13

            if v18 <= 0 or v14 < v19 then
                v11[i] = 0
                v4[i].Visible = false
            else
                local v20 = v5[i] + v7[i] * v13
                local v21 = v9[i] + v10[i] * v13

                v11[i] = v18
                v5[i] = v20
                v6[i] = v19
                v7[i] *= v15
                v8[i] += v13 * 1500
                v9[i] = v21

                local v22 = v4[i]

                v22.Position = UDim2.fromOffset(v20, v19)
                v22.Rotation = v21

                if v18 < 0.55 then
                    v22.ImageTransparency = 1 - v18 / 0.55
                end

                n5 += 1
            end
        end
    end

    if not (n4 > 0 and os.clock() - n3 >= 0.1) then
        if n5 == 0 then
            sleep()
        end
    else
        local v23 = n4

        n4 = 0
        emit(v23)
    end
end

local function wake() -- line: 161
    -- upvalues: RunService (copy), ParentParent (copy), connection (ref), step (copy)
    if not connection then
        ParentParent.Enabled = true
        connection = RunService.RenderStepped:Connect(step)
    end
end

function sleep() -- line: 168
    -- upvalues: ParentParent (copy), connection (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    ParentParent.Enabled = false
end

function emit(p2) -- line: 180
    -- upvalues: Parent (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), n2 (ref), n3 (ref), n4 (ref), v12 (copy), buildPool (copy), wake (copy), v1 (ref), v2 (ref)
    p2 = p2 or v2

    local elapsed = os.clock()

    if not (elapsed - n3 < 0.1) then
        buildPool()

        local AbsoluteSize = Parent.AbsoluteSize

        if not (AbsoluteSize.X < 1 or AbsoluteSize.Y < 1) then
            n3 = elapsed

            local v25 = if v2 < p2 then v2 else p2
            local v26 = AbsoluteSize.X * 0.5
            local Y = AbsoluteSize.Y

            for _ = 1, v25 do
                n2 += 1

                if n2 > v1 then
                    n2 = 1
                end

                local v27 = n2
                local v28 = v12:NextNumber(-0.8, 0.8)
                local v29 = v12:NextNumber(950, 1650)
                local v30 = v12:NextInteger(13, 23)

                v5[v27] = v26 + v12:NextNumber(-40, 40)
                v6[v27] = Y
                v7[v27] = math.sin(v28) * v29
                v8[v27] = -math.cos(v28) * v29
                v9[v27] = v12:NextNumber(0, 360)
                v10[v27] = v12:NextNumber(120, 460) * (v12:NextInteger(0, 1) == 0 and -1 or 1)
                v11[v27] = 1.6

                local v31 = v4[v27]

                v31.Size = UDim2.fromOffset(v30, v30)
                v31.ImageColor3 = v3[v12:NextInteger(1, #v3)]
                v31.ImageTransparency = 0
                v31.Position = UDim2.fromOffset(v5[v27], v6[v27])
                v31.Visible = true
            end

            wake()

            return
        end
    end

    if n4 < p2 then
        n4 = p2
    end

    wake()
end

local function fadeOut() -- line: 249
    -- upvalues: v11 (copy), n1 (ref), n4 (ref)
    n4 = 0

    for i = 1, n1 do
        if v11[i] > 0.25 then
            v11[i] = 0.25
        end
    end
end

local BindableEvent = Instance.new("BindableEvent")

BindableEvent.Name = "Burst"
BindableEvent.Parent = ParentParent
BindableEvent.Event:Connect(emit)

local BindableEvent2 = Instance.new("BindableEvent")

BindableEvent2.Name = "Fade"
BindableEvent2.Parent = ParentParent
BindableEvent2.Event:Connect(fadeOut)
ParentParent.DisplayOrder = 6
ParentParent.IgnoreGuiInset = true
ParentParent.ResetOnSpawn = false
ParentParent.Enabled = false
script.Destroying:Once(function() -- line: 276
    -- upvalues: sleep (ref), BindableEvent (copy), BindableEvent2 (copy)
    sleep()
    BindableEvent:Destroy()
    BindableEvent2:Destroy()
end)
