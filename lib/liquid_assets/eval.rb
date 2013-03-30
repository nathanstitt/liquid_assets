
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


end
