-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")

local function GenerateEntropy() -- line: 22
    -- upvalues: HttpService (copy)
    local v1 = HttpService:GenerateGUID(false)

    return tonumber(string.sub(v1, 1, 8), 16), tonumber(string.sub(v1, 10, 13) .. string.sub(v1, 25, 28), 16), (tonumber(string.sub(v1, 29, 36), 16))
end

local function GenerateSeed(p1) -- line: 29
    -- upvalues: HttpService (copy)
    local v7 = table.create(p1, 0)
    local v8 = p1 // 3

    for i = 0, v8 - 1 do
        local v9 = i * 3 + 2
        local v10 = i * 3 + 3
        local v11 = HttpService:GenerateGUID(false)
        local v13 = tonumber(string.sub(v11, 1, 8), 16)
        local v15 = tonumber(string.sub(v11, 10, 13) .. string.sub(v11, 25, 28), 16)
        local v17 = tonumber(string.sub(v11, 29, 36), 16)

        v7[i * 3 + 1] = v13
        v7[v9] = v15
        v7[v10] = v17
    end

    local v18 = p1 - v8 * 3

    if v18 == 1 then
        local v19 = HttpService:GenerateGUID(false)
        local v21 = tonumber(string.sub(v19, 1, 8), 16)

        tonumber(string.sub(v19, 10, 13) .. string.sub(v19, 25, 28), 16)
        tonumber(string.sub(v19, 29, 36), 16)
        v7[p1] = v21
    elseif v18 == 2 then
        local v24 = p1 - 1
        local v25 = HttpService:GenerateGUID(false)
        local v27 = tonumber(string.sub(v25, 1, 8), 16)
        local v29 = tonumber(string.sub(v25, 10, 13) .. string.sub(v25, 25, 28), 16)

        tonumber(string.sub(v25, 29, 36), 16)
        v7[v24] = v27
        v7[p1] = v29
    end

    return v7
end

return GenerateSeed
