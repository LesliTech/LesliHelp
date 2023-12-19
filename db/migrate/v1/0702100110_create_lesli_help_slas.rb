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

class CreateLesliHelpSlas < ActiveRecord::Migration[6.0]
    def change
        create_table :lesli_help_slas do |t|
            t.string    :name
            t.integer   :expected_response_time
            t.integer   :expected_resolution_time
            t.float     :price_per_hour
            t.text      :body
            t.text      :provider_repercussions
            t.text      :client_repercussions
            t.text      :exceptions
            t.boolean   :default, default: false

            # Main user
            t.bigint    :user_main_id

            # acts_as_paranoid
            t.datetime :deleted_at, index: true

            t.timestamps
        end

        add_reference(:lesli_help_slas, :accounts, foreign_key: { to_table: :lesli_help_accounts })
        add_reference(:lesli_help_slas, :users, foreign_key: { to_table: :lesli_users })
        #add_reference(:lesli_help_slas, :statuses,  foreign_key: true, index: { name: "help_slas_workflow_statuses" })
    end
end
