# encoding: utf-8
 
module Sboot
  # Classe con routine di supporto per la manipolazione di stringhe a supporto generazione codice
  class SourceItem
    attr_accessor :name
      
    # Restituisce un nome classe in stile Java
    def java_class_name
      as_class_name name
    end

    # Restituisce un nome variabile in stile Java
    def java_instance_name
        as_variable_name name
    end
    
    def as_class_name value
      value.split('_').collect(&:capitalize).join
    end

    def as_variable_name value
        as_class_name(value).sub(/^[A-Z]/) {|f| f.downcase }
    end
    
    def camel_rather_dash options={}
      val = @name      unless  options.key? :value
      val = options[:value] if options.key? :value
      ret = val.split('_').collect(&:capitalize).join if options[:firstLetter] == 'upcase'
      ret = val.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } if options[:firstLetter] == 'downcase'
      ret = val.split('_').collect(&:capitalize).join().tap { |e| e[0] = e[0].downcase } unless options.key? :firstLetter
      ret
    end
    
  end
end
