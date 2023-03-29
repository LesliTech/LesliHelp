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


// · Import main app
import app from "LesliVue/app"


// · Import apps and components
import appShowDashboard from "LesliVue/shared/dashboards/apps/show.vue"
import dashboardIndex from "LesliVue/shared/dashboards/apps/index.vue"
import dashboardNew from "LesliVue/shared/dashboards/apps/new.vue"
import dashboardEdit from "LesliVue/shared/dashboards/apps/edit.vue"


// · Tickets components
import ticketsIndex from './apps/tickets/index.vue'
import ticketsNew from './apps/tickets/new.vue'
import ticketsShow from './apps/tickets/show.vue'


// · SLAs components
import slasIndex from './apps/sla/index.vue'
import slaNew from './apps/sla/new.vue'
import slaShow from './apps/sla/show.vue'


// · Reports components
import reportsIndex from './apps/reports/index.vue'


// · Ticket priorities components
import prioritiesIndex from './apps/catalog/priorities/index.vue'
import prioritiesShow from './apps/catalog/priorities/show.vue'
import prioritiesNew from './apps/catalog/priorities/new.vue'


// · Ticket types components
import typesIndex from './apps/catalog/types/index.vue'
import typesShow from './apps/catalog/types/show.vue'
import typesNew from './apps/catalog/types/new.vue'


// · Ticket workspaces components
import workspacesIndex from './apps/catalog/workspaces/index.vue'
import workspacesShow from './apps/catalog/workspaces/show.vue'
import workspacesNew from './apps/catalog/workspaces/new.vue'


// · Account settings
import settingsIndex from './apps/account_settings/index.vue'


// · Workflows
import workflowsIndex from 'LesliVue/shared/workflows/apps/index.vue'
import workflowsNew from 'LesliVue/shared/workflows/apps/new.vue'
import workflowsShow from 'LesliVue/shared/workflows/apps/show.vue'

// ·  Dashboard components
import componentListMyTickets from "CloudHelp/apps/dashboards/components/list-my-tickets.vue"
import componentListNewTickets from "CloudHelp/apps/dashboards/components/list-new-tickets.vue"
import componentListUnassignedTickets from "CloudHelp/apps/dashboards/components/list-unassigned-tickets.vue"
import componentChartTicketsByCategory from "CloudHelp/apps/dashboards/components/chart-tickets-by-category.vue"
import componentChartTicketsByType from "CloudHelp/apps/dashboards/components/chart-tickets-by-type.vue"

const propsDashboard = {
    cloudModule: "help",
    renderComponents: {
        "chart-tickets-by-type": componentChartTicketsByType,
        "chart-tickets-by-category": componentChartTicketsByCategory,
        "list-my-tickets": componentListMyTickets,
        "list-new-tickets": componentListNewTickets,
        "list-unassigned-tickets": componentListUnassignedTickets
    }
}

// ·
app('CloudHelp', [
    {
        path: '/',
        component: appShowDashboard,
        props: propsDashboard
    },
    {
        path: '/dashboards',
        component: dashboardIndex,
        props: {
            cloudModule: "help"
        }
    },
    {
        path: '/dashboards/new',
        component: dashboardNew,
        props: {
            cloudModule: "help"
        }
    },
    {
        path: '/dashboards/:id/:edit',
        component: dashboardEdit,
        props: propsDashboard
    },
    {
        path: '/catalog/ticket_priorities',
        component: prioritiesIndex
    },
    {
        path: '/catalog/ticket_priorities/:id',
        component: prioritiesShow
    },
    {
        path: '/catalog/ticket_priorities/new',
        component: prioritiesNew
    },
    {
        path: '/catalog/ticket_types',
        component: typesIndex
    },
    {
        path: '/catalog/ticket_types/:id',
        component: typesShow
    },
    {
        path: '/catalog/ticket_types/new',
        component: typesNew
    },
    {
        path: '/catalog/ticket_workspaces',
        component: workspacesIndex
    },
    {
        path: '/catalog/ticket_workspaces/:id',
        component: workspacesShow
    },
    {
        path: '/catalog/ticket_workspaces/new',
        component: workspacesNew
    },
    {
        path: '/tickets',
        component: ticketsIndex
    },
    {
        path: '/tickets/new',
        component: ticketsNew
    },
    {
        path: '/tickets/:id',
        component: ticketsShow
    },
    {
        path: '/slas',
        component: slasIndex
    },
    {
        path: '/slas/new',
        component: slaNew
    },
    {
        path: '/slas/:id/',
        component: slaShow
    },
    {
        path: '/reports',
        component: reportsIndex
    },
    {
        path: '/settings',
        component: settingsIndex
    },
    {
        path: '/workflows',
        component: workflowsIndex,
        props: {
            cloudModule: 'help',
            cloudObject: 'workflows',
            appMountPath: 'help/workflows'
        }
    },
    {
        path: '/workflows/new',
        component: workflowsNew,
        props: {
            cloudModule: 'help',
            cloudObject: 'workflows',
            appMountPath: 'help/workflows'
        }
    },
    {
        path: '/workflows/:id',
        component: workflowsShow,
        props: {
            cloudModule: 'help',
            cloudObject: 'workflows',
            appMountPath: 'help/workflows'
        }
    },

])