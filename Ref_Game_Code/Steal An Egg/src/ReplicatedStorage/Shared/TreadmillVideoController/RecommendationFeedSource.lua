-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RecommendationService = game:GetService("RecommendationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local Log = require(ReplicatedStorage.Packages.Log)
local RecommendationFlags = require(script.Parent.RecommendationFlags)
local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)
local TreadmillMediaOverlay = require(ReplicatedStorage.Shared.Modules.TreadmillMediaOverlay)

require(script.Parent.Types.Interface)

local v1 = Log.new()
local v2
local t1 = {}
local t2 = {}
local n1 = 0
local v3
local n2 = 0
local v4 = false
local n3 = 0
local t3 = {}

local function buildMediaIndexMap(p1) -- line: 41
    -- upvalues: TreadmillMediaIdentity (copy), v2 (ref), t1 (ref)
    if v2 == p1 then
        return
    end

    v2 = p1
    t1 = {}

    for v5, v6 in ipairs(p1) do
        local v7 = TreadmillMediaIdentity.GetMediaKey(v6)

        if t1[v7] == nil then
            local t4 = t1

            t4[v7] = v5
        end
    end
end

local function appendCurrentPage(p2) -- line: 56
    -- upvalues: TreadmillMediaOverlay (copy), t1 (ref), t2 (ref)
    local CurrentPage = p2:GetCurrentPage()

    for _, v8 in ipairs(CurrentPage) do
        local t5 = t1
        local v9 = t5[v8.ReferenceId]

        if v9 ~= nil and not TreadmillMediaOverlay.IsExcluded(v8.ReferenceId) then
            local t6 = t2

            table.insert(t6, {
                MediaIndex = v9,
                MediaKey = v8.ReferenceId,
                ItemId = v8.ItemId,
                TracingId = v8.TracingId,
                ItemPosition = #t2 + 1
            })
        end
    end
end

local function generateListAsync() -- line: 75
    -- upvalues: RecommendationService (copy), Constants (copy), RecommendationFlags (copy), v1 (copy), t2 (ref), n1 (ref), v3 (ref), n2 (ref), appendCurrentPage (copy)
    if Constants.IS_STUDIO or not RecommendationFlags.Enabled:Get() then
        return false
    end

    local function v10() -- line: 80
        -- upvalues: RecommendationService (copy), RecommendationFlags (copy), t2 (ref), n1 (ref), v3 (ref), n2 (ref), appendCurrentPage (copy)
        local v11 = RecommendationService:GenerateItemListAsync({
            LocationId = "TreadmillFeed",
            ConfigName = RecommendationFlags.ConfigName:Get(),
            PageSize = RecommendationFlags.PageSize:Get()
        })

        t2 = {}
        n1 = 0
        v3 = v11
        n2 = os.clock()
        appendCurrentPage(v11)
    end

    local ok, result = pcall(v10)

    if ok then
        v1:AtTrace():Log((`Generated treadmill recommendation list: {#t2} items`))

        return #t2 > 0
    end

    v1:AtWarning():Log((("Failed to generate treadmill recommendation list: %*"):format(result)))

    return false
end

local function prefetchNextPageAsync() -- line: 102
    -- upvalues: Constants (copy), RecommendationFlags (copy), v1 (copy), v3 (ref), v4 (ref), n3 (ref), appendCurrentPage (copy)
    if Constants.IS_STUDIO
        or not RecommendationFlags.Enabled:Get()
        or v4
        or v3 == nil
        or v3.IsFinished
        or os.clock() < n3 then
        return
    end

    v4 = true
    task.spawn(function() -- line: 111
        -- upvalues: RecommendationFlags (copy), v1 (copy), v3 (ref), v4 (ref), n3 (ref), appendCurrentPage (copy)
        local function v12() -- line: 112
            -- upvalues: v3 (ref), appendCurrentPage (copy)
            v3:AdvanceToNextPageAsync()
            appendCurrentPage(v3)
        end

        local ok, result = pcall(v12)

        v4 = false

        if not ok then
            n3 = os.clock() + RecommendationFlags.FailureCooldownSeconds:Get()
            v1:AtWarning():Log((("Failed to advance treadmill recommendation page: %*"):format(result)))
        end
    end)
end

