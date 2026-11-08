-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function v1() -- line: 42
    return workspace[nil]
end

local function v2() -- line: 44
    return debug.info(2, "f")
end

local _, v3 = xpcall(v1, v2)
local v4 = v3

if type(v3) ~= "function" then
    v4 = function(p1, p2) -- line: 48
        return p1[p2]
    end
end

local self = setmetatable({}, {
    __mode = "k"
})
local t1 = {}

t1.Affected = self

local t4 = {
    BackgroundColor = "BackgroundColor3",
    BorderColor = "BorderColor3",
    TextColor = "TextColor3",
    Font = "FontFace"
}

function t1.Read(p3, p4) -- line: 70
    -- upvalues: v4 (ref), self (copy)
    local v6 = self[p3]

    if not (v6 and v6[p4]) then
        local v7 = v4

        return pcall(v7, p3, p4)
    end

    local GetStyled = p3.GetStyled

    return pcall(GetStyled, p3, p4)
end

function t1.Get(p5, p6) -- line: 79
    -- upvalues: v4 (ref), self (copy)
    local v8 = self[p5]

    if v8 and v8[p6] then
        local GetStyled = p5.GetStyled
        local ok, result = pcall(GetStyled, p5, p6)

        if ok then
            return result
        end
    end

    return v4(p5, p6)
end

