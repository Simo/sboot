class DomainEntity

  attr_accessor :name, :name_pluralized, :properties, :pk, :environment, :primary_key, :datetype

  def initialize options={}
    @name = options[:name] if options.key? :name
    @name_pluralized = options[:name_pluralized] if options.key? :name_pluralized
    @properties = options[:properties] if options.key? :properties
    @pk = options[:pk] if options.key? :pk
    @environment = options[:environment] if options.key? :environment
    send('define_key_properties') unless options.empty?
  end

  def class_name
    single_capitalize
  end

  def instance_name
    single.downcase
  end

  def collection_name
    collection.downcase
  end

  def single_capitalize
    @name.capitalize
  end

  def collection_capitalize options={}
    res = collection.capitalize unless options.key? :collide
    res = collection_disambiguous("capitalize") if options.key? :collide
    res
  end

  def single_downcase
    @name.downcase
  end

  def collection_downcase options={}
    res = collection.downcase unless options.key? :collide
    res = collection_disambiguous("downcase") if options.key? :collide
    res
  end

  def collection
    @name_pluralized ? @name_pluralized : @name
  end

  def collection_save typing_case
    collection.capitalize if typing_case == "capitalize"
    collection.downcase if typing_case == "downcase"
  end

  def collection_defined?
    @name_pluralized ? @name != @name_pluralized : false
  end

  def collection_disambiguous typing_case
    collection_defined? ? collection_save(typing_case) : "#{collection_save(typing_case)}Lista"
  end

  def define_key_properties
    @properties.each do |property|
      @primary_key = property if property[:constraint] == 'pk'
      @datetype = true if property[:type] == 'Date'
    end
  end

  def fixture_pk
    fixture = 'UUID.randomUUID().toString()' if @primary_key.type == 'String'
    fixture = '1L' if @primary_key.type == 'Long'
    fixture = 'UUID.randomUUID()' if @primary_key.type == 'UUID'
    fixture = 'new Integer(1)' if @primary_key.type == 'Integer'
    fixture
  end

end
