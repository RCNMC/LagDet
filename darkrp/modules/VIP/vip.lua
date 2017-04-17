if CLIENT then
(some event
  if ply:canAfford(100000) then
    ply:addMoney(-100000)
    net.Start("MoneySuccess")
    net.WriteStr(ply:Name())
    net.SendToServer()
  else
    // not enough cash
  end
end)
else
util.netvar blah blah

net.Receive("MoneySuccess", function(name)
  RunConsoleCommand("sg", "rank " .. name .. " vip 0")
end)
