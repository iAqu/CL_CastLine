-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
local assign = require(script.Parent.assign)
local ComponentLifecyclePhase = require(script.Parent.ComponentLifecyclePhase)
local Type = require(script.Parent.Type)
local Symbol = require(script.Parent.Symbol)
local invalidSetStateMessages = require(script.Parent.invalidSetStateMessages)
local internalAssert = require(script.Parent.internalAssert)
local v1 = require(script.Parent.GlobalConfig).get()
local v2 = Symbol.named("InternalData")
local t = {
	__tostring = function(p1) --[[ __tostring | Line: 29 ]]
		return p1.__componentName
	end
}
local t2 = {}
setmetatable(t2, t)
t2[Type] = Type.StatefulComponentClass
t2.__index = t2
t2.__componentName = "Component"
function t2.extend(p1, p2) --[[ extend | Line: 45 | Upvalues: v1 (copy), Type (copy), t (copy) ]]
	if v1.typeChecks then
		local isStatefulComponentClass = Type.of(p1) == Type.StatefulComponentClass
		assert(isStatefulComponentClass, "Invalid `self` argument to `extend`.")
		assert(if typeof(p2) == "string" then true else false, "Component class name must be a string")
	end
	local t2 = {}
	for k, v in pairs(p1) do
		if k ~= "extend" then
			t2[k] = v
		end
	end
	t2[Type] = Type.StatefulComponentClass
	t2.__index = t2
	t2.__componentName = p2
	setmetatable(t2, t)
	return t2
end
function t2.__getDerivedState(p1, p2, p3) --[[ __getDerivedState | Line: 71 | Upvalues: v1 (copy), internalAssert (copy), Type (copy), v2 (copy) ]]
	if v1.internalTypeChecks then
		local isStatefulComponentInstance = Type.of(p1) == Type.StatefulComponentInstance
		internalAssert(isStatefulComponentInstance, "Invalid use of `__getDerivedState`")
	end
	local componentClass = p1[v2].componentClass
	if componentClass.getDerivedStateFromProps == nil then
		return nil
	end
	local v22 = componentClass.getDerivedStateFromProps(p2, p3)
	if v22 == nil then
		return nil
	end
	if v1.typeChecks then
		assert(typeof(v22) == "table", "getDerivedStateFromProps must return a table!")
	end
	return v22
end
function t2.setState(p1, p2) --[[ setState | Line: 94 | Upvalues: v1 (copy), Type (copy), v2 (copy), ComponentLifecyclePhase (copy), invalidSetStateMessages (copy), assign (copy) ]]
	if v1.typeChecks then
		local isStatefulComponentInstance = Type.of(p1) == Type.StatefulComponentInstance
		assert(isStatefulComponentInstance, "Invalid `self` argument to `extend`.")
	end
	local v12 = p1[v2]
	local lifecyclePhase = v12.lifecyclePhase
	if lifecyclePhase == ComponentLifecyclePhase.ShouldUpdate or (lifecyclePhase == ComponentLifecyclePhase.WillUpdate or lifecyclePhase == ComponentLifecyclePhase.Render) then
		error(invalidSetStateMessages[v12.lifecyclePhase]:format((tostring(v12.componentClass))), 2)
	elseif lifecyclePhase == ComponentLifecyclePhase.WillUnmount then
		return
	end
	local pendingState = v12.pendingState
	local v4 = nil
	if typeof(p2) == "function" then
		local v6 = p2(if pendingState then pendingState else p1.state, p1.props)
		if v6 == nil then
			return
		end
		v4 = v6
	elseif typeof(p2) == "table" then
		v4 = p2
	else
		error("Invalid argument to setState, expected function or table", 2)
	end
	local v7 = if pendingState == nil then assign({}, p1.state, v4) else assign(pendingState, v4)
	if lifecyclePhase == ComponentLifecyclePhase.Init then
		p1.state = assign(v7, (p1:__getDerivedState(p1.props, v7)))
		return
	end
	if lifecyclePhase == ComponentLifecyclePhase.DidMount or (lifecyclePhase == ComponentLifecyclePhase.DidUpdate or lifecyclePhase == ComponentLifecyclePhase.ReconcileChildren) then
		v12.pendingState = assign(v7, (p1:__getDerivedState(p1.props, v7)))
		return
	end
	if lifecyclePhase == ComponentLifecyclePhase.Idle then
		p1:__update(nil, v7)
	else
		error(invalidSetStateMessages.default:format((tostring(v12.componentClass))), 2)
	end
