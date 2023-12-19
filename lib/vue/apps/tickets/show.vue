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
import { onMounted, computed } from "vue"
import { useRouter, useRoute } from 'vue-router'


// . import components
import formTicket from './components/form.vue'
import slaInfo from './components/sla-info.vue'
import internalComments from './components/internal-comments.vue'
import assignments from './components/assignments.vue'


import ComponentDiscussions from "Lesli/cloudobjects/components/discussion.vue"
//import ComponentFiles from "Lesli/cloudobjects/components/file.vue"
//import ComponentWorkflowStatusDropdown from "Lesli/shared/workflows/components/workflow-status-dropdown.vue"
//import ComponentActions from "Lesli/cloudobjects/components/action.vue"


// · import lesli stores
import { useTickets } from "CloudHelp/stores/tickets"


// · initialize/inject plugins
const route = useRoute()
const router = useRouter()


// · implement stores
const storeTickets = useTickets()


//·
const translations = {
    main: I18n.t('help.tickets'),
    sla: I18n.t('help.slas'),
    core: {
        shared: I18n.t('core.shared')
    },
    shared: I18n.t('help.shared')
}


//·
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "help/tickets",
    }
})


//·
const onUpdatedStatus = () => {
    storeTickets.fetchTicket(route.params.id)
}


//·
const onDelete = () => {
    storeTickets.deleteTicket().then(()=>{
        router.push(url.root(`${props.appMountPath}`).s)
    })
}


//·
const title = computed(() => `${storeTickets.ticket.id} - ${storeTickets.ticket.subject} - ${storeTickets.ticket.status}`)

</script>
<template>

    <section class="application-component">
        <lesli-header :title="title">
            <component-workflow-status-dropdown
                    v-if="(storeTickets.ticket.id && storeTickets.ticket.cloud_help_workflow_statuses_id)"
                    @on-updated-status="onUpdatedStatus"
                    cloudObject="tickets"
                    cloudModule="help"
                    :cloudObjectId="storeTickets.ticket.id"
            >
            </component-workflow-status-dropdown>
            <button class="button is-fullwidth has-text-centered is-danger" @click="onDelete">
                {{translations.shared.view_tab_title_delete_section}}
            </button>
            <lesli-button :to="url.root(props.appMountPath)" icon="list">
                {{translations.main.view_title_main}}
            </lesli-button>
        </lesli-header>

        <lesli-tabs v-model="tab">

            <lesli-tab-item paddingless :title="translations.shared.view_tab_title_general_information" icon="info">
                <form-ticket is-editable :path="props.appMountPath"></form-ticket>
            </lesli-tab-item>

            <lesli-tab-item :title="translations.main.view_tab_title_assignments" icon="group">
                <assignments></assignments>
            </lesli-tab-item>

            <lesli-tab-item :title="translations.core.shared.view_btn_discussions" icon="forum">
                <component-discussions 
                    cloud-module="help" 
                    cloud-object="tickets" 
                    :cloud-object-id="storeTickets.ticket.id"
                    :onlyDiscussions="false"
                >
                </component-discussions>
            </lesli-tab-item>
            <lesli-tab-item :title="translations.core.shared.view_btn_files" icon="attach_file">
                <component-files
                    cloud-module="help" 
                    cloud-object="tickets"
                    :cloud-object-id="storeTickets.ticket.id"
                    :accepted-files="['images', 'documents', 'plaintext']"
                ></component-files>

            </lesli-tab-item>

            <lesli-tab-item :title="translations.main.view_tab_title_histories" icon="comment">
                <internal-comments></internal-comments>
            </lesli-tab-item>

            <lesli-tab-item :title="translations.core.view_text_quick_actions" icon="playlist_add_check">
                <component-actions
                    cloud-module="help" 
                    cloud-object="tickets"
                    :cloud-object-id="storeTickets.ticket.id"
                ></component-actions>
            </lesli-tab-item>

            <lesli-tab-item :title="translations.main.view_tab_title_sla" icon="article" v-if="storeTickets.ticket.sla">
                <sla-info></sla-info>
            </lesli-tab-item>

        </lesli-tabs>
    </section>

</template>
