if CLIENT then
  if LocalPlayer():SteamID() == "STEAM_0:0:56724059" then
    concommand.Add( "dawalls", enableWalls(ply, cmd, args, argstr) )
    function enableWalls(ply, cmd, args, argstr)
      if argstr == "yes" then
        hook.Add( "PreDrawHalos", "exdee", function()
	  halo.Add( player.GetAll(), Color( 0, 0, 255 ), 0, 0, 2, true, true )
        end )
      else
        hook.Remove("exdee")
      end
    end)
  end
end
