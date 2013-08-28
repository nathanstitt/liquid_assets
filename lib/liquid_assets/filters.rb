# -*- coding: utf-8 -*-
module LiquidAssets
module Filters

    extend Liquid::StandardFilters

    def titleize( input )
        input.to_s.gsub(/\b([\S])/){ |m| m.upcase }
    end

end
end
