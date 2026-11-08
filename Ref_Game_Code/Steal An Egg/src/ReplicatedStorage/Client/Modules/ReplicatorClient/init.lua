-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

if _G.__ReplicatorClientReference then
    error("replicator has already been required on the client in another module.")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = utf8.char(0)
local v2 = utf8.char(1)
local v3 = utf8.char(2)
local t1 = {}
local t2 = {}
local t3 = {}
local t4 = {}
local t5 = {}
local ReplicatorSignal = require(script.ReplicatorSignal)
local Buff = require(script.Buff)
local t6 = {}
local t7 = {}
local t8 = {}

local function ensureDescendantPath(p1, p2) -- line: 99
    local v4 = #p2
    local v5 = p1

    for i = 1, v4 do
        local v6 = p2[i]
        local v7 = v5[v6]

        if v7 then
            v5 = v7
        else
            local t9 = {}

            v5[v6] = t9
            v5 = t9
        end
    end

    return v5
end

local function deepCopy(p3) -- line: 113
    -- upvalues: deepCopy (copy)
    local v8 = table.clone(p3)

    for v9, v10 in v8 do
        if type(v10) == "table" then
            v8[v9] = deepCopy(v10)
        end
    end

    return v8
end

local function makeDotCallsError(p4) -- line: 123
    for v11, v12 in p4 do
        if type(v12) == "function" then
            p4[v11] = function(...) -- line: 126
                -- upvalues: p4 (copy), v12 (copy), v11 (copy)
                if select(1, ...) == p4 then
                    return v12(...)
                end

                error((("called %* with .%*() instead of :%*()"):format(v11, v11, v11)))
            end
        end
    end
end

local function fireInitialSignals(p5, p6) -- line: 137
    -- upvalues: t3 (copy), t4 (copy), t5 (copy), fireInitialSignals (copy)
    local v13 = p5[t3]

    if v13 then
        v13.signal:Fire(p6:TryIndex(v13.path))
    end

    local v14 = p5[t4]

    if v14 then
        v14.signal:Fire(p6:TryIndex(v14.path), nil)
    end

    local v15 = p5[t5]

    if v15 then
        local v16 = p6:TryIndex(v15.path)

        if v16 then
            for v17, v18 in v16 do
                v15.signal:Fire(v17, v18)
            end
        end
    end

    for v19, v20 in p5 do
        if type(v19) == "string" then
            fireInitialSignals(v20, p6)
        end
    end
end

local function disconnectAllSignals(p7) -- line: 162
    -- upvalues: t3 (copy), t4 (copy), disconnectAllSignals (copy)
    local v21 = p7[t3]

    if v21 then
        v21.signal:DisconnectAll()
    end

    local v22 = p7[t4]

    if v22 then
        v22.signal:DisconnectAll()
    end

    for v23, v24 in p7 do
        if type(v23) == "string" then
            disconnectAllSignals(v24)
        end
    end
end

