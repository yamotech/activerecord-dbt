# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActiveRecord::Dbt::Configuration::DataSync do
  subject(:dummy_instance) { dummy_class.new }

  let(:dummy_class) do
    Class.new do
      include ActiveRecord::Dbt::Configuration::DataSync
    end
  end

  describe '#data_sync_delayed?' do
    context 'when @data_sync_delayed is not set' do
      it 'returns false' do
        expect(dummy_instance.data_sync_delayed?).to be false
      end
    end

    context 'when @data_sync_delayed is set to true' do
      before { dummy_instance.data_sync_delayed = true }

      it 'returns true' do
        expect(dummy_instance.data_sync_delayed?).to be true
      end
    end

    context 'when @data_sync_delayed is set to false' do
      before { dummy_instance.data_sync_delayed = false }

      it 'returns false' do
        expect(dummy_instance.data_sync_delayed?).to be false
      end
    end
  end
end
