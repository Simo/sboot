# encoding: utf-8
require 'sboot/source_item'

module Sboot
  class Relation<SourceItem
    attr_accessor :entity, :property
    
    def initialize options={}
      @entity   = options[:entity]
      @property = options[:property]
      @name     = options[:name]
    end
    
    def master
      @entity
    end
    
    def detail
      @entity
    end
    
    def name
      return @entity.name if @name.nil?
      @name
    end
    
    def collection_name
      name = if @entity.name_pluralized.nil? then @entity.name else @entity.name_pluralized end
      "#{name.split('_').collect(&:capitalize).join.sub(/^[A-Z]/) {|f| f.downcase }}#{@name.split('_').collect(&:capitalize).join unless @name.nil?}"
    end
    
    def item_in_collection
      "#{@entity.java_class_name.sub(/^[a-z]/) {|f| f.upcase }}#{@name.split('_').collect(&:capitalize).join unless @name.nil?}"
    end
  end
end
