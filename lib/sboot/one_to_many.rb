require 'sboot/code_injector'
 
module Sboot
    class OneToMany < CodeInjector
        def initialize options={}
            super
            @master = options[:master]
            @detail = options[:detail]
        end
        
        def apply_changes
            apply_to_entities
        end
        
        def apply_to_entities
            # relazione diretta, master -> detail
            inject_code @master, @detail, master_code, persistence_file
            # relazione inversa, detail <- master
            inject_code @detail, @master, detail_code, persistence_file
        end
            
        private
        
        def master_code
            ERB.new(get_template("entity_one_to_many"), nil, '-').result(binding)
        end
        
        def detail_code
            ERB.new(get_template("entity_many_to_one"), nil, '-').result(binding)
        end
    end
end
