local function getVIP(ply)
  if ply:canAfford(1) then
    ply:addMoney(-1)
    RunConsoleCommand("sg", "rank " .. name .. " vip 0")
  else
    ply:PrintColor( Color( 255, 0, 0 ), "VIP ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), "You don't have the required cash! (You need $100,000 in total)")
  end
end
DarkRP.defineChatCommand("buyvip", getVIP, 0.3)
