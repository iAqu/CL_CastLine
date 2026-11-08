-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Modules.ProfileDefaults.Types.Interface)

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Signal = require(ReplicatedStorage.Packages.Signal)
local OnboardingTiming = require(ReplicatedStorage.Shared.Util.OnboardingTiming)
local Trove = require(ReplicatedStorage.Packages.Trove)
local t1 = {
    Loaded = Signal.new(),
    Changed = Signal.new(),
    PeerLoaded = Signal.new(),
    PeerChanged = Signal.new()
}
local LocalPlayer = Players.LocalPlayer
local t2 = {}
local t3 = {}
local t4 = {}

local function presentPlayer(p1) -- line: 58
    -- upvalues: LocalPlayer (copy)
    p1 = p1 or LocalPlayer

    return if p1 ~= nil and p1.Parent ~= nil then p1 else nil
end

local function signalFor(p2) -- line: 63
    -- upvalues: Signal (copy), t4 (copy)
    local v2 = t4[p2]

    if v2 == nil then
        v2 = Signal.new()
        t4[p2] = v2
    end

    return v2
end

local function seal(p3, p4) -- line: 73
    -- upvalues: seal (copy)
    if type(p3) ~= "table" or p4[p3] then
        return
    end

    p4[p3] = true

    for v3, v4 in p3 do
        seal(v3, p4)
        seal(v4, p4)
    end

    if not table.isfrozen(p3) then
        table.freeze(p3)
    end
end

local function store(p5, p6, p7) -- line: 87
    -- upvalues: seal (copy)
    if p6 ~= "Inventory" then
        seal(p7, {})
    end

    p5[p6] = p7
end

local function isInventoryPatch(p8, p9) -- line: 94
    if p8 == "Inventory" and type(p9) == "table" then
        return p9.__patch == true
    end

    return false
end

local function foldInventory(p10, p11) -- line: 99
    local v5 = p10.Inventory or {}

    if type(p11.Remove) == "table" then
        for v6 in p11.Remove do
            v5[v6] = nil
        end
    end

    if type(p11.Set) == "table" then
        for v7, v8 in p11.Set do
            v5[v7] = v8
        end
    end

    return v5
end

local function publish(p12, p13) -- line: 114
    -- upvalues: t1 (copy), LocalPlayer (copy), t4 (copy)
    if p12 == LocalPlayer then
        for _, v9 in p13 do
            t1.Changed:Fire(v9.field, v9.value, v9.previous)

            local v10 = t4[v9.field]

            if v10 ~= nil then
                v10:Fire(v9.value, v9.previous)
            end
        end
    else
        for _, v11 in p13 do
            t1.PeerChanged:Fire(p12, v11.field)
        end
    end
end

