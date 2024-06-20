# frozen_string_literal: true

module ActiveRecord
  module Dbt
    module Source
      class Yml
        attr_reader :tables

        delegate :descriptions, to: :@config

        def initialize(tables)
          @tables = tables
          @config = ActiveRecord::Dbt::Config.instance
        end

        def config
          {
            "version" => 2,
            "sources" => [
              "name" => descriptions.dig(:sources, :name),
              "description" => descriptions.dig(:sources, :description),
              "tables" => tables.map(&:config)
            ]
          }
        end
      end
    end
  end
end
