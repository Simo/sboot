module Sboot
  class Property

    attr_accessor :name, :type, :constraint

    def initialize options={}
      @name = options[:name]
      @type = options[:type]
      @constraint = options[:constraint]
    end

    def [](key)
      send("#{key}")
    end

    def dto_type
      if @type == 'Date'
        'String'
      else
        @type
      end
    end

    def peculiar_type?
      if @type == 'Date'
        true
      end
    end

    def date_type?
      if @type == 'Date'
        true
      end
    end

    def binary_type?
      if @type == 'byte[]'
        true
      end
    end

    def is_pk?
      if @constraint == 'pk'
        true
      end
    end

    def is_uuid?
      if @type == 'UUID'
        true
      end
    end

    def camel_rather_dash options={}
      #raise ArgumentError, "firstLetter consente solo valori 'upcase' o 'downcase'" if options.key? :firstLetter && (options[:firstLetter] != 'upcase' || options[:firstLetter] != 'downcase')
      ret = @name.split('_').collect(&:capitalize).join if options[:firstLetter] == 'upcase'
      ret = @name.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } if options[:firstLetter] == 'downcase'
      ret = @name.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } unless options.key? :firstLetter
      ret
    end

    def ts_type
      typ = 'string' if @type == 'String' || @type == 'Date'
      typ = 'number' if @type == 'Long' || @type == 'Integer' || @type == 'Double'
      typ
    end

  end
end
