-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local t1 = {}

local function asContent(p1) -- line: 16
    local v1 = typeof(p1)

    if v1 == "number" then
        return (("rbxassetid://%*"):format(p1))
    end

    if v1 == "string" or v1 == "Instance" then
        return p1
    end

    error(("cannot preload a %* value"):format(v1), 3)
end

local function describe(p2) -- line: 26
    if typeof(p2) == "Instance" then
        return (p2:GetFullName())
    end

    return p2
end

local function requestSlice(p3) -- line: 30
    -- upvalues: ContentProvider (copy)
    local t2 = {}
    local PreloadAsync = ContentProvider.PreloadAsync

    local function v2(p4, p5) -- line: 36
        -- upvalues: t2 (copy)
        if p5 ~= Enum.AssetFetchStatus.Success then
            table.insert(t2, p4)
        end
    end

    local ok, result = pcall(PreloadAsync, ContentProvider, p3, v2)

    if not ok then
        warn((("preload request failed outright: %*"):format(result)))

        for _, v3 in p3 do
            table.insert(t2, if typeof(v3) == "Instance" then v3:GetFullName() else v3)
        end
    end

    return t2
end

function t1.Queue(p6) -- line: 52
    -- upvalues: asContent (copy), requestSlice (copy)
    local v5 = table.create(#p6)

    for _, v6 in p6 do
        table.insert(v5, asContent(v6))
    end

    for i = 1, #v5, 48 do
        local move = table.move
        local v7 = #v5
        local v8 = move(v5, i, math.min(i + 48 - 1, v7), 1, {})
        local v9 = requestSlice(v8)

        if #v9 ~= 0 then
            task.wait(0.75)
            v9 = requestSlice(v8)
        end

        if #v9 > 0 then
            warn((("%* asset(s) still unavailable after a retry: %*"):format(#v9, (table.concat(v9, ", ")))))
        end
    end
end

local function asOneList(...) -- line: 74
    local t3 = {}

    for _, v10 in { ... } do
        if type(v10) == "table" then
            for _, v11 in v10 do
                table.insert(t3, v11)
            end
        else
            table.insert(t3, v10)
        end
    end

    return t3
end

function t1.WarmAssets(...) -- line: 88
    -- upvalues: t1 (copy), asOneList (copy)
    t1.Queue(asOneList(...))
end

function t1.WarmAtWorkspace(p7, ...) -- line: 92
    -- upvalues: ContentProvider (copy), asOneList (copy)
    local v12 = asOneList(...)
    local t4 = {}
    local t5 = {
        MeshPart = true,
        Decal = true,
        Animation = true,
        ParticleEmitter = true,
        Beam = true,
        ImageLabel = true,
        Sound = true,
        VideoFrame = true
    }

    for _, v13 in v12 do
        for v14 in pairs(t5) do
            local v15 = v13:QueryDescendants(v14)

            table.move(v15, 1, #v15, #t4 + 1, t4)
        end
    end

    local ViewportFrame = Instance.new("ViewportFrame")

    ViewportFrame.Parent = workspace
    print((("[%*] Preloading %* assets"):format(p7, #t4)))

    local v17 = math.ceil(#t4 / 50)
    local n1 = 0
    local t6 = {}

    local function loadBatch() -- line: 125
        -- upvalues: p7 (copy), v17 (copy), n1 (ref), t6 (copy), ContentProvider (copy)
        n1 += 1

        local function v18() -- line: 128
            -- upvalues: t6 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync(t6)
        end

        pcall(v18)

        for _, v19 in t6 do
            v19:Destroy()
        end

        table.clear(t6)
        print((("[%*] Preloading %*/%* batches"):format(p7, n1, v17)))
    end

    for _, v20 in t4 do
        local clone = v20:Clone()

        if clone:IsA("BasePart") then
            clone.Anchored = true
            clone.Transparency = 1
            clone.CanCollide = false
            clone.CanQuery = false
            clone.CanTouch = false
        end

        for _, v21 in clone:GetTags() do
            clone:RemoveTag(v21)
        end

        clone:ClearAllChildren()
        clone.Parent = ViewportFrame
        table.insert(t6, clone)

        if #t6 >= 50 then
            loadBatch()
            task.wait()
        end
    end

    loadBatch()
    ViewportFrame:Destroy()
    print((("[%*] Preloading completed"):format(script.Name)))
end

function t1.WarmSounds(...) -- line: 170
    -- upvalues: t1 (copy), asOneList (copy)
    local v22 = asOneList(...)
    local t7 = {}
    local t8 = {}

    local function v23() -- line: 174
        -- upvalues: v22 (copy), t7 (copy), t8 (copy), t1 (copy)
        for _, v24 in v22 do
            local v25 = typeof(v24)
            local v26

            if v25 == "number" then
                v26 = ("rbxassetid://%*"):format(v24)
            elseif v25 == "string" or v25 == "Instance" then
                v26 = v24
            else
                error(("cannot preload a %* value"):format(v25), 3)
            end

            if typeof(v26) == "Instance" then
                assert(v26:IsA("Sound"), "WarmSounds expects Sound instances or sound IDs")
                table.insert(t7, v26)
            else
                local Sound = Instance.new("Sound")

                table.insert(t8, Sound)
                Sound.SoundId = v26
                table.insert(t7, Sound)
            end
        end

        t1.Queue(t7)
    end

    local ok, result = pcall(v23)

    for _, v27 in t8 do
        v27:Destroy()
    end

    if not ok then
        error(result, 0)
    end
end

return table.freeze(t1)
