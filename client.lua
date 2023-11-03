--- Config ---

local reviveWait = 10 -- Change the timer count that you want the player to wait (in seconds).
local featureColor = "~y~" -- Game color used as the button key colors.

--- Code ---
local timerCount = reviveWait
local isDead = false

AddEventHandler('onClientMapStart', function()
	Citizen.Trace("CraftRevive: Disabling the autospawn.")
	exports.spawnmanager:spawnPlayer() 
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("CraftRevive: Autospawn is disabled.")
end)

function revivePed(ped)
	local playerPos = GetEntityCoords(ped, true)
	isDead = false
	timerCount = reviveWait
	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end

function ShowInfoRevive(text)
SetNotificationTextEntry("STRING")
AddTextComponentSubstringPlayerName(text)
DrawNotification(true, true)
end

Citizen.CreateThread(function()
    while true do
        if isDead then
			if timerCount ~= 0 then
				timerCount = timerCount - 1
			end
        end
        Citizen.Wait(1000)          
    end
end)


    while true do
    Citizen.Wait(0)
		ped = GetPlayerPed(-1)
        if IsEntityDead(ped) then
			isDead = true
            SetPlayerInvincible(ped, true)
            SetEntityHealth(ped, 1)
			ShowInfoRevive('You are dead. Use ~y~R ~w~to revive.')
            if IsControlJustReleased(0, 45) and GetLastInputMethod(0) then
                if timerCount <= 0 then
                    revivePed(ped)
				else
				TriggerEvent('chat:addMessage', {args = {'^1^*Please Wait ' .. timerCount .. ' more seconds before respawning'}})
            end
        end
    end
end

