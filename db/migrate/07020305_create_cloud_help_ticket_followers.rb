class CreateCloudHelpTicketFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :cloud_help_ticket_followers do |t|

      t.timestamps
    end
  end
end