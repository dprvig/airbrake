require 'airbrake/rails/event'

module Airbrake
  module Rails
    # @api private
    # @since v9.2.0
    class Excon
      def call(*args)
        routes = Airbrake::Rack::RequestStore[:routes]
        return if !routes || routes.none?

        event = Airbrake::Rails::Event.new(*args)

        routes.each do |_route_path, params|
          params[:groups][:http] ||= 0
          params[:groups][:http] += event.duration
        end
      end
    end
  end
end
