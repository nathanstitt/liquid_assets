require 'liquid_assets/version'
require 'liquid_assets/eval'
require 'liquid_assets/config'
require 'liquid_assets/template_handler'
require 'liquid_assets/liquid_file_system'
require 'liquid_assets/resolver'
require 'liquid_assets/filters'

module LiquidAssets

    extend Config

    autoload :TinyLiquid, 'liquid_assets/tiny_liquid'
    autoload :PipelineTemplateEngine, 'liquid_assets/pipeline_template_engine'

    if defined? Rails
        require 'liquid_assets/engine'
    else
        require 'sprockets'
        Config.load_yml! if Config.yml_exists?
        Sprockets.register_engine ".liquid", Tilt
    end

end
