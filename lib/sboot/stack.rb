class Stack

  attr_accessor :persistence, :conversion, :business, :backend, :fullstack

  def initialize
    @persistence = [:entity, :repository]
    @conversion = [:entity, :repository, :dto]
    @business = [:entity, :repository, :dto, :exception, :service, :service_impl]
    @backend = [:entity, :repository, :dto, :exception, :service, :service_impl, :message_dto, :controller]
  end

end