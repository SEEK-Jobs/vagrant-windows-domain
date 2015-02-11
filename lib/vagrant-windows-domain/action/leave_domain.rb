require_relative '../provisioner'
require 'pp'

module VagrantPlugins
  module WindowsDomain
    class LeaveDomain
      include VagrantPlugins::WindowsDomain

      def initialize(app, env)
        @logger = Log4r::Logger.new("vagrant::provisioners::vagrant_windows_domain")
        @logger.debug("Initialising WindowsDomain plugin on destroy action")
        @app = app
        @machine = env[:machine]

        @machine.config.vm.provisioners.each do |prov|
          @config = prov.config if prov.config.is_a?(VagrantPlugins::WindowsDomain::Config)
        end

        @provisioner = VagrantPlugins::WindowsDomain::Provisioner.new(@machine, @config)
      end

      def call(env)
        if @config
          @logger.debug("Configuration detected, triggering leave domain action")
          @provisioner.destroy
          @app.call(env)
        else
          @logger.debug("No configuration detected, not leaving any domain")
          @app.call(env)
        end
      end

    end
  end
end