require 'helper'

class TestLiquidAssets < Test::Unit::TestCase

    include TestSupport

    def teardown
        LiquidAssets::Config.reset!
    end

    def test_mime_type
        assert_equal 'application/javascript', LiquidAssets::TiltEngine.default_mime_type
    end

    def test_tilt_engine_rendering
        scope = make_scope '/myapp/app/assets/javascripts', 'path/to/template.mustache'

        template = LiquidAssets::TiltEngine.new(scope.s_path) { "This is {{me}}" }

        assert_equal <<-END_EXPECTED, template.render(scope, {})
                this.LQT || (this.LQT = {});
                this.LQT[\"path/to/template\"] = function(locals,filters){\nvar $_tmpbuf, $_html = LQT._FNS.html, $_err = LQT._FNS.err, $_rethrow=LQT._FNS.rethrow, $_merge=LQT._FNS.merge, $_range=LQT._FNS.range, $_array=LQT._FNS.array;\n/* == Template Begin == */\nvar $_buf = '';\nvar $_line_num = 0;\n/* == define cycles == */\nvar $_cycle_next = function (n) {\nn.i++;\nif (n.i >= n.length) n.i = 0;\n}\n$_buf+=('This is ');\n$_line_num = 1;\n$_tmpbuf = locals.me;\n$_buf+=($_tmpbuf===null||typeof($_tmpbuf)===\"undefined\"?\"\":$_tmpbuf);\nreturn $_buf;\n};
      END_EXPECTED
    end

    def test_template_rendering
        locals = {foo:'bar'}
        source = 'foo={{foo}}'
        template = LiquidAssets::TemplateHandler.new(DummyView.new).render(source, locals)
        assert_equal 'foo=bar', template
    end

end
