module Sboot
  module NgHelper
    include Sboot::NgRoutesHelper

    def add_routes_to_module
      File.open 'app.module.ts', 'w' do |f|
        f.puts new_contents
      end
    end

    def hello_world
      puts 'hello simo'
    end

  end
end
