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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
*/


// · import vue tools
import { onMounted, inject } from "vue"
import { useRouter } from "vue-router"


// · import lesli stores
import { useTickets } from "LesliHelp/stores/tickets"


// · initialize/inject plugins
const router = useRouter()
const url = inject("url")
const date = inject("date")


// · implement stores
const storeTickets = useTickets()


//·
const translations = {
    lesli: {
        shared: i18n.t("lesli.shared")
    },
    main: I18n.t('help.tickets'),
    core: {
        shared: I18n.t('core.shared')
    }
}


// · initializing
onMounted(() => {
    storeTickets.getTickets()
})


// ·
const columns = [{
    field: "id",
    label: translations.main.column_id,
    sort: true
}, {
    field: "subject",
    label: translations.main.column_subject,
    sort: true
}, {
    field: "deadline",
    label: translations.main.column_deadline,
    align: "center",
    sort: true
}, {
    field: "status_name",
    label: translations.main.column_cloud_help_workflow_statuses_id,
    align: "center",
    sort: true
},{
    field: "priority_name",
    label: translations.main.column_cloud_help_catalog_ticket_priorities_id,
    align: "center",
    sort: true
},  {
    field: "workspace_name",
    label: translations.main.column_cloud_help_catalog_ticket_workspaces_id,
    sort: true
}, {
    field: "user_name",
    label: translations.main.column_users_id,
    sort: true
}, {
    field: "assigned_name",
    label: translations.main.column_user_main_id,
    align: "center"
}]


/**
 * @description Function that extract the initials from the name of the users assigned to a ticket
 * @param {string} name name of the user assigned to the ticket
 */
function extractInitials(name){
    return name.split(" ").map((word)=>{
        if(word){
            return word[0].toUpperCase()
        }else{
            return ''
        }
    }).join("")
}
</script>
<template>
    <lesli-application-container>
        <lesli-header title="Tickets">
            <lesli-button icon="add">
                {{ translations.lesli.shared.button_add_new }}
            </lesli-button>
            <lesli-button @click="storeTickets.reloadTickets" icon="refresh" :loading="storeTickets.loading">
                {{ translations.lesli.shared.button_reload }}
            </lesli-button>
        </lesli-header>

        <lesli-toolbar @search="storeTickets.search" :placeholder="translations.main.view_placeholder_text_filter">
            <lesli-select
                :options="[
                    {
                        label: translations.main.view_text_filter_everyones_tickets,
                        value: null
                    },
                    {
                        label: translations.main.view_text_filter_own_tickets,
                        value: 'own'
                    }
                ]"
                v-model="storeTickets.filters.user_type"
                @change="storeTickets.getTickets()"
            >
            </lesli-select>
            <lesli-select
                :options="[
                    {
                        label: translations.main.view_text_filter_all_tickets,
                        value: null
                    }, {
                        label: translations.main.view_text_filter_active_tickets,
                        value: 'active'
                    }, {
                        label: translations.main.view_text_filter_inactive_tickets,
                        value: 'inactive'
                    },
                ]"
                v-model="storeTickets.filters.search_type"
                @change="storeTickets.getTickets()"
            >
            </lesli-select>

            <lesli-select
                :options="[
                    {
                        label: '10',
                        value: 10
                    }, {
                        label: '15',
                        value: 15
                    }, {
                        label: '30',
                        value: 30
                    }, {
                        label: '50',
                        value: 50
                    },
                ]"
                v-model="storeTickets.filters.per_page"
                @change="storeTickets.getTickets()"
            >
            </lesli-select>
        </lesli-toolbar>

        <lesli-table 
            :columns="columns"
            :records="storeTickets.index.records"            
            :loading="storeTickets.index.loading"
            :pagination="storeTickets.index.pagination">
        </lesli-table>
    </lesli-application-container>
</template>
