module Sboot
  class ArgsResolver

    attr_accessor :types, :constraints, :has_id

    def initialize options={}
      @types = {string: 'String',text: 'String',varchar: 'String',varchar2: 'String',number: 'Long',long: 'Long',int: 'Integer',integer: 'Integer',double: 'Double',numeric: 'Double',date: 'Date', byte: "byte[]"}
      @constraints = {pk: { role: 'pk', type: 'Long'}, uuid: { role: 'pk', type: 'UUID'}}
      @has_id = false
    end

    ## args e' un'array di stringhe
    ## contiene campi delimitati dal carattere ":"
    ## le quattro situazioni tipiche sono: "name", "name:type", "name:type:constraint", "name:constraint"
    def resolve args
      properties = []
      args.each do |arg|
        array = arg.split(":")
        properties << send("format#{array.length}", array)
      end
      properties.unshift(Sboot::Property.new name: 'id',type: 'Long', constraint: 'pk') unless @has_id
      properties
    end

    private

    def format1 array
      Sboot::Property.new name: array[0].downcase,type: 'String', constraint: nil
    end

    def format2 array
      ret = Sboot::Property.new name: array[0].downcase,type: detect_type(array[1].downcase), constraint: nil if is_a_type? array[1].downcase
      ret = Sboot::Property.new name: array[0].downcase,type: detect_constraint_type(array[1].downcase), constraint: detect_constraint(array[1].downcase) if is_a_constraint? array[1].downcase
      ret
    end

    def format3 array
      Sboot::Property.new name: array[0].downcase,type: detect_type(array[1].downcase), constraint: detect_constraint(array[2].downcase) if is_a_constraint? array[2].downcase
    end

    def is_a_type? value
      @types[value.to_sym]
    end

    def is_a_constraint? value
      ret = @constraints[value.to_sym]
      @has_id = true if ret
      ret
    end

    def detect_type value
      @types[value.to_sym] || 'String'
    end

    def detect_constraint_type constraint
      @constraints[constraint.to_sym][:type]
    end

    def detect_constraint constraint
      @constraints[constraint.to_sym][:role]
    end

  end
end
