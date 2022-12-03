# Documentation
Exec UI Library

## Loading the Library
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/Exec-UI-Library/main/src.lua'))()
```

## Creating a Window
```lua
local Window = Library:Window({
	Name = <title : string>, 
	Creator = <name : string>,
	Script = <name : string>,
	Hotkey = {
		Key = <keycode : EnumItem>, 
		Enabled = <boolean>
	}
	Saves = {
		FileId = <name : string>,
		Enabled = <boolean>
	}
	Sounds = <boolean>
})
```

## Creating a Tab
```lua
local Tab = Window:AddTab{
	Name = <text : string>,
	TextColor3 = <Color3>,
}
```

## Creating a Left Section
```lua
local LeftSection = Tab:LeftSection(<name : string>)
```
## Creating a Right Section
```lua
local RightSection = Tab:RightSection(<name : string>)
```

## Creating a Notification
```lua
Library:Notification({
	Title = <header : string>,
	Content = <description : string>,
	Time = <duration : number>
})
```

## Creating a Button
```lua
LeftSection:AddButton({
	Text = <name : string>,
	TextColor = <Color3>,
	Callback = <function>,
})
```
You need to state your element as a variable to get its methods, Example: ``` local Button = Section:AddButton{} ```

#### Methods
```lua
Button:Set(<string>)
Button:Destroy()
```

## Creating a toggle
```lua
Section:AddToggle({
	Text = <name : string>,
	TextColor = <Color3>,
	Default = <boolean>,
	Callback = <function>
})
```

#### Methods
```lua
Toggle:Set(<boolean>)
Toggle:Destroy()
```

## Creating a Slider
```lua
Section:AddSlider({
	Text = "Name",
	Min = 0,
	Max = 200,
	Default = 16,
	Color = Color3.fromRGB(85, 170, 255),
	Callback = function(Value)
		print(Value)
	end
})
```

### Change Slider Value
```lua
Slider:Set(2)
```

## Creating a Textbox
```lua
Section:AddTextBox({
	Text = "Name",
	Default = "16",
	Callback = function(Value)
		print(Value)
	end
})

```


## Creating a Keybind
```lua
Section:AddBind({
	Text = "Name",
	Default = Enum.KeyCode.E,
	Callback = function(Value)
		print("Pressed "..Value.Name)
		-- do stuff
	end    
})
```

### Changing the value of a bind
```lua
Bind:Set(Enum.KeyCode.E)
```


## Creating a Dropdown menu
```lua
Section:AddDropDown({
	Text = "Select Option",
	Default = "16",
	Options = {16, 200},
	Callback = function(Value)
		print(Value)
	end
})
```

### Adding a set of new Dropdown buttons to an existing menu
```lua
Dropdown:Refresh(List<table>, true)
```

The above boolean value "true" is whether or not the current buttons will be deleted.

### Selecting a dropdown option
```lua
Dropdown:Set("dropdown option")
```

## Miscellaneous

### Adding Keys
Keys are used as global variables to store (Values, Tables etc.) Toggles, Sliders, Dropdowns & binds. Filesystem not yet implemented.
Example:
```lua
Tab:AddToggle({
    Name = "Toggle",
    Default = true,
    Key = "toggle"
})
```
#### Methods
```lua
print(Library:Get("toggle"))
```

### Destroy a Window
```lua
Library:Destroy()
```
