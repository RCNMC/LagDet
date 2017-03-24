local ADRP_NAMETIME = 5
local ADRP_PREFIX = "Arty's DRP Dev Serv"
local ADRP_NUM = 0

local ADRP_Randomness = {
    [1] = "I lik turtles", 
    [2] = "Firetwucks Intentify",
    [3] = "Now full of dank memes!",
    [4] = "Your mother was a hamster",
    [5] = "AND THEY DONT STOP CUMMIN AND THEY DONT STOP CUMMIN",
    [6] = "xXx_WaLlHaXeNaBlEd_GeT_fUcKiNg_rEkT_sCrUbS_xXx",
    [7] = "Fuck your couch",
    [8] = "Snek is love, Snek is life",
    [9] = "NEVER GONNA GIVE YOU UP, NEVER GONNA LET YOU DOWN",
    [10] = "I got crippling depressiosis!",
    [11] = "Yeah, I'm hard too",
    [12] = "Now sponsored by Pony Buttplugs!",
    [13] = "Lemme smash... please...",
    [14] = "Becky want blue?",
    [15] = "Becky thought my tail was big",
    [16] = "Ben is a hoe",
    [17] = "Gimme the succ",
    [18] = "smol is smol so he must be smol",
    [19] = "GeT 360 y Y lAdDeRsTaLl NoScOpE tRiCkShOtTeD",
    [20] = "Check us out on Pornhub!",
}
	
local function ChAnGeHoStNaMeFoRdAnKnEsS()
  local ADRP_NUM = ADRP_NUM + 1
  if table.Count( ADRP_Randomness ) < ADRP_NUM then
    local ADRP_NUM = 0
    local name = ADRP_Randomness[1]
  else
	  local name = ADRP_Randomness[ADRP_NUM]
  end
	RunConsoleCommand("hostname", ADRP_PREFIX.." ➥ "..name)
end

timer.Create( "DaNkHoStNaMeS", ADRP_NAMETIME, 0, ChAnGeHoStNaMeFoRdAnKnEsS )
