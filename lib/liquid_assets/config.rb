require 'yaml'

module LiquidAssets
  # Change config options in an initializer:
  #
  #   LiquidAssets::Config.namespace = 'LT'
  #
  # Or in a block:
  #
  #   LiquidAssets::Config.configure do |config|
  #      config.path_prefix        = 'app/assets/templates'
  #      config.filters            = MyFilterModule
  #      config.namespace = 'LQT'
  #   end
  #
  # Or change config options in a YAML file (config/liquid_assets.yml):
  #
  #   defaults: &defaults
  #     path_prefix: 'templates'
  #     namespace:   'LQT'
  #     globals:
  #          company: 'BigCorp Inc'
  #   development:
  #     <<: *defaults
  #   test:
  #     <<: *defaults
  #   production:
  #     <<: *defaults

  module Config
    extend self

      # The environment.  Defaults to Rails.env if Rails is detected, otherwise to 'development'
      attr_writer :env
      # Directory to read templates from.  Default = app/assets/templates
      attr_writer :path_prefix
      # The name of the global JS object that will contain the templates.  Defaults = LQT
      attr_writer :namespace
      # A Ruby module implementing the Liquid Filters that are accessible when templates are evaluated as views
      # Javascript filters can be set by modifying the LQT.Filters object.
      # A set of the standard Shopify filters are provided for both Ruby & Javascript.
      # https://github.com/Shopify/liquid/wiki/Liquid-for-Designers
      attr_writer :filters
      # May be set to a Proc/Lambda which will be passed the path to a
      # potential template
      #
      # The lambda should return the contents of a liquid template
      # or false to indicate it is not found
      attr_writer :content_provider
      #
      # A hash of 'global' variables that should always be available to
      # templates.  This will be merged into the template local variables
      # when the template is rendered and may overwrite them
      attr_writer :globals

    def configure
      yield self
    end

    def env
      @env ||= if defined? Rails
                 Rails.env
               elsif ENV['RACK_ENV']
                 ENV['RACK_ENV']
               else
                 'development'
               end
    end

    def load_yml!
        %{path_prefix namespace globals}.each do | name |
            self.instance_variable_set( "@#{name}", yml[name] ) if yaml.has_key?(name)
        end
    end

    def path_prefix
        @path_prefix ||= File.join('app','assets','templates')
    end

    def root_path
        if defined? Rails
            Rails.root
        else
            Pathname.new('.')
        end
    end

    def content_provider
        @content_provider ||= lambda{|path| false }
    end
    def globals
        ( @globals && @globals.is_a?(Proc) ) ? @globals.call : @globals ||= {}
    end
    def template_root_path
        root_path.join( 'app','assets','templates' )
    end

    def filters
        @filters ||= LiquidAssets::Filters
    end
    def namespace
      @namespace ||= 'LQT'
    end

    def yml
      begin
        @yml ||= (YAML.load(IO.read yml_path)[env] rescue nil) || {}
      rescue Psych::SyntaxError
        @yml = {}
      end
    end

    def yml_exists?
      File.exists? yml_path
    end

    private

    def symbolize(hash)
      hash.keys.each do |key|
        hash[(key.to_sym rescue key) || key] = hash.delete(key)
      end
    end

    def yml_path
        @yml_path ||= root_path.join 'config', 'liquid_assets.yml'
    end
  end
end
