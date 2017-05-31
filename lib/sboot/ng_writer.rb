require 'json'

module Sboot
  module NgWriter

    def matches? string, regex
      !!string.match(regex)
    end

    def write_routes
      contents = search_contents open_file
      elaborate_new_contents contents
    end

    def open_file
      file = File.open('src/main/webapp/resources/ng-app/src/app/app.module.ts','r+')
      file.read
    end

    def package_json_file options={}
      File.open('src/main/webapp/resources/ng-app/package.json','r+'){ |file| JSON.parse file.read } if options.key? :read
      File.write('src/main/webapp/resources/ng-app/package.json', JSON.pretty_generate(options[:contents])) if options.key? :write
    end

    def write_out_file new_file
      File.write('src/main/webapp/resources/ng-app/src/app/app.module.ts', new_file)
    end

    def search_contents contents
      find_routes_defs contents
    end

    def elaborate_new_contents contents
      first_time_editing if contents.empty?
      write_inside routes(append_to_existing_object(contents)) unless contents.empty?
    end

    def first_time_editing
      #write_dependencies
      write_import_modules
      write_above_module insert_new_route_object @entity
      write_import_route
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
      new_route = insert_new_route @entity
      originalArray << new_route
      form_reactive_route= insert_form_reactive_route @entity
      originalArray << form_reactive_route
      originalArray.join(',')
    end

    def write_above_module new_contents
      str = open_file
      new_file = str.gsub(/@NgModule/,new_contents)
      write_out_file new_file
    end

    def write_inside_routes new_contents
      str = open_file
      new_file = str.gsub(/(.+\:[\s+]Routes[\s+]=[\s+]\[)([\n\{\s\w\:\'\,\}\/]+)(\];)/, "\\1#{new_contents}\\3")
      write_out_file new_file
    end

    def write_import_route
      str = open_file
      import_array = str.scan /(imports: \[)([\w\,\.\(\)\n\r\s]+)(\])/
      imported = import_array[0][1].split ','
      imported.unshift insert_reactiveformsmodule_import
      imported.unshift insert_routes_import
      new_file = str.gsub /(imports: \[)([\w\,\.\(\)\n\r\s]+)(\])/, "\\1#{imported.join ','}\\3"
      write_out_file new_file
    end

    def write_import_modules
      str = open_file
      new_imports = insert_basic_modules
      new_file = str.gsub /import { FormsModule } from '@angular\/forms';/, new_imports
      write_out_file new_file
    end

    def write_dependencies
      json = package_json_file read: true
      json['dependencies'].merge! insert_jquery_dependency
      json['dependencies'].merge! insert_bootstrap_dependency
      package_json_file write: true, contents: json
    end

    def insert_ngbootstrap_dependency
      {"@ng-bootstrap/ng-bootstrap" => "^1.0.0-alpha.26"}
    end

    def insert_basic_modules
      "import { FormsModule, ReactiveFormsModule } from '@angular/forms';\nimport { RouterModule, Routes } from '@angular/router';"
    end

    def insert_routes_import
      "\n    RouterModule.forRoot(routes)"
    end

    def insert_reactiveformsmodule_import
      "\n    ReactiveFormsModule"
    end

    def insert_new_route_object entity
      "\nconst routes: Routes = [\n  { path: '', redirectTo: '#{entity.collection_downcase}', pathMatch: 'full'},\n  { path: '#{entity.collection_downcase}', component: #{entity.collection_capitalize}ElencoComponent},\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}', component: #{entity.single_capitalize}DettaglioComponent },\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}/form', component: #{entity.single_capitalize}FormComponent },\n  { path: '#{entity.collection_downcase}/new', component: #{entity.single_capitalize}FormComponent },\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}/formreactive', component: #{entity.single_capitalize}FormreactiveComponent }\n];\n\n@NgModule"
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

    def insert_new_route entity
      "\n  { path: '#{entity.collection_downcase}/new', component: #{entity.single_capitalize}FormComponent }"
    end

    def insert_form_reactive_route entity
      "\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}/formreactive', component: #{entity.single_capitalize}FormreactiveComponent }"
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
