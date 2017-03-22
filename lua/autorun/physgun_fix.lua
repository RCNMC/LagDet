hook.Add( "OnPhysgunFreeze", "PhysFreeze", function( weapon, phys, ent, ply )
  if phys == "prop_physics" then
    ent:SetCollisionGroup(COLLISION_GROUP_NONE)
  end
end )
