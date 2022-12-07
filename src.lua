_G.Version = "2B"
local Library = {
	Flags = {},
	Logs = {},
	Config = {
		Name = "ExecLib",
		Script = "Script",
		Creator = "Player",
		Hotkey = {
			Enabled = true,
			Key = Enum.KeyCode.Semicolon,
		},
		Saves = {
			Folder = "raw",
			Enabled = true,
		},
		Sounds = true,
	},
	Theme = {
		Primary = {
			Objects = {},
			Color = Color3.fromRGB(33, 37, 41),
		},
		Secondary = {
			Objects = {},
			Color = Color3.fromRGB(52, 58, 64),
		},
		Tertiary = {
			Objects = {},
			Color = Color3.fromRGB(73, 80, 87),
		},
		Accent = {
			Objects = {},
			Color = Color3.fromRGB(85, 170, 255),
		},
		Text = {
			Objects = {},
			Color = Color3.fromRGB(255, 255, 255),
		},
		PlaceholderText = {
			Objects = {},
			Color = Color3.fromRGB(150,150,150),
		}
	},

}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/Player788/luau1/main/lib.lua"))()
local Create = Utils.Create
local Headshot = Utils.Headshot
local UserId = Utils.GetUserId
local Date = Utils.Date
local Tween = Utils.Tween
local MouseHover = Utils.MouseHover
local BoolToString = Utils.BoolToString
local toJSON = Utils.toJSON
local toTable = Utils.toTable
local EnumToString = Utils.EnumToString
local Drag = Utils.Drag
local OnClick = Utils.Click

local Exec = game:GetObjects("rbxassetid://11700753328")[1]
local Main = Exec.MainT Drag(Main.TopT, Main) 
local NoteFrame = Exec.Noties
local Elements = Main.Elements
local TabButton = Elements.TabButtonT
local TabScrollFrame = Elements.TabElementsScroll
local LeftGroup = Elements.Left
local RightGroup = Elements.Right
local Section = Elements.Section
local Button = Elements.Button
local ToggleButton = Elements.Toggle
local InputBox = Elements.Input
local KeybindButton = Elements.Keybind
local SliderButton = Elements.Slider
local ColorpickerButton = Elements.Colorpicker
local DropdownButton = Elements.Dropdown
local OptionFrame = Elements.OptionFrame

local BlacklistedKeys = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.Escape}

if syn then
	syn.protect_gui(Exec)
	Exec.Parent = game.CoreGui
elseif gethui then
	Exec.Parent = gethui()
elseif not game:GetService("RunService"):IsStudio() then
	Exec.Parent = game.CoreGui
else
	Exec.Parent = game.Players.LocalPlayer.PlayerGui
end

function Library:Save()
	local Data = {}
	for i,v in pairs(Library.Flags) do
		if v.Type == "Colorpicker" then
			Data[i] = {R = v.Value.R * 255, G = v.Value.G * 255, B = v.Value.B * 255}
		elseif v.Type == "Bind" then
			Data[i] = v.Value.Name
		else
			Data[i] = v.Value
		end
	end
	writefile(Library.Config.Saves.Folder .. "/" .. game.GameId .. ".txt", tostring(HttpService:JSONEncode(Data)))
end
function Library:Load()
	if isfile(Library.Config.Saves.Folder .. "/" .. game.GameId .. ".txt") then
		local file = readfile(Library.Config.Saves.Folder .. "/" .. game.GameId .. ".txt")
		local Data = HttpService:JSONDecode(file)
		for i,v in pairs(Data) do
			if Library.Flags[i] then
				spawn(function() 
					if Library.Flags[i].Type == "Colorpicker" then
						Library.Flags[i]:Set(Color3.fromRGB(v.R, v.G, v.B))
					elseif Library.Flags[i].Type == "Bind" then
						Library.Flags[i]:Set(Enum.KeyCode[v])
					else
						Library.Flags[i]:Set(v)
					end    
				end)
			else
				Warn("Filesystem could not find flag '" .. i .."'")
			end
		end
		Library:Notification{Content = "Save loaded!"}
	end
end

function ThemeObj(Table, GuiObject)
	table.insert(Library.Theme[Table].Objects, GuiObject)
end
function Library:UpdateTheme()
	for _, nextTheme in pairs(Library.Theme) do
		for _, object in pairs(nextTheme.Objects) do
			if object:IsA("Frame") then
				object.BackgroundColor3 = nextTheme.Color
			elseif object:IsA("TextButton") then
				object.TextColor3 = Library.Theme.Text.Color
				object.BackgroundColor3 = Library.Theme.Secondary.Color
			elseif object:IsA("TextBox") then
				object.PlaceholderColor3 = Library.Theme.PlaceholderText.Color
				object.TextColor3 = Library.Theme.Text.Color
				object.BackgroundColor3 = Library.Theme.Secondary.Color
			elseif object:IsA("TextLabel") then
				object.BackgroundColor3 = nextTheme.Color
			elseif object:IsA("ScrollingFrame") then
				object.BackgroundColor3 = nextTheme.Color
			end
		end
	end
