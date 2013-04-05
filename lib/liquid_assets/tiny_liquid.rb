# Based on https://github.com/josh/ruby-coffee-script
require 'execjs'
require 'pathname'

module LiquidAssets

  class TinyLiquid

      class << self
          def compile(source, options = {})
              ns = ::LiquidAssets::Config.namespace
              js = context.eval("TinyLiquid.parse(#{source.inspect},{namespace:'#{Config.namespace}'}).code")
              <<-TEMPLATE
                 function(locals,filters){
                     var $_tmpbuf, $_html = #{ns}._FNS.html, $_err = #{ns}._FNS.err,
                         $_rethrow=#{ns}._FNS.rethrow, $_merge=#{ns}._FNS.merge,
                         $_range=#{ns}._FNS.range, $_array=#{ns}._FNS.array;
                         #{js}
                         return $_buf;
                }
              TEMPLATE
          end

          private

          def context
              @context ||= ExecJS.compile(source)
          end

          def source
              @source ||= path.read
          end

          def path
              @path ||= assets_path.join('tinyliquid.js')
          end

          def assets_path
              @assets_path ||= Pathname(__FILE__).dirname.join('..','..','vendor')
          end
      end

  end

end
