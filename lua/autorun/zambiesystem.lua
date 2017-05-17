local adminWeapons = {
  "gmod_tool",
  "weapon_physgun"
}

local autoAnnounce = {
  "Find a bug?  Report it at our forums! Abusing bugs can lead to a permanent suspension! https://buckponyservers.tk",
  "Enjoy your stay!",
  "Be sure to read the rules! (!motd)",
  "Questions? Comments? Maybe suggestions? Let us know on our forums! https://buckponyservers.tk",
  "Seen someone breaking the rules? Report them by typing @ in chat! Do NOT use OOC!",
  "Have discord? We do! Join us today! (link)"
}

function fullyloadedthing(ply)
  -- Connection message blah blah
  if new then
    ply:PrintColor( Color( 50, 205, 50 ), "Server | ", Color( 255, 255, 255 ), "Welcome to Buck Pony Servers, ", ply:Nick(), "! Type !spawn or press F2 to get into the action!" )
    for k, v in pairs( player.GetAll() ) do
      v:PrintColor( Color( 50, 205, 50 ), "Server | ", Color( 255, 255, 255 ), "Welcome our brand new player, ", ply:Nick(), ", to the server! (#", totaluniqueplayers, ")" )
    end
  else
    ply:PrintColor( Color( 50, 205, 50 ), "Server | ", Color( 255, 255, 255 ), "Welcome back to Buck Pony Servers, ", ply:Nick(), "! Type !spawn or press F2 to get into the action!" )
  end
end
if server then
hook.Add( "OnPlayerChat", "SpawnCommand", function( ply, strText, bTeam, bDead )

  strText = string.lower( strText )

  if ( strText == "!spawn" ) then
    if ply.Admin == 1 then
      ply:PrintColor( Color( 255, 0, 0 ), "Server | ", Color( 255, 255, 255 ), "Unable to spawn you in as you are in admin mode!  Use !admin to disable then try again." )
    else
      if ply:GetPData( "posx", 0 ) != 0 then
        -- teleport to location
        -- give all weapons back and perks
        ply:PrintColor( Color( 50, 205, 50 ), "Server | ", Color( 255, 255, 255 ), "You've now spawned in and have 30 seconds of spawn protection.  Good luck." )
        -- start spawn protect and end after 30 seconds
        ply.Spawned = true
        return true 
      end
    end
  else if ( strText == "!admin" ) then
    if ply:GetPData( "staff", 0 ) >= 1 then
      if ply.Admin == 0 then
        if ply.Spawned then
          saveData(ply)
          ply:StripWeapons()
          ply:StripAmmo()
          for k, v in pairs( adminWeapons ) do
            ply:Give(v)
          end
          -- Teleport to spawn
          ply:PrintColor( Color( 255, 0, 0 ), "Admin | ", Color( 255, 255, 255 ), "You are now in admin mode.  Type !admin to disable." )
          for k, v in pairs( player.GetAll() ) do
            if v != ply then
              v:PrintColor( Color( 255, 0, 0 ), "Admin | ", Color( 255, 255, 255 ), ply:Nick(), " has entered admin mode." )
            end
          end
        else
          ply:StripWeapons()
          ply:StripAmmo()
          for k, v in pairs( adminWeapons ) do
            ply:Give(v)
          end
          -- Teleport to spawn
          ply:PrintColor( Color( 255, 0, 0 ), "Admin | ", Color( 255, 255, 255 ), "You are now in admin mode.  Type !admin to disable." )
          for k, v in pairs( player.GetAll() ) do
            if v != ply then
              v:PrintColor( Color( 255, 0, 0 ), "Admin | ", Color( 255, 255, 255 ), ply:Nick(), " has entered admin mode." )
            end
          end
        end
      else
          ply:StripWeapons()
          ply:StripAmmo()
          -- teleport to spawn
          ply:PrintColor( Color( 255, 0, 0 ), "Admin | ", Color( 255, 255, 255 ), "You have now left admin mode." )
          for k, v in pairs( player.GetAll() ) do
            if v != ply then
              v:PrintColor( Color( 255, 0, 0 ), "Admin | ", Color( 255, 255, 255 ), ply:Nick(), " has left admin mode." )
            end
          end
      end
    end
    return true
  end
end )

function saveData( ply )
  ply:SetPData( "weapons", ply:GetWeapons() )
  ply:SetPData( "PosX", ply:GetPos().x )
  ply:SetPData( "PosY", ply:GetPos().y )
  ply:SetPData( "PosZ", ply:GetPos().z )
end

end
