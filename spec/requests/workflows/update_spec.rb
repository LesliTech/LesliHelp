=begin

Copyright (c) 2023, all rights reserved.

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


require "lesli_request_helper"


RSpec.describe "PUT:/help/workflows/:id.json", type: :request do
    include_context "request user authentication"
    # test cases

    let!(:new_workflow) do

        workflow_params =  {
            account: @current_user.account,
            name: Faker::Lorem.word,
            deletion_protection: true,
            default: false,

            statuses_attributes: [{
                number: 1,
                name: "created",
                status_type: "initial",
                next_statuses: ""
            }, {
                number: 2,
                name: "confirmed",
                status_type: "normal",
                next_statuses: ""
            }, {
                number: 3,
                name: "finished",
                status_type: "completed_successfully",
                next_statuses: ""
            }]
        } 
        

        workflow = CloudHelp::Workflow.new(workflow_params)
        workflow.save!
        workflow
    end


    it "is expected to update workflow with single next status" do

        workflow = new_workflow

        statuses_attributes = [
            {
                id: workflow.statuses.first.id,
                number: 3,
                name: "finished",
                status_type: "completed_successfully",
                next_statuses: [workflow.statuses.first.id]
            }
        ]

        put("/help/workflows/#{new_workflow.id}.json", params: {
            workflow: {
                statuses_attributes: statuses_attributes
            }
        })

        expect_response_with_successful

        expect(new_workflow.statuses.find_by(:id => workflow.statuses.first.id).next_statuses).to eql(workflow.statuses.first.id.to_s)

    end

    it "is expected to update workflow with two next statuses" do

        workflow = new_workflow

        statuses_attributes = [
            {
                id: workflow.statuses.first.id,
                number: 3,
                name: "finished",
                status_type: "completed_successfully",
                next_statuses: [1, 2]
            }
        ]

        put("/help/workflows/#{new_workflow.id}.json", params: {
            workflow: {
                statuses_attributes: statuses_attributes
            }
        })

        expect_response_with_successful

        expect(new_workflow.statuses.find_by(:id => workflow.statuses.first.id).next_statuses).to eql("1|2")

    end

    it "is expected to update a the name of the workflow" do
        new_workflow_params = {
            name: Faker::Lorem.word
        }

        put("/help/workflows/#{new_workflow.id}.json", params: {
            workflow: new_workflow_params
        })

        expect_response_with_successful

        # shared_expects validates the response body with the given arguments
        shared_expects(response_body, new_workflow_params, [
            { key: "id", expected_type: "integer" },
            { key: "name", expected_type: "string", expected_value: new_workflow_params[:name] },
            { key: "default", expected_type: "boolean" },
            { key: "created_at", expected_type: "string" },
            { key: "updated_at", expected_type: "string" }
        ])
    end

    it "is expected to update a the name of the workflow and statuses" do
        new_workflow_params = {
            name: Faker::Lorem.word,
            statuses_attributes: [
                {
                    number: 1,
                    name: Faker::Lorem.word,
                    status_type: "initial",
                    next_statuses: ""
                }, {
                    number: 2,
                    name: Faker::Lorem.word,
                    status_type: "normal",
                    next_statuses: ""
                }
            ]
        }

        put("/help/workflows/#{new_workflow.id}.json", params: {
            workflow: new_workflow_params
        })

        expect_response_with_successful

        # shared_expects validates the response body with the given arguments
        shared_expects(response_body, new_workflow_params, [
            { key: "id", expected_type: "integer" },
            { key: "name", expected_type: "string", expected_value: new_workflow_params[:name] },
            { key: "default", expected_type: "boolean" },
            { key: "created_at", expected_type: "string" },
            { key: "updated_at", expected_type: "string" }
        ])
    end

    it "is expected to delete a status" do
        new_workflow_params = {
            statuses_attributes: [
                {
                    number: 1,
                    name: "confirmed",
                    status_type: "initial",
                    next_statuses: "",
                    destroy: true
                }
            ]
        }

        put("/help/workflows/#{new_workflow.id}.json", params: {
            workflow: new_workflow_params
        })

        expect_response_with_successful

        # shared_expects validates the response body with the given arguments
        shared_expects(response_body, new_workflow_params, [
            { key: "id", expected_type: "integer" },
            { key: "name", expected_type: "string", expected_value: new_workflow_params[:name] },
            { key: "default", expected_type: "boolean" },
            { key: "created_at", expected_type: "string" },
            { key: "updated_at", expected_type: "string" }
        ])
    end

    it "is expected to change the type of a status" do
        new_workflow_params = {
            statuses_attributes: [
                {
                    number: 1,
                    name: "confirmed",
                    status_type: "normal",
                    next_statuses: "",
                    destroy: true
                }
            ]
        }

        put("/help/workflows/#{new_workflow.id}.json", params: {
            workflow: new_workflow_params
        })

        expect_response_with_successful

        # shared_expects validates the response body with the given arguments
        shared_expects(response_body, new_workflow_params, [
            { key: "id", expected_type: "integer" },
            { key: "name", expected_type: "string", expected_value: new_workflow_params[:name] },
            { key: "default", expected_type: "boolean" },
            { key: "created_at", expected_type: "string" },
            { key: "updated_at", expected_type: "string" }
        ])
    end


    it "is expected to respond with not found if id is not valid" do
        new_workflow_params = {
            name: Faker::Lorem.word
        }

        put("/help/workflows/#{new_workflow.id + 1}.json", params: {
            workflow: new_workflow_params
        })

        expect_response_with_not_found

    end

    it "is expected to respond with not error if params are empty" do
        new_workflow_params = {}

        put("/help/workflows/#{new_workflow.id}.json", params: {
            workflow: new_workflow_params
        })

        expect_response_with_error

    end
end