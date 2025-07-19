# The small GUI libary

# introducing the small gui libary its the most compact gui libary that i created


## booting the libary up 

This line of code is important so you stick this to your script
```lua
local SmallGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Small-Gui-libary-/refs/heads/main/Source.lua"))()
```

## Creating Window

```lua

local SmallGUI = SmallGUI.new("My Small GUI")
```

## Creating Tab

```lua 


local main = SmallGUI.new("My Menu")


```

## adding buttons

```lua

myGui:addButtonToTab("Main", "Reset GUI", Color3.fromRGB(255, 85, 85), function()
    print("hello world!")
end)

```

