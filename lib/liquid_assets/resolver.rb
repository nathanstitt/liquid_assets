require 'singleton'
require 'action_view'
require 'action_view/template'

module LiquidAssets
    class Resolver < ActionView::Resolver

        include Singleton

        def to_s
            'LiquidAssets::Resolver'
        end

        def find_templates(name, prefix, partial, details)
            path = normalize_path( prefix, name )
            tmpl = Config.content_provider.call( partial_path( path, partial ) )
            if tmpl && tmpl.present?
                return [ make_template( tmpl, path, details, partial ) ]
            else
                return []
            end
        end

        private

        def normalize_path( prefix, name )
            if prefix.present? && name.present?
                prefix + '/' + name
            elsif prefix.present?
                prefix
            else
                name
            end
        end

        def make_template( tmpl, path, details, partial )
            handler = ::ActionView::Template.registered_template_handler('.liquid')
            details = {
                :virtual_path => partial_path(path, partial ),
                :locale       => details[:locale].first.to_s,
                :format       => details[:formats].first.to_s,
                :handler      => details[:handlers].map(&:to_s),
                :updated_at   => tmpl.mtime,
                :partial      => partial || false
            }
            handler = ActionView::Template.registered_template_handler(:liquid)
            return ActionView::Template.new( tmpl.source, "LiquidTemplate - #{path}", handler, details)
        end

        def partial_path( path, partial )
            return path if ! partial
            Resolver.convert_path_to_partial( path )
        end

        def Resolver.convert_path_to_partial( path )
            if index = path.rindex('/')     # had: gsub(/\/([^\/]+)$/,'/_\1')
                path.insert(index+1,'_')  # this is better
            else
                '_' + path
            end
        end
    end
end
