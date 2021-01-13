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
module CloudHelp
    class Engine < ::Rails::Engine
        isolate_namespace CloudHelp

        # register assets manifest
        config.assets.precompile += %w( cloud_help_manifest.js )

        # register engine migrations path
        initializer :append_migrations do |app|
            unless app.root.to_s.match root.to_s
                config.paths["db/migrate"].expanded.each do |expanded_path|
                    app.config.paths["db/migrate"] << expanded_path
                end
            end
        end

        # register templates path in the core. LESLI_ROOT is used to calculate the relative path to the core,
        # since Rails.root is not defined at this point. You can find it in EngineDirectory/bin/rails
        config.generators do |g|
            g.templates.unshift Pathname.new(LESLI_ROOT).join("lib", "templates") if defined? LESLI_ROOT
        end
    end
end
