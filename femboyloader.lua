local http = require("gamesense/http")
local vector = require("vector")
local pui = require('gamesense/pui')

local owner = "luvettee"
local repo = "meowmrrpmrrp"
local branch = "main"
local subfolder = "luas"

local list_url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s/scripts_list.json", owner, repo, branch, subfolder)
local raw_url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s/", owner, repo, branch, subfolder)
local api_url = string.format("https://api.github.com/repos/%s/%s/contents/%s?ref=%s", owner, repo, subfolder, branch)
-- the git repo https://github.com/luvettee/meowmrrpmrrp/tree/main/luas
local menu_r, menu_g, menu_b = client.random_int(1, 255), client.random_int(1, 255), client.random_int(1, 255)

local js = panorama.open()
local steam_name = js.MyPersonaAPI.GetName()

local notify = (function()
    local b = vector
    local c = function(d, b, c) return d + (b - d) * c end
    local e = function() return b(client.screen_size()) end
    local f = function(d, ...)
        local c = { ... }
        local c = table.concat(c, "")
        return b(renderer.measure_text(d, c))
    end
    local g = { notifications = { bottom = {} }, max = { bottom = 6 } }
    g.__index = g
    g.new_bottom = function(...) table.insert(g.notifications.bottom,
        { started = false, instance = setmetatable(
            { active = false, timeout = 5, color = { ["r"] = menu_r, ["g"] = menu_g, ["b"] = menu_b, a = 0 }, x = e().x /
            2, y = e().y, text = ... }, g) }) end
    function g:handler()
        local d = 0
        local b = 0
        for d, b in pairs(g.notifications.bottom) do
            if not b.instance.active and b.started then
                table.remove(g.notifications.bottom, d)
            end
        end
        for d = 1, #g.notifications.bottom do
            if g.notifications.bottom[d].instance.active then
                b = b + 1
            end
        end
        for c, e in pairs(g.notifications.bottom) do
            if c > g.max.bottom then return end
            if e.instance.active then
                e.instance:render_bottom(d, b)
                d = d + 1
            end
            if not e.started then
                e.instance:start()
                e.started = true
            end
        end
    end
    function g:start()
        self.active = true
        self.delay = globals.realtime() + self.timeout
    end
    function g:get_text()
        local d = ""
        for b, b in pairs(self.text) do
            local c = f("", b[1])
            local c, e, f = 255, 255, 255
            if b[2] then c, e, f = menu_r, menu_g, menu_b end
            d = d .. ("\a%02x%02x%02x%02x%s"):format(c, e, f, self.color.a, b[1])
        end
        return d
    end
    local h = (function()
        local d = {}
        d.rec = function(d, b, c, e, f, g, h, i, j)
            j = math.min(d / 2, b / 2, j)
            renderer.rectangle(d, b + j, c, e - j * 2, f, g, h, i)
            renderer.rectangle(d + j, b, c - j * 2, j, f, g, h, i)
            renderer.rectangle(d + j, b + e - j, c - j * 2, j, f, g, h, i)
            renderer.circle(d + j, b + j, f, g, h, i, j, 180, .25)
            renderer.circle(d - j + c, b + j, f, g, h, i, j, 90, .25)
            renderer.circle(d - j + c, b - j + e, f, g, h, i, j, 0, .25)
            renderer.circle(d + j, b - j + e, f, g, h, i, j, -90, .25)
        end
        d.rec_outline = function(d, b, c, e, f, g, h, i, j, k)
            j = math.min(c / 2, e / 2, j)
            if j == 1 then
                renderer.rectangle(d, b, c, k, f, g, h, i)
                renderer.rectangle(d, b + e - k, c, k, f, g, h, i)
            else
                renderer.rectangle(d + j, b, c - j * 2, k, f, g, h, i)
                renderer.rectangle(d + j, b + e - k, c - j * 2, k, f, g, h, i)
                renderer.rectangle(d, b + j, k, e - j * 2, f, g, h, i)
                renderer.rectangle(d + c - k, b + j, k, e - j * 2, f, g, h, i)
                renderer.circle_outline(d + j, b + j, f, g, h, i, j, 180, .25, k)
                renderer.circle_outline(d + j, b + e - j, f, g, h, i, j, 90, .25, k)
                renderer.circle_outline(d + c - j, b + j, f, g, h, i, j, -90, .25, k)
                renderer.circle_outline(d + c - j, b + e - j, f, g, h, i, j, 0, .25, k)
            end
        end
        d.glow_module_notify = function(b, c, e, f, g, h, i, j, k, l, m, n, o, p, p)
            local q = 1
            local r = 1
            if p then d.rec(b, c, e, f, i, j, k, l, h) end
            for i = 0, g do
                local j = l / 2 * (i / g) ^ 3
                d.rec_outline(b + (i - g - r) * q, c + (i - g - r) * q, e - (i - g - r) * q * 2, f - (i - g - r) * q * 2, m, n, o, j / 1.5, h + q * (g - i + r), q)
            end
        end
        return d
    end)()
    function g:render_bottom(g, i)
        local e = e()
        local j = 6
        local k = "     " .. self:get_text()
        local f = f("", k)
        local l = 10
        local m = 5
        local n = 0 + j + f.x
        local n, o = n + m * 2, 12 + 10 + 1
        local p, q = self.x - n / 2, math.ceil(self.y - 40 + .4)
        local r = globals.frametime()
        if globals.realtime() < self.delay then
            self.y = c(self.y, e.y - 45 - (i - g) * o * 1.4, r * 7)
            self.color.a = c(self.color.a, 255, r * 2)
        else
            self.y = c(self.y, self.y - 10, r * 15)
            self.color.a = c(self.color.a, 0, r * 20)
            if self.color.a <= 1 then self.active = false end
        end
        local c, e, g, i = self.color.r, self.color.g, self.color.b, self.color.a
        h.glow_module_notify(p, q, n, o, 9, l, 25, 25, 25, i, menu_r, menu_g, menu_b, i, true)
        local h = m
        h = h + 0 + j
        renderer.text(p + h - 5, q + o / 2 - f.y / 2, menu_r, menu_g, menu_b, i, "b", nil, ">.< ")
        renderer.text(p + h, q + o / 2 - f.y / 2, c, e, g, i, "", nil, k)
    end
    client.set_event_callback("paint_ui", function() g:handler() end)
    return g
end)()

