module Sboot
  module NgWriter
    #include Sboot::NgRoutesHelper

    def matches? string, regex
      !!string.match(regex)
    end

    def write_routes
      file = open_file
      contents = search_contents file
      new_contents = elaborate_new_contents contents
      write_above_module new_contents if contents.empty?
      write_inside_routes new_contents unless contents.empty?
    end

    def open_file
      File.open('src/main/webapp/resources/ng-app/src/app/app.module.ts','r+')
    end

    def search_contents file
      contents = file.read
      find_routes_defs contents
    end

    def elaborate_new_contents contents
      nc = add_routes_to_app if contents.empty?
      nc = append_to_existing_object(contents) unless contents.empty?
      nc
    end

    def add_routes_to_app
      insert_new_route_object @entity
    end

    def append_to_existing_object contents
      generate_routes contents
    end

    def generate_routes contents
      originalArray = routes_to_array contents[0][0]
      collection_route = insert_collection_route @entity
      originalArray << collection_route
      detail_route = insert_detail_route @entity
      originalArray << detail_route
      form_route = insert_form_route @entity
      originalArray << form_route
      form_reactive_route= insert_form_reactive_route @entity
      originalArray << form_reactive_route
      originalArray.join(',')
    end

    def write_above_module new_contents
      file = File.open('src/main/webapp/resources/ng-app/src/app/app.module.ts','r+')
      str = file.read
      new_file = str.gsub(/@NgModule/,new_contents)
      File.write('src/main/webapp/resources/ng-app/src/app/app.module.ts',new_file)
    end

    def write_inside_routes new_contents
      file = File.open('src/main/webapp/resources/ng-app/src/app/app.module.ts','r+')
      str = file.read
      new_file = str.gsub(/(.+\:[\s+]Routes[\s+]=[\s+]\[)([\n\{\s\w\:\'\,\}\/]+)(\];)/, "\\1#{new_contents}\\3")
      File.write('src/main/webapp/resources/ng-app/src/app/app.module.ts', new_file)
    end

    def insert_new_route_object entity
      "\nconst routes: Routes = [\n  { path: '', redirectTo: '#{entity.collection_downcase}', pathMatch: 'full'},\n  { path: '#{entity.collection_downcase}', component: #{entity.collection_capitalize}ElencoComponent},\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}', component: #{entity.single_capitalize}DettaglioComponent }\n];\n\n@NgModule"
    end

    def insert_home_route entity
      "\n  { path: '', redirectTo: '#{entity.collection_downcase}', pathMatch: 'full'}"
    end

    def insert_collection_route entity
      "\n  { path: '#{entity.collection_downcase}', component: #{entity.collection_capitalize}ElencoComponent}"
    end

    def insert_detail_route entity
      "\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}', component: #{entity.single_capitalize}DettaglioComponent }"
    end

    def insert_form_route entity
      "\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}/form', component: #{entity.single_capitalize}FormComponent }"
    end

    def insert_form_reactive_route entity
      "\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}/form', component: #{entity.single_capitalize}FormreactiveComponent }"
    end

    def open_module_file file
      Dir.chdir 'src/app'
      contents = File.open("app.module.ts", "r+"){ |file| file.read }
      contents.read
      #new_contents = contents.gsub(/imports: \[([\w\,\.\(\)\n\r\s]+)/, 'imports: [\1,')
    end

    def find_routes_defs file_string
      file_string.scan(/.+\:[\s+]Routes[\s+]=[\s+]\[([\n\{\s\w\:\'\,\}\/]+)\];/)
      #=> [["\n  { path: '', redirectTo: 'persone', pathMatch: 'full'},\n  { path: 'persone', component: ListaPersoneComponent },\n  { path: 'persone/:id', component: DettaglioPersonaComponent }\n"]]
    end

    def routes_to_array reduced_string
      reduced_string.scan(/(\n\s+\{[\s\w\:\'\/\,]+\})[,]?/)
      #=> ["\n  { path: '', redirectTo: 'persone', pathMatch: 'full'},", "\n  { path: 'persone', component: ListaPersoneComponent },", "\n  { path: 'persone/:id', component: DettaglioPersonaComponent }"]
    end

  end
end
