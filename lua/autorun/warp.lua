--[[
  Warps
  Created By: https://github.com/sweepyoface
  Edited For Personal Use
]]--
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

end

Staff_Warp = {}

Staff_Warp.Groups = {
  "founder",
  "dev",
  "superadmin",
  "headmod",
  "admin",
  "mod"
}

Staff_Warp.Locations = {

	["rp_downtown_rldv3"] = {
		["admin"] = {
			["pos"] = Vector(-4725, -5121.4, 956.5),
			["ang"] = Angle(-0, 180, 0)
		},
	}
  
}

hook.Add("PlayerSay", "StaffWarpTPCommand", function(ply, text)
	local args = string.Explode(" ", text)
	local location = args[2]
	local map = game.GetMap()
	if (args[1] == "!warp") and (Staff_Warp.Locations[map][location] != nil) then
		if (table.HasValue(Staff_Warp.Groups, ply:GetNWString("usergroup"))) then
			ply:SetPos(Staff_Warp.Locations[map][location]["pos"])
			ply:SetEyeAngles(Staff_Warp.Locations[map][location]["ang"])
			for k,v in pairs(player.GetAll()) do
				if (table.HasValue(Staff_Warp.Groups, ply:GetNWString("usergroup"))) then
					v:PrintColor( Color( 255, 0, 0 ), "Staff Warps ", Color( 255, 255, 255 ), "| ", ply:Nick(), " teleported to ", location, "!")
				end
			end
		else
			ply:PrintColor( Color( 255, 0, 0 ), "Staff Warps ", Color( 255, 255, 255 ), "| ", ply:Nick(), ", you do not have permission to use this command!")
		end
		return ""	
	else
    if (args[1] == "!printloc") then
      Pos = ply:GetPos()
      Ang = ply:GetAimVector()
      ply:ChatPrint( "Position: " .. Pos .. " | Angle " .. Ang .. " | Yeah Boi" )
    end
  end
end)
