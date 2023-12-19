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
import { useHistory } from "CloudHelp/stores/tickets/history"

// · import vue router composable
import { useRoute } from "vue-router"

// · implement stores
const storeHistories = useHistory()

// · initialize/inject plugins
const route = useRoute()

// · 
const translations = {
    shared: I18n.t("core.shared"),
    histories: I18n.t('help.ticket/histories'),
    help:{
        shared: I18n.t('help.shared')
    },
    core: I18n.t('core.shared'),
    main: I18n.t('help.ticket/histories')
}

const columns = [{
    field: "created_at",
    label: translations.core.column_created_at,
}, {
    field: "user_creator_name",
    label: translations.main.column_users_id,
}, {
    field: "content",
    label: translations.main.column_content
}]

onMounted(() => {
    storeHistories.getHistories(route.params.id)
    storeHistories.ticket_id = route.params.id
})

/**
 * @description This function is used to create a new internal comment
 */
const onCreate = () => {
    storeHistories.createHistory()

}


</script>
<template>

    <h2>{{translations.histories.view_title_main}}</h2>

    <div class="block">
        <form @submit.prevent="onCreate()">
            <div class="columns">
                <div class="column is-6">
                    <input name="comment" type="text" :placeholder="translations.histories.view_placeholder_add_history" class="input"  v-model="storeHistories.history">
                </div>
                <div class="column is-6">
                    <lesli-button icon="save">{{ translations.shared.view_btn_save }}</lesli-button>
                </div>
            </div>

        </form>
    </div>

    <lesli-table 
        :records="storeHistories.histories"
        :columns="columns"
        :loading="storeHistories.loading"
    >
        <template #options="{ record, value }">
            <a class="dropdown-item" @click="storeHistories.deleteHistory(record)">
                <span class="material-icons">
                    delete
                </span>
                <span>
                    {{translations.help.shared.view_tab_title_delete_section}}
                </span>
            </a>
        </template>
    </lesli-table>

</template>
