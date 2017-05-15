function fullyloadedthing(ply)
  -- Connection message blah blah
  if new then
    ply:PrintColor( Color( 0, 255, 255 ), "Server | ", Color( 255, 255, 255 ), "Welcome to Buck Pony Servers, ", ply:Nick(), "! Type !spawn or press F2 to get into the action!" )
    (print all)
      v:PrintColor( Color( 0, 255, 255 ), "Server | ", Color( 255, 255, 255 ), "Welcome our brand new player, ", ply:Nick(), ", to the server! (#", totaluniqueplayers, ")" )
  else
    ply:PrintColor( Color( 0, 255, 255 ), "Server | ", Color( 255, 255, 255 ), "Welcome back to Buck Pony Servers, ", ply:Nick(), "! Type !spawn or press F2 to get into the action!" )
  end
end

hook.Add( "OnPlayerChat", "SpawnCommand", function( ply, strText, bTeam, bDead )

	strText = string.lower( strText ) -- make the string lower case

	if ( strText == "!spawn" ) then -- if the player typed /hello then
		if ply:GetPData( "posx", 0 ) != 0 then
        -- teleport to location
        -- give all weapons back and perks
        ply:PrintColor( Color( 0, 255, 255 ), "Server | ", Color( 255, 255, 255 ), "You've now spawned in and have 30 seconds of spawn protection.  Good luck." )
        -- start spawn protect and end after 30 seconds
		return true -- this suppresses the message from being shown
	end

end )
