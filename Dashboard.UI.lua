function DashboardFrame_OnLoad(self)
  self:RegisterForDrag("LeftButton");
  tinsert(UISpecialFrames,"DashboardFrame");
  Dashboard.frame = self;
end

function DashboardFrame_OnShow()
  
  Portrait = _G["DashboardFramePortraitTexture"]

  SetPortraitTexture(Portrait,"player");
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);

  DashboardFrame_SetIcon(1,"HUNTER");
  DashboardFrame_SetIcon(2,"DRUID");

  

  realm = GetRealmName()
  column = 1;

  DashboardFrame_SetRowData(1,0,"Name")
  DashboardFrame_SetRowData(2,0,"Race")
  DashboardFrame_SetRowData(3,0,"Money")
  DashboardFrame_SetRowData(4,0,"Level")
  DashboardFrame_SetRowData(5,0,"Needed XP")
  DashboardFrame_SetRowData(6,0,"Rested XP")

  DashboardFrame_SetRowData(7,0,"First Aid")
  DashboardFrame_SetRowData(8,0,"Cooking")
  DashboardFrame_SetRowData(9,0,"Fishing")
  
  DashboardFrame_SetRowData(10,0,"Alchemy")
  DashboardFrame_SetRowData(11,0,"Blacksmithing")
  DashboardFrame_SetRowData(12,0,"Enchanting")
  DashboardFrame_SetRowData(13,0,"Engineering")
  DashboardFrame_SetRowData(14,0,"Leatherworking")
  DashboardFrame_SetRowData(15,0,"Tailoring")
  
  DashboardFrame_SetRowData(16,0,"Mining")
  DashboardFrame_SetRowData(17,0,"Skinning")
  DashboardFrame_SetRowData(18,0,"Herbalism")

  local totalCopper = 0;
  for index, player in pairs(Dashboard.db.data[realm]) do
    
    totalCopper = totalCopper + (player.copper or 0);

    DashboardFrame_SetIcon(column, player.class);

    DashboardFrame_SetRowData(1,column, player.name)
    DashboardFrame_SetRowData(2,column, player.race)
    DashboardFrame_SetRowData(3,column, player.money)
    DashboardFrame_SetRowData(4,column, player.level)
    DashboardFrame_SetRowData(5,column, player.xpNeeded)
    DashboardFrame_SetRowData(6,column, player.rested)

    DashboardFrame_SetRowData(7,column, DashboardFrame_GetSkill(player,"First Aid"))
    DashboardFrame_SetRowData(8,column, DashboardFrame_GetSkill(player,"Cooking"))
    DashboardFrame_SetRowData(9,column, DashboardFrame_GetSkill(player,"Fishing"))
    
    DashboardFrame_SetRowData(10,column, DashboardFrame_GetSkill(player,"Alchemy"))
    DashboardFrame_SetRowData(11,column, DashboardFrame_GetSkill(player,"Blacksmithing"))
    DashboardFrame_SetRowData(12,column, DashboardFrame_GetSkill(player,"Enchanting"))
    DashboardFrame_SetRowData(13,column, DashboardFrame_GetSkill(player,"Engineering"))
    DashboardFrame_SetRowData(14,column, DashboardFrame_GetSkill(player,"Leatherworking"))
    DashboardFrame_SetRowData(15,column, DashboardFrame_GetSkill(player,"Tailoring"))
    
    DashboardFrame_SetRowData(16,column, DashboardFrame_GetSkill(player,"Mining"))
    DashboardFrame_SetRowData(17,column, DashboardFrame_GetSkill(player,"Skinning"))
    DashboardFrame_SetRowData(18,column, DashboardFrame_GetSkill(player,"Herbalism"))


    column = column + 1
  end

  DashboardFrame_SetGold("DashboardFrameMoneyFrame", totalCopper)

end

function DashboardFrameDetails_Update()
  print("DashboardFrameDetails_Update")
end

function DashboardFrame_GetSkill(player, skill)
  if (player.skills and player.skills[skill]) then
    return player.skills[skill].Current.."/"..player.skills[skill].Max
  end
  return ""
end

function DashboardFrame_SetIcon(index, class)
  button = _G["DashboardFrameDetailsIconButton"..index]
  icon = _G["DashboardFrameDetailsIconButton"..index.."NormalTexture"]

  icon:SetAllPoints(button);
  icon:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES"); -- this is the image containing all class icons
  local coords = CLASS_ICON_TCOORDS[string.upper(class)]
  icon:SetTexCoord(unpack(coords));
end

function DashboardFrame_SetRowData(row, column, value)
  _G["DashboardFrameDetailsButton"..row.."Value"..column]:SetText(value);
end

function DashboardFrame_SetGold(frame, c)
  local G,S,C
  local g,s
  
  c = c or 0
  
  g = floor(c / 10000)
  c = mod(c, 10000)
  
  s = floor(c / 100)
  c = mod(c, 100)

  G = _G[frame.."Gold"]
  S = _G[frame.."Silver"]
  C = _G[frame.."Copper"]

  G:SetText(g.."g")
  S:SetText(s.."s")
  C:SetText(c.."c")  

  if g == 0 then
    G:Hide()
  else
    G:Show()
  end
  
  if g==0 and s==0 then
    S:Hide()
  else
    S:Show()
  end
 
end