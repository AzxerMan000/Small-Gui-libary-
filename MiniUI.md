## MINI GUI LIBARY 

the mini gui is a 2nd gui from the smuggle ui or refrence as the rayfield or the arrayfield.

## Booting The libary

this is the main thing if you wanna create a libary
```lua

Local MiniUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/AzxerMan000/Mini-Gui-libary-/refs/heads/main/Source.lua"))()

```

## Creating the Gui (with key system too!)

```lua

local ui = MiniUI:CreateWindow({
    Title = "Example",
    RequireKey = true,              -- Enable key system
    Key = "letmeinpls",             -- Correct key string
    GetKeyURL = "https://mykeylink.com"
})

```

## Creating tabs for buttons and toggles

main thing if you dont have it you cannot load buttons and toggles.

```lua

local tab = ui:CreateTab("example")

```
## adding  buttons

adding buttons is main thing for your script hub

```lua

ui:CreateButton(tab, "Click Me", function()
    print("Button clicked!")
end)

```

## adding toggles

this is optional so you can add whenever you want

```lua

ui:CreateToggle(tab, "Toggle Me", function()
  print("example")
end)

```


## END)






