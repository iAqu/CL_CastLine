-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = game:GetService("RunService"):IsServer()
local v2 = game:GetService("RunService"):IsStudio()
local AnalyticsService = game:GetService("AnalyticsService")
local HttpService = game:GetService("HttpService")
local AnalyticsLogLevel = Enum.AnalyticsLogLevel
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = not v1 and Players.LocalPlayer or nil
local Log = script:FindFirstAncestor("Packages").Configs:FindFirstChild("Log")
local v3 = Log and require(Log) or "Debug"
local Stringify = require(ReplicatedStorage.UserGenerated.Strings.Stringify)
local t = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("t"))
local TryCall = require(ReplicatedStorage.Shared.Utils.TryCall)
local v4
local clock = os.clock
local t1 = {
    Trace = AnalyticsLogLevel.Trace.Value,
    Debug = AnalyticsLogLevel.Debug.Value,
    Info = AnalyticsLogLevel.Information.Value,
    Warning = AnalyticsLogLevel.Warning.Value,
    Error = AnalyticsLogLevel.Error.Value,
    Fatal = AnalyticsLogLevel.Fatal.Value
}
local t2 = {
    Milliseconds = 0,
    Seconds = 1,
    Minutes = 2,
    Hours = 3,
    Days = 4,
    Weeks = 5,
    Months = 6,
    Years = 7
}

local function ToSeconds(p1, p2) -- line: 193
    if p2 == 0 then
        return p1 / 1000
    end

    if p2 == 1 then
        return p1
    end

    if p2 == 2 then
        return p1 * 60
    end

    if p2 == 3 then
        return p1 * 3600
    end

    if p2 == 4 then
        return p1 * 86400
    end

    if p2 == 5 then
        return p1 * 604800
    end

    if p2 == 6 then
        return p1 * 2592000
    end

    if p2 == 7 then
        return p1 * 31536000
    end

    error("Unknown time unit", 2)
end

local function GetPlayerFromCustomData(p3) -- line: 215
    if type(p3) == "table" then
        local v5 = p3.Player or p3.PlayerId

        if v5 then
            return game:GetService("Players"):GetPlayerByUserId(v5)
        end
    end

    return nil
end

local v6

if v2 then
    v6 = function(_, _, _, _) -- line: 227
    end
else
    v6 = function(p8, p9, p10, p11) -- line: 235
        -- upvalues: AnalyticsService (copy), LocalPlayer (copy)
        local function v7() -- line: 241
            -- upvalues: p8 (copy), p9 (copy), p10 (copy), p11 (copy), AnalyticsService (copy), LocalPlayer (copy)
            local v8 = LocalPlayer

            if not LocalPlayer then
                local v9, v10

                if type(p11) == "table" then
                    v9 = p11.Player or p11.PlayerId
                    v10 = not not v9
                else
                    v10 = false
                end

                v8 = if v10 then game:GetService("Players"):GetPlayerByUserId(v9) else nil
            end

            AnalyticsService:FireLogEvent(v8, p8, p9, {
                stackTrace = p10
            }, p11)
        end

        local ok, result = pcall(v7)

        if not ok then
            warn(result)
        end
    end
end

local t4 = {}

t4.__index = t4

function t4.new(p12, p13, p14, p15, p16) -- line: 268
    -- upvalues: t4 (copy)
    return (setmetatable({
        _muted = p16,
        _log = p12,
        _traceback = p14,
        _levelName = p13,
        _modifiers = {
            Throw = false
        },
        _key = p15
    }, t4))
end

function t4._shouldLog(p17, p18) -- line: 288
    -- upvalues: clock (copy)
    if p17._modifiers.Every and not p18:_checkAndIncrementCount(p17._modifiers.Every) then
        return false
    end

    return not not (not p17._modifiers.AtMostEvery or p18:_checkLastTimestamp(clock(), p17._modifiers.AtMostEvery))
end

function t4.Every(p19, p20) -- line: 301
    p19._modifiers.Every = p20

    return p19
end

function t4.AtMostEvery(p21, p22, p23) -- line: 306
    -- upvalues: ToSeconds (copy)
    p21._modifiers.AtMostEvery = ToSeconds(p22, p23)

    return p21
end

function t4.Throw(p24) -- line: 311
    p24._modifiers.Throw = true

    return p24
end

