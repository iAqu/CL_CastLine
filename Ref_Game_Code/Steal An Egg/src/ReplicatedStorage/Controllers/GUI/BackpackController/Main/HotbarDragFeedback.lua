-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local t1 = {}
local t2 = {}
local v1

local function stopAnimationIfIdle() -- line: 10
    -- upvalues: t2 (copy), v1 (ref)
    for _, v2 in t2 do
        if v2.Elapsed ~= nil then
            return
        end
    end

    if v1 then
        v1:Disconnect()
        v1 = nil
    end
end

local function resetShake(p1, p2) -- line: 20
    if p2.Elapsed ~= nil then
        p1.Rotation = p2.RestRotation
        p2.Elapsed = nil
    end
end

local function getState(p3) -- line: 27
    -- upvalues: t2 (copy), v1 (ref)
    if t2[p3] then
        return t2[p3]
    end

    local Frame = Instance.new("Frame")

    Frame.Name = "LockedDragHighlight"
    Frame.BackgroundColor3 = Color3.fromRGB(220, 65, 55)
    Frame.BackgroundTransparency = 0.45
    Frame.BorderSizePixel = 0
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.ZIndex = 18
    Frame.Active = false
    Frame.Selectable = false
    Frame.Interactable = false
    Frame.Visible = false

    local UICorner = p3:FindFirstChildOfClass("UICorner")

    if UICorner then
        UICorner:Clone().Parent = Frame
    end

    Frame.Parent = p3

    local t3 = {
        Highlighted = false,
        Tint = Frame
    }

    t2[p3] = t3
    p3.Destroying:Once(function() -- line: 46
        -- upvalues: p3 (copy), t2 (copy), v1 (ref)
        t2[p3] = nil

        for _, v3 in t2 do
            if v3.Elapsed ~= nil then
                return
            end
        end

        if v1 then
            v1:Disconnect()
            v1 = nil
        end
    end)

    return t3
end

function t1.Start(p4) -- line: 53
    -- upvalues: t2 (copy), v1 (ref), getState (copy)
    for v4, v5 in t2 do
        if v5.Elapsed ~= nil then
            v4.Rotation = v5.RestRotation
            v5.Elapsed = nil
        end

        v5.Highlighted = false
        v5.Tint.Visible = false
    end

    local v6 = false

    for _, v7 in t2 do
        if v7.Elapsed ~= nil then
            v6 = true
            break
        end
    end

    if not v6 and v1 then
        v1:Disconnect()
        v1 = nil
    end

    for _, v8 in p4 do
        local v9 = getState(v8)

        v9.Highlighted = true
        v9.Tint.Visible = true
    end
end

function t1.Finish() -- line: 68
    -- upvalues: t2 (copy)
    for _, v10 in t2 do
        v10.Highlighted = false
        v10.Tint.Visible = v10.Elapsed ~= nil
    end
end

function t1.Reject(p5) -- line: 75
    -- upvalues: RunService (copy), t2 (copy), v1 (ref), getState (copy)
    if p5 and p5.Parent then
        local v11 = getState(p5)

        if v11.Elapsed ~= nil then
            p5.Rotation = v11.RestRotation
            v11.Elapsed = nil
        end

        v11.RestRotation = p5.Rotation
        v11.Elapsed = 0
        v11.Tint.Visible = true
        v1 = v1 or RunService.RenderStepped:Connect(function(p6) -- line: 83
            -- upvalues: t2 (copy), v1 (ref)
            for v12, v13 in t2 do
                if v13.Elapsed ~= nil then
                    v13.Elapsed += p6

                    local v15 = math.min(v13.Elapsed / 0.32, 1)

                    v12.Rotation = v13.RestRotation + math.sin(v15 * 3.141592653589793 * 6) * 8 * (1 - v15)

                    if v15 == 1 then
                        if v13.Elapsed ~= nil then
                            v12.Rotation = v13.RestRotation
                            v13.Elapsed = nil
                        end

                        v13.Tint.Visible = v13.Highlighted
                    end
                end
            end

            for _, v17 in t2 do
                if v17.Elapsed ~= nil then
                    return
                end
            end

            if v1 then
                v1:Disconnect()
                v1 = nil
            end
        end)
    end
end

return t1
