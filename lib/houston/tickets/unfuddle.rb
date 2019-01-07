require "houston/tickets"
require "houston/credentials"
require "houston/tickets/unfuddle/engine"
require "unfuddle"

module Houston
  module Tickets
    module Unfuddle
      extend self

      def dependencies
        [ :tickets, :credentials ]
      end

      # def config(&block)
      #   @configuration ||= Tickets::Configuration.new
      #   @configuration.instance_eval(&block) if block_given?
      #   @configuration
      # end

    end



    Houston.accept_credentials_for "Unfuddle" do |login, password, errors|
      begin
        Unfuddle.with_config(username: login, password: password) { Unfuddle.instance.get("people/current") }
      rescue Unfuddle::UnauthorizedError
        errors.add(:base, "Invalid credentials")
      end
    end

  end
end