notify.new_bottom({ { "Hello " }, { steam_name .. ", ", true }, { "welcome to femboy lua loader" } })

local function read_json_file(filename)
    local content = readfile(filename)
    if content then
        local status, decoded = pcall(json.parse, content)
        if status then
            return decoded
        end
    end
    return nil
end

local script_names = {}
local script_statuses = {}
local formatted_scripts = {}

local group = pui.group('lua', 'b')
local script_list = group:listbox('Lua List', { "Loading scripts..." })
local info_label = group:label("\af5f125FF\u{F071}\r Double-click on a script to load or unload it")
local info_label2 = group:label("\abfbdbdFF thanks to everyone who gave safe luas")
local info_label3 = group:label("\abfbdbdFF made by bob and packett >.<")
local info_label4 = group:label("\abfbdbdFF pasted from yougame, thanks to Zer1fonnz")
-- its all pasted from yougame look here -- https://yougame.biz/threads/379853/ >.< thanks to Zer1fonnz

local function load_selected_script(script_name)
    local file_with_ext = script_name .. ".lua"

    http.get(raw_url .. file_with_ext, function(success, response)
        if not success or response.status ~= 200 then
            notify.new_bottom({ { "Failed to download " }, { script_name, true } })
            return
        end

        local lua_src = load(response.body)
        if not lua_src then
            notify.new_bottom({ { "Syntax error in " }, { script_name, true } })
            return
        end

        local active_luas = read_json_file("luas.json") or {}
        active_luas[script_name] = true
        writefile("luas.json", json.stringify(active_luas))

        script_statuses[script_name] = true

        for i, script_text in ipairs(formatted_scripts) do
            if script_text:match(script_name) then
                formatted_scripts[i] = "\a" .. string.format("%02x%02x%02x%02x", menu_r, menu_g, menu_b, 255) .. "\u{25C9} \abfbdbdFF " .. script_name
                script_list:update(formatted_scripts)
                break
            end
        end

        notify.new_bottom({ { "Successfully loaded " }, { script_name .. "! ", true } })
        local ok, err = pcall(lua_src)  -- <-- replaces the old lua_src()
        if not ok then
        notify.new_bottom({ { "Error in " }, { script_name .. ": " .. tostring(err), true } })
        end
    end)
end

local function load_autoload_scripts()
    local active_luas = read_json_file("luas.json") or {}
    for script_name, is_active in pairs(active_luas) do
        if is_active then
            load_selected_script(script_name)
        end
    end
end


local function list_scripts()
    http.get(api_url, function(success, response)
        if not success or response.status ~= 200 then
            script_list:update({ "Failed to connect to GitHub" })
            return
        end

        local status, decoded_data = pcall(json.parse, response.body)
        if not status then
            script_list:update({ "Error: Broken JSON" })
            return
        end

        local active_luas = read_json_file("luas.json") or {}
        script_names = {}
        formatted_scripts = {}

        for _, file in ipairs(decoded_data) do
            -- only .lua files
            if file.name:match("%.lua$") then
                local script_name = file.name:gsub("%.lua$", "")
                local is_active = active_luas[script_name] or false
                script_statuses[script_name] = is_active
                table.insert(script_names, script_name)

                local circle_prefix = is_active and "\u{25C9}" or "\u{25CB}"
                table.insert(formatted_scripts, "\a" .. string.format("%02x%02x%02x%02x", menu_r, menu_g, menu_b, 255) .. circle_prefix .. "\abfbdbdFF " .. script_name)
            end
        end

        script_list:update(formatted_scripts)
        load_autoload_scripts()
    end)
end


local function unload_selected_script(script_name)
    local active_luas = read_json_file("luas.json") or {}
    active_luas[script_name] = nil
    writefile("luas.json", json.stringify(active_luas))

    script_statuses[script_name] = false
    client.reload_active_scripts()
end

local last_click_time = 0
local last_click_index = -1

local function list_clicks()
    local listitem = (script_list:get() + 1)
    if not listitem or listitem <= 0 then return end

    local cur_time = globals.curtime()
    if last_click_index == listitem and last_click_time + 0.5 > cur_time then
        local selected_item = script_names[listitem]
        if not selected_item then return end

        if not script_statuses[selected_item] then
            load_selected_script(selected_item)
        else
            unload_selected_script(selected_item)
        end

        last_click_index = -1
    else
        last_click_index = listitem
        last_click_time = cur_time
    end
end

list_scripts()

script_list:set_callback(function()
    list_clicks()
end)