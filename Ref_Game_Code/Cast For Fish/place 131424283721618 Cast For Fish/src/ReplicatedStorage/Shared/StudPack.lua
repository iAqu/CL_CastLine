-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

t1.__index = t1
t1.ATTRIBUTE = "StudTile"
t1.PREFIX = "Stud_"
t1.Z_INDEX = 2
t1.FACES = Enum.NormalId:GetEnumItems()

function t1.new(p1) -- line: 9
    -- upvalues: t1 (copy)
    local self = setmetatable({}, t1)

    self.Texture = p1

    return self
end

function t1:IsStud(p3) -- line: 15
    return p3:IsA("Texture") and p3.Texture == self.Texture and p3.Name == self.PREFIX .. p3.Face.Name
end

function t1:Pack(p5) -- line: 19
    local n1 = 0

    for _, descendant in ipairs(p5:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local t3 = {}

            for _, child in ipairs(descendant:GetChildren()) do
                if self:IsStud(child) then
                    table.insert(t3, child)
                end
            end

            if #t3 > 0 then
                descendant:SetAttribute(self.ATTRIBUTE, t3[1].StudsPerTileU)

                for _, v2 in ipairs(t3) do
                    v2:Destroy()
                end

                n1 += 1
            end
        end
    end

    return n1
end

function t1:Unpack(p7) -- line: 41
    local n2 = 0

    for _, descendant in ipairs(p7:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local Attribute = descendant:GetAttribute(self.ATTRIBUTE)

            if type(Attribute) == "number" and not descendant:FindFirstChild(self.PREFIX .. "Top") then
                for _, v3 in ipairs(self.FACES) do
                    local Texture = Instance.new("Texture")

                    Texture.Name = self.PREFIX .. v3.Name
                    Texture.Face = v3
                    Texture.Texture = self.Texture
                    Texture.StudsPerTileU = Attribute
                    Texture.StudsPerTileV = Attribute
                    Texture.ZIndex = self.Z_INDEX
                    Texture.Parent = descendant
                end

                n2 += 1
            end
        end
    end

    return n2
end

t1.Shared = t1.new(require(script.Parent.Style).STUD_TEXTURE)

return t1
