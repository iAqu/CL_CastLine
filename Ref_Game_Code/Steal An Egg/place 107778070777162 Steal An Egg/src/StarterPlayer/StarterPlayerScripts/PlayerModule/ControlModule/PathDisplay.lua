-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local UserRaycastUpdateAPI = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserRaycastUpdateAPI")
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Exclude

local t1 = {
    spacing = 8,
    image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
    imageSize = Vector2.new(2, 2)
}
local v2 = {}
local t2 = {}
local Model = Instance.new("Model")

Model.Name = "PathDisplayPoints"

local Part = Instance.new("Part")

Part.Anchored = true
Part.CanCollide = false
Part.Transparency = 1
Part.Name = "PathDisplayAdornee"
Part.CFrame = CFrame.new(0, 0, 0)
Part.Parent = Model

local t3 = {}
local n1 = 30

for i = 1, 30 do
    local ImageHandleAdornment = Instance.new("ImageHandleAdornment")

    ImageHandleAdornment.Archivable = false
    ImageHandleAdornment.Adornee = Part
    ImageHandleAdornment.Image = t1.image
    ImageHandleAdornment.Size = t1.imageSize
    t3[i] = ImageHandleAdornment
end

local function retrieveFromPool() -- line: 41
    -- upvalues: t3 (copy), n1 (ref)
    local v3 = t3[1]

    if not v3 then
        return nil
    end

    local v4 = n1

    t3[1] = t3[n1]
    t3[v4] = nil
    n1 -= 1

    return v3
end

local function returnToPool(p1) -- line: 52
    -- upvalues: t3 (copy), n1 (ref)
    n1 += 1
    t3[n1] = p1
end

local function renderPoint(p2, _) -- line: 57
    -- upvalues: UserRaycastUpdateAPI (copy), v1 (copy), Model (copy), t3 (copy), n1 (ref)
    if n1 == 0 then
        return nil
    end

    local v5 = t3[1]

    if v5 then
        local v6 = n1

        t3[1] = t3[n1]
        t3[v6] = nil
        n1 -= 1
    else
        v5 = nil
    end

    if UserRaycastUpdateAPI then
        v1.FilterDescendantsInstances = {
            game.Players.LocalPlayer.Character,
            workspace.CurrentCamera
        }

        local v7 = workspace:Raycast(p2 + Vector3.new(0, 2, 0), Vector3.new(0, -8, 0), v1)

        if not v7 then
            return nil
        end

        v5.CFrame = CFrame.lookAlong(v7.Position, v7.Normal)
    else
        local v8 = Ray.new(p2 + Vector3.new(0, 2, 0), (Vector3.new(0, -8, 0)))
        local v9, v10, v11 = workspace:FindPartOnRayWithIgnoreList(v8, {
            game.Players.LocalPlayer.Character,
            workspace.CurrentCamera
        })

        if not v9 then
            return nil
        end

        v5.CFrame = CFrame.new(v10, v10 + v11)
    end

    v5.Parent = Model

    return v5
end

function t1.setCurrentPoints(p4) -- line: 89
    -- upvalues: v2 (ref)
    if typeof(p4) == "table" then
        v2 = p4
    else
        v2 = {}
    end
end

function t1.clearRenderedPath() -- line: 97
    -- upvalues: t2 (ref), Model (copy), t3 (copy), n1 (ref)
    for _, v12 in ipairs(t2) do
        v12.Parent = nil
        n1 += 1
        t3[n1] = v12
    end

    t2 = {}
    Model.Parent = nil
end

function t1.renderPath() -- line: 106
    -- upvalues: t1 (copy), v2 (ref), t2 (ref), Model (copy), renderPoint (copy)
    t1.clearRenderedPath()

    if not v2 or #v2 == 0 then
        return
    end

    local v14 = #v2
    local v15 = v2[v14]

    t2[1] = renderPoint(v15, true)

    if t2[1] then
        local n2 = 0

        while true do
            local v16 = v2[v14]
            local v17 = v2[v14 - 1]

            if v14 < 2 then
                break
            end

            local v19 = v17 - v16
            local magnitude = v19.magnitude

            if magnitude < n2 then
                n2 -= magnitude
                v14 -= 1
            else
                local v21 = renderPoint(v16 + v19.unit * n2, false)

                if v21 then
                    t2[#t2 + 1] = v21
                end

                n2 += t1.spacing
            end
        end

        Model.Parent = workspace.CurrentCamera
    end
end

return t1
