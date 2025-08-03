local WQL = require("")

local creature_template = WQL.Context.CreatureTemplate(10)

creature_template:set_name("WQL Creature " .. creature_template:get_entry())
print(creature_template:get_name())

creature_template:set_type(10)
print(creature_template:get_type())