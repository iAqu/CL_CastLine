-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StaffTagFlags = require(ReplicatedStorage.Shared.Flags.StaffTagFlags)
local t1 = {
    "Assets",
    "Billboards",
    "StaffTag"
}
local t2 = {
    Owner = "OwnerLabel",
    Admin = "AdminLabel",
    Developer = "DeveloperLabel"
}
local t3 = {
    Owner = "OwnerChatLabel",
    Admin = "AdminChatLabel",
    Developer = "DeveloperChatLabel"
}
local t4 = {
    Owner = "OwnerColor",
    Admin = "AdminColor",
    Developer = "DeveloperColor"
}
local t5 = {
    Owner = "OwnerLightColor",
    Admin = "AdminLightColor",
    Developer = "DeveloperLightColor"
}
local t6 = {
    Owner = "OWNER",
    Admin = "ADMIN",
    Developer = "DEVELOPER"
}
local t7 = {
    Owner = "OWNER",
    Admin = "ADMIN",
    Developer = "DEV"
}
local t8 = {
    Owner = Color3.fromRGB(255, 68, 68),
    Admin = Color3.fromRGB(255, 68, 68),
    Developer = Color3.fromRGB(64, 156, 255)
}
local t9 = {
    Owner = Color3.fromRGB(255, 176, 176),
    Admin = Color3.fromRGB(255, 176, 176),
    Developer = Color3.fromRGB(168, 220, 255)
}
local t10 = {
    Changed = StaffTagFlags.Changed
}

local function template() -- line: 80
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local v1 = ReplicatedStorage

    for _, v2 in t1 do
        v1 = if v1 then v1:FindFirstChild(v2) else nil
    end

    return if v1 and v1:IsA("BillboardGui") then v1 else nil
end

local function chatBadge(p1, p2) -- line: 92
    return table.concat({
        "<font color=\"#",
        p2:ToHex(),
        "\">[",
        p1,
        "]</font>"
    })
end

function t10.RoleOf(p3) -- line: 96
    -- upvalues: StaffTagFlags (copy)
    return if StaffTagFlags.Enabled:Get() then StaffTagFlags.Roles:Get()[tostring(p3)] else nil
end

function t10.LabelOf(p4) -- line: 104
    -- upvalues: t2 (copy), t6 (copy), template (copy)
    local v3 = template()
    local v4 = if v3 then v3:GetAttribute(t2[p4]) else nil

    if typeof(v4) ~= "string" or v4 == "" then
        return t6[p4]
    end

    return v4
end

function t10.ChatLabelOf(p5) -- line: 111
    -- upvalues: t3 (copy), t7 (copy), template (copy)
    local v5 = template()
    local v6 = if v5 then v5:GetAttribute(t3[p5]) else nil

    if typeof(v6) ~= "string" or v6 == "" then
        return t7[p5]
    end

    return v6
end

function t10.OverheadLabel(p6) -- line: 118
    -- upvalues: t10 (copy)
    return string.format("[%s]", t10.LabelOf(p6))
end

function t10.ColorOf(p7) -- line: 122
    -- upvalues: t4 (copy), t8 (copy), template (copy)
    local v7 = template()
    local v8 = if v7 then v7:GetAttribute(t4[p7]) else nil

    if typeof(v8) == "Color3" then
        return v8
    end

    return t8[p7]
end

function t10.LightColorOf(p8) -- line: 129
    -- upvalues: t5 (copy), t9 (copy), template (copy)
    local v9 = template()
    local v10 = if v9 then v9:GetAttribute(t5[p8]) else nil

    if typeof(v10) == "Color3" then
        return v10
    end

    return t9[p8]
end

function t10.GradientOf(p9) -- line: 136
    -- upvalues: t10 (copy)
    local v11 = t10.ColorOf(p9)

    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, v11),
        ColorSequenceKeypoint.new(0.5, t10.LightColorOf(p9)),
        ColorSequenceKeypoint.new(1, v11)
    })
end

function t10.ChatTag(p10) -- line: 146
    -- upvalues: t10 (copy), chatBadge (copy)
    local v12 = t10.RoleOf(p10)

    if v12 == nil then
        return nil
    end

    return chatBadge(t10.ChatLabelOf(v12), t10.ColorOf(v12))
end

return t10
