class CreateCloudHelpWorkflowAssociations < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000203_workflow_associations.json")))
        create_table :cloud_help_workflow_associations do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end

            # Specific fields to which you can associate a workflow with
            t.bigint :ticket_type
            t.bigint :ticket_category

            t.timestamps
        end
        
        add_index :cloud_help_workflow_associations, :ticket_type,      name: "help_workflow_associations_ticket_types"
        add_index :cloud_help_workflow_associations, :ticket_category,  name: "help_workflow_associations_ticket_categories"

        add_reference(
            :cloud_help_workflow_associations, 
            :workflow, 
            foreign_key: { to_table: :cloud_help_workflows}, 
            index: { name: "help_workflow_associations_workflows" }
        )
    end
end
