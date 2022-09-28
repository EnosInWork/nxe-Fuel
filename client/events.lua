RegisterNetEvent("Fuel:OnRequestStationsData")
AddEventHandler("Fuel:OnRequestStationsData", function(stations)
    local function GetFuel(id)
        for k,v in pairs(stations) do
            if (tostring(v.station_id) == tostring(id)) then
                return v.station_fuel
            end
        end
    end
    for k,v in pairs(Fuel.Stations) do
        local fuel = GetFuel(v.id)
        v.fuel = fuel
    end
end)

RegisterNetEvent("Fuel:OnUpdateStationFuel")
AddEventHandler("Fuel:OnUpdateStationFuel", function(fuel, station_id)
    for k,v in pairs(Fuel.Stations) do
        if (tostring(v.id) == tostring(station_id)) then
            v.fuel = fuel
            break
        end
    end
end)