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
            source = Config.content_provider.call( partial_path( path, partial ) )
            if false == source
                return []
            else
                return [ make_template( source, path, details, partial ) ]
            end
        end

        def clear_cache_for( expired_path )
            # FIXME - this doesn't work sometimes?
            # @cached.each do |context, prefix_hash |
            #     prefix_hash.each do | prefix, name_hash |
            #         name_hash.delete_if{ | name, partial_hash |
            #             normalize_path( prefix, name ) == expired_path
            #         }
            #     end
            # end
            clear_cache
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

        def make_template( source, path, details, partial )
            handler = ::ActionView::Template.registered_template_handler('.liquid')
            details = {
                :virtual_path => partial_path(path, partial ),
                :locale  => details[:locale].first.to_s,
                :format  => details[:formats].first.to_s,
                :handler => details[:handlers].map(&:to_s),
                :partial => partial || false
            }
            handler = ActionView::Template.registered_template_handler(:liquid)
            return ActionView::Template.new(source, "LiquidTemplate - #{path}", handler, details)
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
