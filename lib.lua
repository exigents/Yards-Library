local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local Mouse = Player:GetMouse()

local viewport = workspace.CurrentCamera.ViewportSize
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local Library = {}

function Library:ValidateOptions(Defaults, Options)
	for i,v in pairs(Defaults) do
		if Options[i] == nil then
			Options[i] = v
		end
	end
	return Options
end

function Library:Tween(object, goal, callback)
	local tween = TweenService:Create(object, tweenInfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

function Library:new(Options)
	local Options = Options or {}
	Options = Library:ValidateOptions({
		title = "UI Library",
	}, Options)

	local UI = {
		CurrentTab = nil,
		Hover = false,
		Down = false,
		Connection = nil,
		DragStart = nil,
		StartPos = nil,
		Opened = true
	}

	do
		-- StarterGui.MyLibrary
		UI["1"] = Instance.new("ScreenGui", RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui") or CoreGui);
		UI["1"]["IgnoreGuiInset"] = true;
		UI["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
		UI["1"]["Name"] = Options["title"];
		UI["1"]["ResetOnSpawn"] = false;

		-- StarterGui.MyLibrary.Frame
		UI["2"] = Instance.new("Frame", UI["1"]);
		UI["2"]["BackgroundColor3"] = Color3.fromRGB(49, 49, 49);
		UI["2"]["AnchorPoint"] = Vector2.new(0, 0);
		UI["2"]["Size"] = UDim2.new(0, 400, 0, 300);
		UI["2"]["Position"] = UDim2.fromOffset((viewport.X/2) - (UI["2"]["Size"].X.Offset / 2),(viewport.Y/2) - (UI["2"]["Size"].Y.Offset / 2));
		UI["2"]["ClipsDescendants"] = not UI["Opened"]
		
		-- StarterGui.MyLibrary.Frame.UICorner
		UI["3"] = Instance.new("UICorner", UI["2"]);
		UI["3"]["CornerRadius"] = UDim.new(0.02500000037252903, 0);

		-- StarterGui.MyLibrary.Frame.DropShadowHolder
		UI["4"] = Instance.new("Frame", UI["2"]);
		UI["4"]["ZIndex"] = 0;
		UI["4"]["BorderSizePixel"] = 0;
		UI["4"]["BackgroundTransparency"] = 1;
		UI["4"]["Size"] = UDim2.new(1, 0, 1, 0);
		UI["4"]["Name"] = [[DropShadowHolder]];

		-- StarterGui.MyLibrary.Frame.DropShadowHolder.DropShadow
		UI["5"] = Instance.new("ImageLabel", UI["4"]);
		UI["5"]["ZIndex"] = 0;
		UI["5"]["BorderSizePixel"] = 0;
		UI["5"]["SliceCenter"] = Rect.new(49, 49, 450, 450);
		UI["5"]["ScaleType"] = Enum.ScaleType.Slice;
		UI["5"]["ImageColor3"] = Color3.fromRGB(0, 0, 0);
		UI["5"]["ImageTransparency"] = 0.5;
		UI["5"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		UI["5"]["Image"] = [[rbxassetid://6014261993]];
		UI["5"]["Size"] = UDim2.new(1, 47, 1, 47);
		UI["5"]["Name"] = [[DropShadow]];
		UI["5"]["BackgroundTransparency"] = 1;
		UI["5"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

		-- StarterGui.MyLibrary.Frame.TopBar
		UI["6"] = Instance.new("Frame", UI["2"]);
		UI["6"]["BackgroundColor3"] = Color3.fromRGB(178, 79, 80);
		UI["6"]["Size"] = UDim2.new(1, 0, 0, 30);
		UI["6"]["Name"] = [[TopBar]];
		UI["6"]["ZIndex"] = 100

		-- StarterGui.MyLibrary.Frame.TopBar.Bottom
		UI["7"] = Instance.new("Frame", UI["6"]);
		UI["7"]["BorderSizePixel"] = 0;
		UI["7"]["BackgroundColor3"] = Color3.fromRGB(178, 79, 80);
		UI["7"]["AnchorPoint"] = Vector2.new(0, 1);
		UI["7"]["Size"] = UDim2.new(1, 0, 0.5, 0);
		UI["7"]["Position"] = UDim2.new(0, 0, 1, 0);
		UI["7"]["Name"] = [[Bottom]];
		UI["7"]["ZIndex"] = 101

		-- StarterGui.MyLibrary.Frame.TopBar.Title
		UI["8"] = Instance.new("TextLabel", UI["6"]);
		UI["8"]["TextWrapped"] = true;
		UI["8"]["TextScaled"] = true;
		UI["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		UI["8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		UI["8"]["FontFace"] = Font.new([[rbxasset://fonts/families/Nunito.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
		UI["8"]["TextSize"] = 14;
		UI["8"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		UI["8"]["Size"] = UDim2.new(0.5, 0, 1, 0);
		UI["8"]["Name"] = [[Title]];
		UI["8"]["Text"] = Options["title"];
		UI["8"]["BackgroundTransparency"] = 1;
		UI["8"]["ZIndex"] = 103

		-- StarterGui.MyLibrary.Frame.TopBar.Title.UIPadding
		UI["9"] = Instance.new("UIPadding", UI["8"]);
		UI["9"]["PaddingLeft"] = UDim.new(0, 8);

		-- StarterGui.MyLibrary.Frame.TopBar.Close
		UI["a"] = Instance.new("ImageButton", UI["6"]);
		UI["a"]["ScaleType"] = Enum.ScaleType.Fit;
		UI["a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		UI["a"]["AnchorPoint"] = Vector2.new(1, 0.5);
		UI["a"]["Image"] = [[rbxassetid://13212899616]];
		UI["a"]["Size"] = UDim2.new(0, 22, 0, 22);
		UI["a"]["Name"] = [[Close]];
		UI["a"]["Position"] = UDim2.new(1, -8, 0.5, 0);
		UI["a"]["BackgroundTransparency"] = 1;
		UI["a"]["ZIndex"] = 102

		-- StarterGui.MyLibrary.Frame.TopBar.Line
		UI["b"] = Instance.new("Frame", UI["6"]);
		UI["b"]["BorderSizePixel"] = 0;
		UI["b"]["BackgroundColor3"] = Color3.fromRGB(87, 87, 87);
		UI["b"]["AnchorPoint"] = Vector2.new(0, 1);
		UI["b"]["Size"] = UDim2.new(1, 0, 0, 1);
		UI["b"]["Position"] = UDim2.new(0, 0, 1, 0);
		UI["b"]["Name"] = [[Line]];

		-- StarterGui.MyLibrary.Frame.TopBar.UICorner
		UI["c"] = Instance.new("UICorner", UI["6"]);
		UI["c"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

		-- StarterGui.MyLibrary.Frame.Navigation
		UI["d"] = Instance.new("Frame", UI["2"]);
		UI["d"]["BorderSizePixel"] = 0;
		UI["d"]["BackgroundColor3"] = Color3.fromRGB(62, 62, 62);
		UI["d"]["Size"] = UDim2.new(0, 120, 1, -30);
		UI["d"]["Position"] = UDim2.new(0, 0, 0, 30);
		UI["d"]["Name"] = [[Navigation]];

		-- StarterGui.MyLibrary.Frame.Navigation.UICorner
		UI["e"] = Instance.new("UICorner", UI["d"]);
		UI["e"]["CornerRadius"] = UDim.new(0.02500000037252903, 0);

		-- StarterGui.MyLibrary.Frame.Navigation.Hide
		UI["f"] = Instance.new("Frame", UI["d"]);
		UI["f"]["BorderSizePixel"] = 0;
		UI["f"]["BackgroundColor3"] = Color3.fromRGB(62, 62, 62);
		UI["f"]["Size"] = UDim2.new(1, 0, 0, 10);
		UI["f"]["Name"] = [[Hide]];

		-- StarterGui.MyLibrary.Frame.Navigation.Hide
		UI["10"] = Instance.new("Frame", UI["d"]);
		UI["10"]["BorderSizePixel"] = 0;
		UI["10"]["BackgroundColor3"] = Color3.fromRGB(62, 62, 62);
		UI["10"]["AnchorPoint"] = Vector2.new(1, 1);
		UI["10"]["Size"] = UDim2.new(0, 10, 0, 10);
		UI["10"]["Position"] = UDim2.new(1, 0, 1, 0);
		UI["10"]["Name"] = [[Hide]];

		-- StarterGui.MyLibrary.Frame.Navigation.ButtonHolder
		UI["11"] = Instance.new("Frame", UI["d"]);
		UI["11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		UI["11"]["BackgroundTransparency"] = 1;
		UI["11"]["Size"] = UDim2.new(1, 0, 1, 0);
		UI["11"]["Name"] = [[ButtonHolder]];

		-- StarterGui.MyLibrary.Frame.Navigation.ButtonHolder.UIPadding
		UI["12"] = Instance.new("UIPadding", UI["11"]);
		UI["12"]["PaddingTop"] = UDim.new(0, 8);
		UI["12"]["PaddingBottom"] = UDim.new(0, 8);

		-- StarterGui.MyLibrary.Frame.Navigation.ButtonHolder.UIListLayout
		UI["13"] = Instance.new("UIListLayout", UI["11"]);
		UI["13"]["Padding"] = UDim.new(0, 1);
		UI["13"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

		-- StarterGui.MyLibrary.Frame.ContentContainer
		UI["1f"] = Instance.new("Frame", UI["2"]);
		UI["1f"]["BorderSizePixel"] = 0;
		UI["1f"]["BackgroundColor3"] = Color3.fromRGB(57, 57, 57);
		UI["1f"]["AnchorPoint"] = Vector2.new(1, 0);
		UI["1f"]["BackgroundTransparency"] = 1;
		UI["1f"]["Size"] = UDim2.new(1, -133, 1, -42);
		UI["1f"]["Position"] = UDim2.new(1, -6, 0, 36);
		UI["1f"]["Name"] = [[ContentContainer]];

		-- StarterGui.MyLibrary.Frame.Navigation.Line
		UI["1e"] = Instance.new("Frame", UI["d"]);
		UI["1e"]["BorderSizePixel"] = 0;
		UI["1e"]["BackgroundColor3"] = Color3.fromRGB(87, 87, 87);
		UI["1e"]["AnchorPoint"] = Vector2.new(1, 0);
		UI["1e"]["Size"] = UDim2.new(0, 1, 1, 0);
		UI["1e"]["Position"] = UDim2.new(1, 0, 0, 0);
		UI["1e"]["Name"] = [[Line]];
	end

	function UI:NewTab(Options)
		local Options = Options or {}
		Options = Library:ValidateOptions({
			title = "Home",
			icon = 13212905277
		}, Options)

		local Tab = {
			Hover = false,
			Active = false,
		}

		do
			-- StarterGui.MyLibrary.Frame.Navigation.ButtonHolder.Inactive
			Tab["19"] = Instance.new("Frame", UI["11"]);
			Tab["19"]["BorderSizePixel"] = 0;
			Tab["19"]["BackgroundColor3"] = Color3.fromRGB(173, 77, 78);
			Tab["19"]["BackgroundTransparency"] = 1;
			Tab["19"]["Size"] = UDim2.new(1, 0, 0, 30);
			Tab["19"]["Name"] = [[Inactive]];

			-- StarterGui.MyLibrary.Frame.Navigation.ButtonHolder.Inactive.Title
			Tab["1a"] = Instance.new("TextLabel", Tab["19"]);
			Tab["1a"]["TextWrapped"] = true;
			Tab["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["1a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Tab["1a"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Tab["1a"]["TextSize"] = 20;
			Tab["1a"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["1a"]["AnchorPoint"] = Vector2.new(1, 0);
			Tab["1a"]["Size"] = UDim2.new(1, -30, 1, 0);
			Tab["1a"]["Text"] = Options["title"];
			Tab["1a"]["Name"] = [[Title]];
			Tab["1a"]["BackgroundTransparency"] = 1;
			Tab["1a"]["Position"] = UDim2.new(1, 0, 0, 0);

			-- StarterGui.MyLibrary.Frame.Navigation.ButtonHolder.Inactive.Title.UIPadding
			Tab["1b"] = Instance.new("UIPadding", Tab["1a"]);
			Tab["1b"]["PaddingLeft"] = UDim.new(0, 5);

			-- StarterGui.MyLibrary.Frame.Navigation.ButtonHolder.Inactive.Icon
			Tab["1c"] = Instance.new("ImageLabel", Tab["19"]);
			Tab["1c"]["ScaleType"] = Enum.ScaleType.Fit;
			Tab["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["1c"]["Image"] = typeof(Options["icon"]) == "number" and "rbxassetid://"..Options["icon"] or Options["icon"];
			Tab["1c"]["Size"] = UDim2.new(0, 25, 0, 25);
			Tab["1c"]["Name"] = [[Icon]];
			Tab["1c"]["BackgroundTransparency"] = 1;
			Tab["1c"]["Position"] = UDim2.new(0, 5, 0, 2);

			-- StarterGui.MyLibrary.Frame.Navigation.ButtonHolder.Inactive.Button
			Tab["1d"] = Instance.new("TextLabel", Tab["19"]);
			Tab["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["1d"]["FontFace"] = Font.new([[rbxasset://fonts/families/SourceSansPro.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Tab["1d"]["TextSize"] = 14;
			Tab["1d"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["1d"]["Size"] = UDim2.new(1, 0, 1, 0);
			Tab["1d"]["Text"] = [[]];
			Tab["1d"]["Name"] = [[Button]];
			Tab["1d"]["BackgroundTransparency"] = 1;

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab
			Tab["20"] = Instance.new("Frame", UI["1f"]);
			Tab["20"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["20"]["BackgroundTransparency"] = 1;
			Tab["20"]["Size"] = UDim2.new(1, 0, 1, 0);
			Tab["20"]["Name"] = [[HomeTab]];
			Tab["20"].Visible = false

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent
			Tab["21"] = Instance.new("ScrollingFrame", Tab["20"]);
			Tab["21"]["Active"] = true;
			Tab["21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["21"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
			Tab["21"]["BackgroundTransparency"] = 1;
			Tab["21"]["Size"] = UDim2.new(1, 0, 1, 0);
			Tab["21"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["21"]["ScrollBarThickness"] = 0;
			Tab["21"]["Name"] = [[TabContent]];

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.UIPadding
			Tab["35"] = Instance.new("UIPadding", Tab["21"]);
			Tab["35"]["PaddingTop"] = UDim.new(0, 5);
			Tab["35"]["PaddingRight"] = UDim.new(0, 5);
			Tab["35"]["PaddingBottom"] = UDim.new(0, 5);
			Tab["35"]["PaddingLeft"] = UDim.new(0, 5);

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.UIListLayout
			Tab["22"] = Instance.new("UIListLayout", Tab["21"]);
			Tab["22"]["Padding"] = UDim.new(0, 8);
			Tab["22"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

			Tab["1d"].MouseEnter:Connect(function()
				Tab.Hover = true
				if Tab.Active == false then
					Tab["19"]["BackgroundTransparency"] = 0.9
				end
			end)
			Tab["1d"].MouseLeave:Connect(function()
				Tab.Hover = false

				if Tab.Active == false then
					Tab["19"]["BackgroundTransparency"] = 1
				end
			end)

			function Tab:Activate()
				if not Tab.Active then
					if UI.CurrentTab ~= nil then
						UI.CurrentTab:Deactivate()
					end

					Tab.Active = true
					Tab["19"]["BackgroundTransparency"] = 0.75
					Tab["20"].Visible = true
					UI.CurrentTab = Tab
				end
			end

			function Tab:Deactivate()
				if Tab.Active then
					Tab.Active = false
					Tab.Hover = false
					Tab["19"]["BackgroundTransparency"] = 1
					Tab["20"].Visible = false
				end
			end

			uis.InputBegan:Connect(function(input, gpe)
				if gpe then return end

				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					if Tab.Hover then
						Tab:Activate()
						Tab["19"]["BackgroundTransparency"] = 0.75
					end
				end
			end)

			if UI.CurrentTab == nil then
				Tab:Activate()
			else
				Tab:Deactivate()
			end

		end

		-- Tab["21"]

		-- Button
		function Tab:MakeButton(Options)
			local Options = Options or {}
			Options = Library:ValidateOptions({
				title = "Button",
				callback = function() print("Clicked") end
			}, Options)

			local Button = {
				Hover = false
			}

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Button
			Button["23"] = Instance.new("TextButton", Tab["21"]);
			Button["23"]["BackgroundColor3"] = Color3.fromRGB(39, 39, 39);
			Button["23"]["Size"] = UDim2.new(1, 0, 0, 30);
			Button["23"]["Name"] = [[Button]];
			Button["23"]["Text"] = "";

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Button.UIStroke
			Button["24"] = Instance.new("UIStroke", Button["23"]);
			Button["24"]["Color"] = Color3.fromRGB(62, 62, 62);
			Button["24"]["Thickness"] = 2;

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Button.Title
			Button["25"] = Instance.new("TextLabel", Button["23"]);
			Button["25"]["TextWrapped"] = true;
			Button["25"]["TextScaled"] = true;
			Button["25"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Button["25"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Button["25"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Button["25"]["TextSize"] = 14;
			Button["25"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Button["25"]["AnchorPoint"] = Vector2.new(0, 0.5);
			Button["25"]["Size"] = UDim2.new(1, -32, 0, 20);
			Button["25"]["Text"] = Options["title"];
			Button["25"]["Name"] = [[Title]];
			Button["25"]["BackgroundTransparency"] = 1;
			Button["25"]["Position"] = UDim2.new(0, 0, 0.5, 0);

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Button.Title.UIPadding
			Button["26"] = Instance.new("UIPadding", Button["25"]);
			Button["26"]["PaddingLeft"] = UDim.new(0, 8);

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Button.Icon
			Button["27"] = Instance.new("ImageLabel", Button["23"]);
			Button["27"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Button["27"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Button["27"]["Image"] = [[rbxassetid://13213015293]];
			Button["27"]["Size"] = UDim2.new(0, 20, 0, 20);
			Button["27"]["Name"] = [[Icon]];
			Button["27"]["BackgroundTransparency"] = 1;
			Button["27"]["Position"] = UDim2.new(1, -8, 0.5, 0);

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Button.UICorner
			Button["28"] = Instance.new("UICorner", Button["23"]);
			Button["28"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

			Button["23"].MouseEnter:Connect(function()
				Button.Hover = true
			end)
			Button["23"].MouseLeave:Connect(function()
				Button.Hover = false
			end)

			Button["23"].MouseButton1Click:Connect(function()
				if Button.Hover == true then
					Options["callback"]()
				end
			end)

		end

		-- Warning
		function Tab:MakeWarning(Options)
			local Options = Options or {}
			Options = Library:ValidateOptions({
				text = "Warning"
			},Options)

			local Warning = {}

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Warning
			Warning["2f"] = Instance.new("Frame", Tab["21"]);
			Warning["2f"]["BackgroundColor3"] = Color3.fromRGB(99, 96, 2);
			Warning["2f"]["Size"] = UDim2.new(1, 0, 0, 30);
			Warning["2f"]["Name"] = [[Warning]];

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Warning.UIStroke
			Warning["30"] = Instance.new("UIStroke", Warning["2f"]);
			Warning["30"]["Color"] = Color3.fromRGB(172, 166, 3);
			Warning["30"]["Thickness"] = 2;

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Warning.Title
			Warning["31"] = Instance.new("TextLabel", Warning["2f"]);
			Warning["31"]["TextWrapped"] = true;
			Warning["31"]["TextScaled"] = false;
			Warning["31"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Warning["31"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Warning["31"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Warning["31"]["TextSize"] = 18;
			Warning["31"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Warning["31"]["AnchorPoint"] = Vector2.new(0, 0.5);
			Warning["31"]["Size"] = UDim2.new(1, -32, 0, 20);
			Warning["31"]["Text"] = Options["text"];
			Warning["31"]["Name"] = [[Title]];
			Warning["31"]["BackgroundTransparency"] = 1;
			Warning["31"]["Position"] = UDim2.new(0, 0, 0.5, 0);
			Warning["31"]["TextYAlignment"] = Enum.TextYAlignment.Top

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Warning.Title.UIPadding
			Warning["32"] = Instance.new("UIPadding", Warning["31"]);
			Warning["32"]["PaddingLeft"] = UDim.new(0, 8);

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Warning.Icon
			Warning["33"] = Instance.new("ImageLabel", Warning["2f"]);
			Warning["33"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Warning["33"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Warning["33"]["Image"] = [[rbxassetid://13213045734]];
			Warning["33"]["Size"] = UDim2.new(0, 20, 0, 20);
			Warning["33"]["Name"] = [[Icon]];
			Warning["33"]["BackgroundTransparency"] = 1;
			Warning["33"]["Position"] = UDim2.new(1, -8, 0.5, 0);

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Warning.UICorner
			Warning["34"] = Instance.new("UICorner", Warning["2f"]);
			Warning["34"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

			function Warning:_update(txt)
				local txt = txt or Options["text"]
				Warning["31"]["Text"] = txt;
				Warning["31"]["Size"] = UDim2.new(Warning["31"].Size.X.Scale, Warning["31"].Size.X.Offset, 0, math.huge);
				Warning["31"]["Size"] = UDim2.new(Warning["31"].Size.X.Scale, Warning["31"].Size.X.Offset, 0, Warning["31"].TextBounds.Y);
				Warning["2f"]["Size"] = UDim2.new(Warning["2f"].Size.X.Scale, Warning["2f"].Size.X.Offset, 0, Warning["31"].TextBounds.Y + 12);
			end

			function Warning:Update(Options)
				local Options = Options or {}
				Options = Library:ValidateOptions({
					text = "Warning"
				},Options)

				Warning["31"]["Text"] = Options["text"];
				Warning:_update(Options["text"])
			end

			Warning:_update()

			return Warning
		end

		-- Info
		function Tab:MakeInfo(Options)
			local Options = Options or {}
			Options = Library:ValidateOptions({
				text = "Information"
			},Options)

			local Info = {}

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Info
			Info["29"] = Instance.new("Frame", Tab["21"]);
			Info["29"]["BackgroundColor3"] = Color3.fromRGB(39, 94, 99);
			Info["29"]["Size"] = UDim2.new(1, 0, 0, 30);
			Info["29"]["Name"] = [[Info]];

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Info.UIStroke
			Info["2a"] = Instance.new("UIStroke", Info["29"]);
			Info["2a"]["Color"] = Color3.fromRGB(54, 172, 172);
			Info["2a"]["Thickness"] = 2;

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Info.Title
			Info["2b"] = Instance.new("TextLabel", Info["29"]);
			Info["2b"]["TextWrapped"] = true;
			Info["2b"]["TextScaled"] = false;
			Info["2b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Info["2b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Info["2b"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			Info["2b"]["TextSize"] = 14;
			Info["2b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			Info["2b"]["AnchorPoint"] = Vector2.new(0, 0.5);
			Info["2b"]["Size"] = UDim2.new(1, -32, 0, 20);
			Info["2b"]["Text"] = Options["text"];
			Info["2b"]["Name"] = [[Title]];
			Info["2b"]["BackgroundTransparency"] = 1;
			Info["2b"]["Position"] = UDim2.new(0, 0, 0.5, 0);
			Info["2b"]["TextYAlignment"] = Enum.TextYAlignment.Top

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Info.Title.UIPadding
			Info["2c"] = Instance.new("UIPadding", Info["2b"]);
			Info["2c"]["PaddingLeft"] = UDim.new(0, 8);

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Info.Icon
			Info["2d"] = Instance.new("ImageLabel", Info["29"]);
			Info["2d"]["ScaleType"] = Enum.ScaleType.Fit;
			Info["2d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Info["2d"]["ImageColor3"] = Color3.fromRGB(54, 172, 172);
			Info["2d"]["AnchorPoint"] = Vector2.new(1, 0.5);
			Info["2d"]["Image"] = [[rbxassetid://13213072715]];
			Info["2d"]["Size"] = UDim2.new(0, 20, 0, 20);
			Info["2d"]["Name"] = [[Icon]];
			Info["2d"]["BackgroundTransparency"] = 1;
			Info["2d"]["Position"] = UDim2.new(1, -8, 0.5, 0);

			-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Info.UICorner
			Info["2e"] = Instance.new("UICorner", Info["29"]);
			Info["2e"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

			function Info:_update(txt)
				local txt = txt or Options["text"]
				Info["2b"]["Text"] = txt;
				Info["2b"]["Size"] = UDim2.new(Info["2b"].Size.X.Scale, Info["2b"].Size.X.Offset, 0, math.huge);
				Info["2b"]["Size"] = UDim2.new(Info["2b"].Size.X.Scale, Info["2b"].Size.X.Offset, 0, Info["2b"].TextBounds.Y);
				Info["29"]["Size"] = UDim2.new(Info["29"].Size.X.Scale, Info["29"].Size.X.Offset, 0, Info["2b"].TextBounds.Y + 12);
			end

			function Info:Update(Options)
				local Options = Options or {}
				Options = Library:ValidateOptions({
					text = "Warning"
				},Options)

				Info["2b"]["Text"] = Options["text"];
				Info:_update(Options["text"])
			end

			Info:_update()

			return Info
		end

		-- Slider
		function Tab:MakeSlider(Options)
			local Slider = {
				Count = 0,
				Hover = false,
				Down = false,
				Connection = nil
			}
			local Options = Options or {}
			Options = Library:ValidateOptions({
				title = "slider",
				start = 0,
				min = 0,
				max = 100,
				callback = function(v) print(v) end
			},Options)

			Slider["Count"] = Options["start"]

			do
				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider
				Slider["36"] = Instance.new("Frame", Tab["21"]);
				Slider["36"]["BackgroundColor3"] = Color3.fromRGB(39, 39, 39);
				Slider["36"]["Size"] = UDim2.new(1, 0, 0, 42);
				Slider["36"]["Name"] = [[Slider]];

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.UIStroke
				Slider["37"] = Instance.new("UIStroke", Slider["36"]);
				Slider["37"]["Color"] = Color3.fromRGB(62, 62, 62);
				Slider["37"]["Thickness"] = 2;

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.Title
				Slider["38"] = Instance.new("TextLabel", Slider["36"]);
				Slider["38"]["TextWrapped"] = true;
				Slider["38"]["TextScaled"] = true;
				Slider["38"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["38"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Slider["38"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Slider["38"]["TextSize"] = 14;
				Slider["38"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["38"]["AnchorPoint"] = Vector2.new(0, 0.5);
				Slider["38"]["Size"] = UDim2.new(1, -32, 0, 20);
				Slider["38"]["Text"] = Options["title"];
				Slider["38"]["Name"] = [[Title]];
				Slider["38"]["BackgroundTransparency"] = 1;
				Slider["38"]["Position"] = UDim2.new(0, 0, 0.25, 0);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.Title.UIPadding
				Slider["39"] = Instance.new("UIPadding", Slider["38"]);
				Slider["39"]["PaddingLeft"] = UDim.new(0, 8);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.Value
				Slider["3a"] = Instance.new("TextLabel", Slider["36"]);
				Slider["3a"]["TextWrapped"] = true;
				Slider["3a"]["TextScaled"] = true;
				Slider["3a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["3a"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Slider["3a"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Slider["3a"]["TextSize"] = 14;
				Slider["3a"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["3a"]["AnchorPoint"] = Vector2.new(1, 0.5);
				Slider["3a"]["Size"] = UDim2.new(0, 20, 0, 20);
				Slider["3a"]["Text"] = Options["start"];
				Slider["3a"]["Name"] = [[Value]];
				Slider["3a"]["BackgroundTransparency"] = 1;
				Slider["3a"]["Position"] = UDim2.new(1, -5, 0.25, 0);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.Value.UIPadding
				Slider["3b"] = Instance.new("UIPadding", Slider["3a"]);
				Slider["3b"]["PaddingLeft"] = UDim.new(0, 8);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.SliderBack
				Slider["3c"] = Instance.new("Frame", Slider["36"]);
				Slider["3c"]["BorderSizePixel"] = 0;
				Slider["3c"]["BackgroundColor3"] = Color3.fromRGB(31, 31, 31);
				Slider["3c"]["AnchorPoint"] = Vector2.new(0, 1);
				Slider["3c"]["Size"] = UDim2.new(1, -10, 0, 5);
				Slider["3c"]["ClipsDescendants"] = true;
				Slider["3c"]["Position"] = UDim2.new(0, 5, 1, -5);
				Slider["3c"]["Name"] = [[SliderBack]];

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.SliderBack.Draggable
				Slider["3d"] = Instance.new("Frame", Slider["3c"]);
				Slider["3d"]["BorderSizePixel"] = 0;
				Slider["3d"]["BackgroundColor3"] = Color3.fromRGB(55, 55, 55);
				Slider["3d"]["Size"] = UDim2.new(0.5, 0, 1, 0);
				Slider["3d"]["Name"] = [[Draggable]];

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.SliderBack.Draggable.UICorner
				Slider["3e"] = Instance.new("UICorner", Slider["3d"]);
				Slider["3e"]["CornerRadius"] = UDim.new(0.5, 0);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.SliderBack.UICorner
				Slider["3f"] = Instance.new("UICorner", Slider["3c"]);
				Slider["3f"]["CornerRadius"] = UDim.new(1, 0);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Slider.UICorner
				Slider["40"] = Instance.new("UICorner", Slider["36"]);
				Slider["40"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);

			end

			function Slider:GetValue()
				return Slider["Count"]
			end

			function Slider:SetValue(v)
				if v == nil then
					local percentage = math.clamp((Mouse.X - Slider["36"].AbsolutePosition.X) / (Slider["36"].AbsoluteSize.X), 0, 1)
					local value = math.floor(((Options["max"] - Options["min"]) * percentage) + Options["min"])
					Slider["3a"]["Text"] = tostring(value)
					Slider["Count"] = value

					Slider["3d"].Size = UDim2.fromScale(percentage, 1)
				elseif v ~= nil and tonumber(v) then
					Slider["Count"] = tonumber(v)
					Library:Tween(Slider["3d"], {Size = UDim2.new(Slider["Count"]/Options["max"], 0, 1, 0)})
				end
				Options["callback"](Slider:GetValue())
			end

			Slider:SetValue(Options["start"])

			do
				Slider["36"].MouseEnter:Connect(function()
					Slider.Hover = true
				end)
				Slider["36"].MouseLeave:Connect(function()
					Slider.Hover = false
				end)


				uis.InputBegan:Connect(function(input, gpe)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Slider.Hover == true then
						Slider.Down = true
						if not Slider.Connection then
							Slider.Connection = RunService.RenderStepped:Connect(function()
								Slider:SetValue()
							end)
						end
					end
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if Slider.Down then
							Slider.Down = false

							if Slider.Connection ~= nil then
								Slider.Connection:Disconnect()
							end
							Slider.Connection = nil
						end
					end
				end)
			end

			return Slider

		end

		-- Toggle
		function Tab:MakeToggle(Options)
			local Options = Options or {}
			Options = Library:ValidateOptions({
				title = "Toggle",
				start = false,
				callback = function(v) print(v) end,
			},Options)

			local toggle = {
				Hover = false,
				Toggled = false
			}

			toggle["Toggled"] = Options["start"]

			do
				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Toggle
				toggle["4f"] = Instance.new("Frame", Tab["21"]);
				toggle["4f"]["BackgroundColor3"] = Color3.fromRGB(39, 39, 39);
				toggle["4f"]["Size"] = UDim2.new(1, 0, 0, 30);
				toggle["4f"]["Name"] = [[Toggle]];

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Toggle.UIStroke
				toggle["50"] = Instance.new("UIStroke", toggle["4f"]);
				toggle["50"]["Color"] = Color3.fromRGB(62, 62, 62);
				toggle["50"]["Thickness"] = 2;

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Toggle.Title
				toggle["51"] = Instance.new("TextLabel", toggle["4f"]);
				toggle["51"]["TextWrapped"] = true;
				toggle["51"]["TextScaled"] = true;
				toggle["51"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				toggle["51"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				toggle["51"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				toggle["51"]["TextSize"] = 14;
				toggle["51"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				toggle["51"]["AnchorPoint"] = Vector2.new(0, 0.5);
				toggle["51"]["Size"] = UDim2.new(1, -32, 0, 20);
				toggle["51"]["Text"] = Options["title"];
				toggle["51"]["Name"] = [[Title]];
				toggle["51"]["BackgroundTransparency"] = 1;
				toggle["51"]["Position"] = UDim2.new(0, 0, 0.5, 0);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Toggle.Title.UIPadding
				toggle["52"] = Instance.new("UIPadding", toggle["51"]);
				toggle["52"]["PaddingLeft"] = UDim.new(0, 8);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Toggle.Checkmark
				toggle["53"] = Instance.new("Frame", toggle["4f"]);
				toggle["53"]["BackgroundColor3"] = Color3.fromRGB(53, 53, 53);
				toggle["53"]["AnchorPoint"] = Vector2.new(1, 0.5);
				toggle["53"]["Size"] = UDim2.new(0, 20, 0, 20);
				toggle["53"]["Position"] = UDim2.new(1, -8, 0.5, 0);
				toggle["53"]["Name"] = [[Checkmark]];

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Toggle.Checkmark.Icon
				toggle["54"] = Instance.new("ImageLabel", toggle["53"]);
				toggle["54"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				toggle["54"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
				toggle["54"]["Image"] = [[rbxassetid://13213276499]];
				toggle["54"]["Size"] = UDim2.new(0, 15, 0, 15);
				toggle["54"]["Name"] = [[Icon]];
				toggle["54"]["BackgroundTransparency"] = 1;
				toggle["54"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
				toggle["54"].Visible = toggle["Toggled"]

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Toggle.Checkmark.UICorner
				toggle["55"] = Instance.new("UICorner", toggle["53"]);
				toggle["55"]["CornerRadius"] = UDim.new(0.30000001192092896, 0);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Toggle.UICorner
				toggle["56"] = Instance.new("UICorner", toggle["4f"]);
				toggle["56"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);	
			end

			toggle["4f"].MouseEnter:Connect(function()
				toggle["Hover"] = true
			end)

			toggle["4f"].MouseLeave:Connect(function()
				toggle["Hover"] = false
			end)

			uis.InputBegan:Connect(function(key, gpe)
				if key.UserInputType == Enum.UserInputType.MouseButton1 and toggle["Hover"] == true then
					toggle["Toggled"] = not toggle["Toggled"]
					toggle["54"].Visible = toggle["Toggled"]
					Options["callback"](toggle["Toggled"])
				end
			end)
		end

		-- Dropdown
		function Tab:MakeDropdown(Options)
			local Options = Options or {}
			Options = Library:ValidateOptions({
				title = "Dropdown",
				options = {},
				callback = function(opt) print(opt) end,
			},Options)

			local Dropdown = {
				Hover = false,
				HoveringOption = nil,
				SelectedOption = nil,
				Opened = false,
			}

			do
				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown
				Dropdown["41"] = Instance.new("Frame", Tab["21"]);
				Dropdown["41"]["BackgroundColor3"] = Color3.fromRGB(39, 39, 39);
				Dropdown["41"]["Size"] = UDim2.new(1, 0, 0.022551381960511208, 30);
				Dropdown["41"]["ClipsDescendants"] = true;
				Dropdown["41"]["Position"] = UDim2.new(0.018726591020822525, 0, 0.20542635023593903, 0);
				Dropdown["41"]["Name"] = [[Dropdown]];

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.UIStroke
				Dropdown["42"] = Instance.new("UIStroke", Dropdown["41"]);
				Dropdown["42"]["Color"] = Color3.fromRGB(62, 62, 62);
				Dropdown["42"]["Thickness"] = 2;

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Title
				Dropdown["43"] = Instance.new("TextLabel", Dropdown["41"]);
				Dropdown["43"]["TextWrapped"] = true;
				Dropdown["43"]["TextScaled"] = true;
				Dropdown["43"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["43"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Dropdown["43"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Dropdown["43"]["TextSize"] = 14;
				Dropdown["43"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["43"]["AnchorPoint"] = Vector2.new(0, 0.5);
				Dropdown["43"]["Size"] = UDim2.new(1, -32, 0, 20);
				Dropdown["43"]["Text"] = [[Dropdown]];
				Dropdown["43"]["Name"] = [[Title]];
				Dropdown["43"]["BackgroundTransparency"] = 1;
				Dropdown["43"]["Position"] = UDim2.new(0, 0, 0, 20);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Title.UIPadding
				Dropdown["44"] = Instance.new("UIPadding", Dropdown["43"]);
				Dropdown["44"]["PaddingLeft"] = UDim.new(0, 8);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Icon
				Dropdown["45"] = Instance.new("ImageLabel", Dropdown["41"]);
				Dropdown["45"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["45"]["AnchorPoint"] = Vector2.new(1, 0.5);
				Dropdown["45"]["Image"] = [[rbxassetid://13213161985]];
				Dropdown["45"]["Size"] = UDim2.new(0, 20, 0, 20);
				Dropdown["45"]["Name"] = [[Icon]];
				Dropdown["45"]["BackgroundTransparency"] = 1;
				Dropdown["45"]["Position"] = UDim2.new(1, -8, 0, 20);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Options
				Dropdown["46"] = Instance.new("Frame", Dropdown["41"]);
				Dropdown["46"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["46"]["BackgroundTransparency"] = 1;
				Dropdown["46"]["Size"] = UDim2.new(1, 0, 0, 100);
				Dropdown["46"]["Position"] = UDim2.new(0, 0, 0, 35);
				Dropdown["46"]["Name"] = [[Options]];

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Options.OptionHolder
				Dropdown["47"] = Instance.new("ScrollingFrame", Dropdown["46"]);
				Dropdown["47"]["Active"] = true;
				Dropdown["47"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["47"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
				Dropdown["47"]["BackgroundTransparency"] = 1;
				Dropdown["47"]["Size"] = UDim2.new(1, 0, 1, 0);
				Dropdown["47"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
				Dropdown["47"]["ScrollBarThickness"] = 0;
				Dropdown["47"]["Name"] = [[OptionHolder]];

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Options.OptionHolder.UIListLayout
				Dropdown["48"] = Instance.new("UIListLayout", Dropdown["47"]);
				Dropdown["48"]["SortOrder"] = Enum.SortOrder.LayoutOrder;
				Dropdown["48"].Padding = UDim.new(0, 8)

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Options.OptionHolder.UIPadding
				Dropdown["4d"] = Instance.new("UIPadding", Dropdown["47"]);
				Dropdown["4d"]["PaddingTop"] = UDim.new(0, 5);
				Dropdown["4d"]["PaddingRight"] = UDim.new(0, 5);
				Dropdown["4d"]["PaddingBottom"] = UDim.new(0, 5);
				Dropdown["4d"]["PaddingLeft"] = UDim.new(0, 5);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.UICorner
				Dropdown["4e"] = Instance.new("UICorner", Dropdown["41"]);
				Dropdown["4e"]["CornerRadius"] = UDim.new(0.10000000149011612, 0);
			end

			function Dropdown:_addOption(Opt)
				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Options.OptionHolder.Option1
				Dropdown["49"] = Instance.new("TextLabel", Dropdown["47"]);
				Dropdown["49"]["TextWrapped"] = true;
				Dropdown["49"]["TextScaled"] = true;
				Dropdown["49"]["BackgroundColor3"] = Color3.fromRGB(49, 49, 49);
				Dropdown["49"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Dropdown["49"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				Dropdown["49"]["TextSize"] = 14;
				Dropdown["49"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["49"]["Size"] = UDim2.new(1, 0, 0, 30);
				Dropdown["49"]["Text"] = tostring(Opt);
				Dropdown["49"]["Name"] = tostring(Opt);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Options.OptionHolder.Option1.UIPadding
				Dropdown["4a"] = Instance.new("UIPadding", Dropdown["49"]);
				Dropdown["4a"]["PaddingLeft"] = UDim.new(0, 5);

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Options.OptionHolder.Option1.UIStroke
				Dropdown["4b"] = Instance.new("UIStroke", Dropdown["49"]);
				Dropdown["4b"]["Color"] = Color3.fromRGB(87, 87, 87);
				Dropdown["4b"]["Thickness"] = 2;
				Dropdown["4b"]["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border;

				-- StarterGui.MyLibrary.Frame.ContentContainer.HomeTab.TabContent.Dropdown.Options.OptionHolder.Option1.UICorner
				Dropdown["4c"] = Instance.new("UICorner", Dropdown["49"]);
				Dropdown["4c"]["CornerRadius"] = UDim.new(0.20000000298023224, 0);

				Dropdown["49"].MouseEnter:Connect(function()
					Dropdown.HoveringOption = Opt
				end)

				Dropdown["49"].MouseLeave:Connect(function()
					Dropdown.HoveringOption = nil
				end)
			end

			function Dropdown:_open()
				Library:Tween(Dropdown["41"], {Size = UDim2.new(1, 0, 0, 150)})
				Dropdown["Opened"] = true
			end

			function Dropdown:_close()
				Library:Tween(Dropdown["41"], {Size = UDim2.new(1, 0, 0, 35)})
				Dropdown["Opened"] = false
			end

			if Options["options"] ~= nil then
				if #Options["options"] > 0 then
					for i,v in pairs(Options["options"]) do
						Dropdown:_addOption(v)
					end
				end
			end

			Dropdown["41"].MouseEnter:Connect(function()
				Dropdown["Hover"] = true
			end)

			Dropdown["41"].MouseLeave:Connect(function()
				Dropdown["Hover"] = false
			end)

			uis.InputBegan:Connect(function(input, gpe)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then

					if (Dropdown["Hover"] and Dropdown["HoveringOption"] == nil) then
						if Dropdown["Opened"] == false then
							Dropdown:_open()
							return
						elseif Dropdown["Opened"] == true then
							Dropdown:_close()
							return
						end
					elseif (Dropdown["Hover"] and Dropdown["HoveringOption"] ~= nil) then
						Dropdown["SelectedOption"] = Dropdown["HoveringOption"]
						Options["callback"](Dropdown["SelectedOption"])
					end

				end
			end)

			return Dropdown
		end

		return Tab
	end
	
	UI["6"].MouseEnter:Connect(function()
		UI["Hover"] = true
	end)
	UI["6"].MouseLeave:Connect(function()
		UI["Hover"] = false
	end)
	
	UI["6"].InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if UI["Hover"] then
				UI["Down"] = true
				UI["DragStart"] = input.Position
				UI["StartPos"] = UI["2"].Position
			end
		end
	end)
	
	UI["6"].InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if UI["Hover"] then
				UI["Down"] = false
				UI["DragStart"] = nil
				UI["StartPos"] = nil
			end
		end
	end)
	
	uis.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if UI["Down"] then
				local delta = input.Position - UI["DragStart"]
				local position = UDim2.new(UI["StartPos"].X.Scale, UI["StartPos"].X.Offset + delta.X,UI["StartPos"].Y.Scale, UI["StartPos"].Y.Offset + delta.Y)
				
				UI["2"].Position = position
			end
		end
	end)
	
	UI["a"].MouseButton1Click:Connect(function()
		if UI["Opened"] == true then
			UI["2"]["ClipsDescendants"] = true
			Library:Tween(UI["2"], {Size = UDim2.new(0, 400, 0, 30)}, function()
				UI["Opened"] = false
				UI["2"]["BackgroundTransparency"] = 1
				UI["4"].Visible = false
			end)
			return
		elseif UI["Opened"] == false then
			UI["2"]["BackgroundTransparency"] = 0
			UI["4"].Visible = true
			Library:Tween(UI["2"], {Size = UDim2.new(0, 400, 0, 300)}, function()
				UI["2"]["ClipsDescendants"] = false
				UI["Opened"] = true
			end)
			
		end
	end)
	
	return UI
end


return Library
