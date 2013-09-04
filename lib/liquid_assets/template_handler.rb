require 'liquid'

module LiquidAssets


    class TemplateHandler

        def self.call(template)
            dump = Marshal.dump( LiquidAssets.parse( template ) )
            return "LiquidAssets::TemplateHandler.render(#{dump.inspect}, self, local_assigns)"
        end

        def self.render( src, view, local_assigns )
            view.controller.headers["Content-Type"] ||= 'text/html; charset=utf-8'

            assigns = view.assigns.dup
            assigns.merge!( local_assigns.stringify_keys )

            if content = view.content_for?(:layout)
                assigns["content_for_layout"] = content
            end

            Marshal.load( src ).render( assigns, :registers=>{
                    :action_view => view,
                    :controller  => view.controller
                } ).html_safe
        end

    end

end
