class BaseEntity
    new: () =>
        @fields = {}
        @table_name = ""
    
    set: (field, value) =>
        if not @fields[field]
            error "Field #{field} not exist"

        @fields[field].value = value
        return @
    
    get: (field) =>
        if not @fields[field]
            error "Field #{field} not exist"
        
        return @fields[field].value

return BaseEntity