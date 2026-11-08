-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Icons = require(script.Icons)
local ImagePreloader = require(ReplicatedStorage.Client.ImagePreloader)
local TableUtil = require(ReplicatedStorage.Packages.TableUtil)

return {
    Start = function() -- Start | line: 21
        -- upvalues: CollectionService (copy), Icons (copy), ImagePreloader (copy), TableUtil (copy)
        ImagePreloader.RequestAll(TableUtil.Values(Icons.Preload))

        local function onImageLabelAdded(p1) -- line: 24
            -- upvalues: Icons (copy)
            if typeof(p1) == "Instance" and p1:IsA("ImageLabel") then
                local IconId = p1:GetAttribute("IconId")
                local v1 = IconId and Icons.All[IconId]

                if v1 then
                    p1.Image = v1
                else
                    warn("Invalid icon id", IconId, " | ", p1:GetFullName())
                end
            end
        end

        CollectionService:GetInstanceAddedSignal("ICON"):Connect(onImageLabelAdded)

        for _, v2 in CollectionService:GetTagged("ICON") do
            task.spawn(onImageLabelAdded, v2)
        end
    end
}
