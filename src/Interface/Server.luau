-- Variables

local PlayerService = game:GetService("Players")

local Ratelimit = require(script.Parent.Parent.Parent.ratelimit)
local Types = require(script.Parent.Parent.Types)

local Network = script.Parent.Parent.Network
local Server = require(Network.Server)

-- Functions

local function Fire<T...>(self: Types.EventServer<T...>, recipient: Player, ...: T...)
	self._Fire(recipient, self._Identifier, table.pack(...))
end

local function FireNow<T...>(self: Types.EventServer<T...>, recipient: Player, ...: T...)
	self._FireNow(recipient, self._Identifier, table.pack(...))
end

local function FireAll<T...>(self: Types.EventServer<T...>, ...: T...)
	for _, recipient in PlayerService:GetPlayers() do
		self._Fire(recipient, self._Identifier, table.pack(...))
	end
end

local function FireExcept<T...>(self: Types.EventServer<T...>, except: Player | { Player }, ...: T...)
	if type(except) == "table" then
		for _, player in PlayerService:GetPlayers() do
			if table.find(except, player) then
				continue
			end
			self._Fire(player, self._Identifier, table.pack(...))
		end
		return
	end

	for _, player in PlayerService:GetPlayers() do
		if player == except then
			continue
		end
		self._Fire(player, self._Identifier, table.pack(...))
	end
end

local function FireFilter<T...>(self: Types.EventServer<T...>, filter: (Player) -> boolean, ...: T...)
	for _, recipient in PlayerService:GetPlayers() do
		if filter(recipient) then
			self._Fire(recipient, self._Identifier, table.pack(...))
		end
	end
end

local function Listen<T...>(self: Types.EventServer<T...>, listener: (sender: Player, T...) -> (), validTypes: { string }?)
	assert(listener, "Must provide a listener")
	Server.Listen(self._Identifier, function(sender, args)
		if (self._Ratelimit and self._InvokeOverflow) and not self._Ratelimit(sender) then
			self._InvokeOverflow(sender)
			return
		end

		if validTypes then
			for index, value in args do
				if typeof(value) ~= validTypes[index] then
					if self._OnInvalidType then
						self._OnInvalidType(sender)
						return
					end
					warn(`Argument #{index} does not match the type '{validTypes[index]}'`)
					return
				end
			end
		end

		listener(sender, table.unpack(args))
	end)
end

local function SetInvalidTypeCallback<T...>(
	self: Types.EventServer<T...> & Types.FunctionServer<T...>,
	callback: (sender: Player) -> ()
)
	self._OnInvalidType = callback
end

local function SetRateLimit<T...>(
	self: Types.EventServer<T...> & Types.FunctionServer<T...>,
	maxCalls: number,
	resetInterval: number?,
	overflowCallback: ((sender: Player) -> ())?
)
	if maxCalls <= -1 then
		self._Ratelimit = nil
		self._InvokeOverflow = nil
	end

	if not (resetInterval and overflowCallback) then
		return
	end

	self._Ratelimit = Ratelimit(maxCalls, resetInterval or 1)
	self._InvokeOverflow = overflowCallback
end

local function OnInvoke<T...>(
	self: Types.FunctionServer<T...>,
	callback: (sender: Player, T...) -> T...,
	validTypes: { string }?
)
	assert(callback, "Must provide a callback")
	Server.Listen(self._Identifier, function(sender, args)
		if (self._Ratelimit and self._InvokeOverflow) and not self._Ratelimit(sender) then
			self._InvokeOverflow(sender)
			return
		end

		local CallId = table.remove(args, 1)

		if type(CallId) ~= "string" then
			return
		end

		if validTypes then
			for index, value in args do
				if typeof(value) ~= validTypes[index] then
					if self._OnInvalidType then
						self._OnInvalidType(sender)
						return
					end
					warn(`Argument #{index} does not match the type '{validTypes[index]}'`)
					return
				end
			end
		end

		task.spawn(function(player: Player, callId: string, ...: any)
			Server.SendReliableBatchedCallReturn(player, callId, table.pack(callback(player, ...)))
		end, sender, CallId, table.unpack(args))
	end)
end

-- Module

return {
	Fire = Fire,
	FireNow = FireNow,
	FireAll = FireAll,
	FireExcept = FireExcept,
	FireFilter = FireFilter,

	Listen = Listen,

	SetRateLimit = SetRateLimit,
	SetInvalidTypeCallback = SetInvalidTypeCallback,

	OnInvoke = OnInvoke,
}