end
function t2.getElementTraceback(p1) --[[ getElementTraceback | Line: 178 | Upvalues: v2 (copy) ]]
	return p1[v2].virtualNode.currentElement.source
end
function t2.render(p1) --[[ render | Line: 189 | Upvalues: v2 (copy) ]]
	error(("The component %q is missing the `render` method.\n`render` must be defined when creating a Roact component!"):format((tostring(p1[v2].componentClass))), 0)
end
function t2.__getContext(p1, p2) --[[ __getContext | Line: 201 | Upvalues: v1 (copy), internalAssert (copy), Type (copy), v2 (copy) ]]
	if v1.internalTypeChecks then
		local isStatefulComponentInstance = Type.of(p1) == Type.StatefulComponentInstance
		internalAssert(isStatefulComponentInstance, "Invalid use of `__getContext`")
		internalAssert(if p2 == nil then false else true, "Context key cannot be nil")
	end
	return p1[v2].virtualNode.context[p2]
end
function t2.__addContext(p1, p2, p3) --[[ __addContext | Line: 217 | Upvalues: v1 (copy), internalAssert (copy), Type (copy), v2 (copy), assign (copy) ]]
	if v1.internalTypeChecks then
		local isStatefulComponentInstance = Type.of(p1) == Type.StatefulComponentInstance
		internalAssert(isStatefulComponentInstance, "Invalid use of `__addContext`")
	end
	local virtualNode = p1[v2].virtualNode
	if virtualNode.originalContext == nil then
		virtualNode.originalContext = virtualNode.context
	end
	virtualNode.context = assign({}, virtualNode.context, {
		[p2] = p3
	})
end
function t2.__validateProps(p1, p2) --[[ __validateProps | Line: 244 | Upvalues: v1 (copy), v2 (copy) ]]
	if not v1.propValidation then
		return
	end
	local validateProps = p1[v2].componentClass.validateProps
	if validateProps == nil then
		return
	end
	if typeof(validateProps) ~= "function" then
		error(("validateProps must be a function, but it is a %s.\nCheck the definition of the component %q."):format(typeof(validateProps), p1.__componentName))
	end
	local v12, v22 = validateProps(p2)
	if v12 then
		return
	end
	error(("Property validation failed in %s: %s\n\n%s"):format(p1.__componentName, tostring(v22 or "<Validator function did not supply a message>"), p1:getElementTraceback() or "<enable element tracebacks>"), 0)
end
function t2.__mount(p1, p2, p3) --[[ __mount | Line: 283 | Upvalues: v1 (copy), internalAssert (copy), Type (copy), ComponentLifecyclePhase (copy), v2 (copy), assign (copy) ]]
	if v1.internalTypeChecks then
		local isStatefulComponentClass = Type.of(p1) == Type.StatefulComponentClass
		internalAssert(isStatefulComponentClass, "Invalid use of `__mount`")
		internalAssert(if Type.of(p3) == Type.VirtualNode then true else false, "Expected arg #2 to be of type VirtualNode")
	end
	local currentElement = p3.currentElement
	local hostParent = p3.hostParent
	local t = {
		reconciler = p2,
		virtualNode = p3,
		componentClass = p1,
		lifecyclePhase = ComponentLifecyclePhase.Init
	}
	local t2 = {
		[Type] = Type.StatefulComponentInstance,
		[v2] = t
	}
	setmetatable(t2, p1)
	p3.instance = t2
	local props = currentElement.props
	if p1.defaultProps ~= nil then
		props = assign({}, p1.defaultProps, props)
	end
	t2:__validateProps(props)
	t2.props = props
	t2._context = assign({}, p3.legacyContext)
	t2.state = assign({}, t2:__getDerivedState(t2.props, {}))
	if t2.init ~= nil then
		t2:init(t2.props)
		assign(t2.state, t2:__getDerivedState(t2.props, t2.state))
	end
	p3.legacyContext = t2._context
	t.lifecyclePhase = ComponentLifecyclePhase.Render
	local v5 = t2:render()
	t.lifecyclePhase = ComponentLifecyclePhase.ReconcileChildren
	p2.updateVirtualNodeWithRenderResult(p3, hostParent, v5)
	if t2.didMount ~= nil then
		t.lifecyclePhase = ComponentLifecyclePhase.DidMount
		t2:didMount()
	end
	if t.pendingState == nil then
		t.lifecyclePhase = ComponentLifecyclePhase.Idle
		return
	end
	t2:__update(nil, nil)
	t.lifecyclePhase = ComponentLifecyclePhase.Idle
