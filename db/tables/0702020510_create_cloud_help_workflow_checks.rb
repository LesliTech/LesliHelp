class CreateCloudHelpWorkflowChecks < ActiveRecord::Migration[6.1]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000205_workflow_checks.json")))
        create_table :cloud_help_workflow_checks do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        
        add_reference   :cloud_help_workflow_checks, :cloud_help_workflows, foreign_key: true, index: { name: "help_workflow_checks_workflows" }
        add_foreign_key :cloud_help_workflow_checks, :cloud_help_workflow_statuses, column: :initial_status_id
        add_foreign_key :cloud_help_workflow_checks, :cloud_help_workflow_statuses, column: :final_status_id
        add_foreign_key :cloud_help_workflow_checks, :roles, column: :roles_id
        add_foreign_key :cloud_help_workflow_checks, :users, column: :users_id
    end
end
