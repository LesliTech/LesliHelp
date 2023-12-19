class CreateCloudHelpTicketDiscussions < ActiveRecord::Migration[6.0]
    def change
        table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","00000005_discussions.json")))
        create_table :cloud_help_ticket_discussions do |t|
            table_base_structure.each do |column|
                t.send(
                    column["type"].parameterize.underscore.to_sym,
                    column["name"].parameterize.underscore.to_sym
                )
            end
            t.timestamps
        end
        add_reference :cloud_help_ticket_discussions, :cloud_help_ticket_discussions, foreign_key: true, index: { name: "help_ticket_discussions_discussions" }
        add_reference :cloud_help_ticket_discussions, :users, foreign_key: true, index: { name: "help_ticket_discussions_users" }
        add_reference :cloud_help_ticket_discussions, :cloud_help_tickets, foreign_key: true, index: { name: "help_ticket_discussions_tickets" }
    end
end
