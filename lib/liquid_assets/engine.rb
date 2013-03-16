require 'liquid_assets/tilt_engine'

module LiquidAssets

    class Engine < ::Rails::Engine

        initializer "sprockets.liquid_assets", :after => "sprockets.environment", :group => :all do |app|
            next unless app.assets

            LiquidAssets::Config.load_yml! if LiquidAssets::Config.yml_exists?


            ActionView::Template.register_template_handler(:liquid, LiquidAssets::TemplateHandler )

            app.assets.register_engine(".liquid", ::LiquidAssets::TiltEngine )

            app.config.to_prepare do
                Liquid::Template.file_system = Liquid::LocalFileSystem.new( Config.template_root_path )
                ApplicationController.send( :append_view_path, LiquidAssets::Config.path_prefix )
            end
        end

    end

end
