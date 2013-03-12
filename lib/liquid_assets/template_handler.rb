require 'liquid'

module LiquidAssets


    class TemplateHandler

        def self.call(template)
            # view_path = "#{template.virtual_path}_view"
            # abs_view_path = Rails.root.join('app/views', view_path)
            # Rails.logger.warn "looking for: #{abs_view_path}"
            return "LiquidAssets::TemplateHandler.new(self).render(#{template.source.inspect}, local_assigns)"
        end

        def initialize(view)
            @view = view
        end

        def render(template, local_assigns = {})
            @view.controller.headers["Content-Type"] ||= 'text/html; charset=utf-8'

            assigns = @view.assigns

            if content = @view.content_for?(:layout)
                assigns["content_for_layout"] = content
            end
            assigns.merge!(local_assigns.stringify_keys)

            controller = @view.controller
            filters = if controller.respond_to?(:liquid_filters, true)
                          controller.send(:liquid_filters)
                      else
                          Config.filters
                      end

            liquid = ::Liquid::Template.parse(template)
            liquid.render(assigns,
                          :filters => filters,
                          :registers => {
                              :action_view => @view,
                              :controller => @view.controller
                          } ).html_safe
        end

        def compilable?
            false
        end


    end

end
