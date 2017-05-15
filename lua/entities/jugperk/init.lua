AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_interiors/BathTub01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
 
  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
  if IsValid( caller ) and caller:IsPlayer() then
    if caller:GetPData( "hasJug", 0 ) == 0 then
		  caller:PrintColor( Color( 0, 255, 0 ), "Perks | ", Color( 255, 255, 255 ), "You've just bought the juggernaut perk! This perk is temporary as it will be removed on death." )
      caller:SetMaxHealth( 150 )
      caller:SetHealth( 150 )
      caller:SetPData( "hasJug", 1 )
    else
      caller:PrintColor( Color( 255, 0, 0 ), "Perks | ", Color( 255, 255, 255 ), "You've already bought the juggernaut perk!" )
    end
	end
end
 
function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end
