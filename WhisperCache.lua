-- Part of WhisperCache
-- https://github.com/snail23/WhisperCache

if not Whispers then
    Whispers = {}
end

local WhisperCache = CreateFrame("Frame")

WhisperCache:RegisterEvent("CHAT_MSG_WHISPER")
WhisperCache:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
WhisperCache:RegisterEvent("PLAYER_ENTERING_WORLD")

WhisperCache:SetScript("Onevent",
    function(self, event, ...)
        if event == "CHAT_MSG_WHISPER" then
            local message, player = ...
            local guid = select(12, ...)
            
            if not Whispers[guid] then
                Whispers[guid] =
                {
                    player = player
                }
            end
            
            Whispers[guid][#Whispers[guid] + 1] = message
        elseif event == "CHAT_MSG_WHISPER_INFORM" then
            local guid = select(12, ...)
            
            if Whispers[guid] then
                Whispers[guid] = nil
            end
        elseif event == "PLAYER_ENTERING_WORLD" then
            local unread = 0
            
            for _, messages in pairs(Whispers) do
                unread = unread + #messages
            end
            
            if unread == 1 then
                print("|cFFFF00FF[WhisperCache] You have|r |cFFFF0000" .. unread .. "|r |cFFFF00FFunread whisper!|r")
            elseif unread > 1 then
                print("|cFFFF00FF[WhisperCache] You have|r |cFFFF0000" .. unread .. "|r |cFFFF00FFunread whispers!|r")
            end
        end
    end
)

SlashCmdList["WhisperCache"] = function()
    for _, messages in pairs(Whispers) do
        for i = 1, #messages do
            print("|cFFFF7EFF[" .. messages.player ..  "] whispers: " .. messages[i] .. "|r")
        end
    end
    
    Whispers = {}
end

SLASH_WhisperCache1 = "/wc"
