-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.Shared.Types.AssetItem)

local AssetDisplayText = require(ReplicatedStorage.Shared.Modules.AssetDisplayText)
local AssetInfoBillboard = require(ReplicatedStorage.Shared.Modules.AssetInfoBillboard)
local AssetRigFactory = require(ReplicatedStorage.Shared.Modules.AssetRigFactory)
local AssetToolRig = require(ReplicatedStorage.Shared.Modules.AssetToolRig)

return {
    ApplyBillboardDisplay = AssetInfoBillboard.WriteTitle,
    ApplyModelScale = AssetRigFactory.Resize,
    CreateActiveModel = AssetRigFactory.BuildActive,
    CreateDataBillboard = AssetInfoBillboard.Attach,
    CreateTool = AssetToolRig.Build,
    CreateWanderingAssetModel = AssetRigFactory.BuildWandering,
    GetDataBillboardMaxDistance = AssetInfoBillboard.Range,
    GetDisplayScale = AssetRigFactory.Scale,
    GetModelScale = AssetRigFactory.RigScale,
    GetMutationRichTextLine = AssetDisplayText.MutationRun,
    GetNameFromItemData = AssetDisplayText.ForRecord,
    GetVisibleBounds = AssetRigFactory.Extents,
    IsDroppableBaseMutation = AssetDisplayText.IsDroppable,
    ResolveBaseMutation = AssetDisplayText.FirstDroppable,
    SetDataBillboardMoneyPerSecond = AssetInfoBillboard.SetRate,
    StripRuntimeRig = AssetRigFactory.Strip,
    CreateModel = function(p1, _) -- line: 37
        -- upvalues: AssetRigFactory (copy)
        return AssetRigFactory.Build(p1)
    end,
    CreateActiveModelWithHumanoid = function(p3, p4) -- line: 41
        -- upvalues: AssetRigFactory (copy)
        return AssetRigFactory.BuildActive(p3, p4)
    end
}
