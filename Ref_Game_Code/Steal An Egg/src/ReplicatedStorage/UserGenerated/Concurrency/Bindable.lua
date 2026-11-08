-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function ErrorHandler(p1) -- line: 96
    warn((("%*\nStack Begin\n%*Stack End"):format(tostring(p1), (debug.traceback(nil, 3)))))
end

local function WCall(p2, ...) -- line: 100
    -- upvalues: ErrorHandler (copy)
    return xpcall(p2, ErrorHandler, ...)
end

local function FindRight(p3, p4) -- line: 108
    local v1 = false
    local v2 = 1
    local v3 = #p3

    while v2 <= v3 do
        local v4 = v2 + (v3 - v2) // 2
        local v5 = p3[v4].Pr - p4.Pr

        if v5 > 0 then
            v3 = v4 - 1
        else
            if not (v5 < 0) then
                v1 = true
            end

            v2 = v4 + 1
        end
    end

    if not v1 or not v2 then
        v2 = -v2
    end

    return v2
end

local function FindLeft(p5, p6) -- line: 132
    local v6 = false
    local v7 = 1
    local v8 = #p5

    while v7 <= v8 do
        local v9 = v7 + (v8 - v7) // 2
        local v10 = p5[v9].Pr - p6.Pr

        if v10 > 0 then
            v8 = v9 - 1
        elseif v10 < 0 then
            v7 = v9 + 1
        else
            v6 = true
            v8 = v9 - 1
        end
    end

    if not v6 or not v7 then
        v7 = -v7
    end

    return v7
end

local function InsertRight(p7, p8) -- line: 155
    -- upvalues: FindRight (copy)
    local v12 = math.abs((FindRight(p7, p8)))

    table.insert(p7, v12, p8)

    return v12
end

local function Remove(p9, p10) -- line: 165
    -- upvalues: FindLeft (copy)
    local v13 = FindLeft(p9, p10)

    if v13 > 0 then
        for i = v13, #p9 do
            if p9[i] == p10 then
                table.remove(p9, i)

                return true
            end
        end
    end

    return false
end

local function Connection_IsConnected(p11) -- line: 179
    return p11.Ow ~= nil
end

local function Connection_Disconnect(p12) -- line: 183
    -- upvalues: Remove (copy)
    local Ow = p12.Ow

    if Ow == nil then
        return
    end

    p12.Ow = nil

    if not Remove(Ow.Cs, p12) then
        warn("BindableConnectionDisconnect")
    end

    for _, v14 in ipairs(p12.Wt) do
        task.spawn(v14)
    end

    table.clear(p12.Wt)
end

local function Connection_GetPriority(p13) -- line: 197
    return p13.Pr
end

local v15 = table.freeze({
    IsConnected = Connection_IsConnected,
    Disconnect = Connection_Disconnect,
    GetPriority = Connection_GetPriority
})
local v16 = table.freeze({
    __index = v15
})

local function Connection_new(p14, p15, p16) -- line: 208
    -- upvalues: v16 (copy)
    return (setmetatable({
        Ow = p14,
        Cb = p15,
        Pr = p16,
        Wt = {}
    }, v16))
end

local function Connection_IsA(p17) -- line: 222
    -- upvalues: v16 (copy)
    if type(p17) == "table" then
        return getmetatable(p17) == v16
    end

    return false
end

local function Connection_Assert(p18) -- line: 226
    -- upvalues: v16 (copy)
    if type(p18) ~= "table" or getmetatable(p18) ~= v16 then
        error("Connection", 2)
    end

    return p18
end

local function Bindable_Connect(p19, p20, p21) -- line: 234
    -- upvalues: FindRight (copy), v16 (copy)
    assert(p21 == nil or type(p21) == "number" and p21 == p21)
    p21 = p21 or 1e999

    local v19 = setmetatable({
        Ow = p19,
        Cb = p20,
        Pr = p21,
        Wt = {}
    }, v16)

    if p21 == 1e999 then
        table.insert(p19.Cs, v19)
    else
        local Cs = p19.Cs

        table.insert(Cs, math.abs((FindRight(Cs, v19))), v19)
    end

    return v19
end

local function Bindable_Fire(p22, ...) -- line: 250
    local Cs = p22.Cs
    local n1 = 1

    while n1 <= #Cs do
        local v22 = Cs[n1]

        task.spawn(v22.Cb, ...)

        if Cs[n1] == v22 then
            n1 += 1
        end
    end
end