end
function Index(Table, Key)
	for _, v in next, Table do
		if v == Key then
			return true
		end
	end
end
function Library:Notification(Table)
	wait(0.3)
	spawn(function()
		local Note = NoteFrame.Temp:Clone() Note.Parent = NoteFrame
		Note.BackgroundColor3 = Library.Theme.Primary.Color
		local Title = Note.TitleFrame.Title
		Note.TitleFrame.BackgroundColor3 = Library.Theme.Secondary.Color
		local Content = Note.ContentFrame.Content
		Note.BackgroundTransparency = 1
		Note.TitleFrame.BackgroundTransparency = 1
		Title.TextTransparency = 1
		Content.TextTransparency = 1
		Note.Visible = true
		local Time : number = Table.Time or 5
		Title.Text = Table.Title or Library.Config.Name
		Content.Text = Table.Content or "Description"
		Content.TextColor3 = Table.Color or Library.Theme.Text.Color
		Tween(Note, "BackgroundTransparency", 0)
		Tween(Note.TitleFrame, "BackgroundTransparency", 0)
		Tween(Note.TitleFrame.Title, "TextTransparency", 0)
		Tween(Note.ContentFrame.Content, "TextTransparency", 0)
		wait(Time)
		Tween(Note, "BackgroundTransparency", 1)
		Tween(Note.TitleFrame, "BackgroundTransparency", 1)
		Tween(Note.TitleFrame.Title, "TextTransparency", 1)
		local Final = Tween(Note.ContentFrame.Content, "TextTransparency", 1)
		Final.Completed:Wait()
		Note.Visible = false Note:Destroy()
	end)
end

