# frozen_string_literal: true

module Rooms
  module Forms
    class Index < Dry::Validation::Contract
      params do
        optional(:type).value(:string)
      end

      rule(:type) do
        key.failure('invalid type') unless (value.nil? || ['all', 'private'].include?(value))
      end
    end
  end
end
