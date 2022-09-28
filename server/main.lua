local FuelStations = {}

local function CreateStation(station_id)
    MySQL.Async.insert("INSERT INTO fuel_stations (`station_id`, `station_fuel`) VALUES ('"..(station_id).."', '"..(0.0).."')", {
    }, function(id)
        FuelStations[tostring(station_id)] = {
            id = id,
            station_id = station_id,
            station_fuel = 0.0
        }
    end)
end

local function UpdateFuel(fuel)
    MySQL.Sync.execute("UPDATE fuel_stations SET `station_fuel`=@station_fuel WHERE id=@id", {
		["@id"] = fuel.id,
        ["@station_fuel"] = fuel.station_fuel,
	})
end

MySQL.ready(function()
    local stations = MySQL.Sync.fetchAll("SELECT * FROM fuel_stations", {})
    for k,v in pairs(stations) do
        FuelStations[tostring(v.station_id)] = {
            id = v.id,
            station_id = v.station_id,
            station_fuel = v.station_fuel
        }
    end
    for k,v in pairs(Fuel.Stations) do
        if (FuelStations[tostring(v.id)] == nil) then
            CreateStation(v.id)
        end
    end
end)

RegisterNetEvent("Fuel:RequestStationsData")
AddEventHandler("Fuel:RequestStationsData", function()
    local source = source
    TriggerClientEvent("Fuel:OnRequestStationsData", source, FuelStations)
end)

RegisterNetEvent("Fuel:UpdateStationFuel")
AddEventHandler("Fuel:UpdateStationFuel", function(fuel, station_id)
    if ((FuelStations[tostring(station_id)].station_fuel - fuel) > 0) then
        FuelStations[tostring(station_id)].station_fuel = (FuelStations[tostring(station_id)].station_fuel - fuel) 
        TriggerClientEvent("Fuel:OnUpdateStationFuel", -1, FuelStations[tostring(station_id)].station_fuel, station_id)
        UpdateFuel(FuelStations[tostring(station_id)])
    end
end)

RegisterNetEvent("Fuel:AddStationFuel")
AddEventHandler("Fuel:AddStationFuel", function(fuel, station_id)
    if ((FuelStations[tostring(station_id)].station_fuel + fuel)) then
        FuelStations[tostring(station_id)].station_fuel = (FuelStations[tostring(station_id)].station_fuel + fuel) 
        TriggerClientEvent("Fuel:OnUpdateStationFuel", -1, FuelStations[tostring(station_id)].station_fuel, station_id)
        UpdateFuel(FuelStations[tostring(station_id)])
    end
end)

if (Fuel.UseESX) then
    ESX = nil
    TriggerEvent(Fuel.UseESX, function(obj) ESX = obj end)

    local Gived = false

    RegisterNetEvent("Fuel:Salary")
    AddEventHandler("Fuel:Salary", function(salary)
        local source = source
        if (salary > Fuel.MaxSalary or Gived) then
            DropPlayer(source, "Cheat give money")
            return
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer ~= nil) then
            xPlayer.addMoney(salary)
            Gived = true
            Citizen.Wait(10*1000)
            Gived = false
        end
    end)
end