local strIdentifier = "Loading... NOM NOM NOM"

hook.Add ("Think", strIdentifier, function ()
    if IsValid (LocalPlayer ()) then
        -- If you really want to pass your self, go ahead but it's clientside so your essentially the only one using this hook.
        -- hook.Call ("PlayerFinishedLoading", GAMEMODE, LocalPlayer ())

        hook.Call ("PlayerFinishedLoading", GAMEMODE)
        hook.Remove ("Think", strIdentifier)
    end
end)
