<script setup>
/*
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
*/


// · import vue tools
import { onMounted } from "vue"

// · import lesli stores
import { useTickets } from "CloudHelp/stores/tickets"

// · import vue router composable
import { useRoute } from "vue-router"

// · implement stores
const storeTickets = useTickets()

// · initialize/inject plugins
const route = useRoute()

// · 
const translations = {
    users: I18n.t("core.users"),
    shared: I18n.t("core.shared"),
    sla: I18n.t('help.slas')
}


</script>
<template>
    <h2>SLA</h2>
    <div class="box" v-if="!storeTickets.loading">
        <div class="columns">
            <div class="column">
                <label>{{translations.sla.column_name}}</label>
                <p>{{storeTickets.ticket.sla?.name}}</p>
            </div>

            <div class="column">
                <label>{{translations.sla.column_default}}</label>
                <p v-if="storeTickets.ticket.sla?.default">yes</p>
                <p v-else> no </p>
            </div>
        </div>

        <div class="columns">
            <div class="column">
                <label>{{translations.sla.column_expected_response_time}}</label>
                <p>{{storeTickets.ticket.sla?.expected_response_time}}</p>
            </div>

            <div class="column">
                <label>{{translations.sla.column_expected_resolution_time}}</label>
                <p>{{storeTickets.ticket.sla?.expected_resolution_time}}</p>
            </div>

            <div class="column">
                <label>{{translations.sla.column_price_per_hour}}</label>
                <p> {{storeTickets.ticket.sla?.price_per_hour}}</p>
            </div>
        </div>

        <div class="colums">
            <div class="column">
                <label>{{translations.sla.view_tab_title_associations}}</label>
                <div v-for="association in storeTickets.ticket.sla?.association_attributes" :key="association.id">
                    <span class="tag is-info">{{association.ticket_type_name}}</span>
                </div>
            </div>
        </div>

        <div class="field">
            <label class="label">{{translations.sla.column_body}}</label>
            <div class="control">
                <textarea class="textarea is-small" :v-model="storeTickets.ticket.sla?.body" disabled></textarea>
            </div>
        </div>

        <div class="field">
            <label class="label">{{translations.sla.column_client_repercussions}}</label>
            <div class="control">
                <textarea class="textarea is-small" :v-model="storeTickets.ticket.sla?.client_repercussions" disabled></textarea>
            </div>
        </div>

        <div class="field">
            <label class="label">{{translations.sla.column_provider_repercussions}}</label>
            <div class="control">
                <textarea class="textarea is-small" :v-model="storeTickets.ticket.sla?.provider_repercussions" disabled></textarea>
            </div>
        </div>

        <div class="field">
            <label class="label">{{translations.sla.column_exceptions}}</label>
            <div class="control">
                <textarea class="textarea is-small" :v-model="storeTickets.ticket.sla?.exceptions" disabled></textarea>
            </div>
        </div>
    </div>

</template>
