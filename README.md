# The small GUI libary

# introducing the small gui libary its the most compact gui libary that i created


## booting the libary up 

This line of code is important so you stick this to your script
```lua
local SmallGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Small-Gui-libary-/refs/heads/main/Source.lua"))()
```

## Creating Window

```lua



local gui = SmallGUI.new("example")

```

## Creating Tab

```lua 

gui:addTab("Main")



```

## adding buttons

```lua

gui:addButtonToTab("Main", "Click Me", Color3.fromRGB(150, 150, 150), function()
    print("Clicked!")
end)

```

