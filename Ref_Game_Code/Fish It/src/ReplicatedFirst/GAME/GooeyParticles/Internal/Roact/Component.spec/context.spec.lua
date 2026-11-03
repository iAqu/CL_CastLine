-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function() --[[ Line: 1 ]]
	local assertDeepEqual = require(script.Parent.Parent.assertDeepEqual)
	local createElement = require(script.Parent.Parent.createElement)
	local createReconciler = require(script.Parent.Parent.createReconciler)
	local NoopRenderer = require(script.Parent.Parent.NoopRenderer)
	local oneChild = require(script.Parent.Parent.oneChild)
	local Component = require(script.Parent.Parent.Component)
	local v1 = createReconciler(NoopRenderer)
	it("should be provided as an internal api on Component", function() --[[ Line: 12 | Upvalues: Component (copy), createElement (copy), v1 (copy), assertDeepEqual (copy) ]]
		local v12 = Component:extend("Provider")
		function v12.init(p1) --[[ init | Line: 15 ]]
			p1:__addContext("foo", "bar")
		end
		function v12.render(p1) --[[ render | Line: 19 ]] end
		assertDeepEqual(v1.mountVirtualNode(createElement(v12), nil, "Provider").context, {
			foo = "bar"
		})
	end)
	it("should be inherited from parent stateful nodes", function() --[[ Line: 33 | Upvalues: Component (copy), createElement (copy), v1 (copy), assertDeepEqual (copy) ]]
		local v12 = Component:extend("Consumer")
		local v2 = nil
		function v12.init(p1) --[[ init | Line: 37 | Upvalues: v2 (ref) ]]
			v2 = {
				hello = p1:__getContext("hello"),
				value = p1:__getContext("value")
			}
		end
		function v12.render(p1) --[[ render | Line: 44 ]] end
		local v3 = Component:extend("Parent")
		function v3.render(p1) --[[ render | Line: 48 | Upvalues: createElement (ref), v12 (copy) ]]
			return createElement(v12)
		end
		local v4 = createElement(v3)
		local t = {
			hello = "world",
			value = 6
		}
		local v5 = v1.mountVirtualNode(v4, nil, "Parent", t)
		expect(v2).never.to.equal(t)
		expect(v2).never.to.equal(v5.context)
		assertDeepEqual(v5.context, t)
		assertDeepEqual(v2, t)
	end)
	it("should be inherited from parent function nodes", function() --[[ Line: 67 | Upvalues: Component (copy), createElement (copy), v1 (copy), assertDeepEqual (copy) ]]
		local v12 = Component:extend("Consumer")
		local v2 = nil
		function v12.init(p1) --[[ init | Line: 71 | Upvalues: v2 (ref) ]]
			v2 = {
				hello = p1:__getContext("hello"),
				value = p1:__getContext("value")
			}
		end
		function v12.render(p1) --[[ render | Line: 78 ]] end
		local v3 = createElement(function() --[[ Parent | Line: 80 | Upvalues: createElement (ref), v12 (copy) ]]
			return createElement(v12)
		end)
		local t = {
			hello = "world",
			value = 6
		}
		local v4 = v1.mountVirtualNode(v3, nil, "Parent", t)
		expect(v2).never.to.equal(t)
		expect(v2).never.to.equal(v4.context)
		assertDeepEqual(v4.context, t)
		assertDeepEqual(v2, t)
	end)
	it("should not copy the context table if it doesn\'t need to", function() --[[ Line: 99 | Upvalues: Component (copy), createElement (copy), v1 (copy), assertDeepEqual (copy), oneChild (copy) ]]
		local v12 = Component:extend("Parent")
		function v12.init(p1) --[[ init | Line: 102 ]]
			p1:__addContext("parent", "I\'m here!")
		end
		function v12.render(p1) --[[ render | Line: 106 | Upvalues: createElement (ref) ]]
			return createElement(function() --[[ Line: 108 ]] end)
		end
		local v2 = createElement(v12)
		local v3 = v1.mountVirtualNode(v2, nil, "Parent")
		assertDeepEqual(v3.context, {
			parent = "I\'m here!"
		})
		local v4 = oneChild(v3.children)
		expect(v3.context).to.equal(v4.context)
	end)
	it("should not allow context to move up the tree", function() --[[ Line: 128 | Upvalues: Component (copy), createElement (copy), v1 (copy), oneChild (copy), assertDeepEqual (copy) ]]
		local v12 = Component:extend("ChildProvider")
		function v12.init(p1) --[[ init | Line: 131 ]]
			p1:__addContext("child", "I\'m here too!")
		end
		function v12.render(p1) --[[ render | Line: 135 ]] end
		local v2 = Component:extend("ParentProvider")
		function v2.init(p1) --[[ init | Line: 139 ]]
			p1:__addContext("parent", "I\'m here!")
		end
		function v2.render(p1) --[[ render | Line: 143 | Upvalues: createElement (ref), v12 (copy) ]]
			return createElement(v12)
		end
		local v3 = createElement(v2)
		local v4 = v1.mountVirtualNode(v3, nil, "Parent")
		local v5 = oneChild(v4.children)
		assertDeepEqual(v4.context, {
			parent = "I\'m here!"
		})
		assertDeepEqual(v5.context, {
			parent = "I\'m here!",
			child = "I\'m here too!"
		})
	end)
	it("should contain values put into the tree by parent nodes", function() --[[ Line: 168 | Upvalues: Component (copy), createElement (copy), v1 (copy), assertDeepEqual (copy) ]]
		local v12 = Component:extend("Consumer")
		local v2 = nil
		function v12.init(p1) --[[ init | Line: 172 | Upvalues: v2 (ref) ]]
			v2 = {
				dont = p1:__getContext("dont"),
				frob = p1:__getContext("frob")
			}
		end
		function v12.render(p1) --[[ render | Line: 179 ]] end
		local v3 = Component:extend("Provider")
		function v3.init(p1) --[[ init | Line: 183 ]]
			p1:__addContext("frob", "ulator")
		end
		function v3.render(p1) --[[ render | Line: 187 | Upvalues: createElement (ref), v12 (copy) ]]
			return createElement(v12)
		end
		local v4 = createElement(v3)
		local t = {
			dont = "try it"
		}
		local v5 = v1.mountVirtualNode(v4, nil, "Consumer", t)
		local t2 = {
			dont = "try it",
			frob = "ulator"
		}
		expect(v5.context).never.to.equal(t)
		expect(v2).never.to.equal(t)
		expect(v2).never.to.equal(v5.context)
		assertDeepEqual(t, {
			dont = "try it"
		})
		assertDeepEqual(v5.context, t2)
		assertDeepEqual(v2, t2)
	end)
	it("should transfer context to children that are replaced", function() --[[ Line: 218 | Upvalues: Component (copy), createElement (copy), v1 (copy), assertDeepEqual (copy) ]]
		local v12 = Component:extend("ConsumerA")
		local function captureAllContext(p1) --[[ captureAllContext | Line: 221 ]]
			return {
				A = p1:__getContext("A"),
				B = p1:__getContext("B"),
				frob = p1:__getContext("frob")
			}
		end
		local v2 = nil
		function v12.init(p1) --[[ init | Line: 230 | Upvalues: v2 (ref), captureAllContext (copy) ]]
			p1:__addContext("A", "hello")
			v2 = captureAllContext(p1)
		end
		function v12.render(p1) --[[ render | Line: 236 ]] end
		local v3 = Component:extend("ConsumerB")
		local v4 = nil
		function v3.init(p1) --[[ init | Line: 241 | Upvalues: v4 (ref), captureAllContext (copy) ]]
			p1:__addContext("B", "hello")
			v4 = captureAllContext(p1)
		end
		function v3.render(p1) --[[ render | Line: 247 ]] end
		local v5 = Component:extend("Provider")
		function v5.init(p1) --[[ init | Line: 251 ]]
			p1:__addContext("frob", "ulator")
		end
		function v5.render(p1) --[[ render | Line: 255 | Upvalues: createElement (ref), v3 (copy), v12 (copy) ]]
			if p1.props.useConsumerB then
				return createElement(v3)
			else
				return createElement(v12)
			end
		end
		local v6 = createElement(v5)
		local v7 = v1.mountVirtualNode(v6, nil, "Consumer")
		assertDeepEqual(v2, {
			frob = "ulator",
			A = "hello"
		})
		local v8 = createElement(v5, {
			useConsumerB = true
		})
		v1.updateVirtualNode(v7, v8)
		assertDeepEqual(v4, {
			frob = "ulator",
			B = "hello"
		})
	end)
end