require 'liquid_assets/version'
require 'liquid_assets/eval'
require 'liquid_assets/config'
require 'liquid_assets/template_handler'
require 'liquid_assets/liquid_file_system'
require 'liquid_assets/resolver'
require 'liquid_assets/filters'
require 'liquid_assets/pipeline_template_engine'
require 'liquid_assets/tiny_liquid'
require 'liquid_assets/template'

module LiquidAssets

    extend Config

    if defined? Rails
        require 'liquid_assets/engine'
    else
        require 'sprockets'
        Config.load_yml! if Config.yml_exists?
        Sprockets.register_engine ".liquid", Tilt
    end

end
