# Events

Creating events is arguably the most important part of the entire library, and most useful obviously.

## Firing

There are many functions for firing that come with the package already. These include:

- `Fire`
- `FireNow`
- `FireAll`
- `FireExpect`
- `FireFilter`

The difference between `Fire` and `FireNow` is a bit complicated but it will be extremely important to pick the correct when later during development.

For one, `Fire` will batch all of your calls into one single `RemoteEvent:Fire` call. A result of this is that all of your calls will be recieved by the server or client at the exact same time if called on the same frame. This can lead to issues like race conditions if you have a system that requires precision and relies on an event be called first. `FireNow` does not batch the calls, and will simply just send the call as soon as possible. This way, the order you sent the packets in will still persist on the other side. The downside of using this is that there is no optimization for this, so use it sparingly and only when needed!

A quick example of firing an event is as follows:

### Client

```luau
local Net = require(Packages.net).Client
local MyEvent = Net.Event("MyEvent")

MyEvent:Fire("Hello server")
MyEvent:FireNow("Hello server")
```

### Server

```luau
local Net = require(Packages.net).Server
local MyEvent = Net.Event("MyEvent")
local Player = game.Players:WaitForChild("Someone")

MyEvent:Fire(Player, "Hello client")
MyEvent:FireNow(Player, "Hello client")

-- Server exclusive
MyEvent:FireAll("Hello client")
MyEvent:FireExcept(Player, "Hello client")
MyEvent:FireFilter("Hello client", function(player)
    if player:IsA("Player") then
        return true
    else
        return false
    end
end)
```

## Listening

Listening will persist the same across both the client and server. The only difference is that there is an additional `sender` argument on the server callback. Here's an example of how both would work.

### Client

```luau
local Net = require(Packages.net).Client
local MyEvent = Net.Event("MyEvent")

MyEvent:Listen(function(arg)
    print(arg)
end)
```

### Server

```luau
local Net = require(Packages.net).Server
local MyEvent = Net.Event("MyEvent")

MyEvent:Listen(function(sender, arg)
    print(sender.DisplayName, arg)
end)
```
