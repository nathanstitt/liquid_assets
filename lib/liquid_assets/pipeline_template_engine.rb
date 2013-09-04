require 'tilt'

module LiquidAssets

    class PipelineTemplateEngine < Tilt::Template

        self.default_mime_type = 'application/javascript'

        def evaluate(scope, locals, &block)
            template_path = TemplatePath.new( scope )
            tmpl = Config.content_provider.call( template_path.name )
            source = if tmpl && tmpl.present?
                         tmpl.source
                     else
                         data
                     end
            "#{LiquidAssets::Config.namespace}.Templates[#{template_path.name.dump}] = #{ TinyLiquid.compile( source ) };"
        end

        protected


        def prepare;
            # NOOP
        end

        class TemplatePath
            attr_accessor :full_path

            def initialize(scope)
                self.template_path = scope.logical_path
                self.full_path = scope.pathname
            end

            def name
                @name ||= relative_path
            end


            attr_accessor :template_path

            def relative_path
                @relative_path ||= template_path.sub(/^#{LiquidAssets::Config.path_prefix}\/(.*)$/i, '\1' )
            end
        end
    end

end
