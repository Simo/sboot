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
  end
end