-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Signal = require(ReplicatedStorage.Packages.Signal)

local function asset(p1) -- line: 14
    return (("rbxassetid://%*"):format(p1))
end

local t1 = {
    microsoft = {
        [Enum.KeyCode.ButtonA] = "rbxassetid://113824701684322",
        [Enum.KeyCode.ButtonB] = "rbxassetid://107100143818564",
        [Enum.KeyCode.ButtonX] = "rbxassetid://121994310218398",
        [Enum.KeyCode.ButtonY] = "rbxassetid://118121490246715",
        [Enum.KeyCode.ButtonL1] = "rbxassetid://128016621986260",
        [Enum.KeyCode.ButtonL2] = "rbxassetid://121095629027146",
        [Enum.KeyCode.ButtonL3] = "rbxassetid://98426369439432",
        [Enum.KeyCode.ButtonR1] = "rbxassetid://86739128961101",
        [Enum.KeyCode.ButtonR2] = "rbxassetid://121138812911138",
        [Enum.KeyCode.ButtonR3] = "rbxassetid://108823668376359",
        [Enum.KeyCode.ButtonSelect] = "rbxassetid://73640706748399",
        [Enum.KeyCode.ButtonStart] = "rbxassetid://121407964275535",
        [Enum.KeyCode.DPadDown] = "rbxassetid://134006970980101",
        [Enum.KeyCode.DPadLeft] = "rbxassetid://113523064631322",
        [Enum.KeyCode.DPadRight] = "rbxassetid://125621109562134",
        [Enum.KeyCode.DPadUp] = "rbxassetid://110656716055777",
        [Enum.KeyCode.Thumbstick1] = "rbxassetid://86234104961357",
        [Enum.KeyCode.Thumbstick2] = "rbxassetid://92731666763608"
    },
    sony = {
        [Enum.KeyCode.ButtonA] = "rbxassetid://140688515494419",
        [Enum.KeyCode.ButtonB] = "rbxassetid://89979188218128",
        [Enum.KeyCode.ButtonX] = "rbxassetid://105740811198422",
        [Enum.KeyCode.ButtonY] = "rbxassetid://102844478766253",
        [Enum.KeyCode.ButtonL1] = "rbxassetid://101741164721625",
        [Enum.KeyCode.ButtonL2] = "rbxassetid://92051888341203",
        [Enum.KeyCode.ButtonL3] = "rbxassetid://71736763291675",
        [Enum.KeyCode.ButtonR1] = "rbxassetid://108359563054786",
        [Enum.KeyCode.ButtonR2] = "rbxassetid://95486021989419",
        [Enum.KeyCode.ButtonR3] = "rbxassetid://100766112822921",
        [Enum.KeyCode.ButtonStart] = "rbxassetid://115132567456286",
        [Enum.KeyCode.DPadDown] = "rbxassetid://101700700938948",
        [Enum.KeyCode.DPadLeft] = "rbxassetid://114773739810891",
        [Enum.KeyCode.DPadRight] = "rbxassetid://110011411664004",
        [Enum.KeyCode.DPadUp] = "rbxassetid://77095582918408",
        [Enum.KeyCode.Thumbstick1] = "rbxassetid://87994926804700",
        [Enum.KeyCode.Thumbstick2] = "rbxassetid://123691072001381"
    }
}
local t2 = {
    Changed = Signal.new()
}
local t3 = {}
local t4 = {}
local v1

local function relabelled(p2) -- line: 75
    -- upvalues: UserInputService (copy)
    local GetStringForKeyCode = UserInputService.GetStringForKeyCode
    local ok, result = pcall(GetStringForKeyCode, UserInputService, p2)

    if ok then
        ok = typeof(result) == "string" and result ~= "" and result ~= p2.Name
    end

    return ok
end

local function vendor() -- line: 80
    -- upvalues: UserInputService (copy), v1 (ref)
    local v2 = v1
    local v3

    if v2 ~= nil then
        v3 = v2

        return v3
    end

    local ButtonY = Enum.KeyCode.ButtonY
    local GetStringForKeyCode = UserInputService.GetStringForKeyCode
    local ok, result = pcall(GetStringForKeyCode, UserInputService, ButtonY)

    if ok then
        ok = typeof(result) == "string" and result ~= "" and result ~= ButtonY.Name
    end

    v3 = ok and "sony" or "microsoft"
    v1 = v3

    return v3
end

