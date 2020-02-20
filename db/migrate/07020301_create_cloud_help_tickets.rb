class CreateCloudHelpTickets < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_help_tickets do |t|
            t.timestamps
        end
        
        add_reference :cloud_help_tickets, :cloud_help_accounts, foreign_key: true
        add_reference :cloud_help_tickets, :cloud_help_workflow_statuses, foreign_key: true, index: { name: "help_tickets_workflow_statuses" }
        add_reference :cloud_help_tickets, :cloud_help_catalog_ticket_types, foreign_key: true, index: { name: "help_tickets_catalog_ticket_types" }
        add_reference :cloud_help_tickets, :cloud_help_catalog_ticket_priorities, foreign_key: true, index: { name: "help_tickets_catalog_ticket_priorities" }
        add_reference :cloud_help_tickets, :cloud_help_catalog_ticket_sources, foreign_key: true, index: { name: "help_tickets_catalog_ticket_sources" }
        add_reference :cloud_help_tickets, :cloud_help_catalog_ticket_categories, foreign_key: true, index: { name: "help_tickets_catalog_ticket_categories" }
        
    end
end
