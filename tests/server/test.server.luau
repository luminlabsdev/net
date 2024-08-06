local Packages = game:GetService("ReplicatedStorage").Packages
local PlayerService = game:GetService("Players")
local NetServer = require(Packages.lumin_net).Server

local MyEvent = NetServer.Event("HI")

MyEvent:Fire(PlayerService:WaitForChild("2jammers") ,"from the server :P")
MyEvent:Listen(function(mystuff)
    print(mystuff)
end)
