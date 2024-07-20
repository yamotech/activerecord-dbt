# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveRecord::Dbt::Column::Testable::NotNullTestable do
  let(:dummy_class) { Class.new { include ActiveRecord::Dbt::Column::Testable::NotNullTestable }.new }
  let(:column) { instance_double(ActiveRecord::ConnectionAdapters::SQLite3::Column) }

  before do
    allow(dummy_class).to receive(:column).and_return(column)
  end

  describe '#not_null_test' do
    before do
      allow(column).to receive(:null).and_return(column_null)
    end

    context 'when column is nullable' do
      let(:column_null) { true }

      it 'returns nil' do
        expect(dummy_class.not_null_test).to be_nil
      end
    end

    context 'when column is not nullable' do
      let(:column_null) { false }

      it 'returns "not_null"' do
        expect(dummy_class.not_null_test).to eq('not_null')
      end
    end
  end
end
