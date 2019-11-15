--[[ Set the Main Global Scope for the Add On ]]--
Dashboard = {}
Dashboard.db = {}

BINDING_HEADER_DASHBOARD = "Alt Character Dashboard"
BINDING_NAME_DASHBOARD = "Show/Hide the dashboard"

local debug = true;

local p = function(msg)
  if (debug) then print (msg); end
end

--[[--------------------

  EVENT Functions
  
--------------------]]--
function DashboardDataFrame_OnEvent(self, event, arg1)
  if event == "ADDON_LOADED" and arg1 == "Dashboard" then
    Dashboard.db.load(event);

  elseif event == "PLAYER_LOGOUT" then
    Dashboard.update(event);
    Dashboard.db.save();

  --elseif event == "PLAYER_XP_UPDATE" then
  --elseif event == "PLAYER_ENTERING_WORLD" then
  --elseif event == "TRADE_SKILL_UPDATE" then
  --elseif event == "PLAYER_XP_UPDATE" then

  else 
    Dashboard.update(event);
  end

    
end

Dashboard.init = function()
  Dashboard.registerSlashCommand()
end

Dashboard.slash = function()
  Dashboard.update("manual");
  Dashboard.frame:Show();
end

Dashboard.registerSlashCommand = function()
  SLASH_DASHBOARD1 = "/dashboard"
  SlashCmdList["DASHBOARD"] = Dashboard.slash
end

Dashboard.skillUpdate = function()
  local nResult = {}
  local skills = "|Alchemy|Blacksmithing|Cooking|Engineering|Leatherworking|Tailoring|Herbalism|Mining|Skinning|Fishing|Poisons|Lockpicking|Enchanting|First Aid|"

  local numSkills = GetNumSkillLines();

  for i=0, numSkills do
    local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType = GetSkillLineInfo(i);  
    if (skillName) then
      if (string.find(skills, "|"..skillName.."|")) then
        nResult[skillName] = {};
        nResult[skillName].Current = skillRank
        nResult[skillName].Max = skillMaxRank
      end
    end
  end

  return nResult;
end

Dashboard.update = function(event)

  realm = GetRealmName()
  name = UnitName("player")

  if not Dashboard.db.data[realm] then Dashboard.db.data[realm] = {} end
  if not Dashboard.db.data[realm][name] then Dashboard.db.data[realm][name] = {} end

  local player = Dashboard.db.data[realm][name];

  player.name = name;
  player.realm = realm;

  player.race = UnitRace("player");
  player.class = UnitClass("player");
  player.level = UnitLevel("player");

  gender = UnitSex("player");
  if (gender == 1) then player.gender = "Unknown" end
  if (gender == 2) then player.gender = "Male" end
  if (gender == 3) then player.gender = "Female" end

  -- On PLAYER_LOGOUT the GetXPExhaustion() always return nil, bug?
  -- So only update it for other events.
  if (event ~= "PLAYER_LOGOUT") then 
    player.rested = GetXPExhaustion(); 
    player.xp = UnitXP("player");
    player.xpMax = UnitXPMax("player");
    player.xpNeeded = player.xpMax - player.xp;

    player.pvpName = UnitPVPName("player");
    player.pvpRank = UnitPVPRank("player");

    player.skills = Dashboard.skillUpdate()

    player.copper = GetMoney();
    player.money = ("%dg %ds %dc"):format(player.copper / 10000, (player.copper / 100) % 100, player.copper % 100);
  end

  return player, realm, name;
end

Dashboard.init()