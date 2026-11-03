-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return {
	Nodes = {
		stealing_open = {
			text = { "Good job! here\'s the reward I promised" }
		},
		default_open = {
			text = { "Hello there, my name is Bob! how may I help you?" },
			choices = {
				{
					id = "about",
					text = "Tell me about youself."
				},
				{
					id = "odd",
					text = "Bob? What an odd name for a brick."
				}
			}
		},
		about = {
			text = { "Well... where do I start..", "My name is Bob I am from Robloxia City,", "My favorite color is grey.", "I think." },
			trigger = function() --[[ trigger | Line: 28 ]]
				print("Bob tells about himself")
			end,
			choices = {
				{
					id = "boring",
					text = "Boring..."
				},
				{
					id = "nice",
					text = "Nice to meet you, Bob!"
				},
				{
					id = "bye",
					text = "Ok Goodbye"
				}
			}
		},
		odd = {
			text = { "Odd? well yes..", "BUT I LOVE IT!" },
			trigger = function() --[[ trigger | Line: 43 ]]
				print("Bob DHV")
			end,
			choices = {
				{
					id = "bye",
					text = "Ok bye Bob the brick!"
				}
			}
		},
		boring = {
			text = { "Boring?", "You are boring." },
			trigger = function() --[[ trigger | Line: 56 ]]
				print("Bob is upset")
			end
		},
		nice = {
			text = { "Nice to meet you too!", "Do you need anything else?" },
			trigger = function() --[[ trigger | Line: 66 ]]
				print("Bob is happy")
			end,
			choices = {
				{
					id = "bye",
					text = "No, bye bye."
				}
			}
		},
		bye = {
			text = { "see you later bruh" },
			trigger = function() --[[ trigger | Line: 78 ]]
				print("you finished talking to Bob")
			end
		}
	},
	GetCorrectOpening = function(p1) --[[ GetCorrectOpening | Line: 84 ]]
		if p1:HasTag("Stealing") then
			return "stealing_open"
		else
			return "default_open"
		end
	end
}