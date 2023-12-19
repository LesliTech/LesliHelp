=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class CreateLesliHelpTickets < ActiveRecord::Migration[6.0]
    def change
        create_table :lesli_help_tickets do |t|
            t.string  :subject 
            t.text    :description
            
            t.string  :tags
            t.decimal :hours_worked
            t.string  :reference_url

            t.datetime :deadline
            t.datetime :started_at
            t.datetime :completed_at

            t.datetime :deleted_at, index: true
            t.timestamps
        end
=begin
        add_reference(
            :cloud_lesli_tickets, 
            :status, 
            foreign_key: { to_table: :cloud_help_workflow_statuses }, 
            index: { name: "help_tickets_workflow_statuses" }
        )
        add_reference(
            :cloud_lesli_tickets, 
            :type, 
            foreign_key: { to_table: :cloud_help_catalog_ticket_types}, 
            index: { name: "help_tickets_catalog_ticket_types" }
        )
        add_reference(
            :cloud_lesli_tickets, 
            :priority, 
            foreign_key: { to_table: :cloud_help_catalog_ticket_priorities }, 
            index: { name: "help_tickets_catalog_ticket_priorities" }
        )
        add_reference(
            :cloud_lesli_tickets, 
            :source, 
            foreign_key: { to_table: :cloud_help_catalog_ticket_sources }, 
            index: { name: "help_tickets_catalog_ticket_sources" }
        )
        add_reference(
            :cloud_lesli_tickets, 
            :category, 
            foreign_key: { to_table: :cloud_help_catalog_ticket_categories }, 
            index: { name: "help_tickets_catalog_ticket_categories" }
        )
        add_reference(
            :cloud_lesli_tickets, 
            :workspace, 
            foreign_key: { to_table: :cloud_help_catalog_ticket_workspaces }, 
            index: { name: "help_tickets_catalog_ticket_workspaces" }
        )
=end
        add_reference(:lesli_help_tickets, :account, foreign_key: { to_table: :lesli_help_accounts })
        add_reference(:lesli_help_tickets, :slas,    foreign_key: { to_table: :lesli_help_slas })
        add_reference(:lesli_help_tickets, :user,    foreign_key: { to_table: :lesli_users })
        add_reference(:lesli_help_tickets, :assigned,foreign_key: { to_table: :lesli_users })
    end
end
