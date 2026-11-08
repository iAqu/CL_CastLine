-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")

local function SafeGet(p1, p2, p3) -- line: 34
    local function v1() -- line: 35
        -- upvalues: p1 (copy), p2 (copy)
        return p1[p2]
    end

    local ok, result = pcall(v1)

    if ok then
        return result
    end

    return p3
end

local function IsWindows() -- line: 41
    -- upvalues: GuiService (copy)
    local v2 = "IsWindows"

    local function v3() -- line: 35
        -- upvalues: v2 (copy), GuiService (copy)
        return GuiService[v2]
    end

    local ok, result = pcall(v3)

    if ok then
        return result
    end

    return false
end

local function GetCharacterSize(p4) -- line: 45
    -- upvalues: TextService (copy)
    return TextService:GetTextSize(utf8.char(p4), 16, Enum.Font.SourceSans, Vector2.new(1000, 1000))
end

local TextSize = TextService:GetTextSize(utf8.char(65535), 16, Enum.Font.SourceSans, Vector2.new(1000, 1000))

local function IsValidCharacter(p5) -- line: 51
    -- upvalues: TextService (copy), TextSize (copy)
    return TextService:GetTextSize(utf8.char(p5), 16, Enum.Font.SourceSans, Vector2.new(1000, 1000)) ~= TextSize
end

local function GetPlatform() -- line: 57
    -- upvalues: GuiService (copy), TextService (copy), UserInputService (copy), VRService (copy), TextSize (copy)
    local v4 = tostring(version())
    local v5 = ""

    local function v6() -- line: 60
        -- upvalues: v5 (ref), UserInputService (copy)
        v5 = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonSelect):lower()
    end

    pcall(v6)

    local v7 = v4:find("^0%.") ~= nil
    local v8 = GuiService:IsTenFootInterface() and v4:find("^1%.") ~= nil
    local v9 = v4:find("^2%.") ~= nil
    local v10 = UserInputService.VREnabled and VRService.VREnabled
    local v11 = "IsWindows"

    local function v12() -- line: 35
        -- upvalues: v11 (copy), GuiService (copy)
        return GuiService[v11]
    end

    local ok, result = pcall(v12)

    if not ok then
        result = false
    end

    local v13 = TextService:GetTextSize(utf8.char(63743), 16, Enum.Font.SourceSans, Vector2.new(1000, 1000)) ~= TextSize

    if v8 then
        local v14 = v5:find("xbox") ~= nil
        local v15 = v5:find("ps4") ~= nil
        local v16 = v5:find("ps5") ~= nil

        if v14 or result then
            return Enum.Platform.XBoxOne
        end

        if v15 then
            return Enum.Platform.PS4
        end

        if v16 then
            return Enum.Platform.PS5
        end
    else
        if v9 then
            if result then
                return Enum.Platform.UWP
            end

            if v10 then
                return Enum.Platform.MetaOS
            end

            if v13 then
                return Enum.Platform.IOS
            end

            if UserInputService.TouchEnabled then
                return Enum.Platform.Android
            end

            return Enum.Platform.Linux
        end

        if v7 then
            if result then
                return Enum.Platform.Windows
            end

            return Enum.Platform.OSX
        end
    end

    return Enum.Platform.None
end

local function Get() -- line: 106
    -- upvalues: GuiService (copy), UserInputService (copy)
    if UserInputService.VREnabled then
        return Enum.DeviceForm.VR
    end

    if GuiService:IsTenFootInterface() then
        return Enum.DeviceForm.Console
    end

    local v17 = "IsWindows"

    local function v18() -- line: 35
        -- upvalues: v17 (copy), GuiService (copy)
        return GuiService[v17]
    end

    local ok, result = pcall(v18)

    if ok and result then
        return Enum.DeviceForm.Desktop
    end

    if UserInputService.GyroscopeEnabled or UserInputService.AccelerometerEnabled then
        return Enum.DeviceForm.Phone
    end

    if UserInputService.MouseEnabled then
        return Enum.DeviceForm.Desktop
    end

    if UserInputService.TouchEnabled then
        return Enum.DeviceForm.Phone
    end

    return if UserInputService.GamepadEnabled then Enum.DeviceForm.Console else nil
end

return table.freeze({
    DetectorVersion = "heuristic_v1",
    Get = Get,
    GetPlatform = GetPlatform
})
