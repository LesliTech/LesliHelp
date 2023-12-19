=begin

Copyright (c) 2022, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
class CreateCloudHelpCatalogTicketWorkspaces < ActiveRecord::Migration[6.1]
    def change
        create_table :cloud_help_catalog_ticket_workspaces do |t|
            t.string :name
            t.boolean :default, default: false

            # acts_as_paranoid
            t.datetime :deleted_at, index: true
            
            t.timestamps
        end

        add_reference(
            :cloud_help_catalog_ticket_workspaces, 
            :account, 
            foreign_key: { to_table: :cloud_help_accounts }, 
            index: { name: "help_catalog_ticket_workspaces_accounts" }
        )
    end
end
