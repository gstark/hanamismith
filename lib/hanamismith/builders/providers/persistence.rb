# frozen_string_literal: true

require "refinements/structs"

module Hanamismith
  module Builders
    module Providers
      # Builds project skeleton for persistence provider.
      class Persistence
        using Refinements::Structs

        def self.call(...) = new(...).call

        def initialize configuration, builder: Rubysmith::Builder
          @configuration = configuration
          @builder = builder
        end

        def call
          path = "%project_name%/config/providers/persistence.rb.erb"
          builder.call(configuration.merge(template_path: path)).render
          configuration
        end

        private

        attr_reader :configuration, :builder
      end
    end
  end
end
