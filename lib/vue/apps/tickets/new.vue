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
import { onMounted } from "vue"
import { useRouter } from "vue-router"


// . import components
import formTicket from "./components/form.vue"


// · import lesli stores
import { useTickets } from "CloudHelp/stores/tickets"


// · initialize/inject plugins
const router = useRouter()


// · implement stores
const storeTickets = useTickets()


//·
const translations = {
    main: I18n.t('help.tickets'),
    core: {
        shared: I18n.t('core.shared')
    }
}


//·
const props = defineProps({
    appMountPath: {
        type: String,
        required: false,
        default: "help/tickets",
    }
})


// · initializing
storeTickets.getOptions()

</script>
<template>
    <lesli-application>

        <lesli-header :title="translations.main.view_title_main">
            <lesli-button :to="url.root(props.appMountPath)" icon="list">
                {{translations.core.shared.view_btn_list}}
            </lesli-button>
        </lesli-header>
        <form-ticket :path="props.appMountPath"></form-ticket>

    </lesli-application>
</template>
