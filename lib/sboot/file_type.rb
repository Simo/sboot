class FileType
  
  attr_accessor :key, :reference, :extension

  def initialize options={}
    raise ArgumentError, ':key non presente' unless options.key? :key
    raise ArgumentError, ':reference non presente' unless options.key? :reference

    @key = options[:key]
    @reference = options[:reference]
    @extension = options[:extension] if options.key? :extension
  end

  def ref
    @reference
  end

  def ext
    ext = @extension || ''
    ext
  end
  
end