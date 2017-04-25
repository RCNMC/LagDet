if SERVER then

  MsgC( Color( 255, 255, 255 ), "[", Color( 0, 255, 0 ), "Maintenance Mode", Color( 255, 255, 255 ), "] [", Color( 0, 255, 255 ), "INFO", Color( 255, 255, 255 ), "] Starting up...\n" )
  
  util.AddNetworkString("bpdrp_whitelist_open")
  util.AddNetworkString( "PrintColor" )

  local Meta = FindMetaTable( "Player" )

  function Meta:PrintColor( ... )
    net.Start( "PrintColor" )
    net.WriteTable( { ... } )
    net.Send( self )
  end
  
  local whitelist = {
    lookup     = {},
    count      = 0,
  }

  local function WhitelistSave()
    file.Write("bpdrp_whitelist/whitelist.txt", util.TableToJSON(whitelist))
    MsgC( Color( 255, 255, 255 ), "[", Color( 0, 255, 0 ), "Maintenance Mode", Color( 255, 255, 255 ), "] [", Color( 0, 255, 255 ), "INFO", Color( 255, 255, 255 ), "] Whitelist Saved\n" )
  end
  hook.Add("ShutDown", "bpdrp_whitelist_save", WhitelistSave)

  if not file.Exists("bpdrp_whitelist", "DATA") then
    file.CreateDir("bpdrp_whitelist")
    WhitelistSave()
  elseif file.Exists("bpdrp_whitelist/whitelist.txt", "DATA") then
    local json = file.Read("bpdrp_whitelist/whitelist.txt", "DATA")
    if json then
      whitelist = util.JSONToTable(json) or whitelist
    end
		
    MsgC( Color( 255, 255, 255 ), "[", Color( 0, 255, 0 ), "Maintenance Mode", Color( 255, 255, 255 ), "] [", Color( 0, 255, 255 ), "INFO", Color( 255, 255, 255 ), "] Whitelist Loaded. ", whitelist.count, " player(s) in the whitelist!\n" ) 
    
  end
  
  local function WhitelistUpdate(mode, id)
    if id == "" then return end
    if (mode == -1 and not whitelist.lookup[id]) or (mode == 1 and whitelist.lookup[id]) then return end
    
    whitelist.lookup[id] = (mode == 1 and true or nil)
    whitelist.count = whitelist.count + mode
  end
  
  local function WhitelistMenuOpen(ply)
    net.Start("bpdrp_whitelist_open")
      net.WriteUInt(whitelist.count, 11)
      for k, _ in pairs(whitelist.lookup) do
        net.WriteString(k)
      end
    net.Send(ply)
  end
  
  -- Commands
  
  concommand.Add("maintenance_enable", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
	
    DaVar:SetInt( 1 )
    for k, v in pairs( player.GetAll() ) do
	    v:PrintColor( Color( 255, 0, 0 ), "ADMIN ACTION ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), ply:Nick(), " has enabled maintenance!" )
	end
  end)
  concommand.Add("maintenance_disable", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
	
    DaVar:SetInt( 0 )
    for k, v in pairs( player.GetAll() ) do
	    v:PrintColor( Color( 255, 0, 0 ), "ADMIN ACTION ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), ply:Nick(), " has disabled maintenance!" )
	end
  end)
  concommand.Add("whitelist_save", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end

    WhitelistSave()
  end)
  
  concommand.Add("whitelist_add", function(ply, command, args, arg)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    if not arg or arg == "" then return end
    
    WhitelistUpdate(1, arg)
  end)

  concommand.Add("whitelist_remove", function(ply, command, args, arg)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    if not arg or arg == "" then return end
    
    WhitelistUpdate(-1, arg)
  end)
  
  concommand.Add("whitelist", function(ply)
    if not IsValid(ply) then return end
    if not ply:IsSuperAdmin() then return end
    
    WhitelistMenuOpen(ply)
  end)
  
  hook.Add("PlayerSay", "bpdrp_whitelist_command", function(ply, text)
    if not IsValid(ply) then return end
    if not ply:IsSuperAdmin() then return end
    
    if string.lower(text) == "!whitelist" then
      WhitelistMenuOpen(ply)
      return ""
    end
  end)
  
  hook.Add("CheckPassword", "bpdrp_whitelist_kick", function(steamID, ip, svpass, clpass, name)
    if not (whitelist.lookup[util.SteamIDFrom64(steamID)] or game.SinglePlayer()) and whitelist.count > 0 then
	  if DaVar:GetInt() == 1 then
	  for k, v in pairs( player.GetAll() ) do
	    v:PrintColor( Color( 0, 0, 255 ), "Whitelist ", Color( 0, 0, 0 ), "| ", Color( 255, 255, 255 ), name, "(", steamID, ") attempted to connect, however they're not on the whitelist!" )
	  end
      return false, "                  ---------[ Arty's DarkRP ]---------\n\n                               Access Denied\n                  Reason:  Undergoing Maintenance\n\n"
      end
	end
  end)
  
  CreateConVar( "in_maintenance", 0, {"FCVAR_ARCHIVE"}, "Toggle maintenance on and off" )
  DaVar = GetConVar( "in_maintenance" )
  if DaVar:GetInt() == 1 then
    MsgC( Color( 255, 255, 255 ), "[", Color( 0, 255, 0 ), "Maintenance Mode", Color( 255, 255, 255 ), "] [", Color( 0, 255, 255 ), "INFO", Color( 255, 255, 255 ), "] Server was last in maintenance mode, therefore it will be when server is up.\n")
  else
    MsgC( Color( 255, 255, 255 ), "[", Color( 0, 255, 0 ), "Maintenance Mode", Color( 255, 255, 255 ), "] [", Color( 0, 255, 255 ), "INFO", Color( 255, 255, 255 ), "] Server was not in maintenance mode, therefore it won't be when server is up.\n")
  end
  
  MsgC( Color( 255, 255, 255 ), "[", Color( 0, 255, 0 ), "Maintenance Mode", Color( 255, 255, 255 ), "] [", Color( 0, 255, 255 ), "INFO", Color( 255, 255, 255 ), "] Up and running successfully!\n" )
  
else
  
  local whitelist = {
    lookup = {},
    count  = 0,
  }
  
  net.Receive( "PrintColor", function()
    chat.AddText( unpack( net.ReadTable() ) )
  end )
  
  local function AddID(id, panel, first)
    if id == "" then return end
    if whitelist.lookup[id] then return end
    
    whitelist.lookup[id] = panel:AddLine(id):GetID()
    whitelist.count = whitelist.count + 1
    
    if first then return end
    
    LocalPlayer():ConCommand("whitelist_add " .. id)
  end
  
  local function RemoveID(id, panel)
    if id == "" then return end
    if not whitelist.lookup[id] then return end
  
    panel:RemoveLine(whitelist.lookup[id])
    whitelist.lookup[id] = nil
    whitelist.count = whitelist.count - 1
    LocalPlayer():ConCommand("whitelist_remove " .. id)
  end
    
  net.Receive("bpdrp_whitelist_open", function()
  
    whitelist.lookup = {}
    whitelist.count = 0

    local menu_base = vgui.Create("DFrame")
    menu_base:SetTitle("Whitelist")
    menu_base:ShowCloseButton(false)
    function menu_base:Paint(w, h)
    
      draw.RoundedBox(6, 0, 0, w, h, Color(149, 165, 166))
      
    end
    menu_base:SetSize(325, 300)
    menu_base:Center()
    menu_base:MakePopup()
    
    local menu_close = menu_base:Add("DButton")
    menu_close:SetText("")
    function menu_close:Paint(w, h)
    
      draw.RoundedBox(8, 0, 0, w, h, Color(189, 195, 199))
      draw.SimpleText("X", "Default", w / 2, 3, Color(0, 0, 0), TEXT_ALIGN_CENTER)
      
    end
    function menu_close:DoClick()
    
      LocalPlayer():ConCommand("whitelist_save")
      menu_base:Close()
      
    end
    menu_close:SetSize(18, 18)
    menu_close:SetPos(302, 5)
    
    local menu_list = menu_base:Add("DListView")
    menu_list:SetMultiSelect(true)
    menu_list:AddColumn("SteamID")
    for i = 1, net.ReadUInt(11) do 
      AddID(net.ReadString(), menu_list, true)
    end
    function menu_list:DoDoubleClick(line, panel)
    
      RemoveID(panel:GetValue(1), menu_list)
      
    end
    menu_list:SetSize(160, 206)
    menu_list:SetPos(10, 36)
    
    local menu_list_remove = menu_base:Add("DButton")
    menu_list_remove:SetText("Remove Selected")
    function menu_list_remove:DoClick()
    
      for k, v in ipairs(menu_list:GetSelected()) do
        RemoveID(v:GetValue(1), menu_list)
      end
      
    end
    menu_list_remove:SetSize(160, 20)
    menu_list_remove:SetPos(10, 244)
    
    local menu_list_remove_all = menu_base:Add("DButton")
    menu_list_remove_all:SetText("Remove All")
    function menu_list_remove_all:DoClick()
    
      menu_base:SetVisible(false)
      
      local confirm_box = vgui.Create("DFrame")
      confirm_box:SetTitle("")
      confirm_box:ShowCloseButton(false)
      function confirm_box:Paint(w, h)
      
        draw.RoundedBox(6, 0, 0, w, h, Color(149, 165, 166))
        draw.SimpleText("Are you sure?", "Default", w / 2, 15, Color(0, 0, 0), TEXT_ALIGN_CENTER)
        
      end
      confirm_box:SetSize(150, 70)
      confirm_box:Center()
      confirm_box:MakePopup()
      
      local confirm_box_yes = confirm_box:Add("DButton")
      confirm_box_yes:SetText("I'm sure")
      function confirm_box_yes:DoClick()
      
        for k, _ in pairs(whitelist.lookup) do
          RemoveID(k, menu_list)
        end
        
        menu_base:SetVisible(true)
        confirm_box:Close()
        
      end
      confirm_box_yes:SetSize(60, 22)
      confirm_box_yes:SetPos(10, 40)
      
      local confirm_box_no = confirm_box:Add("DButton")
      confirm_box_no:SetText("No")
      function confirm_box_no:DoClick()
      
        menu_base:SetVisible(true)
        confirm_box:Close()
        
      end
      confirm_box_no:SetSize(60, 22)
      confirm_box_no:SetPos(80, 40)
      
    end
    menu_list_remove_all:SetSize(160, 20)
    menu_list_remove_all:SetPos(10, 266)
    
    local menu_mode = menu_base:Add("DCheckBoxLabel") 
    menu_mode:SetText("64Bit")
    menu_mode:SetValue(0)
    menu_mode:SetDark(true)
    menu_mode:SizeToContents()
    menu_mode:SetPos(267, 60)
    
    local menu_text_entry = menu_base:Add("DTextEntry")
    menu_text_entry:SetText("SteamID or 64Bit ID")
    function menu_text_entry:GetSteamID()
    
      return menu_mode:GetChecked() and util.SteamIDFrom64(menu_text_entry:GetValue()) or menu_text_entry:GetValue()
      
    end
    menu_text_entry:SetSize(135, 22)
    menu_text_entry:SetPos(180, 36)
    
    local menu_check_id = menu_base:Add("DButton")
    menu_check_id:SetText("Check ID")
    function menu_check_id:DoClick()
    
      menu_base:SetVisible(false)
      
      local id = menu_text_entry:GetSteamID()
      
      local whitelisted_box = vgui.Create("DFrame")
      whitelisted_box:SetTitle("")
      whitelisted_box:ShowCloseButton(false)
      function whitelisted_box:Paint(w, h)
      
        draw.RoundedBox(6, 0, 0, w, h, Color(149, 165, 166))
        draw.SimpleText("SteamID: '" .. id .. "' is " .. (whitelist.lookup[id] and "whitelisted!" or "not whitelisted!"), "Default", w / 2, 15, Color(0, 0, 0), TEXT_ALIGN_CENTER)
        
      end
      whitelisted_box:SetSize(300, 70)
      whitelisted_box:Center()
      whitelisted_box:MakePopup()
      
      local whitelisted_close = whitelisted_box:Add("DButton")
      whitelisted_close:SetText("Close")
      function whitelisted_close:DoClick()
      
        menu_base:SetVisible(true)
        whitelisted_box:Close()
        
      end
      whitelisted_close:SetSize(284, 22)
      whitelisted_close:SetPos(8, 40)
      
    end
    menu_check_id:SetSize(80, 15)
    menu_check_id:SetPos(180, 60)
    
    local menu_add_id = menu_base:Add("DButton")
    menu_add_id:SetText("Add ID")
    function menu_add_id:DoClick()
    
      AddID(menu_text_entry:GetSteamID(), menu_list)
      
    end
    menu_add_id:SetSize(135, 20)
    menu_add_id:SetPos(180, 77)
    
    local menu_remove_id = menu_base:Add("DButton")
    menu_remove_id:SetText("Remove ID")
    function menu_remove_id:DoClick()
    
      RemoveID(menu_text_entry:GetSteamID(), menu_list)
      
    end
    menu_remove_id:SetSize(135, 20)
    menu_remove_id:SetPos(180, 99)
  end)
  
end
