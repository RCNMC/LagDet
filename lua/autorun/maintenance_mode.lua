-- Dev Server --

if CLIENT then

net.Receive( "PrintColor", function()
  chat.AddText( unpack( net.ReadTable() ) )
end )

else
	
util.AddNetworkString( "PrintColor" )

local Meta = FindMetaTable( "Player" )

function Meta:PrintColor( ... )
  net.Start( "PrintColor" )
  net.WriteTable( { ... } )
  net.Send( self )
end

CreateConVar( "in_maintenance", 1, {"FCVAR_ARCHIVE"}, "Toggle maintenance on and off" )

print("[INFO]: Maintenance Mode System starting up...\n")
DaVar = GetConVar( "in_maintenance" )
if DaVar:GetInt() == 1 then
  print("[INFO]: Server was last in maintenance mode, therefore it will be when server is up.\n")
else
  print("[INFO]: Server was not in maintenance mode, therefore it won't be when server is up.\n")
end

hook.Add( "CheckPassword", "access_whitelist", function( steamID64, ip, svpass, clpass, name )
  Var = GetConVar( "in_maintenance" )
  if Var:GetInt() == 1 then
    local conply = tosteamid(steamID64)							
    if not table.HasValue({"admin","founder","superadmin","mod","dev"}, conply:GetNWString("usergroup")) then
      for k, v in pairs( player.GetAll() ) do
        v:PrintColor( Color( 255, 0, 0 ), "Failed Connection ", Color( 0, 0, 0 ), "\|/ ", Color( 255, 255, 255 ), name, " has attempted to connect but was denied.\nReason: Insignificant permissions" )
      end
      return false, "---------[ Arty's DarkRP ]---------\n\n           Access Denied\n Reason:  Insignificant permissions"
    end
  end
end )

end