function t4.Log(p25, p26, ...) -- line: 316
    -- upvalues: v2 (copy), HttpService (copy), Stringify (copy), TryCall (copy), clock (copy), t1 (copy), v6 (ref)
    if p25._muted then
        return
    end

    local v11 = select("#", ...)
    local v12 = if v11 == 1 then select(1, ...) elseif v11 > 1 then { ... } else nil
    local v13 = p25._log:_getLogStats(p25._key)

    if not p25:_shouldLog(v13) then
        return
    end

    local v14

    if type(p26) == "function" then
        local v15

        v14, v15 = p26()

        if v15 ~= nil then
            v12 = v15
        end
    elseif type(p26) == "table" then
        local v16, v17 = TryCall(HttpService.JSONEncode, HttpService, p26)

        v14 = v16 and v17 or p26
    else
        v14 = p26
    end

    local v18 = false

    if v2 then
    elseif p25._log._settings.EnableStringRead and type(v14) == "string" and type(v12) == "table" then
        local v19, v20 = TryCall(Stringify.Pretty, v12)

        if v19 and v20 then
            v14 ..= " " .. v20
            v18 = true
        end
    end

    v13:_setTimestamp(clock())

    local v21 = ("%s: [%s] %s"):format(p25._log._name, p25._levelName, v14)
    local v22 = t1[p25._levelName]

    v6(v22, ("%s: %s"):format(p25._log._name, v14), p25._traceback, v12)

    if p25._modifiers.Throw then
        local _error = error
        local v23, v24

        if not v12 or v18 then
            v24 = false
        else
            local v25 = " " .. HttpService:JSONEncode(v12)

            if v25 then
                v23 = v25
                v24 = true
            else
                v24 = false
            end
        end

        if not v24 then
            v23 = ""
        end

        _error(v21 .. v23, 4)
    elseif v22 < t1.Warning then
        print(v21, not v18 and v12 or "")
    else
        warn(v21, not v18 and v12 or "")
    end
end

function t4.SepLog(p27, p28, p29) -- line: 388
    -- upvalues: t (copy)
    t.strict(t.optional(t.string))(p29)
    t.strict(t.optional(t.number))(p28)
    p27:Log(string.rep(p29 or "-", p28 or 100))
end

function t4.Wrap(p30) -- line: 395
    return function(...) -- line: 396
        -- upvalues: p30 (copy)
        p30:Log(...)
    end
end

function t4.Assert(p31, p32, ...) -- line: 399
    if p32 then
        p31:Throw():Log(...)
    end
end

local t6 = {}

t6.__index = t6
setmetatable(t6, t4)

function t6.new(...) -- line: 409
    -- upvalues: t4 (copy), t6 (copy)
    return (setmetatable(t4.new(...), t6))
end

function t6.Log(_) -- line: 414
end

local t7 = {}

t7.__index = t7

function t7.new() -- line: 429
    -- upvalues: t7 (copy)
    local self = setmetatable({}, t7)

    self._invocationCount = 0
    self._lastTimestamp = 0

    return self
end

function t7:_checkAndIncrementCount(p35) -- line: 436
    local v28 = self._invocationCount % p35 == 0

    self._invocationCount += 1

    return v28
end

function t7:_checkLastTimestamp(p37, p38) -- line: 442
    return p38 <= p37 - self._lastTimestamp
end

function t7:_setTimestamp(p40) -- line: 446
    self._lastTimestamp = p40
end

local t9 = {}

t9.__index = t9
t9.TimeUnit = t2
t9.Level = t1
t9.LevelNames = {}

for v29, v30 in pairs(t9.Level) do
    t9.LevelNames[v30] = v29
end

function t9.new(p41) -- line: 648
    -- upvalues: t (copy), t9 (copy)
    t.strict(t.optional(t.table))(p41)

    local self = setmetatable({}, t9)

    self._name = debug.info(2, "s"):match("([^%.]-)$")
    self._muted = false
    self._stats = {}
    self._settings = p41 or {}

    return self
end

function t9.getLevelFromName(p42) -- line: 660
    -- upvalues: t (copy), t9 (copy)
    t.strict(t.string)(p42)

    return assert(t9.Level[p42], (("Invalid log level: \"%*\""):format(p42)))
end

function t9.isWithinLevel(p43) -- line: 665
    -- upvalues: v4 (ref), t9 (copy)
    return t9.getLevelFromName(p43) >= v4, v4
end

function t9:_getLogStats(p45) -- line: 670
    -- upvalues: t7 (copy)
    local v34 = self._stats[p45]

    if not v34 then
        v34 = t7.new()
        self._stats[p45] = v34
    end

    return v34
end

function t9:_at(p47) -- line: 679
    -- upvalues: v4 (ref), t4 (copy), t6 (copy), t9 (copy)
    local lf, lf2 = debug.info(3, "lf")
    local v35 = debug.traceback("Log", 3)
    local v36 = tostring(lf) .. tostring(lf2)

    if p47 < (self._limitUnder or v4) then
        return (t6.new(self, t9.LevelNames[p47], v35, v36))
    end

    return t4.new(self, t9.LevelNames[p47], v35, v36, self._muted)
end

function t9:Mute() -- line: 691
    self._muted = true

    return self
end

function t9:UnMute() -- line: 696
    self._muted = false

    return self
end

function t9:LimitUnderLevel(p51) -- line: 701
    -- upvalues: t9 (copy)
    self._limitUnder = t9.getLevelFromName(p51)

    return self
end

