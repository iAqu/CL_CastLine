-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReflectionService = game:GetService("ReflectionService")
local t1 = {}
local t2 = {}
local t3 = {
    Parent = true,
    ClassName = true,
    Name = true,
    ExtentsCFrame = true,
    ExtentsSize = true,
    ResizeIncrement = true,
    ResizeableFaces = true,
    CurrentPhysicalProperties = true,
    Sandboxed = true,
    Capabilities = true,
    PrivateServerId = true,
    PrivateServerOwnerId = true,
    SerializedDefaultAttributes = true
}
local t4 = {
    Debug = true
}

local function v1() -- line: 44
    return tostring(SecurityCapabilities.fromCurrent()):split(" | ")
end

local ok, result = pcall(v1)
local v2 = if ok then result else {}

local function canRead(p1) -- line: 50
    -- upvalues: v2 (copy)
    if not p1 then
        return true
    end

    local v3 = tostring(p1):split(" | ")

    if v3[1] ~= nil and v3[1] ~= "" then
        for _, v4 in v3 do
            if not table.find(v2, v4) then
                return false
            end
        end
    end

    return true
end

function t1.getReadProperties(p2) -- line: 66
    -- upvalues: ReflectionService (copy), t2 (copy), t3 (copy), t4 (copy), canRead (copy)
    local v5 = t2[p2]

    if v5 then
        return v5
    end

    local t5 = {}

    local function v6() -- line: 73
        -- upvalues: p2 (copy), ReflectionService (copy)
        return ReflectionService:GetPropertiesOfClass(p2)
    end

    local ok, result = pcall(v6)

    if ok and result then
        for _, v7 in result do
            local Name = v7.Name

            if not t3[Name] then
                local Display = v7.Display

                if Display then
                    if (not Display.DeprecationMessage or Display.DeprecationMessage == "") and (not Display.Category or not t4[Display.Category]) then
                        local Type = v7.Type

                        if not Type or Type.ScriptType ~= "Instance" then
                            local Permits = v7.Permits

                            Permits = Permits and Permits.Read

                            if canRead(Permits) then
                                table.insert(t5, Name)
                            end
                        end
                    end
                else
                    local Type = v7.Type

                    if not Type or Type.ScriptType ~= "Instance" then
                        local Permits = v7.Permits

                        Permits = Permits and Permits.Read

                        if canRead(Permits) then
                            table.insert(t5, Name)
                        end
                    end
                end
            end
        end
    end

    t2[p2] = t5

    return t5
end

return t1
