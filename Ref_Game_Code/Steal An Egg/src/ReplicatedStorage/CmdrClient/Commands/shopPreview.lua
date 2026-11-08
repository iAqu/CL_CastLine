-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "shopPreview",
    Description = "Preview the shop before or after the configured Halloween switch on your client in DEV, TEST or Studio.",
    Group = "Admin",
    Aliases = { "previewShop" },
    Args = {
        {
            Type = "string",
            Name = "Mode",
            Description = "before/old, after/new, or off",
            Optional = true,
            Default = "after"
        }
    },
    ClientRun = function(_, p2) -- ClientRun | line: 10
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local ShopPreview = require(ReplicatedStorage.Client.ShopPreview)
        local v1, v2 = ShopPreview.Set(p2)

        if v1 then
            require(ReplicatedStorage.Client.ShopNavigation).Open(ShopPreview.IsHalloween() and "Featured" or "Stars")
        end

        return v2
    end
}
