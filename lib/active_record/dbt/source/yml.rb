module ActiveRecord
  module Dbt
    module Source
      class Yml
        def config
          {
            source: {
              name: 'test name',
              description: 'test description'
            }
          }
        end
      end
    end
  end
end
