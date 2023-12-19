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

module LesliHelp
    class TicketsController < ApplicationController
        before_action :set_ticket, only: [:show, :update, :destroy, :images]

        def index
            respond_to do |format|
                format.html { }
                format.json do
                    #respond_with_successful(TicketService.new(current_user, query).index)
                    respond_with_pagination(TicketService.new(current_user, query).index)
                end
            end
        end

        def show
            respond_to do |format|
                format.html { }
                format.json do
                    respond_with_successful(@ticket.show)
                end
            end
        end

        def new
        end

        def edit
        end

        def create
            ticket = TicketServices.new(current_user, query).create(ticket_params)

            if ticket.successful?
                respond_with_successful(ticket.result)
            else 
                respond_with_error(ticket.errors)
            end
        end

        def update
            return respond_with_not_found unless @ticket
            return respond_with_unauthorized unless @ticket.is_editable_by?(current_user, bypass_status: true)

            # When the ticket is closed, the only available field for update is the status
            update_params = ticket_params
            if ["completed_successfully", "completed_unsuccessfully"].include? @ticket.status&.status_type
                update_params = completed_ticket_params
            end

            if @ticket.check_workflow_transitions(current_user, update_params)
                ticket_update_response = TicketServices.update(current_user, @ticket, update_params)

                @ticket = ticket_update_response.payload
                if ticket_update_response.successful?
                    respond_with_successful(@ticket.show(current_user, @query))
                else
                    respond_with_error(@ticket.errors.full_messages.to_sentence)
                end
            else
                respond_with_error(@ticket.errors.full_messages.to_sentence)
            end
        end

        def options
            respond_with_successful(Ticket.options(current_user, @query))
        end


        def destroy
            return respond_with_not_found unless @ticket
            return respond_with_unauthorized unless @ticket.is_editable_by?(current_user)

            ticket_destroy_response = TicketServices.destroy(current_user, @ticket)

            if ticket_destroy_response.successful?
                respond_with_successful
            else
                respond_with_error(ticket_destroy_response.payload.errors.full_messages.to_sentence)
            end
        end

        def images
            return respond_with_not_found unless @ticket

            images = @ticket.files.filter do |file|
                file_name = ""
                file_name = file.attachment_s3_identifier.downcase if file.attachment_s3_identifier
                file_name = file.attachment_identifier.downcase if file.attachment_identifier

                file_name.end_with?('png') || file_name.end_with?('jpg') || file_name.end_with?('jpeg')
            end

            images = images.map do |image|
                {
                    id: image.id,
                    name: image.name,
                    src: "/help/tickets/#{@ticket.id}/files/#{image.id}",
                    href: "/help/tickets/#{@ticket.id}/files/#{image.id}?view=true"
                }
            end

            respond_with_successful(images)
        end

        private


        def set_ticket
            ticket_id = params[:id] unless params[:id].blank?
            ticket_id = params[:ticket_id] unless params[:ticket_id].blank?
            L2.info "start"
            @ticket = TicketServices.new(current_user, query).find(ticket_id)
            pp @ticket
            L2.info "end"
            return respond_with_not_found unless @ticket.found?
        end
        

        def ticket_params
            params.require(:ticket).permit(
                :cloud_help_catalog_ticket_types_id,
                :cloud_help_catalog_ticket_priorities_id,
                :cloud_help_catalog_ticket_categories_id,
                :cloud_help_catalog_ticket_workspaces_id,
                :cloud_help_workflow_statuses_id,
                :subject,
                :description,
                :reference_url,
                :tags,
                :hours_worked,
                :deadline,
                :started_at,
                :finished_at
            )
        end

        def completed_ticket_params
            params.require(:ticket).permit(
                :cloud_help_workflow_statuses_id
            )
        end

    end
end
