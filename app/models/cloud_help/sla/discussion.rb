module CloudHelp
=begin

Copyright (c) 2020, all rights reserved.

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
    class Sla::Discussion < CloudObject::Discussion
        
        belongs_to :cloud_object, class_name: "CloudHelp::Sla", foreign_key: "cloud_help_slas_id"
        belongs_to :parent, class_name: "Discussion", optional: true
        has_many :children, class_name: "Discussion", foreign_key: "parent_id"
        
    end
end
