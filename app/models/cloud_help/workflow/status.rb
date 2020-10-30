module CloudHelp
=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Model for workflow statuses. Each status is accessed only through its *workflow*, and
    represents one *workflow* *state*. It also contains information about transitions to
    other states
=end
    class Workflow::Status < CloudObject::Workflow::Status
        belongs_to :workflow, inverse_of: :statuses, class_name: "Workflow", foreign_key: "cloud_help_workflows_id"
        belongs_to :workflow_including_deleted, class_name: "Workflow", foreign_key: "cloud_help_workflows_id", with_deleted: true, optional: true
    end
end