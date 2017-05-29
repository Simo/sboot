module Sboot
  module NgImportsHelper

    def insert_jquery_dependency
      {"jquery" => "^3.2.1"}
    end

    def insert_bootstrap_dependecy
      {"bootstrap" => "^3.3.7"}
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
      "\nconst routes: Routes = [\n  { path: '', redirectTo: '#{entity.collection_downcase}', pathMatch: 'full'},\n  { path: '#{entity.collection_downcase}', component: #{entity.collection_capitalize}ElencoComponent},\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}', component: #{entity.single_capitalize}DettaglioComponent },\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}/form', component: #{entity.single_capitalize}FormComponent },\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}/formreactive', component: #{entity.single_capitalize}FormreactiveComponent }\n];\n\n@NgModule"
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
      "\n  { path: '#{entity.collection_downcase}/:#{entity.primary_key.name}/formreactive', component: #{entity.single_capitalize}FormreactiveComponent }"
    end
  end
end
