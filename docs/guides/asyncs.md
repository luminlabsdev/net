# Asyncs

Asyncs are similar to how RemoteFunctions work and also act as a better way to perform tasks where the server returns data back to the client in a call.

## Requesting

Requesting is done on the client. Calling this method will yield the thread until the value is resolved.

```luau
local Net = require(Packages.net).Client
local MyAsync = Net.Async("MyAsync")
local Response = MyAsync:Request("Hi")

print(Response) -- Output: Goodbye
```

## Listening To Request

When listening to a request you must return a value. This is what happens on the server, and if you don't return a value it defeats the purpose of using a async. Use an event instead for this.

```luau
local Net = require(Packages.net).Client
local MyAsync = Net.Async("MyAsync")

MyAsync:OnRequest(function(sender, data)
    if data == "Hi" then
        return "Goodbye"
    end
    return "Huh?"
end)
```
