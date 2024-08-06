-- Forked from red-blox/Red

-- Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Promise = require(script.Parent.Parent.Parent.promise)

local NetFolder = ReplicatedStorage:WaitForChild("Net")
local Reliable = NetFolder:WaitForChild("Reliable")

local NextShared = 0
local NextUnique = 0

-- Functions

local function UInt(num: number): any
    return string.pack(`I{math.ceil(math.log(num + 1, 2) / 8)}`, num)
end

local function Shared(name: string): Promise.TypedPromise<any>
    return Promise.new(function(resolve)
        if RunService:IsServer() then
            if Reliable:GetAttribute(name) then
                resolve(Reliable:GetAttribute(name))
            else
                NextShared += 1
                local Id = UInt(NextShared)
                Reliable:SetAttribute(name, Id)
                resolve(Id)
            end
        else
            local Delay = task.delay(5, function()
                warn(`Infinite yield possible on identifier '{name}'`)
            end)

            while not Reliable:GetAttribute(name) do
                Reliable.AttributeChanged:Wait()
            end

            task.cancel(Delay)
            resolve(Reliable:GetAttribute(name))
        end
    end)
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