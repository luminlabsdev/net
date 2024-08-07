local Packages = game:GetService("ReplicatedStorage").Packages
local NetServer = require(Packages.lumin_net).Server

local MyEvent = NetServer.Event("HI")

MyEvent:Listen(function(plr, stuff)
    print(plr, stuff)
end)

MyEvent:SetRateLimit(2, 4, function(sender)
    print(sender.DisplayName, "stop doing that!!!!")
end)

task.wait(10)
MyEvent:FireAll("from the server :P")
