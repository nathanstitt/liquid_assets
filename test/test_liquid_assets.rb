require 'helper'

class TestLiquidAssets < Test::Unit::TestCase

    include TestSupport

    def teardown
        LiquidAssets::Config.reset!
    end

    def test_mime_type
        assert_equal 'application/javascript', LiquidAssets::PipelineTemplateEngine.default_mime_type
    end

    def test_tilt_engine_rendering
        scope = make_scope '/myapp/app/assets/javascripts', 'path/to/template.mustache'

        template = LiquidAssets::PipelineTemplateEngine.new(scope.s_path) { "This is {{me}}" }

tmpl="LQT.Templates[\"path/to/template\"] =                  function(locals,filters){\n                     var $_tmpbuf, $_html = LQT._FNS.html, $_err = LQT._FNS.err,\n                         $_rethrow=LQT._FNS.rethrow, $_merge=LQT._FNS.merge,\n                         $_range=LQT._FNS.range, $_array=LQT._FNS.array;\n                         /* == Template Begin == */\nvar $_buf = '';\nvar $_line_num = 0;\n/* == define cycles == */\nvar $_cycle_next = function (n) {\nn.i++;\nif (n.i >= n.length) n.i = 0;\n}\n$_buf+=('This is ');\n$_line_num = 1;\n$_tmpbuf = locals.me;\n$_buf+=($_tmpbuf===null||typeof($_tmpbuf)===\"undefined\"?\"\":$_tmpbuf);\n                         return $_buf;\n                }\n;"
        assert_equal tmpl, template.render(scope, {})

    end

    def test_template_rendering
        locals = {foo:'bar'}
        source = 'foo={{foo}}'
        template = LiquidAssets::TemplateHandler.new(DummyView.new).render(source, locals)
        assert_equal 'foo=bar', template
    end


    def test_resolver
        LiquidAssets::Config.content_provider = lambda do | path |
            'good' == path ? 'Hello {{bob|upcase}}' : false
        end

        details = {:formats=>[:liquid], :locale=>[:en], :handlers=>[] }
        resolver = LiquidAssets::Resolver.instance

        assert_empty     resolver.find_all('bad','',false, details )
        assert_not_empty resolver.find_all('good','',false, details )
    end

    def test_resolver_caches
        times_called = 0
        LiquidAssets::Config.content_provider = lambda do | path |
            times_called += 1
            'foo/bar/good' == path ? 'Hello {{bob|upcase}}' : false
        end

        details = {:formats=>[:liquid], :locale=>[:en], :handlers=>[] }
        resolver = LiquidAssets::Resolver.instance
        key = 'dumb-key'
        (0...3).each do
            resolver.find_all('foo/bar/good',nil ,false, details, key )
        end
        assert_equal 1, times_called

        times_called = 0

        resolver.clear_cache_for( 'bad' ) # shouldn't clear cache for 'good'

        resolver.find_all('foo/bar/good',nil,false, details, key )

        assert_equal 0, times_called

        resolver.clear_cache_for( 'foo/bar/good' )

        resolver.find_all('foo/bar/good',nil,false, details, key )

        assert_equal 1, times_called


    end
end
