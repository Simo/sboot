class DomainEntity

  attr_accessor :name, :name_pluralized, :properties, :pk, :environment, :primary_key, :datetype

  def initialize options={}
    @name = options[:name]
    @name_pluralized = options[:name_pluralized]
    @properties = options[:properties]
    @pk = options[:pk]
    @environment = options[:environment]
    send('define_key_properties')
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

  def define_key_properties
    @properties.each do |property|
      @primary_key = property if property[:constraint] == 'pk'
      @datetype = true if property[:type] == 'Date'
    end
  end

end