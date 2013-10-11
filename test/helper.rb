require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'liquid_assets'

module LiquidAssets::Config
    def reset!
        %w(env path_prefix namespace filters ).each do |option|
            send "#{option}=", nil
        end
    end
end

class DummyController
    attr_reader :headers
    def initialize
        @headers = {}
    end
end

class DummyView
    attr_reader :controller, :assigns
    def initialize
        @controller = DummyController.new
        @assigns = {}
    end
    def content_for?(block)
        nil
    end
    def compile( code )
        source = <<-end_src
          def template(local_assigns)
             #{code}
          end
        end_src
        self.instance_eval(source)
    end
end

class Hash
    def transform_keys
        result = {}
        each_key do |key|
            result[yield(key)] = self[key]
        end
        result
    end
    def stringify_keys
        transform_keys{ |key| key.to_s }
    end
end

class String
    def html_safe
        self
    end
end

module TestSupport
    # Try to act like sprockets.
    def make_scope(root, file)
        Class.new do
            define_method(:logical_path) { pathname.to_s.gsub(root + '/', '').gsub(/\..*/, '') }

            define_method(:pathname) { Pathname.new(root) + file }

            define_method(:root_path) { root }

            define_method(:s_path) { pathname.to_s }
        end.new
    end
end

class Test::Unit::TestCase
end
