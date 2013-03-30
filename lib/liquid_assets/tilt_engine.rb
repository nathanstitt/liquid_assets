require 'tilt'

module LiquidAssets

    class TiltEngine < Tilt::Template

        self.default_mime_type = 'application/javascript'

        # def initialize_engine
        # end

        def evaluate(scope, locals, &block)

            template_path = TemplatePath.new scope

            "#{LiquidAssets::Config.namespace}.Templates[#{template_path.name}] = #{ TinyLiquid.compile(data) };"
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
                @name ||= relative_path.dump
            end

            private

            attr_accessor :template_path

            def relative_path
                @relative_path ||= template_path.gsub(/^#{LiquidAssets::Config.path_prefix}\/(.*)$/i, "\\1")
            end
        end
    end

end
