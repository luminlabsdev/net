local Packages = game:GetService("ReplicatedStorage").Packages
local NetClient = require(Packages.lumin_net).Client

local MyEvent = NetClient.Event("HI")

MyEvent:Listen(function(mystuff)
    print(mystuff)
end)

while true do
    task.wait(1)
    MyEvent:Fire("from the client :P")
end
