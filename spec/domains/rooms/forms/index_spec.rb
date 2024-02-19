# frozen_string_literal: true

require 'rails_helper'

describe Rooms::Forms::Index do
  subject(:form) { described_class.new }

  context 'when params are empty' do
    it { expect(form.call({})).to be_success }
  end

  context 'when params are valid' do
    it { expect(form.call(type: 'private')).to be_success }
  end

  context 'when params are invalid' do
    it { expect(form.call(type: 'trololo')).to be_failure }
  end
end
