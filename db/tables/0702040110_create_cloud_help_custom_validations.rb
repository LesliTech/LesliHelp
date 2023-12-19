class CreateCloudHelpCustomValidations < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000401_custom_validations.json")))
        create_table :cloud_help_custom_validations do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_help_custom_validations, :users, foreign_key: true
        add_reference :cloud_help_custom_validations, :cloud_help_accounts, foreign_key: true, index: { name: "help_custom_validations_accounts" }
    end
end
