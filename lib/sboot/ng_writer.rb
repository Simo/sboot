module Sboot
  class NgWriter
    #include Sboot::NgRoutesHelper

    attr_accessor :entity

    def initialize options={}
      @entity = options[:entity]
    end

    def matches? string, regex
      !!string.match(regex)
    end

    def insert_new_route_object
      "\nconst routes: Routes = [\n  { path: '', redirectTo: '#{entity.collection_downcase}', pathMatch: 'full'},\n  { path: #{entity.collection_downcase}, component: #{entity.collection_capitalize}ElencoComponent},\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}', component: #{entity.single_capitalize}DettaglioComponent }\n];\n\n@NgModule"
    end

    def insert_home_route entity
      "\n  { path: '', redirectTo: '#{entity.collection_downcase}', pathMatch: 'full'}"
    end

    def insert_collection_route entity
      "\n  { path: #{entity.collection_downcase}, component: #{entity.collection_capitalize}ElencoComponent}"
    end

    def insert_detail_route entity
      "\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}', component: #{entity.single_capitalize}DettaglioComponent }"
    end

    def open_module_file file
      Dir.chdir 'src/app'
      contents = File.open("app.module.ts", "r+"){ |file| file.read }
      new_contents = contents.gsub /imports: \[([\w\,\.\(\)\n\r\s]+)/, 'imports: [\1,'
    end

    def find_routes_defs file_string
      file_string.scan /.+\:[\s+]Routes[\s+]=[\s+]\[([\n\{\s\w\:\'\,\}\/]+)\];/
      #=> [["\n  { path: '', redirectTo: 'persone', pathMatch: 'full'},\n  { path: 'persone', component: ListaPersoneComponent },\n  { path: 'persone/:id', component: DettaglioPersonaComponent }\n"]]
    end

    def routes_to_array reduced_string
      reduced_string.scan /(\n\s+\{[\s\w\:\'\/\,]+\})[,]?/
      #=> ["\n  { path: '', redirectTo: 'persone', pathMatch: 'full'},", "\n  { path: 'persone', component: ListaPersoneComponent },", "\n  { path: 'persone/:id', component: DettaglioPersonaComponent }"]
    end

  end
end