local function verify(p3) -- line: 89
    -- upvalues: ContentProvider (copy), t2 (copy), t3 (copy), t4 (copy)
    t4[p3] = true
    task.spawn(function() -- line: 91
        -- upvalues: p3 (copy), ContentProvider (copy), t2 (copy), t3 (copy), t4 (copy)
        local v4 = false

        local function v5() -- line: 93
            -- upvalues: v4 (ref), p3 (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync({
                p3
            }, function(_, p5) -- line: 94
                -- upvalues: v4 (ref)
                v4 = p5 == Enum.AssetFetchStatus.Success
            end)
        end

        pcall(v5)
        t4[p3] = nil
        t3[p3] = v4

        if not v4 then
            warn((("gamepad glyph %* did not load; using the engine glyph instead"):format(p3)))
            t2.Changed:Fire()
        end
    end)
end

local function bespoke(p6) -- line: 107
    -- upvalues: ContentProvider (copy), UserInputService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), v1 (ref)
    local v6 = v1
    local v7

    if v6 ~= nil then
        v7 = v6
    else
        local ButtonY = Enum.KeyCode.ButtonY
        local GetStringForKeyCode = UserInputService.GetStringForKeyCode
        local ok, result = pcall(GetStringForKeyCode, UserInputService, ButtonY)

        if ok then
            ok = typeof(result) == "string" and result ~= "" and result ~= ButtonY.Name
        end

        v7 = ok and "sony" or "microsoft"
        v1 = v7
    end

    local v8 = t1[v7][p6]

    if v8 == nil then
        return nil
    end

    if t3[v8] == nil and t4[v8] == nil then
        t4[v8] = true
        task.spawn(function() -- line: 91
            -- upvalues: v8 (copy), ContentProvider (copy), t2 (copy), t3 (copy), t4 (copy)
            local v9 = false

            local function v10() -- line: 93
                -- upvalues: v8 (copy), ContentProvider (copy), v9 (ref)
                ContentProvider:PreloadAsync({
                    v8
                }, function(_, p8) -- line: 94
                    -- upvalues: v9 (ref)
                    v9 = p8 == Enum.AssetFetchStatus.Success
                end)
            end

            pcall(v10)
            t4[v8] = nil
            t3[v8] = v9

            if not v9 then
                warn((("gamepad glyph %* did not load; using the engine glyph instead"):format(v8)))
                t2.Changed:Fire()
            end
        end)
    end

    return if t3[v8] ~= false then v8 else nil
end

local function engineGlyph(p9) -- line: 118
    -- upvalues: UserInputService (copy)
    local GetImageForKeyCode = UserInputService.GetImageForKeyCode
    local ok, result = pcall(GetImageForKeyCode, UserInputService, p9)

    return if ok and typeof(result) == "string" and result ~= "" then result else nil
end

local function announce() -- line: 123
    -- upvalues: t2 (copy), v1 (ref)
    v1 = nil
    t2.Changed:Fire()
end

function t2.Vendor() -- line: 128
    -- upvalues: UserInputService (copy), v1 (ref)
    local v11 = v1
    local v12

    if v11 ~= nil then
        v12 = v11

        return v12
    end

    local ButtonY = Enum.KeyCode.ButtonY
    local GetStringForKeyCode = UserInputService.GetStringForKeyCode
    local ok, result = pcall(GetStringForKeyCode, UserInputService, ButtonY)

    if ok then
        ok = typeof(result) == "string" and result ~= "" and result ~= ButtonY.Name
    end

    v12 = ok and "sony" or "microsoft"
    v1 = v12

    return v12
end

function t2.Image(p10) -- line: 132
    -- upvalues: ContentProvider (copy), UserInputService (copy), t1 (copy), t2 (copy), t3 (copy), t4 (copy), v1 (ref)
    local v13 = v1
    local v14

    if v13 ~= nil then
        v14 = v13
    else
        local ButtonY = Enum.KeyCode.ButtonY
        local GetStringForKeyCode = UserInputService.GetStringForKeyCode
        local ok, result = pcall(GetStringForKeyCode, UserInputService, ButtonY)

        if ok then
            ok = typeof(result) == "string" and result ~= "" and result ~= ButtonY.Name
        end

        v14 = ok and "sony" or "microsoft"
        v1 = v14
    end

    local v15 = t1[v14][p10]
    local v16 = true

    if v15 ~= nil then
        if t3[v15] == nil and t4[v15] == nil then
            t4[v15] = true
            task.spawn(function() -- line: 91
                -- upvalues: v15 (copy), ContentProvider (copy), t2 (copy), t3 (copy), t4 (copy)
                local v17 = false

                local function v18() -- line: 93
                    -- upvalues: v15 (copy), ContentProvider (copy), v17 (ref)
                    ContentProvider:PreloadAsync({
                        v15
                    }, function(_, p12) -- line: 94
                        -- upvalues: v17 (ref)
                        v17 = p12 == Enum.AssetFetchStatus.Success
                    end)
                end

                pcall(v18)
                t4[v15] = nil
                t3[v15] = v17

                if not v17 then
                    warn((("gamepad glyph %* did not load; using the engine glyph instead"):format(v15)))
                    t2.Changed:Fire()
                end
            end)
        end

        v16 = false
    end

    local v19 = if v16 or t3[v15] == false then nil else v15

    if not v19 then
        local GetImageForKeyCode = UserInputService.GetImageForKeyCode
        local ok, result = pcall(GetImageForKeyCode, UserInputService, p10)

        if ok and typeof(result) == "string" and result ~= "" then
            return result
        end

        v19 = nil
    end

    return v19
end

UserInputService.GamepadConnected:Connect(announce)
UserInputService.GamepadDisconnected:Connect(announce)
UserInputService.LastInputTypeChanged:Connect(function(p13) -- line: 138
    -- upvalues: t2 (copy), v1 (ref)
    if string.find(p13.Name, "Gamepad", 1, true) == 1 then
        v1 = nil
        t2.Changed:Fire()
    end
end)

return table.freeze(t2)