function t3.PrefetchFeed(p3) -- line: 135
    -- upvalues: Constants (copy), RecommendationFlags (copy), t2 (ref), n2 (ref), v4 (ref), n3 (ref), buildMediaIndexMap (copy), generateListAsync (copy)
    buildMediaIndexMap(p3)

    if not Constants.IS_STUDIO and RecommendationFlags.Enabled:Get() and (not (#t2 > 0) or not (os.clock() - n2 < RecommendationFlags.StaleSeconds:Get())) and not v4 and not (os.clock() < n3) then
        v4 = true
        task.spawn(function() -- line: 146
            -- upvalues: RecommendationFlags (copy), v4 (ref), n3 (ref), generateListAsync (copy)
            local v14 = generateListAsync()

            if not v14 then
                task.wait(RecommendationFlags.FetchRetryDelaySeconds:Get())
                v14 = generateListAsync()
            end

            v4 = false

            if not v14 then
                n3 = os.clock() + RecommendationFlags.FailureCooldownSeconds:Get()
            end
        end)
    end
end

function t3.GetReadyItem() -- line: 160
    -- upvalues: Constants (copy), RecommendationFlags (copy), TreadmillMediaOverlay (copy), t2 (ref), n1 (ref), n2 (ref), prefetchNextPageAsync (copy)
    local v15, v16

    if Constants.IS_STUDIO then
        v16 = true
    elseif RecommendationFlags.Enabled:Get() then
        v15 = #t2 > 0 and os.clock() - n2 < RecommendationFlags.StaleSeconds:Get()
        v16 = false
    else
        v16 = true
    end

    if v16 then
        return nil
    end

    if v15 then
        if n1 == 0 then
            n1 = 1
        end

        for i = n1, #t2 do
            local v18 = t2[i]

            if v18 ~= nil and not TreadmillMediaOverlay.IsExcluded(v18.MediaKey) then
                n1 = i

                if #t2 - n1 <= RecommendationFlags.PrefetchMargin:Get() then
                    prefetchNextPageAsync()
                end

                return v18
            end
        end

        if #t2 - n1 <= RecommendationFlags.PrefetchMargin:Get() then
            prefetchNextPageAsync()
        end
    end

    return nil
end

function t3.Next() -- line: 183
    -- upvalues: RecommendationFlags (copy), TreadmillMediaOverlay (copy), t2 (ref), n1 (ref), prefetchNextPageAsync (copy)
    if #t2 == 0 then
        return nil
    end

    for _ = 1, #t2 do
        n1 += 1

        if n1 > #t2 then
            n1 = 1
        end

        local v20 = t2[n1]

        if v20 ~= nil and not TreadmillMediaOverlay.IsExcluded(v20.MediaKey) then
            if #t2 - n1 <= RecommendationFlags.PrefetchMargin:Get() then
                prefetchNextPageAsync()
            end

            return v20
        end
    end

    if #t2 - n1 <= RecommendationFlags.PrefetchMargin:Get() then
        prefetchNextPageAsync()
    end

    return nil
end

function t3.Previous() -- line: 204
    -- upvalues: TreadmillMediaOverlay (copy), t2 (ref), n1 (ref)
    if #t2 == 0 then
        return nil, false
    end

    for i = n1 - 1, 1, -1 do
        local v21 = t2[i]

        if v21 ~= nil and not TreadmillMediaOverlay.IsExcluded(v21.MediaKey) then
            n1 = i

            return v21, true
        end
    end

    local v22 = n1

    n1 = math.clamp(v22, 1, #t2)

    return t2[n1], false
end

function t3.PeekAhead(p4) -- line: 221
    -- upvalues: TreadmillMediaOverlay (copy), t2 (ref), n1 (ref)
    local t10 = {}
    local n4 = 0

    while #t10 < p4 do
        n4 += 1

        local v24 = t2[n1 + n4]

        if v24 == nil then
            break
        end

        if not TreadmillMediaOverlay.IsExcluded(v24.MediaKey) then
            table.insert(t10, v24.MediaIndex)
        end
    end

    return t10
end

TreadmillMediaOverlay.Changed:Connect(function() -- line: 238
    -- upvalues: v2 (ref)
    v2 = nil
end)
RecommendationFlags.Enabled.Changed:Connect(function() -- line: 241
    -- upvalues: RecommendationFlags (copy), t2 (ref), n1 (ref), v3 (ref), n2 (ref)
    if RecommendationFlags.Enabled:Get() then
        return
    end

    t2 = {}
    n1 = 0
    v3 = nil
    n2 = 0
end)
RecommendationFlags.ConfigName.Changed:Connect(function() -- line: 253
    -- upvalues: RecommendationFlags (copy), v2 (ref), n2 (ref), t3 (copy)
    n2 = 0
    task.delay(math.random() * RecommendationFlags.ConfigSwapSpreadSeconds:Get(), function() -- line: 255
        -- upvalues: v2 (ref), t3 (copy)
        local v25 = v2

        if v25 ~= nil then
            t3.PrefetchFeed(v25)
        end
    end)
end)

return t3
