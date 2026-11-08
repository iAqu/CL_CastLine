-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TokenBucket = require(ReplicatedStorage.Shared.Modules.TokenBucket)
local v1 = require(ReplicatedStorage.Packages.Log).new():AtWarning():Wrap()
local t = require(ReplicatedStorage.Packages.t)

local function callerName() -- line: 23
    for i = 2, 8 do
        local s = debug.info(i, "s")

        if s == nil then
            break
        end

        local v2 = string.match(s, "([^%.]-)$") or ""

        if v2 ~= "" and v2 ~= "RateLimiter" then
            return v2
        end
    end

    return ""
end

local t1

local function watch(p1, p2) -- line: 76
    if p1.watched[p2] then
        return
    end

    p1.watched[p2] = true
    p2.Destroying:Connect(function() -- line: 79
        -- upvalues: p1 (copy), p2 (copy)
        p1:Reset(p2)
        p1.watched[p2] = nil
    end)
end

local function requireBucket(p3, p4) -- line: 86
    -- upvalues: t (copy)
    t.strict(t.optional(t.string))(p4)

    if not p4 then
        return
    end

    assert(p3.buckets[p4] and p4 ~= "Global", string.format("no endpoint named '%s' is configured on this limiter", p4))
end

local function charge(p5, p6, p7) -- line: 94
    -- upvalues: TokenBucket (copy)
    if TokenBucket.Spend(p7, p6) then
        return true
    end

    if p7.causesBan then
        p5:ApplyBan(p6)
    end

    return false
end

local t2 = {
    ApplyBan = function(p8, p9, p10) -- ApplyBan | line: 114
        -- upvalues: v1 (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p9)
        t.strict(t.optional(t.number))(p10)

        local v4 = p8.bannedUntil[p9]
        local v5 = workspace:GetServerTimeNow() + (p10 or p8.banSeconds)
        local bannedUntil = p8.bannedUntil

        if v4 ~= nil then
            v5 = math.max(v5, v4)
        end

        bannedUntil[p9] = v5

        if p8.warns and v4 == nil then
            v1(string.format(p8.logFormat, "BAN", p9.Name, p9.UserId, "Banned!"))
        end
    end,
    RemoveBan = function(p11, p12) -- RemoveBan | line: 128
        -- upvalues: v1 (copy), t (copy)
        t.strict(t.instanceIsA("Player"))(p12)

        if p11.bannedUntil[p12] then
            p11.bannedUntil[p12] = nil

            return true
        end

        return false, v1((string.format(p11.logFormat, "BAN", p12.Name, p12.UserId, "lifted a ban that was never applied")))
    end,
    IsBanned = function(p13, p14) -- IsBanned | line: 146
        -- upvalues: t (copy)
        t.strict(t.instanceIsA("Player"))(p14)

        local v7 = p13.bannedUntil[p14]
        local v8 = v7 ~= nil and v7 < workspace:GetServerTimeNow()

        if v8 then
            p13.bannedUntil[p14] = nil
        end

        return v7 ~= nil and not v8
    end,
    Reset = function(p15, p16) -- Reset | line: 159
        -- upvalues: TokenBucket (copy)
        local v9 = p16 and {
            p16
        } or game.Players:GetPlayers()

        for _, v10 in ipairs(v9) do
            p15.bannedUntil[v10] = nil

            for _, v11 in pairs(p15.buckets) do
                TokenBucket.Forget(v11, v10)
            end
        end
    end,
    Limit = function(p17, p18, p19) -- Limit | line: 170
        -- upvalues: t (copy), t1 (ref), charge (copy)
        t.strict(t.instanceIsA("Player"))(p18)
        t.strict(t.optional(t.string))(p19)

        if p19 then
            assert(p17.buckets[p19] and p19 ~= "Global", string.format("no endpoint named '%s' is configured on this limiter", p19))
        end

        if not p17.watched[p18] then
            p17.watched[p18] = true
            p18.Destroying:Connect(function() -- line: 79
                -- upvalues: p17 (copy), p18 (copy)
                p17:Reset(p18)
                p17.watched[p18] = nil
            end)
        end

        local v13 = p19 and p17.buckets[p19]
        local Global = p17.buckets.Global
        local v14 = if p17.retired then t1.Message.GARBAGE_COLLECTED
            elseif p17:IsBanned(p18) then t1.Message.TEMP_BANNED
            elseif v13 and not charge(p17, p18, v13) then t1.Message.STANDARD_ERROR
            elseif Global and not charge(p17, p18, Global) then t1.Message.STANDARD_ERROR
            else nil

        if v14 then
            return false, v14
        end

        return true
    end
}

t1 = {
    DefaultBanLength = 60,
    DefaultWarn = true,
    Message = {
        STANDARD_ERROR = "You're doing that too fast!",
        TEMP_BANNED = "You're on cooldown. Please try again later.",
        GARBAGE_COLLECTED = "Endpoint not permitted."
    },
    LogTemplates = {
        BAN = "[RATE LIMIT][%*] (%*): %*, %*: (%*)"
    },
    new = function(p20) -- new | line: 209
        -- upvalues: TokenBucket (copy), t (copy), callerName (copy), t1 (ref), t2 (copy)
        t.strict(t.table)(p20)
        t.strict(t.optional(t.number))(p20.BanLength)
        assert(p20.Global or p20.Endpoints, "a limiter needs at least one endpoint")

        local t4 = {}

        if p20.Global then
            t4.Global = TokenBucket.Build("Global", p20.Global)
        end

        for v16, v17 in pairs(p20.Endpoints or {}) do
            assert(v16 ~= "Global", "the global endpoint is configured through Global")
            t4[v16] = TokenBucket.Build(v16, v17)
        end

        assert(next(t4) ~= nil, "a limiter needs at least one endpoint")

        local v20 = p20.Id or callerName()

        return (setmetatable({
            retired = false,
            label = v20,
            logFormat = string.format(t1.LogTemplates.BAN, "%*", v20, "%*", "%*", "%*"),
            warns = if p20.Warn == nil then t1.DefaultWarn else p20.Warn,
            buckets = t4,
            bannedUntil = {},
            banSeconds = p20.BanLength or t1.DefaultBanLength,
            watched = {}
        }, {
            __index = t2
        }))
    end,
    AllowOnce = function() -- AllowOnce | line: 239
        -- upvalues: t1 (ref)
        return t1.new({
            BanLength = 1e999,
            Global = {
                MaximumTokens = 1
            }
        })
    end,
    AllowPerSecond = function(p21, p22) -- AllowPerSecond | line: 243
        -- upvalues: t (copy), t1 (ref)
        assert(p21 > 0, "a per-second allowance needs a positive rate")
        t.strict(t.optional(t.number))(p22)

        local t7 = {
            Tokens = 1,
            Interval = 1 / p21
        }

        return t1.new({
            BanLength = t1.DefaultBanLength,
            Global = {
                Ban = false,
                MaximumTokens = p22 or 1,
                Refresh = { t7 }
            }
        })
    end
}

return t1
