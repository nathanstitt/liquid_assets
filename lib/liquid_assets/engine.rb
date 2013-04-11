require 'liquid_assets/pipeline_template_engine'

module LiquidAssets

    class Engine < ::Rails::Engine

        initializer "sprockets.liquid_assets", :after => "sprockets.environment", :group => :all do |app|
            next unless app.assets

            LiquidAssets::Config.load_yml! if LiquidAssets::Config.yml_exists?

            ActionView::Template.register_template_handler(:liquid, LiquidAssets::TemplateHandler )

            app.assets.register_engine(".liquid", ::LiquidAssets::PipelineTemplateEngine )

            app.config.to_prepare do
                Liquid::Template.file_system = LiquidFileSystem.new
                ApplicationController.send( :append_view_path, LiquidAssets::Config.path_prefix )
                ApplicationController.send( :prepend_view_path, LiquidAssets::Resolver.instance )
            end
        end

    end

end
