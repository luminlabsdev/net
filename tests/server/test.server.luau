local Packages = game:GetService("ReplicatedStorage").Packages
local NetServer = require(Packages.net).Server

local MyEvent = NetServer.Event("HI", true, {"number"})

MyEvent:SetMiddleware({
    Dropped = function(value)
        print(value, "is wrong LOL")
    end
})


MyEvent:Listen(function(plr, stuff)
	print(plr, stuff)
end)

task.wait(10)
MyEvent:FireAll("from the server :P")
