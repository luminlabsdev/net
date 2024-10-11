-- Variables

local RunService = game:GetService("RunService")

local Identifier = require(script.Identifier)
local Storage = require(script.Storage)
local Network = script.Parent.Network

local RunContext = if RunService:IsServer() then "Server" else "Client"

local InterfaceModules = {
	Client = require(Network.Client),
	Server = require(Network.Server),
}

local InterfaceIndexes = {
	Client = { __index = require(script.Client) },
	Server = { __index = require(script.Server) },
}

-- Functions

-- Use the same contstructor for all events; the Event and Function functions are returned for type checking purposes
local function new(name: string, reliable: boolean?, types: { string }?)
	local self = setmetatable({}, InterfaceIndexes[RunContext])

	-- Check the storage to see if we can re-reference an object
	if Storage[name] then
		return Storage[name]
	else
		Storage[name] = self
	end

    self.Id = Identifier.Shared(name)
    self.Reliable = true
    self._Middleware = {}

    if reliable ~= nil then
        self.Reliable = reliable
    end

    if types then
        self._Types = types
    end

	-- Set explicit calls so we don't waste performance later
	self._Fire = if self.Reliable
		then InterfaceModules[RunContext].SendReliableBatched
		else InterfaceModules[RunContext].SendUnreliable
	self._FireNow = if self.Reliable
		then InterfaceModules[RunContext].SendReliable
		else InterfaceModules[RunContext].SendUnreliable

	return self
end

-- Module

return {
	Event = new,
	Async = new,
}
