-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
game:GetService("TextService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Packages.Trove)
local TableUtil = require(ReplicatedStorage.Modules.Util.TableUtil)
local Small = script:WaitForChild("Small")
local t = {
	DefaultProperties = {
		Text = "?",
		Icon = nil
	}
}
function t.Create(p1, p2, p3) --[[ Create | Line: 21 | Upvalues: TableUtil (copy), t (copy), Small (copy) ]]
	local v1 = p2 and TableUtil.Reconcile(p2, t.DefaultProperties) or t.DefaultProperties
	local v2 = Small:Clone()
	v2.Label.Text = v1.Text
	if v1.Icon then
		v2.Vector.Image = v1.Icon
		v2.Vector.Visible = true
	else
		v2.Vector.Visible = false
	end
	return v2
end
return t