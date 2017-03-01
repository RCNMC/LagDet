if CLIENT then

  net.Receive( "PrintColor", function()
    chat.AddText( unpack( net.ReadTable() ) )
  end )
  
local Frame = vgui.Create( "DFrame" )
Frame:SetTitle( "Debug Menu" )
Frame:SetSize( 300, 300 )
Frame:Center()
Frame:MakePopup()
Frame.Paint = function( self, w, h ) 
	draw.RoundedBox( 0, 0, 0, w, h, Color( 231, 76, 60, 150 ) ) 
end

local Button = vgui.Create( "DButton", Frame )
Button:SetText( "Test Prop-Kill Message" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( 100, 100 )
Button:SetSize( 100, 30 )
Button.Paint = function( self, w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( 41, 128, 185, 250 ) ) 
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
		if table.HasValue({"admin","founder","superadmin","mod"}, v:GetNWString("usergroup")) then
			v:PrintColor( Color( 255, 0, 0 ), "Prop Protection ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), ply:Nick(), " was almost prop-killed by some dude!  Note: This is just a debug message!" )
		end
	end
  end )


hook.Add( "PhysgunPickup", "NoPushIndex", function(ply,ent)
	if (IsValid(ply) and IsValid(ent)) and ent.CPPICanPhysgun and ent:CPPICanPhysgun(ply) then
		local collision = ent:GetCollisionGroup()
		if collision == 0 then 
			ent:SetCollisionGroup(COLLISION_GROUP_WEAPON) 
		end
	end
	if (ent:IsPlayer() and ent.isFroze) then
		ent:PrintColor( Color( 255, 0, 0 ), "Staff Action ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255), "You were un-frozen by ", ply:Nick(), "!" )
		ent.isFroze = false
		ent:GodDisable()
		for k, v in pairs( player.GetAll() ) do
			if table.HasValue({"admin","founder","superadmin","mod"}, v:GetNWString("usergroup")) then
				v:PrintColor( Color( 255, 0, 0 ), "Staff Action ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), ply:Nick(), " has unfroze ", ent:Nick(), "!" )
			end
		end
	end
end)

hook.Add("OnPhysgunFreeze", "NoPushPhysgunFreeze", function(_, phys, ent, ply)
	if IsValid(ply) and IsValid(ent) then
		local trace = { start = ent:GetPos(), endpos = ent:GetPos(), filter = ent, ignoreworld = true }
	    local tr = util.TraceEntity( trace, ent )
		if ( tr.Hit and tr.Entity.IsPlayer and tr.Entity:IsPlayer()) then
			owner = ent:CPPIGetOwner()
			owner:PrintColor( Color( 255, 0, 0 ), "Prop Protection ", Color( 255, 255, 255), "| Your prop was not froze due to it being inside of someone!")
			ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		else
			ent:SetCollisionGroup(COLLISION_GROUP_NONE)
		end
	end
	if ent:IsPlayer() then
		ent:Freeze( true )
        	ent:SetMoveType(MOVETYPE_NONE)
		ent:PrintColor( Color( 255, 0, 0 ), "Staff Action ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255), "You were frozen by ", ply:Nick(), "!" )
		ent.isFroze = true
		ent:GodEnable()
		for k, v in pairs( player.GetAll() ) do
			if table.HasValue({"admin","founder","superadmin","mod"}, v:GetNWString("usergroup")) then
				v:PrintColor( Color( 255, 0, 0 ), "Staff Action ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), ply:Nick(), " has froze ", ent:Nick(), "!" )
			end
		end
	end
end)

  function antiPropandCarDamage (victim, attacker)
    if (attacker:IsValid()) then
        if (attacker:GetClass() == "prop_physics" or attacker:IsWorld() or attacker:GetClass() == "prop_vehicle_jeep") then
        	owner = attacker:CPPIGetOwner():Nick()
		prop = attacker:GetPhysicsObject()
        	prop:EnableMotion(false)
        	attacker:SetColor( Color( 255, 0, 0, 255 ) )
		for k, v in pairs( player.GetAll() ) do
			if table.HasValue({"admin","founder","superadmin","mod"}, v:GetNWString("usergroup")) then
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
			if table.HasValue({"admin","founder","superadmin","mod"}, v:GetNWString("usergroup")) then
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

  hook.Add("PlayerShouldTakeDamage", "noproporcardamage", antiPropandCarDamage)

  
  hook.Add("OnPhysgunReload", "NoMassUnfreeze", function( physgun, ply )
	return false
  end)

  local function BlockSuicide(ply)
	if ply.isFroze then
		ply:PrintColor( Color( 255, 0, 0 ), "Error ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), "You cannot kill yourself when frozen!" )
		return false
	else
		return true
	end
  end
  hook.Add( "CanPlayerSuicide", "BlockSuicide", BlockSuicide )

		
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