local function applyDelta(p14, p15, p16) -- line: 132
    -- upvalues: t2 (copy), seal (copy), foldInventory (copy), publish (copy)
    local v12 = t2[p14]

    if v12 == nil then
        return
    end

    local t5 = {}
    local t6 = {}

    if p16 ~= nil then
        for v13 in p16 do
            table.insert(t6, {
                value = nil,
                field = v13,
                previous = v12[v13]
            })
            v12[v13] = nil
        end
    end

    for v14, v15 in p15 do
        local v16 = if v14 == "Inventory" and type(v15) == "table" and v15.__patch == true then foldInventory(v12, v15) else v15

        table.insert(t5, {
            field = v14,
            value = v16,
            previous = v12[v14]
        })

        if v14 ~= "Inventory" then
            seal(v16, {})
        end

        v12[v14] = v16
    end

    table.move(t6, 1, #t6, #t5 + 1, t5)
    publish(p14, t5)
end

local function requestProfile(p17) -- line: 155
    -- upvalues: Remotes (copy), OnboardingTiming (copy), LocalPlayer (copy)
    if p17 == LocalPlayer then
        OnboardingTiming.Mark("OwnerProfileRequestSent")
    end

    local function v17() -- line: 157
        -- upvalues: p17 (copy), Remotes (copy)
        return Remotes.ProfileMirror.FetchProfile:InvokeServer(p17)
    end

    local ok, result = pcall(v17)

    if ok then
        if type(result) == "table" then
            return result
        end
    else
        warn((("profile fetch for %* raised: %*"):format(p17.Name, (tostring(result)))))
    end

    return nil
end

local function adopt(p18, p19) -- line: 168
    -- upvalues: OnboardingTiming (copy), t1 (copy), LocalPlayer (copy), t2 (copy), seal (copy)
    for v18, v19 in p19 do
        if v18 ~= "Inventory" then
            seal(v19, {})
        end
    end

    t2[p18] = p19

    if p18 == LocalPlayer then
        OnboardingTiming.Mark("OwnerProfileReceived")
        t1.Loaded:Fire(p18)
    else
        t1.PeerLoaded:Fire(p18)
    end
end

local function fetch(p20, p21) -- line: 186
    -- upvalues: Signal (copy), t2 (copy), t3 (copy), requestProfile (copy), adopt (copy), fetch (copy)
    local v20 = t2[p20]

    if v20 ~= nil then
        return v20
    end

    local v21 = t3[p20]

    if v21 == nil then
        local v22 = Signal.new()

        t3[p20] = v22

        local n1 = 0.6

        while true do
            if p20.Parent ~= nil and t2[p20] == nil then
                local v23 = requestProfile(p20)

                if p20.Parent ~= nil then
                    if v23 ~= nil then
                        if t2[p20] == nil then
                            adopt(p20, v23)
                        end
                    elseif p21 then
                        task.wait(n1)
                        n1 = math.min(n1 * 1.5, 3)
                        continue
                    end
                end
            end

            break
        end

        t3[p20] = nil

        local v25 = t2[p20]

        v22:Fire(v25)
        v22:Destroy()

        return v25
    end

    local v26 = v21:Wait()

    if v26 == nil and p21 and p20.Parent ~= nil then
        return fetch(p20, p21)
    end

    return v26
end

function t1.Peek(p22) -- line: 235
    -- upvalues: LocalPlayer (copy), t2 (copy)
    local v27 = p22 or LocalPlayer

    if v27 == nil or v27.Parent == nil then
        v27 = nil
    end

    return if v27 ~= nil then t2[v27] else nil
end

function t1.Await(p23) -- line: 242
    -- upvalues: LocalPlayer (copy), fetch (copy)
    local v28 = p23 or LocalPlayer

    if v28 == nil or v28.Parent == nil then
        v28 = nil
    end

    if v28 == nil then
        return nil
    end

    return fetch(v28, v28 == LocalPlayer)
end

function t1.IsLoaded(p24) -- line: 250
    -- upvalues: t1 (copy)
    return t1.Peek(p24) ~= nil
end

function t1.Watch(p25) -- line: 255
    -- upvalues: Signal (copy), t4 (copy)
    local v29 = t4[p25]

    if v29 == nil then
        v29 = Signal.new()
        t4[p25] = v29
    end

    return v29
end

function t1.WatchFields(p26, p27) -- line: 259
    -- upvalues: Signal (copy), Trove (copy), t4 (copy)
    local v30 = Trove.new()

    if type(p26) == "string" then
        local v31 = t4[p26]

        if v31 == nil then
            v31 = Signal.new()
            t4[p26] = v31
        end

        v30:Connect(v31, p27)
    else
        for _, v32 in p26 do
            local v33 = t4[v32]

            if v33 == nil then
                v33 = Signal.new()
                t4[v32] = v33
            end

            v30:Connect(v33, p27)
        end
    end

    return v30
end

function t1.Amend(p28, p29) -- line: 274
    -- upvalues: t1 (copy), LocalPlayer (copy), applyDelta (copy)
    local v34 = t1.Peek()
    local v35 = if v34 == nil then nil else v34[p28]

    if type(v35) ~= "table" then
        return
    end

    if table.isfrozen(v35) then
        v35 = table.clone(v35)
    end

    p29(v35)
    applyDelta(LocalPlayer, {
        [p28] = v35
    })
end

Remotes.ProfileMirror.ProfileDelta.OnClientEvent:Connect(function(p30, p31, p32) -- line: 289
    -- upvalues: LocalPlayer (copy), applyDelta (copy)
    local v36 = if typeof(p32) ~= "Instance" or not p32:IsA("Player") then LocalPlayer else p32
    local applyDelta2, v37

    if v36 ~= nil and type(p30) == "table" then
        applyDelta2 = applyDelta

        if type(p31) == "table" then
            v37 = p31
        end

        applyDelta2(v36, p30, v37)
    end
end)
Players.PlayerRemoving:Connect(function(p33) -- line: 298
    -- upvalues: t2 (copy)
    task.defer(function() -- line: 299
        -- upvalues: p33 (copy), t2 (copy)
        t2[p33] = nil
    end)
end)

local function track(p34) -- line: 304
    -- upvalues: fetch (copy)
    task.spawn(fetch, p34, true)
end

Players.PlayerAdded:Connect(track)

for _, player in Players:GetPlayers() do
    task.spawn(fetch, player, true)
end

return t1