function t9:At(p53) -- line: 710
    return self:_at(p53)
end

function t9:AtTrace() -- line: 716
    -- upvalues: t9 (copy)
    return self:_at(t9.Level.Trace)
end

function t9:AtDebug() -- line: 722
    -- upvalues: t9 (copy)
    return self:_at(t9.Level.Debug)
end

function t9:AtInfo() -- line: 728
    -- upvalues: t9 (copy)
    return self:_at(t9.Level.Info)
end

function t9:AtWarning() -- line: 734
    -- upvalues: t9 (copy)
    return self:_at(t9.Level.Warning)
end

function t9:AtError() -- line: 740
    -- upvalues: t9 (copy)
    return self:_at(t9.Level.Error)
end

function t9:AtFatal() -- line: 746
    -- upvalues: t9 (copy)
    return self:_at(t9.Level.Fatal)
end

function t9:Assert(p61, ...) -- line: 755
    -- upvalues: t9 (copy)
    if not p61 then
        self:_at(t9.Level.Error):Throw():Log(...)
    end
end

function t9.Destroy(_) -- line: 761
end

function t9:__tostring() -- line: 763
    return ("Log<%s>"):format(self._name)
end

local function SetLogLevel(p64) -- line: 767
    -- upvalues: v1 (copy), v2 (copy), v4 (ref), t9 (copy)
    local v37 = p64:lower()

    for v38, v39 in pairs(t9.Level) do
        if v38:lower() == v37 then
            if v2 then
                local v40 = if v1 then "LogLevel" else "LogLevelClient"
                local v41 = v37:sub(1, 1):upper() .. v37:sub(2)

                if tostring(workspace:GetAttribute(v40) or "") ~= v41 then
                    workspace:SetAttribute(v40, v41)
                end
            end

            v4 = v39

            return
        end
    end

    error("Unknown log level: " .. tostring(p64))
end

local v43 = type(v3)

assert(v43 == "table" or v43 == "string", "LogConfig must return a table or a string; got " .. v43)

if v43 == "string" then
    SetLogLevel(v3)
elseif v2 and v3.Studio then
    local v46 = type(v3.Studio)

    assert(v46 == "table" or v46 == "string", "LogConfig.Studio must be a table or a string; got " .. v46)

    if v46 == "string" then
        SetLogLevel(v3.Studio)
    elseif v1 then
        local Server = v3.Studio.Server

        assert(type(Server) == "string", "LogConfig.Studio.Server must be a string; got " .. type(Server))
        SetLogLevel(Server)
    else
        local Client = v3.Studio.Client

        assert(type(Client) == "string", "LogConfig.Studio.Client must be a string; got " .. type(Client))
        SetLogLevel(Client)
    end
else
    local n1 = 0
    local v54 = false
    local v55
    local v53

    for v56, v57 in pairs(v3) do
        if v56 ~= "Studio" then
            if type(v57) == "string" then
                v53 = v57
                n1 += 1
            elseif type(v57) == "table" then
                local PlaceId = v57.PlaceId
                local v58, v59

                if type(PlaceId) == "number" then
                    v59 = v57.PlaceId == game.PlaceId
                    v58 = false
                elseif type(v57.PlaceIds) == "table" then
                    v59 = table.find(v57.PlaceIds, game.PlaceId) ~= nil
                    v58 = false
                elseif type(v57.GameId) == "number" then
                    v59 = v57.GameId == game.GameId
                    v58 = false
                elseif type(v57.GameIds) == "table" then
                    v59 = table.find(v57.GameIds, game.GameId) ~= nil
                    v58 = false
                else
                    v59 = true
                    v58 = true
                end

                if not v58 then
                    assert(not v54, ("More than one LogConfig mapping matched (%s and %s)"):format(v55 or "", v56 or ""))
                end

                if v59 then
                    v55 = v56

                    if v1 then
                        local Server = v57.Server

                        assert(type(Server) == "string", ("LogConfig.%s.Server must be a string; got %s"):format(v56, (type(Server))))
                        SetLogLevel(Server)
                    else
                        local Client = v57.Client

                        assert(type(Client) == "string", ("LogConfig.%s.Client must be a string; got %s"):format(v56, (type(Client))))
                        SetLogLevel(Client)
                    end

                    v54 = true
                end
            else
                warn(("LogConfig.%s must be a table or a string; got %s"):format(v56, (typeof(v57))))
            end
        end
    end

    if n1 > 1 then
        warn("Ambiguous default logging level")
    end

    if v53 and not v54 then
        SetLogLevel(v53)
    end
end

assert(type(v4) == "number", "LogLevel failed to be determined")

if v2 then
    local v69 = if v1 then "LogLevel" else "LogLevelClient"

    workspace:GetAttributeChangedSignal(v69):Connect(function() -- line: 895
        -- upvalues: SetLogLevel (copy), v69 (copy)
        SetLogLevel(workspace:GetAttribute(v69))
    end)
end

return t9
