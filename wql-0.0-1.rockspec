package = "wql"
version = "0.0-1"
source = {
  url = "git://github.com/warlog-dev/WQL",
  tag = "v0.1"
}
description = {
  summary  = "Warlog Query Language: Lua SQL builder for WoW DB",
  detailed = "WQL is a Lua library to generate SQL queries tailored for AzerothCore / TrinityCore databases.",
  homepage = "https://github.com/warlog-dev/WQL",
  license  = "GNU-3"
}
dependencies = {
  -- "luasql-mysql >= 2.0"
  "lua >= 5.1"
}
build = {
  type = "builtin",
  modules = {
    ["wql"] = "wql/init.lua",
    
    -- Core
    ["wql.core.context"] = "wql/core/context.lua",
    ["wql.core.builder"] = "wql/core/builder.lua",

    -- Schema
    ["wql.schema.base_entity"] = "wql/schema/base_entity.lua",
    ["wql.schema.creature_template"] = "wql/schema/creature_template.lua",

    -- Presets
    ["wql.presets.npc_flag"] = "wql/presets/npc_flag.lua",
    ["wql.presets.speed_type"] = "wql/presets/speed_type.lua",
  }
}