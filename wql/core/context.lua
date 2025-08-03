local Context = { }
Context.CreatureTemplate = function(entry)
  return require("wql.schema.creature_template")(entry or -1)
end
return Context
