class CreateCloudHelpSlaAssociations < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_help_sla_associations do |t|
            # acts_as_paranoid
            t.datetime :deleted_at, index: true

            t.timestamps
        end

        add_reference :cloud_help_sla_associations, :cloud_help_catalog_ticket_types, foreign_key: true, index: {name: "help_sla_associations_catalog_ticket_types"}
        add_reference :cloud_help_sla_associations, :cloud_help_slas, foreign_key: true, index: {name: "help_sla_associations_slas"}
    end
end
