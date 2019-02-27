--
-- ┌───────┐                                   ┬
-- │┌─┐    │ Snailsoft                         │  WhisperCache
-- │└─┐ɴᴀɪʟ│ https://snail.software            │  https://snail.software
-- │└─┘ˢᵒᶠᵗ│ https://github.com/snailsoftware  │  https://github.com/snailsoftware/whispercache
-- └───────┘                                   ┴
--
-- Copyright (C) 2016-2019 Snailsoft <https://snail.software/>
--
-- This program is free software; you can redistribute it and/or modify it
-- under the terms of the GNU General Public License as published by the
-- Free Software Foundation; either version 2 of the License, or (at your
-- option) any later version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
-- more details.
--
-- You should have received a copy of the GNU General Public License along
-- with this program. If not, see <http://www.gnu.org/licenses/>.
--

if not Whispers then
	Whispers = {}
end

local WhisperCache = CreateFrame("Frame")

WhisperCache:RegisterEvent("CHAT_MSG_WHISPER")
WhisperCache:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
WhisperCache:RegisterEvent("PLAYER_ENTERING_WORLD")

WhisperCache:SetScript("OnEvent",
	function(Self, Event, ...)
		if Event == "CHAT_MSG_WHISPER" then
			local Message, Player = ...
			local GUID = select(12, ...)
			
			if not Whispers[GUID] then
				Whispers[GUID] = {}
			end
			
			Whispers[GUID][#Whispers[GUID] + 1] =
			{
				Message = Message,
				Player = Player
			}
		elseif Event == "CHAT_MSG_WHISPER_INFORM" then
			local GUID = select(12, ...)
			
			if Whispers[GUID] then
				Whispers[GUID] = nil
			end
		elseif Event == "PLAYER_ENTERING_WORLD" then
			local UnreadWhispers = 0
			
			for _, Messages in pairs(Whispers) do
				for Message in ipairs(Messages) do
					UnreadWhispers = UnreadWhispers + 1
				end
			end
			
			if UnreadWhispers == 1 then
				print("|cFFFF00FF[WhisperCache] You have|r |cFFFF0000" .. UnreadWhispers .. "|r |cFFFF00FFunread whisper!|r")
			elseif UnreadWhispers > 1 then
				print("|cFFFF00FF[WhisperCache] You have|r |cFFFF0000" .. UnreadWhispers .. "|r |cFFFF00FFunread whispers!|r")
			end
		end
	end
)

SlashCmdList["WhisperCache"] = function()
	for Player, Messages in pairs(Whispers) do
		for _, Message in ipairs(Messages) do
			print("|cFFFF7EFF[" .. Message.Player ..  "] whispers: " .. Message.Message .. "|r")
		end
	end
	
	Whispers = {}
end

SLASH_WhisperCache1 = "/wc"
