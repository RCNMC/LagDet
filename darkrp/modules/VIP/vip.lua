concommand.Add("getVIP", function(ply)
  if ply:canAfford(100000) then
    ply:addMoney(-100000)
    RunConsoleCommand("sg", "rank " .. name .. " vip 0")
  else
    ply:PrintColor( Color( 255, 0, 0 ), "VIP ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), "You don't have the required cash!")
  end
end)
