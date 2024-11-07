local MyUI = {}

-- Utility function for creating rounded corners
local function createUICorner(parent, cornerRadius)
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, cornerRadius)
    uiCorner.Parent = parent
end

-- Utility function to create button hover effect
local function createHoverEffect(button, defaultColor, hoverColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = defaultColor
    end)
end

-- Function to create a new window
function MyUI:CreateWindow(config)
    local window = {}
    window.Title = config.Name or "Untitled Window"
    
    -- Create the main UI window
    local screenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local shadowFrame = Instance.new("Frame") -- Shadow effect for main frame

    -- Window Styling
    screenGui.Name = window.Title
    screenGui.Parent = game.CoreGui

    shadowFrame.Size = UDim2.new(0.32, 0, 0.52, 0)
    shadowFrame.Position = UDim2.new(0.34, 0, 0.24, 0)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadowFrame.BackgroundTransparency = 0.5
    shadowFrame.BorderSizePixel = 0
    shadowFrame.Parent = screenGui

    mainFrame.Size = UDim2.new(1, -8, 1, -8)
    mainFrame.Position = UDim2.new(0, 4, 0, 4)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark theme color
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = shadowFrame
    createUICorner(mainFrame, 10) -- Rounded corners

    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = window.Title
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextScaled = true
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame

    -- Close Button (Improved)
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.Gotham
    closeButton.TextSize = 20
    closeButton.Parent = mainFrame
    createUICorner(closeButton, 5)

    -- Close Button functionality
    createHoverEffect(closeButton, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 50, 50)) -- Hover effect
    closeButton.MouseButton1Click:Connect(function()
        window:Destroy()
    end)

    -- Draggable functionality
    local dragging = false
    local dragStart
    local dragInput
    local startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    -- Start dragging
    titleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    -- Update window position while dragging
    titleLabel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            updateDrag(input)
        end
    end)

    window.Gui = screenGui
    window.MainFrame = mainFrame
    window.Tabs = {}

    function window:CreateTab(name)
        local tab = {}
        tab.Name = name or "Tab"

        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Text = tab.Name
        tabButton.Size = UDim2.new(0.2, 0, 0.08, 0)
        tabButton.Position = UDim2.new(#window.Tabs * 0.21, 0, 0.1, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.BorderSizePixel = 0
        tabButton.Parent = mainFrame
        createUICorner(tabButton, 6)
        createHoverEffect(tabButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70)) -- Hover effect

        -- Outline effect
        local outline = Instance.new("UIStroke")
        outline.Thickness = 2
        outline.Color = Color3.fromRGB(0, 170, 255) -- Accent color
        outline.Parent = tabButton

        local tabFrame = Instance.new("Frame")
        tabFrame.Size = UDim2.new(1, 0, 0.8, 0)
        tabFrame.Position = UDim2.new(0, 0, 0.18, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = mainFrame

        -- Show the tab's content on button click
        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                t.TabFrame.Visible = false
                -- Remove tab highlight effect
                t.TabButton.BorderColor3 = Color3.fromRGB(50, 50, 50)
            end
            tabFrame.Visible = true
            -- Highlight selected tab
            tabButton.BorderColor3 = Color3.fromRGB(0, 170, 255)
        end)

        tab.TabFrame = tabFrame
        tab.TabButton = tabButton
        table.insert(window.Tabs, tab)

        -- Automatically show the first tab
        if #window.Tabs == 1 then
            tabFrame.Visible = true
            tabButton.BorderColor3 = Color3.fromRGB(0, 170, 255) -- Highlight the first tab
        end

        function tab:CreateSection(name)
            local section = {}
            section.Name = name or "Section"
            
            -- Section Frame
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0.3, 0)
            sectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Dark section background
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Parent = tabFrame
            createUICorner(sectionFrame, 8)

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Text = section.Name
            sectionLabel.Size = UDim2.new(1, 0, 0.2, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionLabel.Font = Enum.Font.Gotham
            sectionLabel.TextScaled = true
            sectionLabel.Parent = sectionFrame

            section.Frame = sectionFrame

            function section:CreateButton(text, callback)
                local button = Instance.new("TextButton")
                button.Text = text or "Button"
                button.Size = UDim2.new(0.9, 0, 0.3, 0)
                button.Position = UDim2.new(0.05, 0, 0.4, 0)
                button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.Font = Enum.Font.Gotham
                button.TextSize = 16
                button.Parent = sectionFrame
                createUICorner(button, 5)
                createHoverEffect(button, Color3.fromRGB(0, 170, 255), Color3.fromRGB(0, 130, 200)) -- Hover effect
                
                -- Button click callback
                button.MouseButton1Click:Connect(callback)
            end
        end

        return tab
    end

    return window
end

return MyUI