local function handlePacket(p8) -- line: 178
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), t1 (copy), t3 (copy), t4 (copy), t5 (copy), t6 (copy), t7 (copy), t8 (copy), deepCopy (copy), fireInitialSignals (copy), disconnectAllSignals (copy)
    local v25 = p8[1]
    local v26 = p8[2]

    if v25 == v1 then
        local v27 = p8[3]
        local v28 = p8[4]

        for v29, v30 in t6 do
            if v30 == v27 and v29 ~= v26 then
                error((("client received 2 Replicators with the same Id \"%*\""):format(v27)))
            end
        end

        t6[v26] = v27
        t8.get(v27)

        local v31 = t7[v27]

        v31.Data = deepCopy(v28)
        fireInitialSignals(v31._signal_descendants, v31)
        v31._listen_raw_signal:Fire(v31.Data, v31.Data)
    elseif v25 == v2 then
        local v32 = t6[v26]

        if v32 then
            local v33 = t7[v32]

            if v33 then
                local t10 = {}

                local function fireNilDescendants(p9, p10) -- line: 214
                    -- upvalues: t10 (copy), fireNilDescendants (copy), t1 (copy), t3 (copy), t4 (copy), t5 (copy), deepCopy (copy)
                    local v34 = p10[t5]

                    if v34 and type(p9) == "table" then
                        for v35 in p9 do
                            table.insert(t10, {
                                v34.signal,
                                v35,
                                t1
                            })
                        end
                    end

                    for v36, v37 in p10 do
                        if type(v36) == "string" then
                            local v38 = type(p9) == "table" and p9[v36] or nil
                            local v39 = v37[t3]

                            if v39 then
                                table.insert(t10, {
                                    v39.signal,
                                    t1,
                                    nil
                                })
                            end

                            local v40 = v37[t4]

                            if v40 then
                                table.insert(t10, {
                                    v40.signal,
                                    t1,
                                    if type(v38) == "table" then deepCopy(v38) else v38
                                })
                            end

                            fireNilDescendants(v38, v37)
                        end
                    end
                end

                local v42 = p8[3]

                local function apply(p11, p12, p13) -- line: 254
                    -- upvalues: t10 (copy), fireNilDescendants (copy), apply (copy), t1 (copy), t3 (copy), t4 (copy), t5 (copy), deepCopy (copy)
                    if type(p12) == "table" and p12.__none == "__none" then
                        if p13 then
                            fireNilDescendants(p11, p13)
                        end

                        return nil
                    end

                    if type(p11) ~= "table" or type(p12) ~= "table" then
                        return p12
                    end

                    local v43 = p11[1] ~= nil
                    local v44 = p13 and p13[t5]

                    for v45, v46 in next, p12 do
                        local v47 = v43 and type(v45) == "string" and tonumber(v45) or v45
                        local v48 = p13 and p13[tostring(v47)]
                        local v49 = apply(p11[v47] or {}, v46, v48)

                        if v44 and p11[v47] == nil ~= (v49 == nil) then
                            table.insert(t10, {
                                v44.signal,
                                v47,
                                if v49 == nil then t1 else v49
                            })
                        end

                        if v48 then
                            local v51 = v48[t3]

                            if v51 then
                                table.insert(t10, {
                                    v51.signal,
                                    if v49 == nil then t1 else v49,
                                    p12
                                })
                            end

                            local v53 = v48[t4]

                            if v53 then
                                local v54 = p11[v47]
                                local signal = v53.signal
                                local v55 = if v49 == nil then t1 else v49

                                if type(v54) == "table" then
                                    v54 = deepCopy(v54)
                                end

                                table.insert(t10, {
                                    signal,
                                    v55,
                                    v54
                                })
                            end
                        end

                        p11[v47] = v49
                    end

                    return p11
                end

                local v56 = apply(v33.Data, v42, v33._signal_descendants)

                if v33.Data ~= v56 then
                    v33.Data = v56
                end

                for _, v57 in t10 do
                    local v58 = v57[1]
                    local v59, v60 = unpack(v57, 2, 3)

                    if v59 == t1 then
                        v59 = nil
                    end

                    if v60 == t1 then
                        v60 = nil
                    end

                    v58:Fire(v59, v60)
                end

                v33._listen_raw_signal:Fire(v33.Data, v42)
            end
        end
    elseif v25 == v3 then
        local v61 = t6[v26]
        local v62 = t7[v61]

        if not v62 then
            return
        end

        if v62._destroyed == true then
            error("received 2 DESTROY_CMD for the same replicator")
        end

        v62.Destroying:Fire()
        disconnectAllSignals(v62._signal_descendants)
        table.clear(v62._signal_descendants)
        v62._destroyed = true
        t7[v61] = nil
    end
end

