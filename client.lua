exports.qtarget:AddBoxZone("Zasilek", vector3(441.7989, -982.0529, 30.67834), 0.45, 0.35, { -- change coords
    name = "Zasilek",
    heading = 11.0, -- change heading 
    debugPoly = false, -- dont change that
    minZ = 30.77834, -- change minZ 
    maxZ = 30.87834, -- change maxZ
}, {
    options = {
        {
            icon = "fas fa-sign-out-alt",
            label = "Odbierz Zasiłek",
            action = function()
                TriggerServerEvent("kriss:odbierzZasilek")
            end
        },
    },
    distance = 2.5
})
