-- 跨系统靠近交互高亮互斥：动物与 prop/decor 同时只能有一方占用交互高亮。
local InteractionHighlightCoordinator = {}

export type OwnerToken = "animal" | "prop"

type SuppressedListener = (holderToken: OwnerToken?) -> ()

local holderToken: OwnerToken? = nil
local holderModel: Model? = nil
local suppressedListeners: { SuppressedListener } = {}

local function notifySuppressedChanged()
	for _, listener in ipairs(suppressedListeners) do
		task.defer(listener, holderToken)
	end
end

function InteractionHighlightCoordinator.TryClaim(ownerToken: OwnerToken, model: Model): boolean
	if holderToken == nil then
		holderToken = ownerToken
		holderModel = model
		notifySuppressedChanged()
		return true
	end

	if holderToken == ownerToken then
		holderModel = model
		return true
	end

	return false
end

function InteractionHighlightCoordinator.Release(ownerToken: OwnerToken)
	if holderToken ~= ownerToken then
		return
	end

	holderToken = nil
	holderModel = nil
	notifySuppressedChanged()
end

function InteractionHighlightCoordinator.GetHolderToken(): OwnerToken?
	return holderToken
end

function InteractionHighlightCoordinator.GetHolderModel(): Model?
	return holderModel
end

function InteractionHighlightCoordinator.ConnectSuppressedChanged(listener: SuppressedListener): RBXScriptConnection
	table.insert(suppressedListeners, listener)
	return {
		Disconnect = function()
			local index = table.find(suppressedListeners, listener)
			if index then
				table.remove(suppressedListeners, index)
			end
		end,
	} :: any
end

return InteractionHighlightCoordinator
