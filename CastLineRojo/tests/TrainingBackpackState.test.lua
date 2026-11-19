local State =
	assert(loadstring(assert(io.open("src/ReplicatedStorage/Modules/TrainingBackpackState.lua")):read("*a")))()
local current = { Enabled = true, Parent = true }
local gui = {
	FindFirstChild = function()
		return current
	end,
}
local other = false
local state = State.new(gui, function()
	return other
end)
state:SetActive(true)
assert(not current.Enabled)
current.Enabled = true
state:Step()
assert(not current.Enabled, "Keep hidden throughout training")
other = true
state:SetActive(false)
assert(not current.Enabled, "Do not show the backpack during another gameplay owner")
other = false
state:Step()
assert(current.Enabled)
current.Enabled = false
state:SetActive(true)
state:SetActive(false)
assert(not current.Enabled, "Preserve a preexisting hidden state")
current = nil
state:SetActive(true)
current = { Enabled = true, Parent = true }
state:Step()
assert(not current.Enabled, "Late-mounted backpacks must also hide")
state:SetActive(false)
assert(current.Enabled)
state:SetActive(true)
current = { Enabled = true, Parent = true }
state:Step()
assert(not current.Enabled, "Replacement backpack receives the active lock")
state:Destroy()
assert(current.Enabled)
