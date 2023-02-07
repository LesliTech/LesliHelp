=begin
Copyright (c) 2020, all rights reserved.

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

module CloudHelp
    class Dashboard::Component < Shared::Dashboard::Component
        belongs_to :dashboard, inverse_of: :components, class_name: "Dashboard", foreign_key: "cloud_help_dashboards_id"

        enum component_ids: {
            list_new_tickets: "list_new_tickets",
            list_my_tickets: "list_my_tickets",
            list_unassigned_tickets: "list_unassigned_tickets",
            chart_tickets_by_type: "chart_tickets_by_type",
            chart_tickets_by_category: "chart_tickets_by_category",
            hours_worked: "hours_worked"
        }

        def self.configuration_options
            chart_configuration = [
                { column: "query_configuration", group: "filters", name: "only_main_user", type: "Boolean" },
                { column: "custom_configuration", group: "arrangement", name: "range_before", type: "Integer"},
                { column: "custom_configuration", group: "arrangement", name: "range_after", type: "Integer"}
            ]

            list_configuration = [
                { column: "query_configuration", group: "pagination", name: "per_page", type: "Integer" }
            ]
            
            {
                list_new_tickets: list_configuration,
                list_my_tickets: list_configuration,
                list_unassigned_tickets: list_configuration,
                hours_worked: chart_configuration,
                chart_tickets_by_type: [],
                chart_tickets_by_category: []
            }
        end

        def hours_worked(current_user, query)
            configuration = parse_configuration()
            unless current_user.has_privileges?(["cloud_help/tickets"], ["index"])
                return nil
            end

            datetime_start = LC::Date.now.months_ago((configuration[:custom][:arrangement]["range_before"].to_i || 4)).beginning_of_month
            datetime_end = LC::Date.now.end_of_month + (configuration[:custom][:arrangement]["range_after"].to_i || 0).months

            data = current_user.account.help.tickets
            .joins(:type)
            .where("cloud_help_tickets.created_at between ? and ?", datetime_start, datetime_end)
            .where("cloud_help_tickets.hours_worked > 0")

            if configuration[:query][:filters]["only_main_user"]
                data = data
                .left_outer_joins(:assignments)
                .where("cloud_help_ticket_assignments.users_id = ?", current_user.id)
            end

            data = data.select(
                "SUM(cloud_help_tickets.hours_worked) as hours_worked",
                "cloud_help_tickets.cloud_help_catalog_ticket_types_id",
                "cloud_help_catalog_ticket_types.name as type",
                LC::Date.db_to_char_custom("cloud_help_tickets.created_at", include_alias: true, alias_name: "date", db_format: "yyyy-mm")
            )
            .group(
                "date",
                "cloud_help_catalog_ticket_types.name", 
                "cloud_help_tickets.cloud_help_catalog_ticket_types_id"
            ).order(
                "type asc",
                "date asc"
            ).map do |ticket|
                ticket_attributes = ticket.attributes
                
                {
                    hours_worked: ticket_attributes["hours_worked"],
                    type: ticket_attributes["type"],
                    date: ticket_attributes["date"]
                }
            end

            format_hours_worked_component(datetime_start, datetime_end, data)
        end

        def list_new_tickets(current_user, query)

            configuration = parse_configuration()
            unless current_user.has_privileges?(["cloud_help/tickets"], ["index"])
                return nil
            end

            data = Ticket
            .joins(:status)
            .joins("left join cloud_help_catalog_ticket_priorities chctp on chctp.id = cloud_help_tickets.cloud_help_catalog_ticket_priorities_id")
            .order("cloud_help_tickets.created_at desc")
            .where("cloud_help_workflow_statuses.status_type not in (?)", ['completed_successfully', 'completed_unsuccessfully'])
            .limit(configuration[:query][:pagination]["per_page"] || query[:pagination][:perPage])
            .select(
                "cloud_help_tickets.created_at",
                "cloud_help_tickets.id",
                "cloud_help_tickets.subject",
                "chctp.name as priority_name",
                "chctp.weight as priority_weight",
                "CONCAT('/help/tickets/', cloud_help_tickets.id) as url"
            )

            data.map do |ticket|
                ticket_attributes =ticket.attributes
                ticket_attributes["created_at"] = LC::Date.to_string_datetime(ticket.created_at)
                ticket_attributes
            end
        end

        def list_my_tickets(current_user, query)

            configuration = parse_configuration()
            unless current_user.has_privileges?(["cloud_help/tickets"], ["index"])
                return []
            end

            data = Ticket
            .joins(:status)
            .joins("LEFT JOIN cloud_help_ticket_assignments CHTA ON CHTA.cloud_help_tickets_id = cloud_help_tickets.id AND CHTA.deleted_at IS NULL")
            .where("cloud_help_tickets.users_id = ? OR CHTA.users_id = ?", current_user.id, current_user.id)
            .where("cloud_help_workflow_statuses.status_type not in (?)", ['completed_successfully', 'completed_unsuccessfully'])
            .order("cloud_help_tickets.subject asc")
            .limit(configuration[:query][:pagination]["per_page"] || query[:pagination][:perPage])
            .select(
                "cloud_help_tickets.id",
                "cloud_help_tickets.subject",
                "cloud_help_tickets.deadline",
                "cloud_help_workflow_statuses.name as status_name",
                "CONCAT('/help/tickets/', cloud_help_tickets.id) as url"
            )
        end

        def list_unassigned_tickets(current_user, query)
            configuration = parse_configuration()
            unless current_user.has_privileges?(["cloud_help/tickets"], ["index"])
                return nil
            end

            data = Ticket.joins(:status)
            .joins("left join cloud_help_catalog_ticket_priorities chctp on chctp.id = cloud_help_tickets.cloud_help_catalog_ticket_priorities_id")
            .joins("LEFT JOIN cloud_help_ticket_assignments CHTA on CHTA.cloud_help_tickets_id = cloud_help_tickets.id AND CHTA.deleted_at is NULL")
            .order("cloud_help_tickets.created_at asc")
            .where("cloud_help_workflow_statuses.status_type not in (?)", ['completed_successfully', 'completed_unsuccessfully'])
            .where("CHTA.id is ?", nil)
            .select(
                "cloud_help_tickets.deadline",
                "cloud_help_tickets.id",
                "cloud_help_tickets.subject",
                "chctp.name as priority_name",
                "chctp.weight as priority_weight",
                "CONCAT('/help/tickets/', cloud_help_tickets.id) as url"
            )

            data.map do |ticket|
                ticket_attributes = ticket.attributes
                ticket_attributes["deadline_raw"] = ticket.deadline
                ticket_attributes["deadline"] = LC::Date.to_string(ticket.deadline)
                ticket_attributes
            end
        end

        def chart_tickets_by_type(current_user, query)
            
            configuration = parse_configuration()
            unless current_user.has_privileges?(["cloud_help/tickets"], ["index"])
                return nil
            end

            # join to tickets table to count the amount of tickets with a type assigned
            sql_join_tickets = "FULL JOIN cloud_help_tickets CHT 
                on CHT.cloud_help_catalog_ticket_types_id = cloud_help_catalog_ticket_types.id 
                AND CHT.deleted_at IS NULL
                AND CHT.created_at >= '#{ LC::Date.beginning_of_month() }'"

            # count the amount of tickets by grouped by type
            Catalog::TicketType.joins(sql_join_tickets)
            .group(:type_name)
            .select(
                "COUNT(CHT.id) as tickets_count",
                "coalesce(cloud_help_catalog_ticket_types.name, 'undefined') as type_name"
            )
        end

        def chart_tickets_by_category(current_user, query)
            configuration = parse_configuration()
            unless current_user.has_privileges?(["cloud_help/tickets"], ["index"])
                return nil
            end

            sql_join_tickets = "FULL JOIN cloud_help_tickets CHT 
                on CHT.cloud_help_catalog_ticket_categories_id = cloud_help_catalog_ticket_categories.id 
                AND CHT.deleted_at IS NULL
                AND CHT.created_at >= '#{ LC::Date.beginning_of_month() }'"

            Catalog::TicketCategory.joins(sql_join_tickets)
            .group(:category_name)
            .select(
                "COUNT(CHT.id) as tickets_count",
                "coalesce(cloud_help_catalog_ticket_categories.name, 'undefined') as category_name"
            )
        end

        protected
        
        def format_hours_worked_component(datetime_start, datetime_end, data)
            parsed_data = []

            types = data.map do |row|
                row[:type]
            end

            months = []
            types = types.uniq

            types.each do |type|
                date = datetime_start
                while date <= datetime_end
                    month = LC::Date.to_string_datetime_words(date, "%Y-%m")
                    months.push(month) unless months.include? month

                    tickets_by_date_and_type = data.find do |ticket| 
                        ticket[:date] == month && ticket[:type] == type
                    end

                    if tickets_by_date_and_type
                        parsed_data.push(tickets_by_date_and_type)
                    else
                        parsed_data.push({
                            hours_worked: 0,
                            type: type,
                            date: month
                        })
                    end
                    
                    date += 1.month
                end
            end
            
            {
                records: parsed_data,
                types: types,
                months: months
            }
        end
    end
end
