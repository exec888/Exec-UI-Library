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
___

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
LeftSection:AddToggle({
	Text = <name : string>,
	TextColor = <Color3>,
	Default = <boolean>,
	Callback = <function> <returns : boolean>
})
```

#### Methods
```lua
Toggle:Set(<boolean>)
Toggle:Destroy()
```

## Creating a Slider
```lua
LeftSection:AddSlider({
	Text = <name : string>,
	TextColor = <Color3>,
	Default = <number>,
	Min = <number>,
	Max = <number>,
	Increment = <number>,
	Callback = <function> <returns : number>
})
```

#### Methods
```lua
Slider:Set(<number>)
Slider:Destroy()
```

## Creating a Textbox
```lua
LeftSection:AddTextBox({
	Text = <name : string>,
	TextColor = <Color3>,
	PressEnter = <boolean>,
	ClearOnFocus <boolean>,
	Default = <boolean>,
	Callback = <function> <returns : string>
})

```

#### Methods
```lua
Input:Set(<string>)
Input:Destroy()
```

## Creating a Keybind
```lua
LeftSection:AddBind({
	Text = <name : string>,
	TextColor = <Color3>,
	Default = <Keycode : EnumItem>
	Hold = <boolean>,
	Callback = <function> <returns : <string> <holding : boolean>
})
```

#### Methods
```lua
Bind:Set(Enum.KeyCode.E)
Bind:Destroy()
```


## Creating a Dropdown
```lua
LeftSection:AddDropDown({
	Text = "Select Option",
	Default = "16",
	Options = {16, 200},
	Callback = function(Value)
		print(Value)
	end
})
```

#### Methods
```lua
Dropdown:Refresh(<list : table>, <clear : boolean>)
Dropdown:Remove(<index>)
Dropdown:Set(<index>)
```

## Miscellaneous

### Adding Flags
Flags are used as global variables to store (Values, Tables etc.) Toggles, Sliders, Dropdowns & binds. Filesystem not yet implemented.
Example:
```lua
LeftSection:AddToggle({
    Name = "Toggle",
    Default = true,
    Flag = "toggle"
})
```
#### Methods
```lua
Library:Get(<Flag : string>)
<returns value>
```

### Library Methods
```lua
Library:Destroy()
Library:UpdateTheme()
```

### Library Config
```lua
Library.Keys <table : dict>
Library.Theme <table : dict>
Library.Logs <table : array>
Library.Config <table : dict>
