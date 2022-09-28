function RegisterBlips(_blip)
    for _,v in pairs(Fuel.Stations) do
        local blip = AddBlipForCoord(v.pos)
        SetBlipSprite(blip, 361)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 1)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName("Station d'essence")
        EndTextCommandSetBlipName(blip)
    end
end

function ShowHelpNotification(text)
	AddTextEntry("HelpNotification", text)
    DisplayHelpTextThisFrame("HelpNotification", false)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function Keyboard(string_args, max)
    local string = nil
    AddTextEntry("CUSTOM_AMOUNT", "~s~"..string_args)
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", "", "", "", "", "", max or 20)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        string = GetOnscreenKeyboardResult()
        Citizen.Wait(0)
    else
        Citizen.Wait(0)
    end
    return string
end

function Notify(text)
    AddTextEntry("FuelNotify", "<C>"..text)
    BeginTextCommandThefeedPost("FuelNotify")
    EndTextCommandThefeedPostTicker(false, true)
end

function FindNearestFuelPump()
	local fuelPumps = {}
	local handle,object = FindFirstObject()
	local success
	repeat
        local models = {
            [-2007231801] = true,
            [1339433404] = true,
            [1694452750] = true,
            [1933174915] = true,
            [-462817101] = true,
            [-469694731] = true,
            [-164877493] = true
        }
		if models[GetEntityModel(object)] then
			table.insert(fuelPumps,object)
		end
		success,object = FindNextObject(handle,object)
	until not success
	EndFindObject(handle)
	local pumpObject = 0
	local pumpDistance = 1000
	for k,v in pairs(fuelPumps) do
		local dstcheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(v))
		if dstcheck < pumpDistance then
			pumpDistance = dstcheck
			pumpObject = v
		end
	end
	return pumpObject,pumpDistance
end

function coolcoolmec(time)
    cooldown = true
    Citizen.SetTimeout(time,function()
        cooldown = false
    end)
end