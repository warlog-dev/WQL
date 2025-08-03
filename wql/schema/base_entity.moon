Builder = require("wql.core.builder")

class BaseEntity
    new: () =>
        @fields = {}
        @table_name = nil
        @mode = nil

    set: (field, value) =>
        if not @fields[field]
            error "Field #{field} not exist"

        @fields[field].value = value
        return @

    get: (field) =>
        if not @fields[field]
            error "Field #{field} not exist"

        return @fields[field].value

    set_mode: (mode) =>
        unless Builder.MODES[mode]
            error "Invalide mode: #{mode}"
        @mode = mode
        return @

    get_mode: (mode) =>
        return @mode or Builder.MODES.INSERT_ONLY

    build: (where_conditions) =>
        return Builder.build @, where_conditions

    to_sql: (where_conditions) =>
        return Builder.to_sql @, where_conditions

    insert_only: () =>
        return @set_mode "INSERT_ONLY"

    update_only: () =>
        return @set_mode "UPDATE_ONLY"

return BaseEntity