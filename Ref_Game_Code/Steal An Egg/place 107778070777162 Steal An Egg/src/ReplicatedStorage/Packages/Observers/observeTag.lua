-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")

function observeTag(p1, p2, p3) -- line: 56
    -- upvalues: CollectionService (copy)
    local t1 = {}
    local t2 = {}
    local connection

    local function IsGoodAncestor(p4) -- line: 63
        -- upvalues: p3 (copy)
        if p3 == nil then
            return true
        end

        for _, v1 in p3 do
            if p4:IsDescendantOf(v1) then
                return true
            end
        end

        return false
    end

    local function AttemptStartup(p5) -- line: 77
        -- upvalues: p1 (copy), p2 (copy), t1 (copy)
        t1[p5] = "__inflight__"
        task.defer(function() -- line: 82
            -- upvalues: p5 (copy), p1 (copy), p2 (copy), t1 (copy)
            if t1[p5] == "__inflight__" then
                local function v2(p6) -- line: 88
                    -- upvalues: p2 (copy)
                    local v3 = p2(p6)

                    assert(typeof(v3) == "nil" or typeof(v3) == "function", "callback must return a function")

                    return v3
                end

                local traceback = debug.traceback
                local v5, v6 = xpcall(v2, traceback, p5)

                if v5 then
                    if type(v6) == "function" then
                        if t1[p5] ~= "__inflight__" then
                            task.spawn(v6)
                        else
                            t1[p5] = v6
                        end
                    end
                else
                    local v7 = string.split(v6, "\n")[1]
                    local v8 = string.find(v7, ": ")
                    local v9 = if v8 then v7:sub(v8 + 1) else ""

                    warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, v9, v6)))
                end
            end
        end)
    end

    local function AttemptCleanup(p7) -- line: 118
        -- upvalues: t1 (copy)
        local v10 = t1[p7]

        t1[p7] = "__dead__"

        if typeof(v10) == "function" then
            task.spawn(v10)
        end
    end

    local function OnAncestryChanged(p8) -- line: 127
        -- upvalues: p1 (copy), p2 (copy), p3 (copy), t1 (copy)
        local v11

        if p3 ~= nil then
            local v12 = false

            for _, v13 in p3 do
                if p8:IsDescendantOf(v13) then
                    v11 = true
                    v12 = true
                    break
                end
            end

            if not v12 then
                v11 = false
            end
        else
            v11 = true
        end

        if v11 then
            if t1[p8] == "__dead__" then
                t1[p8] = "__inflight__"
                task.defer(function() -- line: 82
                    -- upvalues: p8 (copy), p1 (copy), p2 (copy), t1 (copy)
                    if t1[p8] == "__inflight__" then
                        local function v14(p9) -- line: 88
                            -- upvalues: p2 (copy)
                            local v15 = p2(p9)

                            assert(typeof(v15) == "nil" or typeof(v15) == "function", "callback must return a function")

                            return v15
                        end

                        local traceback = debug.traceback
                        local v17, v18 = xpcall(v14, traceback, p8)

                        if v17 then
                            if type(v18) == "function" then
                                if t1[p8] ~= "__inflight__" then
                                    task.spawn(v18)
                                else
                                    t1[p8] = v18
                                end
                            end
                        else
                            local v19 = string.split(v18, "\n")[1]
                            local v20 = string.find(v19, ": ")
                            local v21 = if v20 then v19:sub(v20 + 1) else ""

                            warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, v21, v18)))
                        end
                    end
                end)
            end
        else
            local v22 = t1[p8]

            t1[p8] = "__dead__"

            if typeof(v22) == "function" then
                task.spawn(v22)
            end
        end
    end

    local function OnInstanceAdded(p10) -- line: 137
        -- upvalues: p1 (copy), p2 (copy), p3 (copy), t1 (copy), t2 (copy), connection (ref)
        if not connection.Connected or t1[p10] ~= nil then
            return
        end

        t1[p10] = "__dead__"
        t2[p10] = p10.AncestryChanged:Connect(function() -- line: 147
            -- upvalues: p10 (copy), p1 (copy), p2 (copy), p3 (copy), t1 (copy)
            local v23

            if p3 ~= nil then
                local v24 = false

                for _, v25 in p3 do
                    if p10:IsDescendantOf(v25) then
                        v23 = true
                        v24 = true
                        break
                    end
                end

                if not v24 then
                    v23 = false
                end
            else
                v23 = true
            end

            if v23 then
                if t1[p10] == "__dead__" then
                    t1[p10] = "__inflight__"
                    task.defer(function() -- line: 82
                        -- upvalues: p10 (copy), p1 (copy), p2 (copy), t1 (copy)
                        if t1[p10] == "__inflight__" then
                            local function v26(p11) -- line: 88
                                -- upvalues: p2 (copy)
                                local v27 = p2(p11)

                                assert(typeof(v27) == "nil" or typeof(v27) == "function", "callback must return a function")

                                return v27
                            end

                            local traceback = debug.traceback
                            local v29, v30 = xpcall(v26, traceback, p10)

                            if v29 then
                                if type(v30) == "function" then
                                    if t1[p10] ~= "__inflight__" then
                                        task.spawn(v30)
                                    else
                                        t1[p10] = v30
                                    end
                                end
                            else
                                local v31 = string.split(v30, "\n")[1]
                                local v32 = string.find(v31, ": ")
                                local v33 = if v32 then v31:sub(v32 + 1) else ""

                                warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, v33, v30)))
                            end
                        end
                    end)
                end
            else
                local v34 = t1[p10]

                t1[p10] = "__dead__"

                if typeof(v34) == "function" then
                    task.spawn(v34)
                end
            end
        end)

        local v35

        if p3 ~= nil then
            local v36 = false

            for _, v37 in p3 do
                if p10:IsDescendantOf(v37) then
                    v35 = true
                    v36 = true
                    break
                end
            end

            if not v36 then
                v35 = false
            end
        else
            v35 = true
        end

        if v35 then
            if t1[p10] == "__dead__" then
                t1[p10] = "__inflight__"
                task.defer(function() -- line: 82
                    -- upvalues: p10 (copy), p1 (copy), p2 (copy), t1 (copy)
                    if t1[p10] == "__inflight__" then
                        local function v38(p12) -- line: 88
                            -- upvalues: p2 (copy)
                            local v39 = p2(p12)

                            assert(typeof(v39) == "nil" or typeof(v39) == "function", "callback must return a function")

                            return v39
                        end

                        local traceback = debug.traceback
                        local v41, v42 = xpcall(v38, traceback, p10)

                        if v41 then
                            if type(v42) == "function" then
                                if t1[p10] ~= "__inflight__" then
                                    task.spawn(v42)
                                else
                                    t1[p10] = v42
                                end
                            end
                        else
                            local v43 = string.split(v42, "\n")[1]
                            local v44 = string.find(v43, ": ")
                            local v45 = if v44 then v43:sub(v44 + 1) else ""

                            warn((("error while calling observeTag(\"%*\") callback:%*\n%*"):format(p1, v45, v42)))
                        end
                    end
                end)
            end
        else
            local v46 = t1[p10]

            t1[p10] = "__dead__"

            if typeof(v46) == "function" then
                task.spawn(v46)
            end
        end
    end

    local function OnInstanceRemoved(p13) -- line: 153
        -- upvalues: t1 (copy), t2 (copy)
        local v47 = t1[p13]

        t1[p13] = "__dead__"

        if typeof(v47) == "function" then
            task.spawn(v47)
        end

        local v48 = t2[p13]

        if v48 then
            v48:Disconnect()
            t2[p13] = nil
        end

        t1[p13] = nil
    end

    connection = CollectionService:GetInstanceAddedSignal(p1):Connect(OnInstanceAdded)

    local connection2 = CollectionService:GetInstanceRemovedSignal(p1):Connect(OnInstanceRemoved)

    task.defer(function() -- line: 170
        -- upvalues: p1 (copy), connection (ref), OnInstanceAdded (copy), CollectionService (copy)
        if connection.Connected then
            for _, v49 in CollectionService:GetTagged(p1) do
                task.spawn(OnInstanceAdded, v49)
            end
        end
    end)

    return function() -- line: 181
        -- upvalues: t1 (copy), t2 (copy), connection (ref), connection2 (copy)
        connection:Disconnect()
        connection2:Disconnect()

        local v50 = next(t1)

        while v50 do
            local v51 = t1[v50]

            t1[v50] = "__dead__"

            if typeof(v51) == "function" then
                task.spawn(v51)
            end

            local v52 = t2[v50]

            if v52 then
                v52:Disconnect()
                t2[v50] = nil
            end

            t1[v50] = nil
            v50 = next(t1)
        end
    end
end

return observeTag
