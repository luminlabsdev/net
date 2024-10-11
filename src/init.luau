local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Network = script.Network
local Packages = script.Parent
local Types = require(script.Types)
local Logs = require(script.Logs)
local Debugger = require(Packages.debugger)

Debugger.SetLogs(Logs)
Debugger.SetMetadata({
    PackageURL = "https://luminlabsdev.github.io/net/",
    PackageName = "Net",
})

if RunService:IsServer() then
	if not ReplicatedStorage:FindFirstChild("Net") then
		local NetFolder = Instance.new("Folder")
		NetFolder.Name = "Net"
		NetFolder.Parent = ReplicatedStorage

		local Reliable = Instance.new("RemoteEvent")
		Reliable.Name = "Reliable"
		Reliable.Parent = NetFolder

		local Unreliable = Instance.new("UnreliableRemoteEvent")
		Unreliable.Name = "Unreliable"
		Unreliable.Parent = NetFolder
	end
	require(Network.Server).Init()
else
	require(Network.Client).Init()
end

local Interface = require(script.Interface)

return {
	Client = Interface,
	Server = Interface,
} :: {
	Client: {
		Event: Types.Constructor<Types.EventClient<...any>>,
		Async: Types.Constructor<Types.AsyncClient<...any>>,
	},
	Server: {
		Event: Types.Constructor<Types.EventServer<...any>>,
		Async: Types.Constructor<Types.AsyncServer<...any>>,
	},
}
