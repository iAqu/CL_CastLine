-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local n1 = 0
local AuthoritativeClockSample
local v1 = false
local t1 = {}

local function finite(p1) -- line: 9
    if type(p1) == "number" and p1 == p1 then
        return math.abs(p1) < 1e999
    end

    return false
end

local function refresh() -- line: 13
    -- upvalues: Workspace (copy), n1 (ref), AuthoritativeClockSample (ref)
    local AuthoritativeClockSample2 = Workspace:GetAttribute("AuthoritativeClockSample")

    if type(AuthoritativeClockSample2) == "number" and AuthoritativeClockSample2 == AuthoritativeClockSample2 and math.abs(AuthoritativeClockSample2) < 1e999 and AuthoritativeClockSample2 > 1E+09 then
        AuthoritativeClockSample = AuthoritativeClockSample2
        n1 = os.clock()
    end
end

function t1.Resolve(p2, p3, p4) -- line: 21
    if type(p3) == "number" and p3 == p3 and math.abs(p3) < 1e999 and p3 > 1E+09 then
        local v2 = p3 + math.max(0, p4)

        if not (type(p2) == "number" and p2 == p2 and math.abs(p2) < 1e999 and math.abs(p2 - v2) < 30) then
            return v2, true
        end

        return p2, false
    end

    if not (type(p2) == "number" and p2 == p2 and math.abs(p2) < 1e999 and p2 > 1E+09) then
        return nil, true
    end

    return p2, false
end

function t1.Now() -- line: 31
    -- upvalues: Workspace (copy), n1 (ref), AuthoritativeClockSample (ref), v1 (ref), t1 (copy)
    local GetServerTimeNow = Workspace.GetServerTimeNow
    local ok, result = pcall(GetServerTimeNow, Workspace)
    local v6, v7 = t1.Resolve(if not ok then nil else result, AuthoritativeClockSample, os.clock() - n1)

    if v7 and not v1 then
        v1 = true
        warn("[ServerClock] Invalid engine time; using replicated server clock sample")
    end

    return v6 or DateTime.now().UnixTimestampMillis / 1000
end

if RunService:IsServer() then
    local function publish() -- line: 42
        -- upvalues: Workspace (copy)
        Workspace:SetAttribute("AuthoritativeClockSample", DateTime.now().UnixTimestampMillis / 1000)
    end

    Workspace:SetAttribute("AuthoritativeClockSample", DateTime.now().UnixTimestampMillis / 1000)
    task.spawn(function() -- line: 46
        -- upvalues: Workspace (copy)
        while task.wait(5) do
            Workspace:SetAttribute("AuthoritativeClockSample", DateTime.now().UnixTimestampMillis / 1000)
        end
    end)
end

local AuthoritativeClockSample2 = Workspace:GetAttribute("AuthoritativeClockSample")

if type(AuthoritativeClockSample2) == "number" and AuthoritativeClockSample2 == AuthoritativeClockSample2 and math.abs(AuthoritativeClockSample2) < 1e999 and AuthoritativeClockSample2 > 1E+09 then
    AuthoritativeClockSample = AuthoritativeClockSample2
    n1 = os.clock()
end

Workspace:GetAttributeChangedSignal("AuthoritativeClockSample"):Connect(refresh)

return table.freeze(t1)
