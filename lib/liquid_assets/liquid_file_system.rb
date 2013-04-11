module LiquidAssets

    class LiquidFileSystem < Liquid::LocalFileSystem

        def initialize
            super( Config.template_root_path )
        end


        def read_template_file( template_path, context )
            source = Config.content_provider.call( Resolver.convert_path_to_partial( template_path.dup ) )
            if false == source
                return super
            else
                return source
            end
        end

    end

end
