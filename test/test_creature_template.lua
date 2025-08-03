local WQL = require("wql")
local creature_template = WQL.Context.CreatureTemplate(19001)
do
  creature_template:set_name("WQL Creature Example")
  creature_template:set_subname("Just a simple creature!")
  creature_template:set_level(10, 20)
  creature_template:set_unit_class(1)
  creature_template:set_faction(35)
  creature_template:set_npcflag(NPC_FLAG.VENDOR.GENERIC)
end
print("=== Mode INSERT_ONLY (default) ===")
print(creature_template:to_sql())
print("\n=== Mode UPDATE_ONLY (Simple) ===")
creature_template:update_only()
print(creature_template:to_sql())
print("\n=== Mode UPDATE_ONLY (Advanced) ===")
creature_template:update_only()
local custom_where = {
  entry = 19001,
  minlevel = 10,
  faction = 35
}
return print(creature_template:to_sql(custom_where))
