-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    Rows = {
        {
            name = "Default",
            icon = "rbxassetid://120140207312365",
            color = Color3.fromRGB(150, 140, 125)
        },
        {
            name = "Caveman",
            icon = "rbxassetid://121804873214408",
            color = Color3.fromRGB(170, 140, 100)
        },
        {
            name = "Jungle",
            icon = "rbxassetid://107493955949997",
            color = Color3.fromRGB(60, 170, 60)
        },
        {
            name = "Royal",
            icon = "rbxassetid://123597299780822",
            color = Color3.fromRGB(200, 30, 50)
        },
        {
            name = "Lava",
            icon = "rbxassetid://109707007635702",
            color = Color3.fromRGB(255, 90, 20)
        },
        {
            name = "Ice",
            icon = "rbxassetid://120220588074158",
            color = Color3.fromRGB(120, 200, 255)
        },
        {
            name = "Candyland",
            icon = "rbxassetid://105244029956359",
            color = Color3.fromRGB(255, 120, 200)
        },
        {
            name = "Golden",
            icon = "rbxassetid://75411118823300",
            color = Color3.fromRGB(255, 200, 60)
        },
        {
            name = "Demon",
            icon = "rbxassetid://88768611728987",
            color = Color3.fromRGB(200, 20, 40)
        },
        {
            name = "Angelic",
            icon = "rbxassetid://124580629144745",
            color = Color3.fromRGB(255, 240, 190)
        },
        {
            name = "Virus",
            icon = "rbxassetid://82803153162617",
            color = Color3.fromRGB(40, 255, 90)
        },
        {
            name = "Shadow",
            icon = "rbxassetid://84231489075924",
            color = Color3.fromRGB(60, 56, 70)
        },
        {
            name = "Rainbow",
            icon = "rbxassetid://79121430385949",
            color = Color3.fromRGB(250, 145, 35)
        },
        {
            name = "Cloud",
            icon = "rbxassetid://101207334970538",
            color = Color3.fromRGB(225, 238, 255)
        },
        {
            name = "Atlantis",
            icon = "rbxassetid://85776240302050",
            color = Color3.fromRGB(55, 140, 135)
        },
        {
            name = "Amber",
            icon = "rbxassetid://108452644763412",
            color = Color3.fromRGB(255, 140, 20)
        },
        {
            name = "Meteor",
            icon = "rbxassetid://96074012934860",
            color = Color3.fromRGB(160, 100, 255)
        },
        {
            name = "Time Machine",
            icon = "rbxassetid://72593376234178",
            color = Color3.fromRGB(70, 205, 255)
        }
    }
}

function t1.Icon(p1) -- line: 34
    -- upvalues: t1 (copy)
    return (t1.Rows[p1] or t1.Rows[#t1.Rows]).icon
end

function t1.Color(p2) -- line: 39
    -- upvalues: t1 (copy)
    return (t1.Rows[p2] or t1.Rows[#t1.Rows]).color
end

function t1.Name(p3) -- line: 44
    -- upvalues: t1 (copy)
    return (t1.Rows[p3] or t1.Rows[#t1.Rows]).name
end

return t1
