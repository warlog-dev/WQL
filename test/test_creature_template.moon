-- CREATURE_TEMPLATE:
WQL = require "wql"

creature_template = WQL.Context.CreatureTemplate 19001

with creature_template
    \set_name "WQL Creature Example"
    \set_subname "Just a simple creature!"
    \set_level 10, 20
    \set_unit_class 1
    \set_faction 35
    \set_npcflag NPC_FLAG.VENDOR.GENERIC

print "=== Mode INSERT_ONLY (default) ==="
print creature_template\to_sql!

print "\n=== Mode UPDATE_ONLY (Simple) ==="
creature_template\update_only!
print creature_template\to_sql!

print "\n=== Mode UPDATE_ONLY (Advanced) ==="
creature_template\update_only!
custom_where = { entry: 19001, minlevel: 10, faction: 35 }
print creature_template\to_sql custom_where