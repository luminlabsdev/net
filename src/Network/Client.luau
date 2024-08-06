-- Forked from red-blox/Red

-- Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local NetFolder = ReplicatedStorage:WaitForChild("Net")
local Reliable: RemoteEvent = NetFolder:WaitForChild("Reliable")
local Unreliable: UnreliableRemoteEvent = NetFolder:WaitForChild("Unreliable")

local Listeners = {}
local Calls = {}
local Queue = {
	Reliable = {},
	Call = {},
}

-- Functions

-- Sends a reliable fire without batching
local function SendReliable(id: string, args: { any })
	Reliable:FireServer({ [id] = { args } })
end

-- Sends a reliable fire with batching
local function SendReliableBatched(id: string, args: { any })
	if not Queue.Reliable[id] then
		Queue.Reliable[id] = {}
	end
	table.insert(Queue.Reliable[id], args)
end

-- Sends an unreliable fire with batching
local function SendUnreliable(id: string, args: { any })
	Unreliable:FireServer(id, args)
end

-- Sends a reliable call with batching
local function SendReliableBatchedCall(id: string, args: { any }): { any }
	if not Queue.Call[id] then
		Queue.Call[id] = {}
	end
	table.insert(Queue.Call[id], args)
	Calls[args[1]] = coroutine.running()
	return coroutine.yield()
end

-- Listens to an event with a specific id within the queue
local function Listen(id: string, listener: ({ any }) -> ())
	Listeners[id] = listener
end

-- Starts the client process
local function Init()
	Reliable.OnClientEvent:Connect(function(fires, calls)
		-- Checks for batched fires
		if fires then
			-- Loop through all of the fires that were batched
			for id, callList in fires do
				-- Check if a listener exists for the specific identifier
				local Listener = Listeners[id]
				if Listener then
					for _, call in calls do
						Listener(call)
					end
				end
			end
		end

		-- Checks for batched calls
		if calls then
			-- Loop through all of the calls that were batched
			for id, callList in calls do
				local thread = Calls[id]
				if thread then
					Calls[id] = nil
					coroutine.resume(thread, callList)
				end
			end
		end
	end)

	Unreliable.OnClientEvent:Connect(function(id, args)
		-- Since unreliables cannot be batched efficiently, we take the raw id and args and call the listener
		local Listener = Listeners[id]
		if Listener then
			Listener(args)
		end
	end)

	RunService.Heartbeat:Connect(function()
		-- Checks every frame if there are calls/fires left in the queue to send to the server
		if next(Queue.Reliable) or next(Queue.Call) then
			Reliable:FireServer(Queue.Reliable, Queue.Call)
			Queue.Reliable = {}
			Queue.Call = {}
		end
	end)
end

-- Modules

return {
	Init = Init,
	Listen = Listen,

	SendReliable = SendReliable,
	SendReliableBatched = SendReliableBatched,

	SendReliableBatchedCall = SendReliableBatchedCall,

	SendUnreliable = SendUnreliable,
}