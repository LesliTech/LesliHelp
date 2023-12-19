class CreateCloudHelpTicketHistories < ActiveRecord::Migration[6.1]
    def change
        create_table :cloud_help_ticket_histories do |t|
            t.text      :content

            # acts_as_paranoid
            t.datetime  :deleted_at, index: true

            t.timestamps
        end

        add_reference :cloud_help_ticket_histories, :cloud_help_tickets, foreign_key: true
        add_reference :cloud_help_ticket_histories, :users, foreign_key: true, index: { name: "help_ticket_histories_users" }
    end
end
