--[[-----------------

  DB Related IO Functions
 
-----------------]]--
local Dashboard = Dashboard;
Dashboard.db = {}
Dashboard.db.data = nil

--[[--------------------

  BASE IO Functions
  
--------------------]]--
Dashboard.db.load = function()
  if not DashboardDataStore then
    DashboardDataStore = {}
  end
  
  Dashboard.db.data = DashboardDataStore
end

Dashboard.db.save = function()
  if not Dashboard.db.data then
    Dashboard.db.data = {}
  end

  DashboardDataStore = Dashboard.db.data
end

Dashboard.db.clear = function()
  DashboardDataStore = {}
  Dashboard.db.load();
end