end
function t2.__unmount(p1) --[[ __unmount | Line: 356 | Upvalues: v1 (copy), internalAssert (copy), Type (copy), v2 (copy), ComponentLifecyclePhase (copy) ]]
	if v1.internalTypeChecks then
		local isStatefulComponentInstance = Type.of(p1) == Type.StatefulComponentInstance
		internalAssert(isStatefulComponentInstance, "Invalid use of `__unmount`")
	end
	local v22 = p1[v2]
	local virtualNode = v22.virtualNode
	local reconciler = v22.reconciler
	if p1.willUnmount ~= nil then
		v22.lifecyclePhase = ComponentLifecyclePhase.WillUnmount
		p1:willUnmount()
	end
	for k, v in pairs(virtualNode.children) do
		reconciler.unmountVirtualNode(v)
	end
end
function t2.__update(p1, p2, p3) --[[ __update | Line: 381 | Upvalues: v1 (copy), internalAssert (copy), Type (copy), v2 (copy), assign (copy) ]]
	if v1.internalTypeChecks then
		local isStatefulComponentInstance = Type.of(p1) == Type.StatefulComponentInstance
		internalAssert(isStatefulComponentInstance, "Invalid use of `__update`")
		internalAssert(if Type.of(p2) == Type.Element then true elseif p2 == nil then true else false, "Expected arg #1 to be of type Element or nil")
		internalAssert(if typeof(p3) == "table" then true elseif p3 == nil then true else false, "Expected arg #2 to be of type table or nil")
	end
	local v6 = p1[v2]
	local componentClass = v6.componentClass
	local props = p1.props
	if p2 ~= nil then
		props = p2.props
		if componentClass.defaultProps ~= nil then
			props = assign({}, componentClass.defaultProps, props)
		end
		p1:__validateProps(props)
	end
	local count = 0
	while true do
		local v8, v9
		if v6.pendingState == nil then
			v8 = nil
		else
			v8 = v6.pendingState
			v6.pendingState = nil
		end
		if p3 == nil and props == p1.props then
			v9 = v8
		else
			v9 = if v8 == nil then if p3 then p3 else p1.state else assign(v8, p3)
			local v12 = p1:__getDerivedState(props, v9)
			if v12 ~= nil then
				v9 = assign({}, v9, v12)
			end
			p3 = nil
		end
		if not p1:__resolveUpdate(props, v9) then
			return false
		end
		count = count + 1
		if count > 100 then
			local v14 = error
			v14(("The component %q has reached the setState update recursion limit.\nWhen using `setState` in `didUpdate`, make sure that it won\'t repeat infinitely!"):format((tostring(v6.componentClass))), 3)
		end
		if v6.pendingState == nil then
			return true
		end
	end
end
function t2.__resolveUpdate(p1, p2, p3) --[[ __resolveUpdate | Line: 458 | Upvalues: v1 (copy), internalAssert (copy), Type (copy), v2 (copy), ComponentLifecyclePhase (copy) ]]
	if v1.internalTypeChecks then
		local isStatefulComponentInstance = Type.of(p1) == Type.StatefulComponentInstance
		internalAssert(isStatefulComponentInstance, "Invalid use of `__resolveUpdate`")
	end
	local v22 = p1[v2]
	local virtualNode = v22.virtualNode
	local reconciler = v22.reconciler
	local props = p1.props
	local state = p1.state
	if p2 == nil then
		p2 = props
	end
	if p3 == nil then
		p3 = state
	end
	if p1.shouldUpdate ~= nil then
		v22.lifecyclePhase = ComponentLifecyclePhase.ShouldUpdate
		if not p1:shouldUpdate(p2, p3) then
			v22.lifecyclePhase = ComponentLifecyclePhase.Idle
			return false
		end
	end
	if p1.willUpdate ~= nil then
		v22.lifecyclePhase = ComponentLifecyclePhase.WillUpdate
		p1:willUpdate(p2, p3)
	end
	v22.lifecyclePhase = ComponentLifecyclePhase.Render
	p1.props = p2
	p1.state = p3
	local v3 = virtualNode.instance:render()
	v22.lifecyclePhase = ComponentLifecyclePhase.ReconcileChildren
	reconciler.updateVirtualNodeWithRenderResult(virtualNode, virtualNode.hostParent, v3)
	if p1.didUpdate ~= nil then
		v22.lifecyclePhase = ComponentLifecyclePhase.DidUpdate
		p1:didUpdate(props, state)
	end
	v22.lifecyclePhase = ComponentLifecyclePhase.Idle
	return true
end
return t2