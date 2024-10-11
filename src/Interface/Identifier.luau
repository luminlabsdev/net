-- Forked from red-blox/Red

-- Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent.Parent
local NetFolder = ReplicatedStorage:WaitForChild("Net")
local Reliable = NetFolder:WaitForChild("Reliable")

local Debugger = require(Packages.debugger)

local NextShared = 0
local NextUnique = 0

-- Functions

local function UInt(num: number): any
	return string.pack(`I{math.ceil(math.log(num + 1, 2) / 8)}`, num)
end

local function Shared(name: string)
	if RunService:IsServer() then
		if Reliable:GetAttribute(name) then
			return Reliable:GetAttribute(name)
		else
			NextShared += 1
			local Id = UInt(NextShared)
			Reliable:SetAttribute(name, Id)
			return Id
		end
	else
		local Delay = task.delay(5, function()
            Debugger.Warn("NoIdentifier", name)
		end)

		while not Reliable:GetAttribute(name) do
			Reliable.AttributeChanged:Wait()
		end

		task.cancel(Delay)
		return Reliable:GetAttribute(name)
	end
end

local function Exists(name: string): boolean
	return RunService:IsServer() and Reliable:GetAttribute(name) ~= nil
end

local function Unique(): any
	NextUnique += 1
	if NextUnique == 0xFFFF then
		NextUnique = 0
	end
	return UInt(NextUnique)
end

return {
	Shared = Shared,
	Exists = Exists,
	Unique = Unique,
}
