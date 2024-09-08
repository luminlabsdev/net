# Ratelimiting

The ratelimit feature is built in to every single event and allows you to specify a specific amount of packets that the server should recieve from the client per time interval.

## Usage

The usage of the ratelimiting function is very simple. An example is shown below with commenting.

```luau
local Net = require(Packages.net).Server
local MyEvent = Net.Event("MyEvent")

MyEvent:Listen(function()
    print("Prints 1 time every 10 seconds")
end)

-- First number is the max calls per interval
-- Second number is the interval
MyEvent:SetRateLimit(1, 10, function(sender)
    print(sender.DisplayName, "is sending too many requests")
end)
```
