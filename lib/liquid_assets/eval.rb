module LiquidAssets


    class LiquidWrapper < Struct.new(:template)

        def render( variables={}, config={} )
            assigns = Config.globals.dup
            assigns.merge!( variables )
            config[:filters] ||= ::LiquidAssets::Config.filters
            template.render(assigns, config )
        end
    end

    def self.parse( source )
        LiquidWrapper.new( ::Liquid::Template.parse( source ) )
    end

    def self.template( path )
        source = Config.content_provider.call( path )
        if false == source
            full_path = Config.template_root_path.join( "#{path}.liquid" )
            if full_path.exist?
                source = File.read( full_path )
            else
                raise Liquid::FileSystemError, "No such template '#{path}' #{full_path}"
            end
        end
        LiquidWrapper.new( ::Liquid::Template.parse( source ) )
    end

end
