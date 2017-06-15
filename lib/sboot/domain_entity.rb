class DomainEntity

  attr_accessor :name, :name_pluralized, :properties, :pk, :environment, :primary_key, :datetype
  # Supporto per la generazione di relazioni
  attr_accessor :masters, :details

  def initialize options={}
    @name = options[:name] if options.key? :name
    @name_pluralized = options[:name_pluralized] if options.key? :name_pluralized
    @properties = options[:properties] if options.key? :properties
    @pk = options[:pk] if options.key? :pk
    @environment = options[:environment] if options.key? :environment
    @join_column = options[:join_column] if options.key? :join_column
    @details = []
    @masters = []
    send('define_key_properties') unless options.empty?
  end
  
  def define_attributes attributes
      attributes.each do |a|
          idx = @properties.index {|p| p[:name] == a[:name] }
          
          @properties[idx] = a if idx     # Sostituisco l'elemento senza cambiare l'ordine
          @properties << a     unless idx # Elemento non presente, lo aggiungo
      end
  end
  
  def one_to_many detail, key
      details << { detail: detail, key: key }
  end
  
  def many_to_one master, key
      masters << { master: master, key: key }
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
  
  def java_class_name
      @name.split('_').collect(&:capitalize).join
  end

  def fixture_pk
    fixture = 'UUID.randomUUID().toString()' if @primary_key.type == 'String'
    fixture = '1L' if @primary_key.type == 'Long'
    fixture = 'UUID.randomUUID()' if @primary_key.type == 'UUID'
    fixture = 'new Integer(1)' if @primary_key.type == 'Integer'
    fixture
  end

  # TODO: unificare con l'omonima in property
  def camel_rather_dash name,options={}
      ret = name.split('_').collect(&:capitalize).join if options[:firstLetter] == 'upcase'
      ret = name.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } if options[:firstLetter] == 'downcase'
      ret = name.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } unless options.key? :firstLetter
      ret
  end
  
end
