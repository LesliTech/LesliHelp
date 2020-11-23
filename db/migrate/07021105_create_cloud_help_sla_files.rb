class CreateCloudHelpSlaFiles < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000006_files.json")))
        create_table :cloud_help_sla_files do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_help_sla_files, :users, foreign_key: true
        add_reference :cloud_help_sla_files, :cloud_help_slas, foreign_key: true
    end
end
