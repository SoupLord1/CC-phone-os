local basalt = require("basalt")

local function getFileContents(filepath)
    local file = fs.open(filepath, "r")
    local content = file:readAll()
    file:close()
    return content
end

local function exitOs()
    basalt.stop()
end

local main = basalt.createFrame()


-- LOCK SCREEN
local lock_screen = main:addFrame():setSize("parent.w", "parent.h")

local topBar_ls = lock_screen:addFrame():setPosition(1,1):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local versionLabel_ls = topBar_ls:addLabel():setText("OS v1.0"):setPosition(2, 1)
local Clock_ls = topBar_ls:addLabel():setText("Tempclock"):setPosition("parent.w-11", 1)

local desktop_ls = lock_screen:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h-2"):setBackground(colors.black)

local passFrame = desktop_ls:addFrame():setSize("parent.w/3", "parent.h/3 + 2"):setPosition("parent.w/2-self.w/2", "parent.h/2-self.h/2"):setBackground(colors.gray)
local passLabel = passFrame:addLabel():setText(" Password:"):setPosition("parent.w/2-self.w/2", "parent.h/2-self.h/2"):setForeground(colors.white)
local passInput = passFrame:addInput():setInputType("password"):setInputLimit(12):setPosition("parent.w/2-self.w/2", "parent.h/2-self.h/2+1"):setForeground(colors.white)
local pass_submit = passFrame:addButton():setText("Submit"):setPosition("parent.w/2-self.w/2", "parent.h/2+3"):setSize(8, 1):setBackground(colors.lightGray)
local passReponse = passFrame:addLabel():setText(""):setPosition("parent.w/2-self.w/2", "parent.h/2+2"):setForeground(colors.white)

local bottomBar_ls = lock_screen:addFrame():setPosition(1,"parent.h"):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local exit_button_ls = bottomBar_ls:addButton():setText("Exit"):setBackground(colors.lightGray):setSize(6,1):setPosition("parent.w/2-self.w/2",1):onClick(exitOs)
-- LOCK SCREEN END

local main_os = main:addFrame():setSize("parent.w", "parent.h"):hide()


local function enterPass()
    local sha2 = require("modules.sha2.sha2")
    local password = getFileContents("os/default_apps/storage/settings/password.txt")
    local entered_password = sha2.sha224(passInput:getValue())
    if password == entered_password then
        passInput:setValue("")
        lock_screen:hide()
        main_os:show()
    else
        passInput:setValue("")
        passReponse:setText("Incorrect"):setForeground(colors.red)
    end

  end

pass_submit:onClick(enterPass)

local function Logout()
    lock_screen:show()
    main_os:hide()
end

-- MAIN OS


local topBar = main_os:addFrame():setPosition(1,1):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local versionLabel = topBar:addLabel():setText("OS v1.0"):setPosition(2, 1)
local Clock = topBar:addLabel():setText("Tempclock"):setPosition("parent.w-11", 1)

local desktop = main_os:addFrame():setPosition(1, 2):setSize("parent.w", "parent.h-2"):setBackground(colors.black)

local bottomBar = main_os:addFrame():setPosition(1,"parent.h"):setSize("parent.w", 1):setBackground(colors.gray):setForeground(colors.white)
local exit_button = bottomBar:addButton():setText("Exit"):setBackground(colors.lightGray):setSize(6, 1):setPosition(1,1):onClick(exitOs)
local logout_button = bottomBar:addButton():setText("Logout"):setBackground(colors.lightGray):setSize(8, 1):setPosition("parent.w-self.w+1",1):onClick(Logout)
local home_button = bottomBar:addButton():setText("Home"):setBackground(colors.lightGray):setSize(6,1):setPosition("parent.w/2-self.w/2",1)
-- MAIN OS END

local app_loader = require("modules.main_os.app_loader")
local apps = app_loader.get_default_apps()

local app_slots = {}
app_slots["app_frame"] = {}
app_slots["slot_handle"] = {}
app_slots["app_frame_2"] = {}
app_slots["slot_handle_2"] = {}

local spacing = {w = 8, h = 6}
local offset = {w = 4, h = 2}

for i = 1, #apps.appsL1 do
    app_slots["app_frame"][i] = apps.appsL1[i]["app"](desktop):hide()
end

for i = 1, #app_slots["app_frame"] do
    app_slots["slot_handle"][i] = {icon = desktop:addImage():setPosition(spacing.w*(i-1) + offset.w, offset.h):setImage(apps.appsL1[i]["icon"]):onClick(function () app_slots["app_frame"][i]:show(); end),
    nameL1 = desktop:addLabel():setText(apps.appsL1[i]["name"]["nameL1"]):setPosition(spacing.w*(i-1) + offset.w - (string.len(apps.appsL1[i]["name"]["nameL1"])-5)/2,3 + offset.h ):setForeground(colors.white),
    nameL2 = desktop:addLabel():setText(apps.appsL1[i]["name"]["nameL2"]):setPosition(spacing.w*(i-1) + offset.w - (string.len(apps.appsL1[i]["name"]["nameL2"])-5)/2,4 + offset.h ):setForeground(colors.white)}
end

for i = 1, #apps.appsL2 do
    app_slots["app_frame_2"][i] = apps.appsL2[i]["app"](desktop):hide()
end
for i = 1, #app_slots["app_frame_2"] do
    app_slots["slot_handle_2"][i] = {icon = desktop:addImage():setPosition(spacing.w*(i-1) + offset.w, offset.h + spacing.h):setImage(apps.appsL2[i]["icon"]):onClick(function () app_slots["app_frame_2"][i]:show(); end),
    nameL1 = desktop:addLabel():setText(apps.appsL2[i]["name"]["nameL1"]):setPosition(spacing.w*(i-1) + offset.w - (string.len(apps.appsL2[i]["name"]["nameL1"])-5)/2,3 + offset.h + spacing.h):setForeground(colors.white),
    nameL2 = desktop:addLabel():setText(apps.appsL2[i]["name"]["nameL2"]):setPosition(spacing.w*(i-1) + offset.w - (string.len(apps.appsL2[i]["name"]["nameL2"])-5)/2,4 + offset.h + spacing.h):setForeground(colors.white)}
end


local function home()
    for i = 1, #app_slots["app_frame_2"] do
        app_slots["app_frame_2"][i]:hide()
    end

    for i = 1, #app_slots["app_frame"] do
        app_slots["app_frame"][i]:hide()
    end
end

home_button:onClick(home)

-- local function show_app(self)
--     basalt.debug(self)
-- end

-- local function hide_app()
--     apps["test_app"][1]:hide()
-- end



local leftButton = desktop:addButton():setText("<"):setPosition(1, "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)
local leftButton = desktop:addButton():setText(">"):setPosition("parent.w", "parent.h/2-self.h/2"):setSize(1, 5):setBackground(colors.lightGray)




-- TODO
-- Add a app title

-- IDEA
-- Try to store a frame in a file and send it like a module

-- local testApp = desktop:addImage():setPosition(3, 2):loadImage("test.bimg"):onClick(show_app)

local function clockTick()
    while true do
        Clock:setText(os.date("%r"))
        sleep(0.01)
    end
end

local function clockTick_ls()
    while true do
        Clock_ls:setText(os.date("%r"))
        sleep(0.01)
    end
end

local clockThread = main_os:addThread()
local clockThread_ls = lock_screen:addThread()

--local imageThread = main:addThread()

clockThread:start(clockTick)
clockThread_ls:start(clockTick_ls)
--imageThread:start(updateImages)

basalt.autoUpdate()