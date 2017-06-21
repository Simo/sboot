# encoding: utf-8
require 'yaml'
require 'sboot/navigator'

module Sboot
    class ConfigRepository

        def initialize options={}
            @config = options[:config]
            FileUtils.mkdir_p @config['sboot_repo_path']
        end
        
        def save_entity entity
            navigator = Sboot::Navigator.new
            navigator.nav_to_root_folder Dir.pwd
            serialized_object = YAML::dump(entity)
            File.write "#{@config['sboot_repo_path']}/#{entity.name}.yml", serialized_object
            navigator.set_original_path_back
        end
        
        def load_entity entity_name
            file_yml = "#{@config['sboot_repo_path']}/#{entity_name}.yml"
            return nil unless File.exists? file_yml
            navigator = Sboot::Navigator.new
            navigator.nav_to_root_folder Dir.pwd
            serialized_object = File.read file_yml
            result = YAML::load(serialized_object)
            navigator.set_original_path_back
            result
        end
        
    end
end
