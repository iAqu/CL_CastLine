-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function valueClassFor(p1) -- line: 22
    local v1 = typeof(p1)

    if v1 == "number" then
        return "NumberValue"
    end

    if v1 == "string" then
        return "StringValue"
    end

    if v1 == "boolean" then
        return "BoolValue"
    end

    if v1 == "Vector3" then
        return "Vector3Value"
    end

    return if v1 == "Color3" then "Color3Value" else nil
end

local function syncValue(p2, p3, p4) -- line: 32
    -- upvalues: t1 (copy)
    local v2 = tostring(p3)
    local v3 = p2:FindFirstChild(v2)

    if type(p4) == "table" then
        if v3 and not v3:IsA("Folder") then
            v3:Destroy()
            v3 = nil
        end

        if v3 then
            t1.Sync(v3, p4)
        else
            local Folder = Instance.new("Folder")

            Folder.Name = v2
            t1.Sync(Folder, p4)
            Folder.Parent = p2
        end
    else
        local v4 = typeof(p4)
        local v5

        if v4 == "number" then
            v5 = "NumberValue"
        elseif v4 == "string" then
            v5 = "StringValue"
        elseif v4 == "boolean" then
            v5 = "BoolValue"
        elseif v4 == "Vector3" then
            v5 = "Vector3Value"
        elseif v4 == "Color3" then
            v5 = "Color3Value"
        end

        if v5 then
            if v3 and v3.ClassName ~= v5 then
                v3:Destroy()
                v3 = nil
            end

            if v3 then
                if v3.Value ~= p4 then
                    v3.Value = p4
                end
            else
                local v6 = Instance.new(v5)

                v6.Name = v2
                v6.Value = p4
                v6.Parent = p2
            end
        elseif v3 then
            v3:Destroy()
        end
    end
end

function t1.Sync(p5, p6) -- line: 70
    -- upvalues: syncValue (copy)
    local t2 = {}

    for v7, v8 in pairs(p6) do
        t2[tostring(v7)] = true
        syncValue(p5, v7, v8)
    end

    for _, child in ipairs(p5:GetChildren()) do
        if not t2[child.Name] then
            child:Destroy()
        end
    end
end

function t1.SyncKey(p7, p8, p9) -- line: 84
    -- upvalues: syncValue (copy)
    local v9 = p8[p9]

    if v9 ~= nil then
        syncValue(p7, p9, v9)
    else
        local v10 = p7:FindFirstChild((tostring(p9)))

        if v10 then
            v10:Destroy()
        end
    end
end

function t1.Read(p10) -- line: 95
    -- upvalues: t1 (copy)
    if not p10 then
        return nil
    end

    if p10:IsA("ValueBase") then
        return p10.Value
    end

    local t3 = {}

    for _, child in ipairs(p10:GetChildren()) do
        local v11 = tonumber(child.Name) or child.Name

        if child:IsA("Folder") then
            t3[v11] = t1.Read(child)
        elseif child:IsA("ValueBase") then
            t3[v11] = child.Value
        end
    end

    return t3
end

function t1.ReadPath(p11, p12) -- line: 113
    -- upvalues: t1 (copy)
    for match in string.gmatch(p12, "[^%.]+") do
        if not p11 then
            return nil
        end

        p11 = p11:FindFirstChild(match)
    end

    if p11 then
        return t1.Read(p11)
    end

    return nil
end

return t1