local function Bindable_FireAndWait(p23, ...) -- line: 264
    -- upvalues: WCall (copy)
    local Cs = p23.Cs

    if #Cs == 0 then
        return
    end

    local n2 = 1
    local thread = coroutine.running()

    local function executor(p24, ...) -- line: 271
        -- upvalues: n2 (ref), thread (copy), WCall (copy)
        WCall(p24, ...)
        n2 -= 1

        if n2 == 0 then
            task.spawn(thread)
        end
    end

    local n3 = 1

    while n3 <= #Cs do
        local v23 = Cs[n3]

        n2 += 1
        task.spawn(executor, v23.Cb, ...)

        if Cs[n3] == v23 then
            n3 += 1
        end
    end

    n2 -= 1

    if n2 > 0 then
        coroutine.yield()
    end
end

local function Bindable_FireSync(p25, ...) -- line: 293
    -- upvalues: WCall (copy)
    local Cs = p25.Cs
    local n4 = 1

    while n4 <= #Cs do
        local v24 = Cs[n4]

        WCall(v24.Cb, ...)

        if Cs[n4] == v24 then
            n4 += 1
        end
    end
end

local function Bindable_Invoke(p26, ...) -- line: 305
    local Cs = p26.Cs

    if #Cs >= 1 then
        return Cs[1].Cb(...)
    end

    error("Invoke")
end

local function Bindable_Wait(p27) -- line: 316
    -- upvalues: Connection_Disconnect (copy), v16 (copy)
    local thread = coroutine.running()
    local v25 = true
    local v26

    local function v27(...) -- line: 320
        -- upvalues: thread (copy), v25 (ref), v26 (ref), Connection_Disconnect (copy)
        local v28 = table.find(v26.Wt, thread)

        if v28 then
            table.remove(v26.Wt, v28)
        end

        v25 = false
        Connection_Disconnect(v26)
        task.spawn(thread, ...)
    end

    assert(true)

    local v29 = setmetatable({
        Pr = 1e999,
        Ow = p27,
        Cb = v27,
        Wt = {}
    }, v16)

    table.insert(p27.Cs, v29)
    v26 = v29
    table.insert(v26.Wt, thread)

    local v30 = table.pack(coroutine.yield())

    if v25 then
        error("Disconnected")
    end

    return table.unpack(v30)
end

local function Bindable_Once(p28, p29, p30) -- line: 337
    -- upvalues: FindRight (copy), Connection_Disconnect (copy), v16 (copy)
    local v31

    local function v32(...) -- line: 343
        -- upvalues: p29 (copy), v31 (ref), Connection_Disconnect (copy)
        Connection_Disconnect(v31)

        return p29(...)
    end

    assert(p30 == nil or type(p30) == "number" and p30 == p30)
    p30 = p30 or 1e999

    local v35 = setmetatable({
        Ow = p28,
        Cb = v32,
        Pr = p30,
        Wt = {}
    }, v16)

    if p30 == 1e999 then
        table.insert(p28.Cs, v35)
    else
        local Cs = p28.Cs

        table.insert(Cs, math.abs((FindRight(Cs, v35))), v35)
    end

    v31 = v35

    return v31
end

local function Bindable_DisconnectAll(p31) -- line: 350
    -- upvalues: Connection_Disconnect (copy)
    local Cs = p31.Cs

    for i = #Cs, 1, -1 do
        Connection_Disconnect(Cs[i])
    end
end

local function Bindable_GetSize(p32) -- line: 357
    return #p32.Cs
end

local function Bindable_IsEmpty(p33) -- line: 361
    return #p33.Cs == 0
end

local v38 = table.freeze({
    Fire = Bindable_Fire,
    FireAndWait = Bindable_FireAndWait,
    FireSync = Bindable_FireSync,
    Invoke = Bindable_Invoke,
    Connect = Bindable_Connect,
    Wait = Bindable_Wait,
    Once = Bindable_Once,
    DisconnectAll = Bindable_DisconnectAll,
    GetSize = Bindable_GetSize,
    IsEmpty = Bindable_IsEmpty
})
local v39 = table.freeze({
    __index = v38
})

local function new(_) -- line: 379
    -- upvalues: v39 (copy)
    local t5 = {
        Cs = {}
    }

    return (table.freeze((setmetatable(t5, v39))))
end

local function IsA(p35) -- line: 386
    -- upvalues: v39 (copy)
    if type(p35) == "table" then
        return getmetatable(p35) == v39
    end

    return false
end

local function Assert(p36) -- line: 390
    -- upvalues: v39 (copy)
    if type(p36) ~= "table" or getmetatable(p36) ~= v39 then
        error("Bindable", 2)
    end

    return p36
end

return table.freeze({
    new = new,
    IsA = IsA,
    Assert = Assert,
    IsAConnection = Connection_IsA,
    AssertConnection = Connection_Assert
})
