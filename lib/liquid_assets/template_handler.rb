require 'liquid'

module LiquidAssets


    class TemplateHandler

        def self.call(template)
            return "LiquidAssets::TemplateHandler.new(self).render(#{template.source.inspect}, local_assigns)"
        end

        def initialize(view)
            @view = view
        end

        def render(template, local_assigns = {})
            @view.controller.headers["Content-Type"] ||= 'text/html; charset=utf-8'

            assigns = @view.assigns.dup
            assigns.merge!( local_assigns.stringify_keys )

            if content = @view.content_for?(:layout)
                assigns["content_for_layout"] = content
            end
            LiquidAssets.parse(template).render( assigns, :registers=>{
                                                     :action_view => @view,
                                                     :controller => @view.controller
                                                 } ).html_safe
        end

        def compilable?
            false
        end


    end

end
