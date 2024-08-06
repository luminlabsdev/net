local Packages = game:GetService("ReplicatedStorage").Packages
local NetClient = require(Packages.lumin_net).Client

local MyEvent = NetClient.Event("HI")

MyEvent:Fire("wsg bruh")
MyEvent:Listen(function(mystuff)
    print(mystuff)
end)
