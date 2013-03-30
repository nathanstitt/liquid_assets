require 'liquid_assets/version'
require 'liquid_assets/eval'
require 'liquid_assets/config'
require 'liquid_assets/template_handler'
require 'liquid_assets/tilt_engine'
require 'liquid_assets/resolver'

module LiquidAssets

    extend Config

    autoload :TinyLiquid, 'liquid_assets/tiny_liquid'
    autoload :TiltEngine, 'liquid_assets/tilt_engine'

    if defined? Rails
        require 'liquid_assets/engine'
    else
        require 'sprockets'
        Config.load_yml! if Config.yml_exists?

        Sprockets.register_engine ".liquid", Tilt

    end
end
