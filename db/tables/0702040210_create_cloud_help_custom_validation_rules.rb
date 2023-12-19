class CreateCloudHelpCustomValidationRules < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000402_custom_validation_rules.json")))
        create_table :cloud_help_custom_validation_rules do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_help_custom_validation_rules, :users, foreign_key: true
        add_reference :cloud_help_custom_validation_rules, :cloud_help_custom_validations, foreign_key: true, index: { name: "help_custom_validation_rules_validations" }
    end
end
