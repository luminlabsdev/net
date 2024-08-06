-- Forked from red-blox/Red

-- Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local NetFolder = ReplicatedStorage:WaitForChild("Net")
local Reliable: RemoteEvent = NetFolder:WaitForChild("Reliable")
local Unreliable: UnreliableRemoteEvent = NetFolder:WaitForChild("Unreliable")

local Listeners = {}
local Queue = {}

-- Functions

-- Creates a new queue that is designated to a defined player
local function CreateQueue(player: Player)
	Queue[player] = {
		Reliable = {},
		Call = {},
	}
end

local function SendReliable(player: Player, id: string, args: { any })
	Reliable:FireClient(player, { [id] = { args } })
end

local function SendReliableBatched(player: Player, id: string, args: { any })
	local QueueForPlayer = Queue[player]
	if not QueueForPlayer then
		CreateQueue(player)
		QueueForPlayer = Queue[player]
	end
	if not QueueForPlayer.Reliable[id] then
		QueueForPlayer.Reliable[id] = {}
	end
	table.insert(QueueForPlayer.Reliable[id], args)
end

local function SendUnreliable(player: Player, id: string, args: { any })
    Unreliable:FireClient(player, id, args)
end

local function SendReliableBatchedCallReturn(player: Player, id: string, args: { any })
    local QueueForPlayer = Queue[player]
	if not QueueForPlayer then
		CreateQueue(player)
		QueueForPlayer = Queue[player]
	end
	QueueForPlayer.Call[id] = args
end

local function Listen(id: string, listener: (Player, {any}) -> ())
    Listeners[id] = listener
end

local function Init()
	Reliable.OnServerEvent:Connect(function(player, fires, calls)
		if type(fires) == "table" then
			for id, callList in fires do
				if type(id) ~= "string" or type(callList) ~= "table" then
					continue
				end
				local Listener = Listeners[id]
				if Listener then
					for _, call in callList do
						Listener(player, call)
					end
				end
			end
		end

		if type(calls) == "table" then
			for id, callList in calls do
				if type(id) ~= "string" or type(callList) ~= "table" then
					continue
				end
				local Listener = Listeners[id]
				if Listener then
					for _, call in callList do
						Listener(player, call)
					end
				else
					for _, call in callList do
						SendReliableBatchedCallReturn(player, call[1], { false, "Event has no listener" })
					end
				end
			end
		end
	end)

	Unreliable.OnServerEvent:Connect(function(player, id, args)
		if type(id) == "string" and type(args) == "table" then
			local Listener = Listeners[id]
			if Listener then
				Listener(player, args)
			end
		end
	end)

	RunService.Heartbeat:Connect(function()
		for player, queue in Queue do
			if next(queue.Reliable) or next(queue.Call) then
				Reliable:FireClient(player, queue.Reliable, queue.Call)
			end
			Queue[player] = nil
		end
	end)
end

-- Module

return {
	Init = Init,
    Listen = Listen,

    SendReliable = SendReliable,
	SendReliableBatched = SendReliableBatched,

	SendReliableBatchedCallReturn = SendReliableBatchedCallReturn,

	SendUnreliable = SendUnreliable,
}
