function fullyloadedthing(ply)
  -- Connection message blah blah
  if new then
    ply:PrintColor( Color( 0, 255, 255 ), "Server | ", Color( 255, 255, 255 ), "Welcome to Buck Pony Servers, ", ply:Nick(), "! Type !spawn or press F2 to get into the action!" )
    for k, v in pairs( player.GetAll() ) do
      v:PrintColor( Color( 0, 255, 255 ), "Server | ", Color( 255, 255, 255 ), "Welcome our brand new player, ", ply:Nick(), ", to the server! (#", totaluniqueplayers, ")" )
    end
  else
    ply:PrintColor( Color( 0, 255, 255 ), "Server | ", Color( 255, 255, 255 ), "Welcome back to Buck Pony Servers, ", ply:Nick(), "! Type !spawn or press F2 to get into the action!" )
  end
end

hook.Add( "OnPlayerChat", "SpawnCommand", function( ply, strText, bTeam, bDead )

  strText = string.lower( strText )

  if ( strText == "!spawn" ) then
    if ply:GetPData( "posx", 0 ) != 0 then
      -- teleport to location
      -- give all weapons back and perks
      ply:PrintColor( Color( 0, 255, 255 ), "Server | ", Color( 255, 255, 255 ), "You've now spawned in and have 30 seconds of spawn protection.  Good luck." )
      -- start spawn protect and end after 30 seconds
      ply.Spawned = true
      return true 
    end
  else if ( strText == "!admin" ) then
    if ply:GetPData( "staff", 0 ) >= 1 then
      if ply.Admin == 0 then
        if ply.Spawned then
          -- save players data then toggle admin mode
        else
          -- Just toggle admin mode
        end
      else
        -- teleport to spawn 
      end
    end
    return true
  end
end )

function saveData( ply )
		-- do save shit
end