function Library:Window(Table)
	Exec.Enabled = true
	ThemeObj("Primary", Main) ThemeObj("Secondary", Main.TopT)
	ThemeObj("Secondary", Main.ContainerT) ThemeObj("Primary", Main.ContainerT.ElementsT)
	ThemeObj("Primary", Main.ContainerT.TabsT)
	Library.Config.Name = Table.Name or Library.Config.Name
	Library.Config.Script = Table.Script or Library.Config.Script
	Library.Config.Creator = Table.Creator or Library.Config.Creator
	Library.Config.Sounds = Table.Sounds or Library.Config.Sounds
	if Table.Hotkey then
		Library.Config.Hotkey.Enabled = Table.Hotkey.Enabled or Library.Config.Hotkey.Enabled
		Library.Config.Hotkey.Key = Table.Hotkey.Key or Library.Config.Hotkey.Key
	end
	if Table.Saves then
		Library.Config.Saves.Enabled = Table.Saves.Enabled or Library.Config.Saves.Enabled
		Library.Config.Saves.Folder = Table.Saves.Folder or Library.Config.Saves.Folder
		if not isfolder(Library.Config.Saves.Folder) then
			makefolder(Library.Config.Saves.Folder)
		end	
	end

	Main.TopT.Title.Text = Library.Config.Name .. " | " .. Library.Config.Script

	local Tabs = {}
	local Selected
	function Tabs:AddTab(Table)
		local TabButton = TabButton:Clone(); TabButton.Parent = Main.ContainerT.TabsT.TabsScrollingFrame
		TabButton.Visible = true
		TabButton.Text:SetAttribute("Idle",Table.TextColor or Color3.fromRGB(155, 155, 155))
		TabButton.Text:SetAttribute("Active",Table.TextColor or Color3.fromRGB(255, 255, 255))
		TabButton.Text.TextColor3 = Table.TextColor or TabButton.Text.TextColor3
		TabButton.Text.Text = Table.Name or TabButton.Text.Text
		TabButton.Name = Table.Id or #Tabs+1
		table.insert(Tabs, TabButton)
		ThemeObj("Tertiary", TabButton) ThemeObj("Accent", TabButton.SelectT)

		local Selected = TabButton.Text:GetAttribute("Idle")

		local TabFrame = TabScrollFrame:Clone(); TabFrame.Parent = Main.ContainerT.ElementsT
		local LeftSection = LeftGroup:Clone(); LeftSection.Parent = TabFrame; LeftSection.Visible = true
		local RightSection = RightGroup:Clone(); RightSection.Parent = TabFrame; RightSection.Visible = true
		ThemeObj("Primary", LeftSection) ThemeObj("Primary", RightSection)

		local function onToggle()
			for _, v in next, Main.ContainerT.TabsT.TabsScrollingFrame:GetChildren() do
				if v:IsA("Frame") then
					v.SelectT.Visible = false
					Tween(v, "BackgroundTransparency", 1)
					Tween(v.Text, "TextTransparency", 0.5)
				end    
			end
			for _, v in next, Main.ContainerT.ElementsT:GetChildren() do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end    
			end
			Tween(TabButton, "BackgroundTransparency", 0)
			Tween(TabButton.Text, "TextTransparency", 0)
		
			TabFrame.Visible = true
			TabButton.SelectT.Visible = true   
			Selected = TabButton
		end

		local TabClick = OnClick({TabButton, 
			Callback = function()
				onToggle()
			end
		})
		TabClick.MouseEnter:Connect(function()
			Tween(TabButton.Text, "TextTransparency", 0)
		end); TabClick.MouseLeave:Connect(function()
			if Selected ~= TabButton then
				Tween(TabButton.Text, "TextTransparency", 0.5)
			end
		end)

		-- BUTTON
		local function AddButton(Table, Parent)
			local TextButton = {TextColor = Table.TextColor or Library.Theme.Text.Color, Callback = Table.Callback or function() end}
			local newButton = Button:Clone(); newButton.Parent = Parent
			newButton.Text.TextColor3 = TextButton.TextColor
			newButton.Text.Text = Table.Name or newButton.Text.Text
			newButton.Visible = true
			ThemeObj("Tertiary", newButton) ThemeObj("Text", newButton.Text)

			local Click = OnClick({newButton, 
				Callback  = function()
					local x,y = pcall(function()
						TextButton.Callback()
					end)
					if not x then Warn(y) end
				end
			})
			Click.BackgroundColor3 = Library.Theme.Accent.Color
			MouseHover(Click, "BackgroundTransparency", 0.9, 1)

			function TextButton:Set(Text)
				newButton.Text.Text = Text
			end
			function TextButton:Destroy()
				newButton:Destroy()
			end
			function TextButton:AddButton(Table)
				AddButton(Table, Parent)
				return TextButton
			end
			return TextButton
		end

		-- INPUT
		local function AddTextBox(Table, Parent)
			local TextBox = {
				Default = Table.Default or "",
				Value = Table.Placeholder or "Enter text", 
				Flag = Table.Flag or false,
				PressEnter = Table.PressEnter or false,
				ClearOnFocus = Table.ClearOnFocus or false,
				TextColor = Table.TextColor or Library.Theme.Text.Color,
				Callback = Table.Callback or function() end
			}

			local newInput = InputBox:Clone(); newInput.Parent = Parent
			newInput.Text.TextColor3 = TextBox.TextColor
			newInput.Visible = true
			newInput.Text.Text = Table.Name or newInput.Text.Text
			newInput.TextBox.ClearTextOnFocus = TextBox.ClearOnFocus
			newInput.TextBox.PlaceholderText = TextBox.Value newInput.TextBox.Text = TextBox.Default 
			ThemeObj("Tertiary", newInput) ThemeObj("PlaceholderText", newInput.TextBox)
			ThemeObj("Text", newInput.Text)

			local Click = OnClick({newInput, 
				Callback  = function()
					newInput.TextBox:CaptureFocus()
				end
			})
			Click.BackgroundColor3 = Library.Theme.Accent.Color
			MouseHover(Click, "BackgroundTransparency", 0.9, 1)

			newInput.TextBox.FocusLost:Connect(function(enterPressed, v)
				if TextBox.PressEnter and enterPressed then
					local x,y = pcall(function()
						TextBox.Callback(newInput.TextBox.Text)
					end)
					if not x then Warn(y) end
				elseif not TextBox.PressEnter then
					local x,y = pcall(function()
						TextBox.Callback(newInput.TextBox.Text)
					end)
					if not x then Warn(y) end
				end

			end)

			function TextBox:Set(Text)
				newInput.TextBox.Text = Text
				TextBox.Callback(newInput.TextBox.Text)
			end
			function TextBox:Destroy()
				newInput:Destroy()
			end
			function TextBox:AddTextBox(Table)
				AddTextBox(Table, Parent)
				return TextBox
			end
			return TextBox
		end

		-- TOGGLE
		local function AddToggle(Table, Parent)
			local Toggle = {
				Value = Table.Default or false, 
				Flag = Table.Flag or false, 
				TextColor = Table.TextColor or Library.Theme.Text.Color,
				Callback = Table.Callback or function() end,
				Type = "Toggle",
			}
			
			local newToggle = ToggleButton:Clone(); newToggle.Parent = Parent
			newToggle.Text.TextColor3 = Toggle.TextColor
			newToggle.Visible = true
			newToggle.Text.Text = Table.Text or newToggle.Text.Text
			ThemeObj("Tertiary", newToggle) ThemeObj("Text", newToggle.Text)
			ThemeObj("Secondary", newToggle.TextButton)

			local Click = OnClick({newToggle})
			Click.BackgroundColor3 = Library.Theme.Accent.Color
			MouseHover(Click, "BackgroundTransparency", 0.9, 1)

			function Toggle:Set(Boolean)
				Toggle.Value = Boolean
				if Boolean then
					Tween(newToggle.TextButton, "BackgroundColor3", Library.Theme.Accent.Color)
				elseif not Boolean then
					Tween(newToggle.TextButton, "BackgroundColor3", Library.Theme.Secondary.Color)
				end
				local x,y = pcall(function()
					Toggle.Callback(Toggle.Value)
				end)
				if not x then Warn(y) end
			end
			Toggle:Set(Toggle.Value)
			function Toggle:Destroy()
				newToggle:Destroy()
			end
			function Toggle:AddToggle(Table)
				AddToggle(Table, Parent)
				return Toggle
			end
			newToggle.TextButton.Activated:Connect(function()
				Toggle:Set(not Toggle.Value)
				if Table.Flag and Library.Config.Saves.Enabled == true then
					Library:Save()
				end
			end)
			if Table.Flag and Library.Config.Saves.Enabled == true then				
				Library.Flags[Toggle.Flag] = Toggle
			end
			return Toggle
		end

		-- BIND
		local function AddBind(Table, Parent)
			local Keybind = {
				Value = Table.Default or Enum.KeyCode.LeftAlt, 
				Flag = Table.Flag or false,
				Hold = Table.Hold or false,
				TextColor = Table.TextColor or Library.Theme.Text.Color,
				Callback = Table.Callback or function() end,
				Type = "Bind"
			}
			
			local newBind = KeybindButton:Clone(); newBind.Parent = Parent
			newBind.Text.TextColor3 = Keybind.TextColor
			newBind.Text.Text = Table.Name or newBind.Text.Text
			newBind.Visible = true
			ThemeObj("Tertiary", newBind) ThemeObj("Text", newBind.Text)
			ThemeObj("Text", newBind.Input)

			local Click = OnClick({newBind})
			Click.BackgroundColor3 = Library.Theme.Accent.Color
			MouseHover(Click, "BackgroundTransparency", 0.9, 1)

			local Focus = false
			local Holding = false

			newBind.Input.Activated:Connect(function()
				Focus = true
				newBind.Input.Text = "..."
			end)

			UserInputService.InputBegan:Connect(function(Input)
				if Focus and Input.UserInputType == Enum.UserInputType.Keyboard then
					Keybind:Set(Input.KeyCode)
					if Table.Flag and Library.Config.Saves.Enabled == true then
						Library:Save()
					end
				elseif not Focus and Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Keybind.Value then
					if Keybind.Hold then
						Holding = true
						local x,y = pcall(function()
							Keybind.Callback(Holding)
						end)
						if not x then Warn(y) end
					else
						local x,y = pcall(function()
							Keybind.Callback(Keybind.Value)
						end)
						if not x then Warn(y) end
					end
				end
			end)
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode == Keybind.Value then
					if Keybind.Hold and Holding then
						Holding = false
						local x,y = pcall(function()
							Keybind.Callback(Holding)
						end)
						if not x then Warn(y) end
					end
				end
			end)

			function Keybind:Set(EnumItem)
				if not Index(BlacklistedKeys, EnumItem) then
					Keybind.Value  = EnumItem
					newBind.Input.Text = EnumItem.Name
					Focus = false
					-- Save
				else
					newBind.Input.Text = Keybind.Value.Name
					Focus = false
					Warn(EnumItem.Name .. " is a blacklisted key, try another one.")
				end
			end
			function Keybind:Destroy()
				newBind:Destroy()
			end
			function Keybind:AddBind(Table)
				AddBind(Table, Parent)
				return Keybind
			end
			Keybind:Set(Keybind.Value)
			if Table.Flag and Library.Config.Saves.Enabled == true then				
				Library.Flags[Keybind.Flag] = Keybind
			end
			return Keybind

		end

		-- SLIDER
		local function AddSlider(Table, Parent)
			local Slider = {
				Min = Table.Min or 0,
				Max = Table.Max or Table.Default or 25,
				Value = Table.Default or Table.Max or 5,
				Flag = Table.Flag or false,
				TextColor = Table.TextColor or Library.Theme.Text.Color,
				Increment = Table.Increment or 1,
				Callback = Table.Callback or function() end,
			}
			
			local newSlider = SliderButton:Clone(); newSlider.Parent = Parent
			newSlider.Visible = true local Label = newSlider["1Label"] local Count = newSlider.Slider.TextBox
			Label.Text = Table.Name or Label.Text
			Label.TextColor3 = Slider.TextColor
			local SliderBar = newSlider.Slider.Bar
			SliderBar.Fill.BackgroundColor3 = Library.Theme.Accent.Color
			ThemeObj("Tertiary", newSlider.Slider) ThemeObj("Secondary", SliderBar) ThemeObj("Text", Label)
			ThemeObj("Accent", SliderBar.Fill) ThemeObj("PlaceholderText", newSlider.Slider.TextBox)

			local Click = OnClick({newSlider})
			Click.BackgroundColor3 = Library.Theme.Accent.Color
			MouseHover(Click, "BackgroundTransparency", 0.9, 1)

			local dragging = false
			newSlider.Slider.Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			newSlider.Slider.Bar.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			Count.FocusLost:Connect(function()
				Slider:Set(tonumber(Count.Text))
			end)
			newSlider.Slider.Bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local SizeScale = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					Slider:Set(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale)) 
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local SizeScale = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
					Slider:Set(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
					if Table.Flag and Library.Config.Saves.Enabled == true then
						Library:Save()
					end
				end
			end)
			local function Round(Number, Factor)
				local Result = math.floor(Number/Factor + (math.sign(Number) * 0.5)) * Factor
				if Result < 0 then Result = Result + Factor end
				return Result
			end
			function Slider:Set(Value)
				if typeof(Value) == "number" then
					if Value > self.Max then 
						Warn("'".. newSlider["1Label"].Text .. "' Value can't be greater than " .. self.Max)
						self:Set(Slider.Value)
						return
					elseif Value < self.Min  then
						Warn("'".. newSlider["1Label"].Text .. "' Value can't be less than " .. self.Min) 
						self:Set(Slider.Value)
						return
					end

					if Slider.Increment > 1 then
						self.Value = math.clamp(Round(Value, self.Increment), self.Min, self.Max)
					else
						self.Value = math.floor(Value)
					end
					Tween(newSlider.Slider.Bar.Fill, "Size", UDim2.fromScale((self.Value - self.Min) / (self.Max - self.Min), 1), "Out", "Quint", 0.1)
					Count.Text = self.Value
					local x,y = pcall(function()
						Slider.Value = self.Value
						Slider.Callback(self.Value)
					end)
					if not x then Warn(y) end
				else
					Warn("'".. newSlider["1Label"].Text .. "' Expected number got " .. tostring(typeof(Value)))
				end

			end
			function Slider:Destroy()
				newSlider:Destroy()
			end
			function Slider:AddSlider(Table)
				AddSlider(Table, Parent)
				return Slider
			end
			Slider:Set(Slider.Value)
			if Table.Flag and Library.Config.Saves.Enabled == true then				
				Library.Flags[Slider.Flag] = Slider
			end
			return Slider
		end

		-- DROPDOWN
		local function AddDropdown(Table, Parent)
			local Dropdown = {
				Options = Table.Options or {},
				Flag = Table.Flag or false,
				TextColor = Table.TextColor or Library.Theme.Text.Color,
				Callback = Table.Callback or function() end,
				Toggled = false,
				Type = "Dropdown"
			}
			if Table.Options then
				Dropdown.Value = Table.Value or Dropdown.Options[1] or false
			end
			
			local newdrop = DropdownButton:Clone(); newdrop.Parent = Parent
			local Label = newdrop["1Top"]["1Label"].Text
			Label.Text = Table.Name or Label.Text
			Label.TextColor3 = Dropdown.TextColor
			newdrop.Visible = true
			local Options = newdrop["3Options"]
			local OptTemp = OptionFrame
			local Input = newdrop["1Top"]["2ButtonBox"].TextBox
			local Button = newdrop["1Top"]["2ButtonBox"].TextButton
			ThemeObj("Tertiary", newdrop["1Top"]["2ButtonBox"]) ThemeObj("Text", Label)
			ThemeObj("Secondary", Options) ThemeObj("PlaceholderText", Input)

			local Click = OnClick({newdrop["1Top"]}) Click.BackgroundColor3 = Library.Theme.Accent.Color
			MouseHover(Click, "BackgroundTransparency", 0.9, 1)

			Button.ImageButton.Activated:Connect(function()
				Dropdown.Toggled = not Dropdown.Toggled
				Options.Visible = Dropdown.Toggled
				Tween(Button.ImageButton, "Rotation", Dropdown.Toggled and 0 or 180)
				for i, v in pairs(Options:GetChildren()) do
					if v:IsA("Frame") then
						v.Visible = true
					end
				end
			end)
			local function OnActivate(Option)
				if Dropdown.Value ~= false then
					if Index(Dropdown.Options, Option) then
						local x,y = pcall(function()
							Dropdown.Value = Option
							Dropdown.Callback(Option)
						end)
						if x then Input.Text = Option else Warn(y) end
					else
						OnActivate(Dropdown.Value)
						Warn("'" .. Label.Text .. "' " .. tostring(Option) .. " is not an available option to set")
					end
					Dropdown.Toggled = false
					Options.Visible = false
					Tween(Button.ImageButton, "Rotation", 180)
				end
			end
			Input.Focused:Connect(function()
				Dropdown.Toggled = true
				Options.Visible = true
				Tween(Button.ImageButton, "Rotation", 0)
			end)
			Input.FocusLost:Connect(function(enterPressed)
				if not enterPressed then return end
				if typeof(tonumber(Input.Text)) == "number" then
					OnActivate(tonumber(Input.Text))
					if Table.Flag and Library.Config.Saves.Enabled == true then
						Library:Save()
					end
				elseif typeof(Input.Text) == "string" then
					OnActivate(Input.Text)
					if Table.Flag and Library.Config.Saves.Enabled == true then
						Library:Save()
					end
				end
			end)
			Input.Changed:Connect(function()
				local Search = string.lower(Input.Text)
				for i, v in pairs(Options:GetChildren()) do
					if v:IsA("Frame") then
						if Search ~= "" then
							local Opt = string.lower(v.Text.Text)
							if string.find(Opt, Search) then
								v.Visible = true
							else
								v.Visible = false
							end
						else
							v.Visible = true
						end
					end
				end
			end)

			function Dropdown:Set(Option)
				OnActivate(Option)
			end
			Dropdown:Set(Dropdown.Value)
			function Dropdown:Remove(Option)
				if Index(Dropdown.Options, Option) then
					for index, v in pairs(Dropdown.Options) do
						if v == Option then
							table.remove(Dropdown.Options, index)
						end
					end
					Dropdown:Refresh(Dropdown.Options, true)
				else
					Warn("'" .. Label.Text .. "' " .. tostring(Option) .. " is not an available option to remove")
				end
			end
			local function CreateOpt(v)
				if typeof(v) == "number" then
					local newOp = OptTemp:Clone()
					ThemeObj("Secondary", newOp) ThemeObj("Text", newOp.Text)
					newOp.Parent = Options 
					newOp.Visible = true
					newOp.Text.Text = v
					newOp.Text.Activated:Connect(function()
						OnActivate(v)
						if Table.Flag and Library.Config.Saves.Enabled == true then
							Library:Save()
						end
					end)
				elseif typeof(v) == "string" then
					local newOp = OptTemp:Clone()
					ThemeObj("Secondary", newOp) ThemeObj("Text", newOp.Text)
					newOp.Parent = Options 
					newOp.Visible = true
					newOp.Text.Text = v
					newOp.Text.Activated:Connect(function()
						OnActivate(v)
						if Table.Flag and Library.Config.Saves.Enabled == true then
							Library:Save()
						end
					end)
				elseif typeof(v) == "boolean" then
					Warn("'" .. Label.Text .. "' cannot set boolean as option")
				end
			end
			function Dropdown:Refresh(List, clear)
				if clear then
					Dropdown.Options = List
					for _, v in pairs(Options:GetChildren()) do
						if v:IsA("Frame") then
							v:Destroy()
						end
					end
					for _, v in pairs(Dropdown.Options) do
						CreateOpt(v)
					end
				else
					for _, v in pairs(List) do
						table.insert(Dropdown.Options, v)
					end
					for _, v in pairs(Options:GetChildren()) do
						if v:IsA("Frame") then
							v:Destroy()
						end
					end
					for _, v in pairs(Dropdown.Options) do
						CreateOpt(v)
					end
				end
			end
			function Dropdown:Destroy()
				newdrop:Destroy()
			end
			function Dropdown:AddDropdown(Table)
				AddDropdown(Table, Parent)
				return Dropdown
			end
			Dropdown:Refresh(Dropdown.Options, true)
			if Table.Flag and Library.Config.Saves.Enabled == true then				
				Library.Flags[Dropdown.Flag] = Dropdown
			end
			return Dropdown
		end

		-- COLORPICKER
		local function AddColor(Table, Parent)
			local ColorH, ColorS, ColorV = 1, 1, 1
			local Colorpicker = {
				Value = Table.Default or Color3.fromRGB(85, 170, 127),
				Flag = Table.Flag or false, 
				TextColor = Table.TextColor or Library.Theme.Text.Color,
				Callback = Table.Callback or function() end,
				Toggle = false,
				Type = "Colorpicker"
			}
			
			local newColor = ColorpickerButton:Clone(); newColor.Parent = Parent
			newColor.Visible = true
			local Display = newColor["1ButtonDisplay"].Display
			local Label = newColor["1ButtonDisplay"].TextButton Label.Text = Table.Name or Label.Text
			local Color = newColor["2Colorpicker"].Color local ColorSelection = Color.ImageLabel
			local Hue = newColor["2Colorpicker"].Hue local HueSelection = Hue.Line
			ThemeObj("Tertiary", newColor["1ButtonDisplay"]) ThemeObj("Text", Label)
			ThemeObj("Secondary", newColor["2Colorpicker"])

			local Click = OnClick({newColor["1ButtonDisplay"], 
				Callback  = function()
					local x,y = pcall(function()
						newColor["2Colorpicker"].Visible = not newColor["2Colorpicker"].Visible
						ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
						ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
						ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
					end)
					if not x then Warn(y) end
				end
			})
			Click.BackgroundColor3 = Library.Theme.Accent.Color
			MouseHover(Click, "BackgroundTransparency", 0.9, 1)

			function Colorpicker:Set(Value)
				Colorpicker.Value = Value
				Display.BackgroundColor3 = Colorpicker.Value
				Colorpicker.Callback(Display.BackgroundColor3)
			end
			local function UpdateColorPicker()
				Display.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
				Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
				Colorpicker:Set(Display.BackgroundColor3)
				if Table.Flag and Library.Config.Saves.Enabled == true then				
					Library:Save()
				end
			end 

			local dragging
			Color.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)
			Color.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			Color.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
					local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
					ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
					ColorS = ColorX
					ColorV = 1 - ColorY
					UpdateColorPicker()
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
					local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
					ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
					ColorS = ColorX
					ColorV = 1 - ColorY
					UpdateColorPicker()
				end
			end)
			local dragging2
			Hue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging2 = true
				end
			end)
			Hue.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging2 = false
				end
			end)

			Hue.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)

					HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
					ColorH = 1 - HueY

					UpdateColorPicker()
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
					local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)

					HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
					ColorH = 1 - HueY

					UpdateColorPicker()
				end
			end)
			Colorpicker:Set(Colorpicker.Value)
			function Colorpicker:AddColor(Table)
				AddColor(Table, Parent)
				return Colorpicker
			end
			if Table.Flag and Library.Config.Saves.Enabled == true then				
				Library.Flags[Colorpicker.Flag] = Colorpicker
			end
			return Colorpicker
		end

		-- SECTIONS
		local Sections = {}
		function Sections:LeftSection(Name)
			local Elements = {}
			local NewSection = Section:Clone(); NewSection.Parent = LeftSection; NewSection.Visible = true
			NewSection["1SectionText"].Text.Text = Name or NewSection["1SectionText"].Text.Text
			ThemeObj("Accent", NewSection["1SectionText"].SelectT)
			function Elements:AddButton(Table)
				return AddButton(Table, NewSection["2Elements"])
			end
			function Elements:AddToggle(Table)
				return AddToggle(Table, NewSection["2Elements"])
			end
			function Elements:AddTextBox(Table)
				return AddTextBox(Table, NewSection["2Elements"])
			end
			function Elements:AddBind(Table)
				return AddBind(Table, NewSection["2Elements"])
			end
			function Elements:AddSlider(Table)
				return AddSlider(Table, NewSection["2Elements"])
			end
			function Elements:AddDropdown(Table)
				return AddDropdown(Table, NewSection["2Elements"])
			end
			function Elements:AddColor(Table)
				return AddColor(Table, NewSection["2Elements"])--Chain
			end
			return Elements
		end
		function Sections:RightSection(Name)
			local Elements = {}
			local NewSection = Section:Clone(); NewSection.Parent = RightSection; NewSection.Visible = true
			NewSection["1SectionText"].Text.Text = Name or NewSection["1SectionText"].Text.Text
			ThemeObj("Accent", NewSection["1SectionText"].SelectT)
			function Elements:AddButton(Table)
				return AddButton(Table, NewSection["2Elements"])
			end
			function Elements:AddToggle(Table)
				return AddToggle(Table, NewSection["2Elements"])
			end
			function Elements:AddTextBox(Table)
				return AddTextBox(Table, NewSection["2Elements"])
			end
			function Elements:AddBind(Table)
				return AddBind(Table, NewSection["2Elements"])
			end
			function Elements:AddSlider(Table)
				return AddSlider(Table, NewSection["2Elements"])
			end
			function Elements:AddDropdown(Table)
				return AddDropdown(Table, NewSection["2Elements"])
			end
			function Elements:AddColor(Table)
				return AddColor(Table, NewSection["2Elements"])
			end
			return Elements
		end
		return Sections

	end
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Library.Config.Hotkey.Key then
			if Library.Config.Hotkey.Enabled then
				Main.Visible = not Main.Visible
			end
		end	
	end)

	local Settings = Tabs:AddTab{Name = "Settings", Id = "Z"}
	Settings:LeftSection("Theme")
	:AddColor{
		Default = Library.Theme.Primary.Color,
		Name = "Primary",
		Callback = function(v)
			Library.Theme.Primary.Color = v
			Library:UpdateTheme()
		end,
	}:AddColor{
		Default = Library.Theme.Secondary.Color,
		Name = "Secondary",
		Callback = function(v)
			Library.Theme.Secondary.Color = v
			Library:UpdateTheme()
		end,
	}:AddColor{
		Default = Library.Theme.Tertiary.Color,
		Name = "Tertiary",
		Callback = function(v)
			Library.Theme.Tertiary.Color = v
			Library:UpdateTheme()
		end,
	}:AddColor{
		Default = Library.Theme.Accent.Color,
		Name = "Accent",
		Callback = function(v)
			Library.Theme.Accent.Color = v
			Library:UpdateTheme()
		end,
	}:AddColor{
		Default = Library.Theme.Text.Color,
		Name = "Text",
		Callback = function(v)
			Library.Theme.Text.Color = v
			Library:UpdateTheme()
		end,
	}:AddColor{
		Default = Library.Theme.PlaceholderText.Color,
		Name = "PlaceholderText",
		Callback = function(v)
			Library.Theme.PlaceholderText.Color = v
			Library:UpdateTheme()
		end,
	}
	local Info = Settings:RightSection("Info")
	Info:AddButton{Name = "Script By : " .. Library.Config.Creator}
	:AddButton{
		Name = "UI Library By : Player788", 
		Callback = function() 
			if typeof(setclipboard) == "function" then 
				setclipboard("https://github.com/Player788/Exec-UI-Library")
				Library:Notification{Content = "UI Source link copied to clipboard"}
			else
				Library:Notification{Content = "https://github.com/Player788/Exec-UI-Library"}
			end

		end,
	}
	local FPS = Info:AddButton{"Avg. FPS : "}
	local PING, ping = Info:AddButton{"Avg. PING : "}
	if not game:GetService("RunService"):IsStudio() then
		for a,v in pairs(game.CoreGui.RobloxGui.PerformanceStats:GetDescendants()) do
			if v:IsA("TextLabel") and v.Name == "TitleLabel" then
				if v.Text == "Ping" then
					ping = v.Parent.ValueLabel
				end
			end
		end
	end

	local TimeFunction = RunService:IsRunning() and time or os.clock
	local LastIteration, Start
	local FrameUpdateTable = {}
	local function HeartbeatUpdate()
		LastIteration = TimeFunction()
		for Index = #FrameUpdateTable, 1, -1 do
			FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
		end

		FrameUpdateTable[1] = LastIteration
		pcall(function()
			if not Exec then return end
			FPS:Set("Avg. FPS : " .. tostring(math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start))))
			if ping then PING:Set("Avg. PING : " .. ping.Text or 0) end	
		end)
	end
	Start = TimeFunction()
	RunService.Heartbeat:Connect(HeartbeatUpdate)
	local rbx_join = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/rbxscripts/main/roblox_join.lua'))()
	local Misc = Settings:RightSection("Misc")
	Misc:AddTextBox({
		Name = "Join Player",
		Placeholder = "UserId",
		Callback = function(userid)
			Library:Notification({Title = 'Join Player', Content = "Searching..."})
			local var = rbx_join.Join(userid)
			if var.Success then
				Library:Notification({Title = '<font color="rgb(85, 170, 127)">Join Player</font>', Content = var.Message})
			elseif not var.Success then
				Library:Notification({Title = '<font color="rgb(227, 67, 67)">Join Player</font>', Content = var.Message})
			end
		end
	})
	Misc:AddButton{Name = "Logs", 
		Callback = function()
			if typeof(setclipboard) == "function" then
				setclipboard(HttpService:JSONEncode(Library.Logs))
				Library:Notification{Content = "Logs copied to clipboard"}
			else
				for i, v in pairs(Library.Logs) do
					print("Log#"..i, v)
				end
				--print(HttpService:JSONEncode(Library.Logs))
				Library:Notification{Content = "Logs printed in output"}
			end
			
		end}
	Library:Notification({Content = "Loaded! \nUI: ExecLib v" .._G.Version})
	return Tabs
end

function Warn(T)
	Library:Notification({Title = "Error", Content = T, Color = Color3.fromRGB(255, 69, 69)})
	table.insert(Library.Logs, T)
end

function Library:Get(str)
	if not Library.Flags[str] then Warn("Key : " .. str .. " not found.") return end
	return Library.Flags[str].Value
end

function Library:Destroy()
	Exec:Destroy()
end

return Library
