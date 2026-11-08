-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local HttpService = game:GetService("HttpService")
local t1 = {}
local v1 = false

local function finite(p1) -- line: 56
    if type(p1) == "number" and p1 == p1 then
        return math.abs(p1) < 1e999
    end

    return false
end

local function slice() -- line: 59
    local v2 = os.clock() + 0.003

    return function() -- line: 61
        -- upvalues: v2 (ref)
        if os.clock() >= v2 then
            task.wait()
            v2 = os.clock() + 0.003
        end
    end
end

function t1.Validate(p2, p3) -- line: 69
    -- upvalues: HttpService (copy)
    assert(type(p2) == "string" and #p2 <= p3, "capture_too_large_or_invalid")

    local v4 = HttpService:JSONDecode(p2)

    assert(type(v4) == "table" and v4.version == 1, "unsupported_format")

    local v6 = os.clock() + 0.003

    local function v7() -- line: 61
        -- upvalues: v6 (ref)
        if os.clock() >= v6 then
            task.wait()
            v6 = os.clock() + 0.003
        end
    end

    local t2 = {}
    local t3 = {}
    local t4 = {}
    local t5 = {}
    local t6 = {}

    local function array(p4) -- line: 75
        -- upvalues: v7 (copy)
        assert(type(p4) == "table", "invalid_array")

        for v9 in pairs(p4) do
            assert(type(v9) == "number" and v9 % 1 == 0 and v9 >= 1 and v9 <= #p4, "invalid_array")
            v7()
        end
    end

    local function dictionary(p5, p6) -- line: 82
        -- upvalues: v7 (copy), array (copy)
        array(p5)

        for _, v11 in ipairs(p5) do
            local id = v11.id
            local v12 = type(id) == "number" and id == id and math.abs(id) < 1e999 and v11.id >= 0 and v11.id % 1 == 0 and not p6[v11.id]

            assert(v12, "invalid_id")
            p6[v11.id] = v11
            v7()
        end
    end

    dictionary(v4.frames, t2)
    dictionary(v4.threads, t3)
    dictionary(v4.timers, t4)
    dictionary(v4.scopes, t5)
    dictionary(v4.memory_counters, t6)
    assert(t2[v4.anchor_frame_id], "invalid_anchor")
    assert(type(v4.complete) == "boolean" and type(v4.stitched) == "boolean", "invalid_flags")
    assert(type(v4.labels) == "table" and type(v4.origins) == "table", "invalid_labels_or_origins")

    local cpu = v4.origins.cpu
    local v16 = type(cpu) == "number" and cpu == cpu and math.abs(cpu) < 1e999

    if v16 then
        local gpu = v4.origins.gpu

        v16 = type(gpu) == "number" and gpu == gpu and math.abs(gpu) < 1e999
    end

    assert(v16, "invalid_origins")
    array(v4.labels)

    local t7 = {}

    for _, v17 in ipairs(v4.labels) do
        assert(type(v17) == "string" and not t7[v17], "invalid_label")
        t7[v17] = true
        v7()
    end

    local v19

    for _, v20 in ipairs(v4.frames) do
        local absolute_id = v20.absolute_id
        local v21 = type(absolute_id) == "number" and absolute_id == absolute_id and math.abs(absolute_id) < 1e999 and v20.absolute_id >= 0 and v20.absolute_id % 1 == 0

        assert(v21, "invalid_absolute_frame_id")

        for _, v22 in ipairs({ "cpu", "gpu" }) do
            local v23 = v20[v22 .. "_start_ms"]
            local v24 = type(v23) == "number" and v23 == v23 and math.abs(v23) < 1e999

            if v24 then
                local v25 = v20[v22 .. "_end_ms"]

                v24 = type(v25) == "number" and v25 == v25 and math.abs(v25) < 1e999

                if v24 then
                    if v20[v22 .. "_end_ms"] >= v20[v22 .. "_start_ms"] then
                        local v26 = v20[v22 .. "_end_ms"] - v20[v22 .. "_start_ms"]

                        v24 = type(v26) == "number" and v26 == v26 and math.abs(v26) < 1e999
                        v24 = v24 and (not v19 or v20[v22 .. "_start_ms"] >= v19[v22 .. "_start_ms"])
                    else
                        v24 = false
                    end
                end
            end

            assert(v24, "invalid_frame")
        end

        v19 = v20
        assert(type(v20.incomplete) == "boolean" and type(v20.stitched) == "boolean", "invalid_frame_flags")
        v7()
    end

    for _, v28 in ipairs(v4.threads) do
        assert(type(v28.name) == "string" and type(v28.is_gpu) == "boolean", "invalid_thread")
        v7()
    end

    for _, v30 in ipairs(v4.timers) do
        local name = v30.name
        local v31

        if type(name) == "string" then
            local group_id = v30.group_id

            v31 = type(group_id) == "number" and group_id == group_id and math.abs(group_id) < 1e999

            if v31 then
                v31 = false

                if v30.group_id >= 0 and v30.group_id % 1 == 0 and type(v30.group_name) == "string" and type(v30.is_gpu) == "boolean" and type(v30.color) == "string" then
                    v31 = string.match(v30.color, "^#%x%x%x%x%x%x$") ~= nil
                end
            end
        else
            v31 = false
        end

        assert(v31, "invalid_timer")
    end

    local t8 = {}
    local t9 = {}

    for _, v32 in ipairs(v4.scopes) do
        assert(v32.id > 0 and t3[v32.thread_id] and t4[v32.timer_id], "invalid_reference")

        local start_ms = v32.start_ms
        local v34 = type(start_ms) == "number" and start_ms == start_ms and math.abs(start_ms) < 1e999

        if v34 then
            local duration_ms = v32.duration_ms

            v34 = type(duration_ms) == "number" and duration_ms == duration_ms and math.abs(duration_ms) < 1e999

            if v34 then
                v34 = false

                if v32.duration_ms >= 0 then
                    local v35 = v32.start_ms + v32.duration_ms

                    if type(v35) == "number" and v35 == v35 then
                        v34 = math.abs(v35) < 1e999
                    end
                end
            end
        end

        assert(v34, "invalid_timing")

        local incomplete_start = v32.incomplete_start
        local v36 = false

        if type(incomplete_start) == "boolean" and type(v32.incomplete_end) == "boolean" then
            v36 = type(v32.stitched) == "boolean"
        end

        assert(v36, "invalid_scope_flags")
        array(v32.labels)

        local t10 = {}

        for _, v37 in ipairs(v32.labels) do
            assert(v4.labels[v37], "invalid_label_reference")
            table.insert(t10, v4.labels[v37])
            v7()
        end

        local v40 = t5[v32.parent_id]

        if v32.parent_id == 0 then
            v40 = true
        elseif v40 then
            v40 = v40.id < v32.id and v40.thread_id == v32.thread_id and v40.start_ms <= v32.start_ms + 1E-06 and v40.start_ms + v40.duration_ms + 1E-06 >= v32.start_ms + v32.duration_ms
        end

        assert(v40, "invalid_nesting")

        local name = t4[v32.timer_id].name
        local v41 = HttpService:JSONEncode({ name, t10 })
        local v42 = t9[v41]

        if v42 then
            v42.min_ms = math.min(v42.min_ms, v32.duration_ms)
            v42.max_ms = math.max(v42.max_ms, v32.duration_ms)
        else
            local t11 = {
                name = name,
                labels = t10,
                min_ms = v32.duration_ms,
                max_ms = v32.duration_ms
            }

            t9[v41] = t11
            table.insert(t8, t11)
        end

        v7()
    end

    for _, v43 in ipairs(v4.memory_counters) do
        local name = v43.name
        local v44 = false

        if type(name) == "string" and type(v43.path) == "string" then
            v44 = type(v43.is_leaf) == "boolean"
        end

        assert(v44, "invalid_counter")
        assert(v43.parent_id == 0 or t6[v43.parent_id] and v43.parent_id ~= v43.id, "invalid_counter_parent")

        local t12 = {}
        local v46 = v43

        while v46 and v46.parent_id ~= 0 do
            assert(not t12[v46.id], "counter_cycle")
            t12[v46.id] = true
            v7()
            v46 = t6[v46.parent_id]
        end

        local v48

        if v43.value ~= nil then
            local value = v43.value

            v48 = type(value) == "number" and value == value and math.abs(value) < 1e999

            if v48 then
                local frame_id = v43.frame_id

                v48 = type(frame_id) == "number" and frame_id == frame_id and math.abs(frame_id) < 1e999

                if v48 then
                    v48 = v43.frame_id >= 0 and v43.frame_id % 1 == 0
                end
            end
        else
            v48 = true
        end

        assert(v48, "invalid_counter_sample")
        v7()
    end

    local v49 = HttpService:JSONEncode(t8)

    assert(#v49 <= p3, "scope_index_too_large")

    return v4, v49
end

function t1.IsBusy() -- line: 220
    -- upvalues: v1 (ref)
    return v1
end

function t1.Run(p7) -- line: 223
    -- upvalues: v1 (ref)
    if v1 then
        return nil, "capture_busy"
    end

    v1 = true

    local v51, v52, v53 = pcall(p7)

    v1 = false

    if v51 then
        return v52, v53
    end

    return nil, (tostring(v52))
end

function t1.CreateLabelReader(p8) -- line: 236
    if not (type(p8.FetchLabelBufferRegions) == "function" and type(p8.ReadDataLocator) == "function") then
        return function() -- line: 238
            error("labels_unavailable")
        end
    end

    local function v56() -- line: 243
        -- upvalues: p8 (copy)
        return p8:FetchLabelBufferRegions()
    end

    local ok, result = pcall(v56)

    if not ok or type(result) ~= "table" or #result == 0 then
        return function() -- line: 247
            error("labels_unavailable")
        end
    end

    table.sort(result, function(p9, p10) -- line: 252
        return p9.StartOffset < p10.StartOffset
    end)

    local t13 = {}
    local v57 = os.clock() + 0.003

    local function v58() -- line: 61
        -- upvalues: v57 (ref)
        if os.clock() >= v57 then
            task.wait()
            v57 = os.clock() + 0.003
        end
    end

    return function(p11) -- line: 258
        -- upvalues: p8 (copy), result (copy), t13 (copy), v58 (copy)
        local v59 = t13[p11]

        if v59 == nil then
            local t14 = {}
            local v60 = p11
            local n1 = 1e999
            local v61

            while true do
                if n1 > 0 then
                    v58()

                    local v62

                    for _, v63 in ipairs(result) do
                        if v63.StartOffset <= v60 and v60 < v63.EndOffset then
                            v62 = v63
                            break
                        end
                    end

                    if v62 then
                        local v65 = math.min(4096, n1, v62.EndOffset - v60)

                        if not (v65 <= 0) then
                            local v66 = v62.BufferStartLocator + (v60 - v62.StartOffset)

                            local function v67() -- line: 287
                                -- upvalues: v65 (copy), v66 (copy), p8 (copy)
                                return p8:ReadDataLocator(v66, v65)
                            end

                            local ok, result = pcall(v67)

                            if ok and type(result) == "string" then
                                if #result == 0 then
                                    v61 = false
                                    break
                                end

                                local v68 = string.find(result, "\000", 1, true)

                                if v68 then
                                    local v70 = string.sub(result, 1, v68 - 1)

                                    v61 = true
                                    table.insert(t14, v70)
                                    break
                                end

                                table.insert(t14, result)
                                v60 += #result
                                n1 -= #result
                                continue
                            end
                        end
                    end
                end

                v61 = false
                break
            end

            assert(v61, "incomplete_label")

            local v71 = table.concat(t14)

            if utf8.len(v71) == nil then
                error("invalid_label_utf8")
            end

            t13[p11] = v71

            return v71
        end

        if v59 == false or not v59 then
            v59 = nil
        end

        return v59
    end
end

function t1.Export(p12, p13, p14, p15) -- line: 317
    -- upvalues: HttpService (copy), t1 (copy)
    local t15 = {}

    local function v72() -- line: 319
        -- upvalues: p12 (copy), p13 (copy), p14 (copy), p15 (copy), t15 (copy), HttpService (copy), t1 (copy)
        local v73 = os.clock() + 0.003

        local function v74() -- line: 61
            -- upvalues: v73 (ref)
            if os.clock() >= v73 then
                task.wait()
                v73 = os.clock() + 0.003
            end
        end

        local v75 = p12.Session.OpenFromBuffer(p13)

        assert(v75, "snapshot_unavailable")
        table.insert(t15, v75)
        assert(v75:IsValid(), "invalid_snapshot")

        local v77 = v75:FetchGlobalDesc()
        local FrameIdMin = v75:GetFrameIdMin()
        local FrameIdMax = v75:GetFrameIdMax()

        assert(FrameIdMin <= FrameIdMax and not (FrameIdMin == 0 and FrameIdMax == 0), "no_frames")

        local v79 = v75:FetchFrameDesc(FrameIdMin)
        local t16 = {
            version = 1,
            complete = true,
            stitched = false,
            anchor_frame_id = p14 or FrameIdMax,
            origins = {
                cpu = v79.TickStartCpu,
                gpu = v79.TickStartGpu
            },
            frames = {},
            threads = {},
            timers = {},
            labels = {},
            scopes = {},
            memory_counters = {}
        }
        local t17 = {}
        local t18 = {}
        local t19 = {}
        local t20 = {}
        local t21 = {}

        for i = FrameIdMin, FrameIdMax do
            local v80 = v75:FetchFrameDesc(i)
            local t22 = {
                stitched = false,
                id = i,
                absolute_id = v80.FrameAbsoluteId,
                cpu_start_ms = (v80.TickStartCpu - v79.TickStartCpu) * v77.TickToMsCpu,
                cpu_end_ms = (v80.TickEndCpu - v79.TickStartCpu) * v77.TickToMsCpu,
                gpu_start_ms = (v80.TickStartGpu - v79.TickStartGpu) * v77.TickToMsGpu,
                gpu_end_ms = (v80.TickEndGpu - v79.TickStartGpu) * v77.TickToMsGpu,
                incomplete = v80.IsIncomplete == true
            }

            table.insert(t16.frames, t22)
            t17[i] = t22

            if t22.incomplete then
                t16.complete = false
            end

            v74()
        end

        assert(t17[t16.anchor_frame_id], "anchor_not_in_snapshot")

        local v82 = t1.CreateLabelReader(v75)
        local v83 = v75:CreateLogIterator()

        table.insert(t15, v83)
        v83:Configure({
            SkipEvents = true,
            EmitThreadFrameEnd = true
        })

        local State = v83:GetState()

        v83:RewindTo(FrameIdMin, FrameIdMax)

        local t23 = {}

        local function record(p16, p17, p18, p19, p20, p21) -- line: 370
            -- upvalues: v75 (copy), v77 (copy), FrameIdMin (copy), v79 (copy), t16 (copy), t18 (copy), t19 (copy), t21 (copy), State (copy), t23 (copy)
            local v84 = t18[p17]

            if not v84 then
                local v85 = v75:FetchThreadDesc(p17)

                v84 = {
                    id = p17,
                    name = v85.ThreadName
                }
                v84.is_gpu = v85.IsGpu == true
                t18[p17] = v84
                table.insert(t16.threads, v84)
            end

            if not t19[p16] then
                local v86 = v75:FetchTimerDesc(p16)
                local v87 = v75:FetchGroupDesc(v86.GroupId)
                local t25 = {
                    id = p16,
                    name = v86.TimerName,
                    group_id = v86.GroupId,
                    group_name = v87.GroupName,
                    is_gpu = v84.is_gpu,
                    color = string.format("#%06x", (bit32.band(v86.Color, 16777215)))
                }

                t19[p16] = t25
                table.insert(t16.timers, t25)
            end

            local is_gpu = v84.is_gpu
            local v88 = if is_gpu then v79.TickStartGpu else v79.TickStartCpu
            local v89 = if is_gpu then v77.TickToMsGpu else v77.TickToMsCpu
            local v90 = v75:FetchFrameDesc(State:FrameId())
            local v91, v92

            if p18 then
                v92 = p18:EnterTimestampFrameLocal()
                v91 = tostring(p17) .. ":" .. tostring(p18:EnterEntryLocator())
            else
                v92 = if is_gpu then v90.TickStartGpu else v90.TickStartCpu
            end

            local v93 = v91 and t21[v91]
            local v94 = (v92 - v88) * v89
            local v95 = (p19 - v88) * v89

            assert(v94 <= v95, "negative_scope_duration")

            if v93 then
                v93.duration_ms = math.max(v93.start_ms + v93.duration_ms, v95) - v93.start_ms
                v93.incomplete_end = p21
                v93.stitched = v93.stitched or State:IsFrameStitching()
            else
                v93 = {
                    parent_id = 0,
                    id = #t16.scopes + 1,
                    timer_id = p16,
                    thread_id = p17,
                    labels = {},
                    start_ms = v94,
                    duration_ms = v95 - v94
                }
                v93.incomplete_start = p18 == nil or p18:EnterFrameId() < FrameIdMin
                v93.incomplete_end = p21
                v93.stitched = State:IsFrameStitching()
                v93._depth = p20
                table.insert(t16.scopes, v93)

                if v91 then
                    t21[v91] = v93
                end
            end

            if v91 and t23[v91] then
                v93.labels = t23[v91]
            end
        end

        while v83:Step() do
            v74()

            if State:IsFrameStitching() then
                t16.stitched = true
                t17[State:FrameId()].stitched = true
            end

            if State:ThreadStackIsOverflowed() or State:ThreadStackWasOverflowed() then
                error("scope_stack_overflow")
            end

            if not State:IsFrameBoundary() then
                local v98 = State:ThreadId()
                local v99 = State:ThreadStackDepth()
                local ThreadStackState = v83:GetThreadStackState(v98)

                if State:IsLabel() and v99 > 0 and not State:ThreadStackIsOverflowed() then
                    local CurrentThreadStackElement = v83:GetCurrentThreadStackElement(v99 - 1)
                    local CurrentEntryWords, CurrentEntryWords2 = v83:GetCurrentEntryWords()

                    if CurrentThreadStackElement and CurrentEntryWords and CurrentEntryWords2 then
                        local v101 = v82(CurrentEntryWords + bit32.band(CurrentEntryWords2, 65535) * 4294967296)
                        local v100

                        if v101 then
                            v100 = t20[v101]

                            if not v100 then
                                v100 = #t16.labels + 1
                                t16.labels[v100] = v101
                                t20[v101] = v100
                            end

                            local v102 = tostring(v98) .. ":" .. tostring(CurrentThreadStackElement:EnterEntryLocator())
                            local v103 = t23[v102] or {}

                            t23[v102] = v103
                            table.insert(v103, v100)
                        end
                    end
                elseif not State:IsExit() or State:ThreadStackWasOverflowed() then
                    if State:IsThreadFrameEnd() then
                        for i = v99 - 1, 0, -1 do
                            local CurrentThreadStackElement = v83:GetCurrentThreadStackElement(i)

                            if CurrentThreadStackElement then
                                record(CurrentThreadStackElement:EnterTimerId(), v98, CurrentThreadStackElement, State:Timestamp(), ThreadStackState:DepthAbsolute() - (v99 - i), true)
                            end

                            v74()
                        end
                    end
                else
                    local v104 = if not State:ThreadStackIsUnderflowed() then v83:GetCurrentThreadStackElement(v99) else nil

                    record(State:TimerId(), v98, v104, State:Timestamp(), ThreadStackState:DepthAbsolute(), false)
                end
            end
        end

        local function less(p22, p23) -- line: 483
            if p22.thread_id ~= p23.thread_id then
                return p22.thread_id < p23.thread_id
            end

            if p22.start_ms ~= p23.start_ms then
                return p22.start_ms < p23.start_ms
            end

            if p22._depth == p23._depth then
                return p22.id < p23.id
            end

            return p22._depth < p23._depth
        end

        local v106 = t16.scopes
        local v107 = table.create(#t16.scopes)
        local v108 = 1

        while v108 < #v106 do
            for i = 1, #v106, v108 * 2 do
                local v111 = math.min(i + v108, #v106 + 1)
                local v114 = math.min(i + v108 * 2, #v106 + 1)
                local v115 = v114 - 1
                local v116 = i
                local v117 = v111

                for j = i, v115 do
                    local v118 = false

                    if v116 < v111 then
                        if v114 <= v117 then
                            v118 = true
                        else
                            local v119 = v106[v117]
                            local v120 = v106[v116]

                            v118 = not (if v119.thread_id ~= v120.thread_id then v119.thread_id < v120.thread_id
                                elseif v119.start_ms ~= v120.start_ms then v119.start_ms < v120.start_ms
                                elseif v119._depth == v120._depth then v119.id < v120.id
                                else v119._depth < v120._depth)
                        end
                    end

                    if v118 then
                        v107[j] = v106[v116]
                        v116 += 1
                    else
                        v107[j] = v106[v117]
                        v117 += 1
                    end

                    v74()
                end
            end

            v106, v107, v108 = v107, v106, v108 * 2
        end

        t16.scopes = v106

        local t27 = {}

        for v121, v122 in ipairs(t16.scopes) do
            while true do
                if #t27 > 0 then
                    local v123 = t27[#t27]

                    if v123.thread_id ~= v122.thread_id or not (v123._depth < v122._depth) or not (v123.start_ms + v123.duration_ms + 1E-06 >= v122.start_ms + v122.duration_ms) then
                        table.remove(t27)
                        continue
                    end
                end

                v122.id = v121

                if #t27 > 0 then
                    v122.parent_id = t27[#t27].id
                else
                    v122.parent_id = 0
                end

                table.insert(t27, v122)

                if v122.incomplete_start or v122.incomplete_end then
                    t16.complete = false
                end

                v74()
                break
            end
        end

        for _, v124 in ipairs(t16.scopes) do
            v124._depth = nil
        end

        local function v125() -- line: 541
            -- upvalues: v75 (copy)
            return v75:CreateCounterIterator()
        end

        local ok, result = pcall(v125)

        t16.memory_available = ok and result ~= nil

        if t16.memory_available then
            table.insert(t15, result)

            local State = result:GetState()

            while result:Step() do
                local v126 = State:CounterId()
                local t28 = {}

                for i = 0, State:Level() do
                    table.insert(t28, v75:FetchCounterDesc(result:GetStackElement(i)).CounterName)
                end

                local t29 = {
                    id = v126,
                    parent_id = if State:Level() > 0 then result:GetStackElement(State:Level() - 1) else 0,
                    name = v75:FetchCounterDesc(v126).CounterName,
                    path = table.concat(t28, "/"),
                    is_leaf = State:IsLeaf()
                }

                local function v127() -- line: 560
                    -- upvalues: v75 (copy), v126 (copy)
                    return v75:FetchLastCounterSample(v126)
                end

                local ok, result2 = pcall(v127)

                if ok and result2 then
                    t29.value = result2.Value
                    t29.frame_id = result2.FrameId
                end

                table.insert(t16.memory_counters, t29)
                v74()
            end
        end

        local v128 = HttpService:JSONEncode(t16)
        local _, v129 = t1.Validate(v128, p15)

        return v128, v129
    end

    local v130, v131, v132 = pcall(v72)

    for i = #t15, 1, -1 do
        local function v133() -- line: 576
            -- upvalues: t15 (copy), i (copy)
            t15[i]:Dispose()
        end

        pcall(v133)
    end

    if not v130 then
        error(v131, 0)
    end

    return v131, v132
end

return t1
