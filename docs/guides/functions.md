# Functions

Functions are similar to how RemoteFunctions work and also act as a better way to perform tasks where the server returns data back to the client in a call.

## Invoking

Invoking is done on the client, and it returns a Future. Typically, you would wait for the Future to complete the job and to get the value. Here's an example using `Await`.

```luau
local Net = require(Packages.net).Client
local MyFunction = Net.Function("MyFunction")
local Response = MyFunction:InvokeAsync("Hi"):Await()

print(Response) -- Output: Goodbye
```

## Listening To Invocation

When listening to an invocation you must return a value. This is what happens on the server, and if you don't return a value it defeats the purpose of using a function. Use an event instead for this purpose!

```luau
local Net = require(Packages.net).Client
local MyFunction = Net.Function("MyFunction")

MyFunction:OnInvoke(function(sender, data)
    if data == "Hi" then
        return "Goodbye"
    end
    return "Huh?"
end)
```
