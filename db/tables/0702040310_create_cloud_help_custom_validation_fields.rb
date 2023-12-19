class CreateCloudHelpCustomValidationFields < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000403_custom_validation_fields.json")))
        create_table :cloud_help_custom_validation_fields do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_help_custom_validation_fields, :users, foreign_key: true
        add_reference :cloud_help_custom_validation_fields, :cloud_help_custom_validations, foreign_key: true, index: { name: "cloud_help_custom_validation_fields_validations" }
    end
end
