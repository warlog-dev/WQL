Context = {}

Context.CreatureTemplate = (entry) ->
    return require("wql.schema.creature_template")(entry or -1)

return Context