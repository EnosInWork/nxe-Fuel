local onFuel = false
local FuelClasses = {
    [0] = 0.7, -- Compacts
    [1] = 0.7, -- Sedans
    [2] = 0.7, -- SUVs
    [3] = 0.7, -- Coupes
    [4] = 0.7, -- Muscle
    [5] = 0.7, -- Sports Classics
    [6] = 0.7, -- Sports
    [7] = 0.7, -- Super
    [8] = 0.5, -- Motorcycles
    [9] = 0.7, -- Off-road
    [10] = 0.3, -- Industrial
    [11] = 0.4, -- Utility
    [12] = 0.6, -- Vans
    [13] = 0.0, -- Cycles
    [14] = 0.5, -- Boats
    [15] = 0.9, -- Helicopters
    [16] = 0.9, -- Planes
    [17] = 0.5, -- Service
    [18] = 0.9, -- Emergency
    [19] = 0.5, -- Military
    [20] = 0.5, -- Commercial
    [21] = 0.0, -- Trains
}

local FuelUsage = {
    [1.0] = 1.4,
    [0.9] = 1.2,
    [0.8] = 1.0,
    [0.7] = 0.9,
    [0.6] = 0.8,
    [0.5] = 0.7,
    [0.4] = 0.5,
    [0.3] = 0.4,
    [0.2] = 0.2,
    [0.1] = 0.1,
    [0.0] = 0.0,
}

Citizen.CreateThread(function()
    DecorRegister("_FUEL_LEVEL", 1)
    while true do
        if IsPedInAnyVehicle(PlayerPedId()) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()),-1) == PlayerPedId() then
                if IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId())) then
                    SetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId()), GetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId())) - FuelUsage[Round(GetVehicleCurrentRpm(GetVehiclePedIsIn(PlayerPedId())),1)] * (FuelClasses[GetVehicleClass(GetVehiclePedIsIn(PlayerPedId()))] or 1.0) / 10)
                    DecorSetFloat(GetVehiclePedIsIn(PlayerPedId()), "_FUEL_LEVEL", GetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId())))
                end
            end
        end
        Citizen.Wait(2000)
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent("Fuel:RequestStationsData")
    RegisterBlips()
    while true do
        local wait = 750
        for k,v in pairs(Fuel.Stations) do
            if #(v.pos - GetEntityCoords(GetPlayerPed(-1))) < 20.0 then
                local pumpObject,pumpDistance = FindNearestFuelPump()
                if pumpDistance < 3.0 then
                    wait = 0
                    if IsPedSittingInAnyVehicle(PlayerPedId()) then
                        ShowHelpNotification(Fuel.Language.Exit_Vehicle_for_Add)
                    else
                        if not onFuel then
                            local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
                            local getessencebg = math.floor(GetVehicleFuelLevel(vehicle))

                            ShowHelpNotification("- Station d'essence N°~y~"..(k).."~s~ (ID : "..(v.id)..")~s~\n- Litre(s) disponible(s) : ~b~"..(v.fuel or 0.0).."~s~ Litre(s)\n- Votre résérvoir possède : "..getessencebg.." Litre(s)\n- Appuyez sur ~INPUT_CELLPHONE_LEFT~ ~INPUT_CELLPHONE_RIGHT~ pour changer le remplissage\n- Appuyez sur ~INPUT_CONTEXT~ pour ~o~remplir~s~ : ← "..(Fuel.LiterList[Fuel.LiterIndex]).." → Litre(s)\n- Prix total du remplissage : ~g~"..(Fuel.PriceForOneLiter*Fuel.LiterList[Fuel.LiterIndex]).."$")

                            if IsControlJustPressed(0, 174) then
                                if (Fuel.LiterIndex - 1) <= 0 then
                                    Fuel.LiterIndex = #Fuel.LiterList
                                else
                                    Fuel.LiterIndex = (Fuel.LiterIndex - 1)
                                end
                            end

                            if IsControlJustPressed(0, 175) then
                                if (Fuel.LiterIndex + 1) >= #Fuel.LiterList then
                                    Fuel.LiterIndex = 1
                                else
                                    Fuel.LiterIndex = (Fuel.LiterIndex + 1)
                                end
                            end

                            if IsControlJustPressed(0, 38) then
                                if (tonumber(v.fuel) >= Fuel.LiterList[Fuel.LiterIndex]) then
                                    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 10.0, 0, 70)
                                    local oldFuel = GetVehicleFuelLevel(vehicle)
                                    local fuelToAdd = Fuel.LiterList[Fuel.LiterIndex]
                                    local currentFuel = oldFuel + fuelToAdd
                                    if currentFuel > 100.0 then
                                        ShowNotification(Fuel.Language.FullFuel)
                                    else
                                        onFuel = true
                                        TriggerServerEvent("Fuel:UpdateStationFuel", Fuel.LiterList[Fuel.LiterIndex], v.id)
                                        Wait(10)
                                        SetVehicleFuelLevel(vehicle, currentFuel)
                                        DecorSetFloat(vehicule, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
                                        Wait(10)
                                        onFuel = false
                                        Notify(Fuel.Language.SuccessFuelAdd)
                                    end
                                else
                                    Notify(Fuel.Language.StationNotHave)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(wait)
    end
end)