function claimGrant()
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local currentTime = os.time()

    local query = "SELECT * FROM Zasilek WHERE Identifier = @identifier"
    local params = {
        ['@identifier'] = identifier
    }

    MySQL.Async.fetchAll(query, params, function(result)
        if result[1] then
            local expirationTime = result[1].Czas

            if currentTime >= expirationTime then
                local grantAmount = math.random(700, 950)
                local newExpirationTime = currentTime + 3600

                xPlayer.showNotification("Odebrano zasiłek")
                xPlayer.addMoney(grantAmount)

                local updateQuery = "UPDATE Zasilek SET Czas = @newExpirationTime WHERE Identifier = @identifier"
                local updateParams = {
                    ['@newExpirationTime'] = newExpirationTime,
                    ['@identifier'] = identifier
                }

                MySQL.Async.execute(updateQuery, updateParams, function(rowsAffected)

                end)
            else
                xPlayer.showNotification("Nie możesz odebrać teraz zasiłku. Spróbuj później")
            end
        else
            xPlayer.showNotification("Nie znaleziono zasiłku dla tego gracza")
        end
    end)
end

function addGrant(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.getIdentifier()
    local currentTime = os.time()

    local query = "SELECT * FROM Zasilek WHERE Identifier = @identifier"
    local params = {
        ['@identifier'] = identifier
    }

    MySQL.Async.fetchAll(query, params, function(result)
        if not result[1] then
            local expirationTime = currentTime

            local insertQuery = "INSERT INTO Zasilek (Identifier, Czas) VALUES (@identifier, @expirationTime)"
            local insertParams = {
                ['@identifier'] = identifier,
                ['@expirationTime'] = expirationTime
            }

            MySQL.Async.execute(insertQuery, insertParams, function(rowsAffected)
                xPlayer.showNotification("Zasiłek został Ci przyznany")
            end)
        else
            xPlayer.showNotification("Już masz aktywny zasiłek")
        end
    end)
end

function removeGrant(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.getIdentifier()

    local query = "SELECT * FROM Zasilek WHERE Identifier = @identifier"
    local params = {
        ['@identifier'] = identifier
    }

    MySQL.Async.fetchAll(query, params, function(result)
        if result[1] then
            local deleteQuery = "DELETE FROM Zasilek WHERE Identifier = @identifier"
            local deleteParams = {
                ['@identifier'] = identifier
            }

            MySQL.Async.execute(deleteQuery, deleteParams, function(rowsAffected)
                if rowsAffected > 0 then
                    xPlayer.showNotification("Zasiłek został usunięty")
                else
                    xPlayer.showNotification("Nie udało się usunąć zasiłku")
                end
            end)
        else
            xPlayer.showNotification("Ten gracz nie ma aktywnego zasiłku")
        end
    end)
end

RegisterServerEvent("kriss:usunZasilek", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "doj" then
        removeGrant(id)
    end
end)


RegisterServerEvent("kriss:nadajZasilek", function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getJob().name == "doj" then
        addGrant(id)
    end
end)

RegisterServerEvent("kriss:odbierzZasilek", function()
claimGrant(source)
end)

