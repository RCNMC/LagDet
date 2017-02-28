if CLIENT then

  net.Receive( "PrintColor", function()
    chat.AddText( unpack( net.ReadTable() ) )
  end )
  
local Frame = vgui.Create( "DFrame" )
Frame:SetTitle( "Debug Menu" )
Frame:SetSize( 300, 300 )
Frame:Center()
Frame:MakePopup()
Frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 231, 76, 60, 150 ) ) -- Draw a red box instead of the frame
end

local Button = vgui.Create( "DButton", Frame )
Button:SetText( "Test Prop-Kill Message" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( 100, 100 )
Button:SetSize( 100, 30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) -- Draw a blue button
end
Button.DoClick = function()
	net.Start("TestMsgProp")
	net.SendToServer()
end

net.Recieve( "OpenDaMenu", function()
	Frame:Show()		
end )

else

  util.AddNetworkString( "PrintColor" )
  util.AddNetworkString( "OpenDaMenu" )
  util.AddNetworkString( "TestMsgProp" )
  local Meta = FindMetaTable( "Player" )

  function Meta:PrintColor( ... )
    net.Start( "PrintColor" )
    net.WriteTable( { ... } )
    net.Send( self )
  end
  
  function Meta:OpenDaMenu( ... )
    net.Start("OpenDaMenu")
    net.Send( self )
  end
	
  net.Receive( "TestMsgProp", function( len, ply )
    	for k, v in pairs( player.GetAll() ) do
		if table.HasValue({"admin","founder","superadmin","mod"}, ply:GetNWString("usergroup")) then
			v:PrintColor( Color( 255, 0, 0 ), "Prop Protection ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), ply:Nick(), " was almost prop-killed by some dude!  Note: This is just a debug message!" )
		end
	end
  end )

hook.Add( "PhysgunPickup", "NoPushIndex", function(ply,ent)
	if (IsValid(ply) and IsValid(ent)) and ent.CPPICanPhysgun and ent:CPPICanPhysgun(ply) then
		local collision = ent:GetCollisionGroup()
		ent.AntiPush.Collision = (collision == COLLISION_GROUP_INTERACTIVE_DEBRIS) and COLLISION_GROUP_NONE or collision
		if collision == COLLISION_GROUP_NONE then 
			ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS) 
		end
	end
end)

hook.Add( "PhysgunDrop", "NoPushNoThrow", function(ply,ent)
	if (IsValid(ply) and IsValid(ent)) and ent.AntiPush and ent.AntiPush.Collision then
		ent:SetCollisionGroup(ent.AntiPush.Collision)
	end
end)

hook.Add("OnPhysgunFreeze", "NoPushPhysgunFreeze", function(_, phys, ent, ply)
	if (IsValid(ply) and IsValid(ent)) and ent.AntiPush and ent.AntiPush.Collision then
		ent:SetCollisionGroup(ent.AntiPush.Collision)
	end
end)

  function antiPropDamage (victim, attacker)
    if (attacker:IsValid()) then
        if (attacker:GetClass() == "prop_physics" or attacker:IsWorld() or attacker:GetClass() == "prop_vehicle_jeep") then
            owner = attacker:CPPIGetOwner():Nick()
	    prop = attacker:GetPhysicsObject()
            prop:EnableMotion(false)
            attacker:SetColor( Color( 255, 0, 0, 255 ) )
			for k, v in pairs( player.GetAll() ) do
				if table.HasValue({"admin","founder","superadmin","mod"}, ply:GetNWString("usergroup")) then
					v:PrintColor( Color( 255, 0, 0 ), "Prop Protection ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), victim:Nick(), " was almost prop-killed by ", owner, "!" )
				end
			end
			
            return false
        else
            if (attacker:IsPlayer()) then
                if (attacker:InVehicle()) then
                    owner = attacker:CPPIGetOwner()
                    attacker:EnableMotion(false)
			for k, v in pairs( player.GetAll() ) do
				if table.HasValue({"admin","founder","superadmin","mod"}, ply:GetNWString("usergroup")) then
					v:PrintColor( Color( 255, 0, 0 ), "CDM Protection ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), victim:Nick(), " was almost CDM'd by ", owner, "!" )
				end
			end
			
                    return false
                end
            else
                return true
            end
        end
    end
  end

  hook.Add("PlayerShouldTakeDamage", "nopropdamage", antiPropDamage)

  concommand.Add( "logan_propkill_debug", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
	    if ply:SteamID64() == "76561198073713846" then
	        ply:OpenDaMenu()
	    else
		print(ply:SteamID64() .. "\n\n")
	        print("This is only for the creator of the addon to test things out!  Read more about it in the update logs!")
	    end
	end
  end )
	
end
