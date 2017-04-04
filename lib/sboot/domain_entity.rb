class DomainEntity

  attr_accessor :name, :name_pluralized, :properties, :pk, :environment, :primary_key

  def initialize options={}
    @name = options[:name]
    @name_pluralized = options[:name_pluralized]
    @properties = options[:properties]
    @pk = options[:pk]
    @environment = options[:environment]
    send('primary_key_property')
  end

  def class_name
    single_capitalize
  end

  def instance_name
    single.downcase
  end

  def collection_name
    collection_downcase
  end

  def single_capitalize
    @name.capitalize
  end

  def collection_capitalize
    collection.capitalize
  end

  def single_downcase
    @name.downcase
  end

  def collection_downcase
    collection.downcase
  end

  def collection
    @name_pluralized ? @name_pluralized : @name
  end

  def collection_defined?
    @name_pluralized ? @name != @name_pluralized : false
  end

  def primary_key_property
    @properties.each do |property|
      @primary_key = property if property[:constraint] == 'pk'
    end
  end

end