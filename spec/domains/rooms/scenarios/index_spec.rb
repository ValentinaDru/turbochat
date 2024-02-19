# frozen_string_literal: true

require 'rails_helper'

describe Rooms::Scenarios::Index do
  let(:scenario) { described_class.new }
  let(:current_user) { User.create!(email: 'example@user.com', password: ';oerigh') }
  let!(:room_1) { Room.create!(name: 'room_1') }
  let!(:room_2) { Room.create!(name: 'room_2') }
  let!(:message) { Message.create!(user: current_user, room: room_1) }

  context 'when type is omitted' do
    it 'returns all rooms where user left message' do  
      expect(scenario.call(user: current_user).pluck(:id)).to eq(Message.select(:room_id).where(user_id: current_user.id).pluck(:room_id))
    end
  end

  context 'when type is all' do
    it 'returns all rooms' do     
      expect(scenario.call(user: current_user, type: 'all').pluck(:id)).to eq(Room.all.pluck(:id))
    end
  end

  context 'when type is private' do
    it 'returns only private records' do      
      expect(scenario.call(user: current_user, type: 'private').pluck(:id)).to eq(Message.select(:room_id).where(user_id: current_user.id).pluck(:room_id))
    end
  end
end

# select(:messages) {user_id: user_id}
# Message.select(:room_id).where(user_id: user_id)
