module LiquidAssets

    class LiquidFileSystem < Liquid::LocalFileSystem

        def initialize
            super( Config.template_root_path )
        end


        def read_template_file( template_path, context )
            tmpl = Config.content_provider.call( Resolver.convert_path_to_partial( template_path.dup ) )
            if tmpl && tmpl.present?
                return tmpl.source
            else
                return super
            end
        end

    end

end
