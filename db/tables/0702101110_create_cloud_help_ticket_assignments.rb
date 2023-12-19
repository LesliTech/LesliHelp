class CreateCloudHelpTicketAssignments < ActiveRecord::Migration[6.0]
    def change
        create_table :cloud_help_ticket_assignments do |t|
            t.bigint :team_id
            t.string :assignment_type

            # acts_as_paranoid
            t.datetime :deleted_at, index: true

            t.timestamps
        end
        add_reference(:cloud_help_ticket_assignments, :ticket, foreign_key: { to_table: :cloud_help_tickets })
        add_reference(:cloud_help_ticket_assignments, :users, foreign_key: { to_table: :users })
    end
end
