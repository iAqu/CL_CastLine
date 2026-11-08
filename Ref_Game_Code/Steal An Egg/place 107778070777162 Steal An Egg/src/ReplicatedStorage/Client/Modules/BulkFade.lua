-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local v1 = TweenInfo.new(1, Enum.EasingStyle.Cubic)
local t1 = {
    TextLabel = true,
    TextButton = true,
    TextBox = true
}
local t2 = {
    ScrollingFrame = true
}
local t3 = {
    ImageButton = true,
    ImageLabel = true
}

local function GetTransparencyProperties(p1) -- line: 46
    -- upvalues: t1 (copy), t2 (copy), t3 (copy)
    local t4 = {}

    local function v2() -- line: 48
        -- upvalues: p1 (copy), t4 (copy)
        if p1.Transparency and type(p1.Transparency) ~= "userdata" and not p1:IsA("GuiBase") then
            t4.Transparency = p1.Transparency
        end
    end

    pcall(v2)

    local function v3() -- line: 53
        -- upvalues: p1 (copy), t4 (copy)
        if p1.BackgroundTransparency and type(p1.BackgroundTransparency) ~= "userdata" then
            t4.BackgroundTransparency = p1.BackgroundTransparency
        end
    end

    pcall(v3)

    if t3[p1.ClassName] then
        t4.ImageTransparency = p1.ImageTransparency
    end

    if t1[p1.ClassName] then
        t4.TextTransparency = p1.TextTransparency
        t4.TextStrokeTransparency = p1.TextStrokeTransparency
    end

    if t2[p1.ClassName] then
        t4.ScrollBarImageTransparency = p1.ScrollBarImageTransparency
    end

    if t4 == {} then
        return
    end

    return t4
end

local function ReturnPropertiesAtValue(p2, p3) -- line: 80
    for v4, _ in pairs(p2) do
        if p2[v4] == 1 then
            p2[v4] = 1
        else
            p2[v4] = p3
        end
    end

    return p2
end

local t5 = {}

t5.__index = t5

function t5.new(p4, p5, p6) -- line: 104
    -- upvalues: v1 (copy), t5 (copy)
    local self = setmetatable({}, t5)

    self.TweenInfo = p5 or v1
    self.AppearTweens = {}
    self.DisappearTweens = {}
    self.Elements = {}
    self.GoalTransparency = p6 or 1
    self.new = nil
    self:AddObject(if type(p4) == "table" then p4 else {
        p4,
        table.unpack(p4:GetDescendants())
    })

    return self
end

function t5:AddObject(p8) -- line: 127
    -- upvalues: TweenService (copy), GetTransparencyProperties (copy)
    if type(p8) == "table" then
        for _, v6 in ipairs(p8) do
            self:AddObject(v6)
        end
    else
        local v7 = GetTransparencyProperties(p8)

        if v7 then
            table.insert(self.Elements, p8)
            self.AppearTweens[p8] = TweenService:Create(p8, self.TweenInfo, v7)

            local DisappearTweens, TweenInfo, GoalTransparency = self.DisappearTweens, self.TweenInfo, self.GoalTransparency

            for v8, _ in pairs(v7) do
                if v7[v8] == 1 then
                    v7[v8] = 1
                else
                    v7[v8] = GoalTransparency
                end
            end

            DisappearTweens[p8] = TweenService:Create(p8, TweenInfo, v7)
        end
    end
end

function t5:RemoveObject(p10) -- line: 147
    if type(p10) == "table" then
        for _, v9 in ipairs(p10) do
            self:RemoveObject(v9)
        end
    else
        self.AppearTweens[p10] = nil
        self.DisappearTweens[p10] = nil

        local v10 = table.find(self.Elements, p10)

        if v10 then
            table.remove(self.Elements, v10)
        end
    end
end

function t5:FadeOut() -- line: 163
    for _, v11 in pairs(self.DisappearTweens) do
        v11:Play()
    end

    return self.DisappearTweens[self.Elements[1]].Completed
end

function t5:FadeOutInstant() -- line: 170
    -- upvalues: GetTransparencyProperties (copy)
    for _, v12 in self.Elements do
        for v13 in (GetTransparencyProperties(v12)) do
            v12[v13] = 1
        end
    end
end

function t5:FadeIn() -- line: 179
    for _, v14 in pairs(self.AppearTweens) do
        v14:Play()
    end

    return self.AppearTweens[self.Elements[1]].Completed
end

return (setmetatable(t5, {
    __call = t5.new
}))
