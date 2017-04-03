class DomainEntity

  attr_accessor :name, :name_pluralized, :properties, :pk, :environment

  def initialize options={}
    @name = options[:name]
    @name_pluralized = options[:name_pluralized]
    @properties = options[:properties]
    @pk = options[:pk]
    @environment = options[:environment]
  end

  def collection
    @name_pluralized ? @name_pluralized : @name
  end

  def collection_defined?
    @name_pluralized ? @name != @name_pluralized : false
  end

end