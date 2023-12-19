<script setup>
/*
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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { inject, onMounted, ref, onUnmounted } from "vue"


// · import vue router composable
import { useRouter, useRoute } from "vue-router"


// · 
import editorRichText from "Lesli/components/editors/richtext.vue"


// · import lesli stores
import { useTickets } from "CloudHelp/stores/tickets"
import { useAssignments } from "CloudHelp/stores/tickets/assignment"


// · implement stores
const storeTickets = useTickets()
const storeAssignments = useAssignments()


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")
const date = inject("date")
const route = useRoute()


// · defining props
const props = defineProps({
    isEditable: {
        type: Boolean,
        required: false,
        default: false,
    },
    path: {
        type: String,
        required: false,
        default: "help/tickets",
    }
})


// · 
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared"),
    main: I18n.t('help.tickets')
}


// · 
const onUpdate = () => {
    storeTickets.updateTicket()
}


// · 
const onCreate = () => {
    storeTickets.postTicket()
    router.push(url.root(props.path).toString())
}


// · 
if (props.isEditable) {
    storeTickets.ticket = {}
    storeTickets.getOptions().then(() => {
        storeTickets.fetchTicket(route.params.id)    
    })
} else {
    storeTickets.getOptions() // get options for ticket form
    storeTickets.ticket = {}
    storeTickets.tags = []
}

</script>
<template>
    <lesli-form 
        @submit="isEditable ? onUpdate() : onCreate()"
        disabled="storeTickets.ticket.status=='closed'">

        <p>Ticket information</p>
        <!-- Ticket creator name -->
        <div class="field is-horizontal" v-if="isEditable">
            <div class="field-label is-normal">
                <label class="label"> 
                    {{translations.main.column_users_id}}
                </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input class="input" disabled  v-model="storeTickets.ticket.user_creator_name">
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket reference url -->
        <div class="field is-horizontal" v-if="isEditable">
            <div class="field-label is-normal">
                <label class="label"> 
                    {{translations.main.column_reference_url}}
                </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="reference_url" disabled type="text" class="input" v-model="storeTickets.ticket.reference_url">
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket assigned users -->
        <div class="field is-horizontal" v-if="isEditable">
            <div class="field-label is-normal">
                <label class="label"> {{translations.main.view_title_assigned_users}} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <div v-for="assignment in storeTickets.ticket.assignment_attributes" :key="assignment">
                            <span class="tag is-success">{{assignment.assignable_name}}
                                <button class="delete is-small" @click="storeAssignments.deleteAssignment(assignment.id)" type="button"></button>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket subject -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> 
                    {{translations.main.column_subject}}
                    <span class="is-danger">*</span>
                </label>
                
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="subject" class="input" required v-model="storeTickets.ticket.subject">
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket deadline -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{translations.main.column_deadline}} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="deadline"  class="input" type="date" v-model="storeTickets.ticket.deadline">
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket types -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> 
                    {{translations.main.column_cloud_help_catalog_ticket_types_id}} 
                </label>

            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-select
                            :options="storeTickets.options.types"
                            v-model="storeTickets.ticket.cloud_help_catalog_ticket_types_id"
                        >
                        </lesli-select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket category -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{translations.main.column_cloud_help_catalog_ticket_categories_id}} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-select
                            v-if="storeTickets.options.categories"
                            :options="storeTickets.options.categories"
                            v-model="storeTickets.ticket.cloud_help_catalog_ticket_categories_id"
                        ></lesli-select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket priority -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{translations.main.column_cloud_help_catalog_ticket_priorities_id}} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-select
                            v-if="storeTickets.options.priorities"
                            :options="storeTickets.options.priorities"
                            v-model="storeTickets.ticket.cloud_help_catalog_ticket_priorities_id"
                        ></lesli-select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket workspace -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"> {{translations.main.column_cloud_help_catalog_ticket_workspaces_id}} </label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-select
                            v-if="storeTickets.options.workspaces"
                            :options="storeTickets.options.workspaces"
                            v-model="storeTickets.ticket.cloud_help_catalog_ticket_workspaces_id"
                        ></lesli-select>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket tags -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">{{translations.main.column_tags}}</label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-input-tag 
                            v-model="storeTickets.tags"
                            placeholder="tags"
                            :options="[ 
                                {
                                    name: 'Bug'
                                },
                                {
                                    name: 'Report'
                                },
                                {
                                    name: 'Performance'
                                }
                            ]"
                            :filterFields="['name']"
                            showField="name"
                        />
                    </div>
                </div>
            </div>
        </div>


        <!-- Ticket started at date -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">{{ translations.main.column_started_at }}</label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-calendar mode="dateTime" v-model="storeTickets.ticket.started_at"></lesli-calendar>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket finished at date -->
        <div class="field is-horizontal" v-if="isEditable">
            <div class="field-label is-normal">
                <label class="label"> {{ translations.column_finished_at }}</label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-calendar mode="dateTime" v-model="storeTickets.ticket.finished_at"></lesli-calendar>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket hours worked -->
        <div class="field is-horizontal" v-if="isEditable">
            <div class="field-label is-normal">
                <label class="label">{{translations.main.column_hours_worked}}</label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <input name="Hours_worked" class="input" type="number" step="any" v-model="storeTickets.ticket.hours_worked">
                    </div>
                </div>
            </div>
        </div>

        <!-- Ticket description -->
        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label">{{translations.main.column_description}}</label>
            </div>

            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <editor-rich-text mode="small" v-model="storeTickets.ticket.description">
                        </editor-rich-text>
                    </div>
                </div>
            </div>

        </div>

        <div class="field is-horizontal">
            <div class="field-label is-normal">
                <label class="label"></label>
            </div>
            <div class="field-body">
                <div class="field">
                    <div class="control">
                        <lesli-button icon="save">
                            {{ translations.shared.view_btn_save }}
                        </lesli-button>                 
                    </div>
                </div>
            </div>
        </div>
    </lesli-form>
</template>
