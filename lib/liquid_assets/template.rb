module LiquidAssets

    class Template

        attr_reader :mtime, :source

        def initialize( source, mtime=Time.now )
            @source = source
            @mtime  = mtime
        end

        def present?
            ! @source.nil? && ! @source.empty?
        end

    end

end
