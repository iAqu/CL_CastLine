-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local GlobalConfig = require(script:WaitForChild("GlobalConfig"))
local createReconciler = require(script:WaitForChild("createReconciler"))
local createReconcilerCompat = require(script:WaitForChild("createReconcilerCompat"))
local RobloxRenderer = require(script:WaitForChild("RobloxRenderer"))
local strict = require(script:WaitForChild("strict"))
local Binding = require(script:WaitForChild("Binding"))
local PropMarkers = script:WaitForChild("PropMarkers")
local v1 = createReconciler(RobloxRenderer)
local v2 = createReconcilerCompat(v1)
return strict({
	Component = require(script.Component),
	createElement = require(script.createElement),
	createFragment = require(script.createFragment),
	oneChild = require(script.oneChild),
	PureComponent = require(script.PureComponent),
	None = require(script.None),
	Portal = require(script.Portal),
	createRef = require(script.createRef),
	forwardRef = require(script.forwardRef),
	createBinding = Binding.create,
	joinBindings = Binding.join,
	createContext = require(script.createContext),
	Change = require(PropMarkers.Change),
	Children = require(PropMarkers.Children),
	Event = require(PropMarkers.Event),
	Ref = require(PropMarkers.Ref),
	mount = v1.mountVirtualTree,
	unmount = v1.unmountVirtualTree,
	update = v1.updateVirtualTree,
	reify = v2.reify,
	teardown = v2.teardown,
	reconcile = v2.reconcile,
	setGlobalConfig = GlobalConfig.set,
	UNSTABLE = {}
})