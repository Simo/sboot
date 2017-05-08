module Sboot
  class Navigator
    attr_accessor :starting_pos

    def initialize options={}
    end

    def nav_to_root_folder from_here
      @starting_pos = from_here
      set_root_folder from_here
    end

    def set_original_path_back
      Dir.chdir @starting_pos
    end

    def package_json_path from_here
      @starting_pos = from_here
      Dir.chdir('src/main/webapp/resources')
    end

    private

    def set_root_folder starting_point
      unless Dir['.sbootconf'].empty?
        return
      else
        here = Dir.pwd
        Dir.chdir '..'
        unless here == starting_point
          set_root_folder here
        else
          return
        end
      end
    end

  end
end