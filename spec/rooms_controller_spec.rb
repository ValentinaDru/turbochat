# frozen_string_literal: true

require 'rails_helper'

describe RoomsController, type: :controller do
  subject(:request!) { get :index, params: params }
  let(:current_user) { User.create!(email: 'ekhlakhovvlad@gmail.com', password: 'oerigh') }

  before do
    sign_in current_user

    4.times { |x| Room.create!(name: "name_#{x}") }
    Message.create(user: current_user, room: Room.first, body: 'text')
  end

  context 'when type is omitted' do
  	let(:params) { {} }

    it { expect(request!.code).to eq('200') }
    
    it 'shows only private rooms' do
      
			rooms_ids_in_response = JSON.parse(request!.body).dig('data').map { |x| x['id'] }.sort
      rooms_ids_in_database = Message.where(user_id: current_user.id).pluck(:room_id).uniq.sort
      
      expect(rooms_ids_in_response).to eq rooms_ids_in_database
    end
  end
  
  context 'when type is all' do
    let(:params) { { type: 'all' } }

    it { expect(request!.code).to eq('200') }

    it 'shows all rooms' do
			rooms_amount_in_response = JSON.parse(request!.body).dig('data').count
      
      expect(rooms_amount_in_response).to eq 4
    end
  end
  
  context 'when type is private' do
    let(:params) { { type: 'private' } }
    
    it { expect(request!.code).to eq('200') }

    it 'show rooms where user left at least one message' do
      rooms_ids_in_response = JSON.parse(request!.body).dig('data').map { |x| x['id'] }.sort
      rooms_ids_in_database = Message.where(user_id: current_user.id).pluck(:room_id).uniq.sort
      
      expect(rooms_ids_in_response).to eq rooms_ids_in_database
  	end
  end
  
  context 'when type is wrong' do
    let(:params) { { type: 'trololoshka' } }
    
    it { expect(request!.code).to eq('400') }
  end
end
