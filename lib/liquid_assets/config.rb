require 'yaml'

module LiquidAssets
  # Change config options in an initializer:
  #
  #   LiquidAssets::Config.template_namespace = 'LT'
  #
  # Or in a block:
  #
  #   LiquidAssets::Config.configure do |config|
  #      config.path_prefix        = 'app/assets/templates'
  #      config.filters            = MyFilterModule
  #      config.template_namespace = 'LQT'
  #   end
  #
  # Or change config options in a YAML file (config/liquid_assets.yml):
  #
  #   defaults: &defaults
  #     path_prefix: 'templates'
  #     template_namespace: 'LQT'
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
      attr_writer :template_namespace
      # A Ruby module implementing the Liquid Filters that are accessible when templates are evaluated as views
      # Javascript filters must be passed as the second parameter given when evaluating a precompiled template
      attr_writer :filters

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
      @path_prefix         = yml['path_prefix'] if yml.has_key? 'path_prefix'
      @template_namespace  = yml['template_namespace'] if yml.has_key? 'template_namespace'
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
    def filters
        @filters ||= Liquid::StandardFilters
    end
    def template_namespace
      @template_namespace ||= 'LQT'
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
