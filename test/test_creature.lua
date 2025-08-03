--[[
    Test 1: Create new simple creature
]]--

local WQL = require("wql")

local creature_template = WQL.Context.CreatureTemplate(19001)
creature_template
    :set_name("WQL creature")
    :set_subname("Just a new vendor")
    :set_level(10, 20)
    :set_unit_class(1)
    :set_faction(35)
    :set_npcflag(NPC_FLAG.VENDOR.GENERIC)

print(creature_template:to_sql())