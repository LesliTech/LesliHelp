module CloudHelp
    class TicketWorkflow < ApplicationRecord
        belongs_to :ticket_state, class_name: "CloudHelp::TicketState", foreign_key: "cloud_help_ticket_states_id"
        belongs_to :ticket_type, class_name: "CloudHelp::TicketType", foreign_key: "cloud_help_ticket_types_id" 
        belongs_to :ticket_category, class_name: "CloudHelp::TicketCategory", foreign_key: "cloud_help_ticket_categories_id" 

        def self.detailed_info(account)
            result = TicketWorkflow.joins(
                :ticket_type
            ).joins(
                :ticket_category
            ).joins(
                :ticket_state
            ).select(
                "cloud_help_ticket_workflows.id",
                "cloud_help_ticket_workflows.created_at",
                "cloud_help_ticket_workflows.updated_at",
                "cloud_help_ticket_types.name as ticket_type_name",
                "cloud_help_ticket_categories.name as ticket_category_name",
                "cloud_help_ticket_categories.id as ticket_category_id"
            ).where(
                "cloud_help_ticket_states.initial = true"
            ).where(
                "cloud_help_ticket_states.cloud_help_accounts_id = #{account.id}"
            ).order(
                "ticket_type_name asc",
                "ticket_category_name asc"
            )
            result.each do |ticket_workflow|
                self.set_category_path(ticket_workflow)
            end
            result
        end

        def full_workflow(account)
            data = {}
            workflow = TicketWorkflow.joins(
                :ticket_type
            ).joins(
                :ticket_category
            ).joins(
                :ticket_state
            ).select(
                "false as visited",
                "cloud_help_ticket_workflows.id",
                "cloud_help_ticket_states.initial",
                "cloud_help_ticket_states.final",
                "cloud_help_ticket_workflows.next_states",
                "cloud_help_ticket_states.id as ticket_state_id",
                "cloud_help_ticket_states.name as ticket_state_name",
                "cloud_help_ticket_types.name as ticket_type_name",
                "cloud_help_ticket_categories.name as ticket_category_name",
                "cloud_help_ticket_categories.id as ticket_category_id"
            ).where(
                "cloud_help_ticket_states.cloud_help_accounts_id = #{account.id}"
            ).where(
                "cloud_help_ticket_types.id = #{cloud_help_ticket_types_id}"
            ).where(
                "cloud_help_ticket_categories.id = #{cloud_help_ticket_categories_id}"
            )
            workflow.each do |node|
                data[node[:ticket_state_id]] = node
            end
            TicketWorkflow.set_category_path(data[1])
            data
        end

        def replace_workflow(account, new_workflow)
            workflow = TicketWorkflow.joins(
                :ticket_state
            ).where(
                "cloud_help_ticket_states.cloud_help_accounts_id = #{account.id}"
            ).where(
                "cloud_help_ticket_types_id = #{cloud_help_ticket_types_id}"
            ).where(
                "cloud_help_ticket_categories_id = #{cloud_help_ticket_categories_id}"
            ).where(
                "cloud_help_ticket_states_id != 1"
            ).where(
                "cloud_help_ticket_states_id != 2"
            ).delete_all
            new_workflow.each do |node|
                # created or closed
                if node[:ticket_state_id] == 1 || node[:ticket_state_id] == 2
                    TicketWorkflow.find(node[:id]).update(
                        next_states: node[:next_states]
                    )
                else
                    TicketWorkflow.create(
                        cloud_help_ticket_categories_id: cloud_help_ticket_categories_id,
                        cloud_help_ticket_types_id: cloud_help_ticket_types_id,
                        cloud_help_ticket_states_id: node[:ticket_state_id],
                        next_states: node[:next_states]
                    )
                end
            end
        end

        private

        def self.set_category_path(workflow_node)
            category_path = ""
            TicketCategory.find(workflow_node.ticket_category_id).path.each do |node|
                if category_path.empty?
                    category_path = node.name
                else
                    category_path += ", #{node.name}"
                end
            end
            workflow_node.ticket_category_name = category_path
        end
    end
end
