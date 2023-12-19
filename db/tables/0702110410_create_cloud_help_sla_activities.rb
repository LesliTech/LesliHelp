class CreateCloudHelpSlaActivities < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000004_activities.json")))
        create_table :cloud_help_sla_activities do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_help_sla_activities, :cloud_help_slas, foreign_key: true
    end
end
