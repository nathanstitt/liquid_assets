# Based on https://github.com/josh/ruby-coffee-script
require 'execjs'
require 'pathname'

module LiquidAssets

  class TinyLiquid

      class << self
          def compile(source, options = {})
              js = context.eval("TinyLiquid.parse(#{source.inspect},{partials_namespace:'#{Config.template_namespace}'}).code")
#              js = context.eval("TinyLiquid.compile(#{source.inspect}, {original: true}).toString()")
              "function(locals,filters){
var $_tmpbuf, $_html = LQT._FNS.html, $_err = LQT._FNS.err, $_rethrow=LQT._FNS.rethrow, $_merge=LQT._FNS.merge, $_range=LQT._FNS.range, $_array=LQT._FNS.array;
#{js}
return $_buf;
}"
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
