-- Main Server --

CreateConVar( "in_maintenance", 0, {"FCVAR_ARCHIVE"}, "Toggle maintenance on and off" )

hook.Add( "CheckPassword", "access_whitelist", function( steamID64, ip, svpass, clpass, name )
	Var = GetConVar( "in_maintenance" )
  if Var:GetInt() == 1 then
    p = player.GetBySteamID64( steamID64 )
    if not table.HasValue({"admin","founder","superadmin","mod","dev"}, p:GetNWString("usergroup")) then
      for k, v in pairs( player.GetAll() ) do
        v:PrintColor( Color( 255, 0, 0 ), "Failed Connection ", Color( 0, 0, 0 ), "\|/ ", Color( 255, 255, 255 ), name, " has attempted to connect but was denied.\nReason: Insignificant permissions" )
      end
      return false, "--------[ Arty's DarkRP ]--------\n\n      Undergoing Maintenance"
		end
	end
end )

-- Dev Server --

CreateConVar( "in_maintenance", 1, {"FCVAR_ARCHIVE"}, "Toggle maintenance on and off" )

hook.Add( "CheckPassword", "access_whitelist", function( steamID64, ip, svpass, clpass, name )
	Var = GetConVar( "in_maintenance" )
  if Var:GetInt() == 1 then
    p = player.GetBySteamID64( steamID64 )
    if not table.HasValue({"admin","founder","superadmin","mod","dev"}, p:GetNWString("usergroup")) then
      for k, v in pairs( player.GetAll() ) do
        v:PrintColor( Color( 255, 0, 0 ), "Failed Connection ", Color( 0, 0, 0 ), "\|/ ", Color( 255, 255, 255 ), name, " has attempted to connect but was denied.\nReason: Insignificant permissions" )
      end
      return false, "---------[ Arty's DarkRP ]---------\n\n           Access Denied\n Reason:  Insignificant permissions"
		end
	end
end )
