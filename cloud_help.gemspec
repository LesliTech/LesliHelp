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

$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "cloud_help/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|

    spec.name    = "cloud_help"
    spec.version = CloudHelp::VERSION
    spec.authors = ["The Lesli Development Team"]
    spec.summary = "Development resources"
    spec.license = "All rights reserved"

    spec.files = Dir["{app,config,db,lib}/**/*", "license", "Rakefile", "readme.md", "lesli.yml"]
    spec.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/leitfaden'

    spec.add_dependency "rails", "~> 6.1.0"
    
end