function t8.get(p14) -- line: 370
    -- upvalues: t2 (copy), t3 (copy), t4 (copy), t5 (copy), ReplicatorSignal (copy), t7 (copy), ensureDescendantPath (copy), makeDotCallsError (copy)
    local v63 = t7[p14]

    if v63 then
        return v63
    end

    local t17 = {
        Data = nil,
        Ready = false,
        _destroyed = false,
        Id = p14,
        Destroying = ReplicatorSignal.new(),
        _indices_signals = {},
        _listen_raw_signal = ReplicatorSignal.new(),
        _signal_descendants = {}
    }

    local function registerListener(p15, p16, p17) -- line: 390
        -- upvalues: t17 (copy), t2 (copy), ReplicatorSignal (copy), ensureDescendantPath (copy)
        if #p15 == 0 and p15 ~= t2 then
            warn("path:", p15)
            error("invalid path to register listener.")
        end

        local v64 = ensureDescendantPath(t17._signal_descendants, p15)
        local v65 = v64[p16]

        if not v65 then
            v65 = {
                connected = 0,
                signal = ReplicatorSignal.new(),
                path = p15
            }
            v64[p16] = v65
        end

        local connection = v65.signal:Connect(p17)

        v65.connected += 1

        return function() -- line: 415
            -- upvalues: p16 (copy), v64 (copy), v65 (ref), connection (copy)
            connection:Disconnect()

            local v66 = v65

            v66.connected -= 1

            if v65.connected == 0 then
                v64[p16] = nil
            end
        end
    end

    function t17.Listen(_, p19, p20) -- line: 452
        -- upvalues: registerListener (copy), t3 (copy)
        if type(p19[1]) ~= "table" then
            return (registerListener(p19, t3, p20))
        end

        local t18 = {}

        for _, v68 in p19 do
            table.insert(t18, (registerListener(v68, t3, p20)))
        end

        return function() -- line: 459
            -- upvalues: t18 (copy)
            for _, v70 in t18 do
                v70()
            end

            table.clear(t18)
        end
    end

    function t17.ListenRaw(_, p22) -- line: 488
        -- upvalues: t17 (copy)
        return t17._listen_raw_signal:Connect(p22)
    end

    function t17.Observe(_, p24, p25) -- line: 510
        -- upvalues: t17 (copy), registerListener (copy), t4 (copy)
        task.spawn(p25, t17:TryIndex(p24), nil)

        return (registerListener(p24, t4, p25))
    end

    function t17.ObserveKeys(_, p27, p28) -- line: 540
        -- upvalues: t17 (copy), registerListener (copy), t5 (copy)
        local v71 = t17:TryIndex(p27)

        if v71 then
            for v72, v73 in v71 do
                p28(v72, v73)
            end
        end

        return (registerListener(p27, t5, p28))
    end

    function t17.ListenKeys(_, p30, p31) -- line: 572
        -- upvalues: registerListener (copy), t5 (copy)
        return (registerListener(p30, t5, p31))
    end

    function t17.Index(_, p33) -- line: 591
        -- upvalues: t17 (copy)
        local Data = t17.Data

        if type(Data) ~= "table" then
            error("Replicator:Index() failed Data is not a table.")
        end

        local v74 = #p33

        for v75, v76 in p33 do
            Data = Data[v76]

            if v75 < v74 and type(Data) ~= "table" then
                error((("Replicator:Index() failed %* is not a table."):format((table.concat(p33, "/", 1, v75)))))
            end
        end

        return Data
    end

    function t17.TryIndex(_, p35) -- line: 623
        -- upvalues: t17 (copy)
        local Data = t17.Data

        if type(Data) ~= "table" then
            return nil
        end

        local v77 = #p35

        for v78, v79 in p35 do
            Data = Data[v79]

            if v78 < v77 and type(Data) ~= "table" then
                return nil
            end
        end

        return Data
    end

    function t17.Path(_, p37) -- line: 659
        local v80 = if type(p37) == "string" then { p37 } else p37

        return function(p38) -- line: 662
            -- upvalues: v80 (copy)
            local v81 = table.clone(v80)

            if p38 ~= nil then
                if type(p38) == "string" then
                    table.insert(v81, p38)
                else
                    table.move(p38, 1, #p38, #v81 + 1, v81)
                end
            end

            return v81
        end
    end

    function t17.WaitForLoaded(_) -- line: 690
        -- upvalues: t17 (copy)
        if not t17.Data then
            t17._listen_raw_signal:Wait()
        end
    end

    t7[p14] = t17
    makeDotCallsError(t17)

    return t17
end

local v82 = false

function t8.init() -- line: 724
    -- upvalues: ReplicatedStorage (copy), Buff (copy), handlePacket (copy), v82 (ref)
    if v82 then
        return
    end

    v82 = true

    local thread = coroutine.running()
    local v83 = false
    local v84 = ReplicatedStorage:WaitForChild("__ReplicatorInternal", 1e999):WaitForChild("RemoteEvent", 1e999)

    v84.OnClientEvent:Connect(function(p40, p41) -- line: 738
        -- upvalues: thread (copy), v83 (ref), Buff (copy), handlePacket (copy)
        for v85, v86 in (Buff.decode(p40, p41)) do
            debug.profilebegin((("replicator::handlepacket::%*"):format(v85)))
            handlePacket(v86)
            debug.profileend()
        end

        if v83 and coroutine.status(thread) == "suspended" then
            task.spawn(thread)
            v83 = false
        end
    end)
    v84:FireServer()
    v83 = true
    coroutine.yield()
end

_G.__ReplicatorClientReference = t8

return t8
