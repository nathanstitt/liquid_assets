module LiquidAssets
    class Resolver < ActionView::Resolver

        def to_s
            'LiquidAssets::Resolver'
        end

        def find_templates(name, prefix, partial, details)
            source = Config.content_provider.call( name )
            if false == source
                return []
            else
                return [ make_template( source, name, details, partial ) ]
            end
        end

        private

        def make_template( source, name, details, partial )
            handler = ActionView::Template.registered_template_handler('.liquid')
            details = {
                :path    => name,
                :locale  => details[:locale].first.to_s,
                :format  => details[:formats].first.to_s,
                :handler => details[:handlers].map(&:to_s),
                :partial => partial || false
            }
            handler = ActionView::Template.registered_template_handler(:liquid)
            return ActionView::Template.new(source, name, handler, details)
        end


    end
end
