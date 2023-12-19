class CreateCloudHelpCustomFields < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000301_custom_fields.json")))
        create_table :cloud_help_custom_fields do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_help_custom_fields, :cloud_help_accounts, foreign_key: true, index: { name: "cloud_help_accounts_custom_fields" }
    end
end
