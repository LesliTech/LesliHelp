class CreateCloudHelpSlaActions < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000003_actions.json")))
        create_table :cloud_help_sla_actions do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_help_sla_actions, :users, foreign_key: true
        add_reference :cloud_help_sla_actions, :cloud_help_slas, foreign_key: true, index: { name: "help_sla_actions_slas" }
    end
end

