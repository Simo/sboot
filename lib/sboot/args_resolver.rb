module Sboot
  class ArgsResolver

    attr_accessor :types, :constraints

    def initialize options={}
      @types = {string: 'String',text: 'String',varchar: 'String',varchar2: 'String',number: 'Long',long: 'Long',int: 'Integer',integer: 'Interger'}
      @constraints = {pk: 'pk'}
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
      properties
    end

    private

    def format1 array
      {name: array[0].downcase,type: 'String', constraint: nil}
    end

    def format2 array
      ret = {name: array[0].downcase,type: detect_type(array[1]), constraint: nil} if is_a_type? array[1]
      ret = {name: array[0].downcase,type: 'Long', constraint: detect_constraint(array[1])} if is_a_constraint? array[1]
      ret
    end

    def format3 array
      {name: array[0].downcase,type: detect_type(array[1]), constraint: detect_constraint(array[2])}
    end

    def is_a_type? value
      @types[value.to_sym]
    end

    def is_a_constraint? value
      @constraints[value.to_sym]
    end

    def detect_type value
      @types[value.to_sym] || 'String'
    end

    def detect_constraint constraint
      @constraints[constraint.to_sym]
    end

  end
end