local function recordedName(p7, p8, p9) -- line: 92
    -- upvalues: t4 (copy)
    if not p9 then
        return nil
    end

    local v9 = t4[p8]

    if not v9 then
        v9 = if p8 == "Transparency" and p7:IsA("GuiObject") then "BackgroundTransparency" elseif not (#p8 > 7) or string.sub(p8, -7) ~= "Content" then p8 else string.sub(p8, 1, -8)
    end

    return if p9[v9] then v9 else nil
end

local function runnable(p10) -- line: 111
    if string.find(p10, "::", 1, true) then
        return nil
    end

    local t5 = {}
    local t6 = {}
    local v10 = false

    local function endCompound() -- line: 118
        -- upvalues: t5 (copy), t6 (copy), v10 (ref)
        if #t6 > 0 then
            table.insert(t5, table.concat(t6, " "))
        elseif v10 then
            table.insert(t5, "GuiObject")
        end

        table.clear(t6)
        v10 = false
    end

    local v11 = #p10
    local n1 = 1

    while n1 <= v11 do
        local v12 = string.sub(p10, n1, n1)

        if string.match(v12, "%s") then
            n1 += 1
        elseif v12 == ">" then
            if #t6 > 0 then
                table.insert(t5, table.concat(t6, " "))
            elseif v10 then
                table.insert(t5, "GuiObject")
            end

            table.clear(t6)
            v10 = false

            if string.sub(p10, n1 + 1, n1 + 1) == ">" then
                table.insert(t5, ">>")

                local v15 = false

                n1 += 2
            else
                table.insert(t5, ">")

                local v16 = false

                n1 += 1
            end
        elseif v12 == ":" or v12 == "@" then
            n1 += #string.match(p10, "^[%w_%-]*", n1 + 1) + 1
            v10 = true
        elseif v12 == "." or v12 == "#" then
            local v17 = string.match(p10, "^[%w_%-]*", n1 + 1)

            table.insert(t6, v12 .. v17)
            n1 += #v17 + 1
        else
            local v19 = string.match(p10, "^[%w_%-]+", n1)

            if not v19 then
                return p10
            end

            table.insert(t6, v19)
            n1 += #v19
        end
    end

    if #t6 > 0 then
        table.insert(t5, table.concat(t6, " "))
    elseif v10 then
        table.insert(t5, "GuiObject")
    end

    table.clear(t6)
    v10 = false

    return table.concat(t5, " ")
end

local function list(p11) -- line: 165
    local t7 = {}

    for match in string.gmatch(p11, "[^,]+") do
        local v20 = string.match(match, "^%s*(.-)%s*$")

        if v20 ~= "" then
            table.insert(t7, v20)
        end
    end

    return t7
end

local function collect(p12, p13, p14) -- line: 180
    -- upvalues: list (copy), collect (copy)
    for _, child in p12:GetChildren() do
        if child:IsA("StyleRule") then
            local v21 = list(child.Selector)
            local v22 = {}

            if p13 then
                for _, v23 in p13 do
                    for _, v24 in v21 do
                        table.insert(v22, v23 .. " " .. v24)
                    end
                end
            else
                v22 = v21
            end

            table.insert(p14, {
                Rule = child,
                Selectors = v22
            })
            collect(child, v22, p14)
        elseif child:IsA("Folder") then
            collect(child, p13, p14)
        end
    end
end

local function sheetRules(p15, p16, p17) -- line: 203
    -- upvalues: collect (copy), sheetRules (copy)
    if p16[p15] then
        return
    end

    p16[p15] = true

    for _, child in p15:GetChildren() do
        if child:IsA("StyleDerive") then
            local StyleSheet = child.StyleSheet

            if StyleSheet then
                sheetRules(StyleSheet, p16, p17)
            end
        end
    end

    collect(p15, nil, p17)
end

local function linksIn(p18) -- line: 219
    local QueryDescendants = p18.QueryDescendants
    local StyleLink, StyleLink2 = pcall(QueryDescendants, p18, "StyleLink")

    if StyleLink then
        return StyleLink2
    end

    local t9 = {}

    for _, descendant in p18:GetDescendants() do
        if descendant:IsA("StyleLink") then
            table.insert(t9, descendant)
        end
    end

    return t9
end

local function markNames(p19, p20, p21) -- line: 235
    -- upvalues: v4 (ref), self (copy), recordedName (copy)
    local v26 = p21[v4(p19, "ClassName")]
    local v27 = self[p19]
    local v28 = false

    for _, v29 in p20 do
        local v30 = recordedName(p19, v29, v26)

        if v30 then
            if v27 then
                if not v27[v30] then
                    v28 = true
                    v27[v30] = true
                end
            else
                v27 = {}
                self[p19] = v27
                v28 = true
                v27[v30] = true
            end
        end
    end

    return v28
end

function t1.Build(p22, p23) -- line: 260
    -- upvalues: self (copy), runnable (copy), sheetRules (copy), linksIn (copy), markNames (copy)
    table.clear(self)

    local function mark(p24, p25) -- line: 262
        -- upvalues: p23 (copy), markNames (copy)
        markNames(p24, p25, p23)
    end

    for _, v31 in p22 do
        for _, v32 in linksIn(v31) do
            local StyleSheet, Parent = v32.StyleSheet, v32.Parent

            if StyleSheet and Parent then
                local t10 = {}

                sheetRules(StyleSheet, {}, t10)

                local GuiObject = Parent:IsA("GuiObject")

                for _, v33 in t10 do
                    local GetProperties = v33.Rule.GetProperties
                    local Rule = v33.Rule
                    local ok, result = pcall(GetProperties, Rule)

                    if ok and type(result) == "table" and next(result) ~= nil then
                        local t11 = {}

                        for v34 in result do
                            table.insert(t11, v34)
                        end

                        if GuiObject then
                            markNames(Parent, t11, p23)
                        end

                        for _, v35 in v33.Selectors do
                            local v36 = runnable(v35)

                            if v36 and v36 ~= "" then
                                local QueryDescendants = Parent.QueryDescendants
                                local ok, result = pcall(QueryDescendants, Parent, v36)

                                if ok then
                                    for _, v37 in result do
                                        markNames(v37, t11, p23)
                                    end
                                else
                                    warn((("[UGUIReplay] style rule %* not recorded: %*"):format(v33.Rule:GetFullName(), result)))
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function chain(p26) -- line: 317
    local t12 = {}

    for match in string.gmatch(p26 .. ">", "([^>]*)>") do
        local v38 = string.match(match, "^%s*(.-)%s*$")

        if v38 == "" or not string.match(v38, "^[%w_%-#%.]+$") then
            return nil
        end

        local t13 = {}

        for match in string.gmatch(v38, "[#%.]?[%w_%-]+") do
            table.insert(t13, match)
        end

        table.insert(t12, t13)
    end

    return if #t12 > 0 then t12 else nil
end

local function ruleNames(p27) -- line: 333
    local t14 = {}
    local GetProperties = p27.GetProperties
    local ok, result = pcall(GetProperties, p27)

    if ok and type(result) == "table" then
        for v39 in result do
            table.insert(t14, v39)
        end
    end

    return t14
end

function t1.Richer(p28) -- line: 347
    -- upvalues: sheetRules (copy), chain (copy)
    local StyleSheet = p28.StyleSheet

    if not StyleSheet then
        return nil, {}
    end

    local t15 = {}

    sheetRules(StyleSheet, {}, t15)

    local t16 = {}
    local t17 = {}
    local v40 = false
    local n2 = 0

    for _, v41 in t15 do
        table.insert(t16, v41.Rule)

        if string.gsub(v41.Rule.Selector, "%s", "") == "TextLabel>TextLabel" then
            v40 = true
        end

        local t18 = {}

        for _, v42 in v41.Selectors do
            local v43 = chain(v42)

            if v43 then
                table.insert(t18, v43)
                n2 = math.max(n2, #v43 - 1)
            end
        end

        if #t18 > 0 then
            table.insert(t17, {
                Rule = v41.Rule,
                Paths = t18
            })
        end
    end

    if v40 then
        return {
            Rules = t17,
            Depth = n2
        }, t16
    end

    return nil, t16
end

local function compoundMatches(p29, p30) -- line: 381
    -- upvalues: v4 (ref)
    for _, v45 in p30 do
        local v46 = string.sub(v45, 1, 1)

        if v46 == "#" then
            if v4(p29, "Name") ~= string.sub(v45, 2) then
                return false
            end
        elseif v46 == "." then
            if not p29:HasTag((string.sub(v45, 2))) then
                return false
            end
        elseif not p29:IsA(v45) then
            return false
        end
    end

    return true
end

local function pathMatches(p31, p32, p33) -- line: 400
    -- upvalues: v4 (ref), compoundMatches (copy)
    local v47 = #p33
    local v48 = p31

    for i = v47, 2, -1 do
        local v49 = if v48 then compoundMatches(v48, p33[i]) else nil

        if not v48 or not v49 then
            return false
        end

        v48 = v4(v48, "Parent")
    end

    if v48 == p32 then
        return (compoundMatches(p32, p33[1]))
    end

    return false
end

function t1.MarkRicher(p34, p35, p36, p37) -- line: 417
    -- upvalues: self (copy), markNames (copy), ruleNames (copy), pathMatches (copy)
    local v50 = false

    for _, v51 in p36.Rules do
        for _, v52 in v51.Paths do
            if pathMatches(p34, p35, v52) then
                if not self[p34] then
                    v50 = true
                    self[p34] = {}
                end

                if markNames(p34, ruleNames(v51.Rule), p37) then
                    v50 = true
                end

                break
            end
        end
    end

    return v50
end

function t1.Clear() -- line: 441
    -- upvalues: self (copy)
    table.clear(self)
end

return table.freeze(t1)
