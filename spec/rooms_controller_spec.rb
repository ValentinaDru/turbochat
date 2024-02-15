# frozen_string_literal: true

require 'rails_helper'

describe RoomsController, type: :controller do
  subject(:request!) { get :index, params: {type: type} }
  let(:current_user) { User.create }

  before do
    sign_in current_user
    Room.create 
  end

  context 'when type is omitted' do
  	let(:type) { nil }

    it { expect(request!.code).to eq('200') }
    
    it 'shows only private rooms' do
      
			rooms_ids_in_response = JSON.parse(request!.body).dig('data').map { |x| x["id"] }.sort
      rooms_ids_in_database = Message.where(user_id: current_user.id).pluck(:room_id).uniq.sort
      
      expect(rooms_ids_in_response).to eq rooms_ids_in_database
    end
  end
  
  context 'when type is all' do
    let(:type) { 'all' }

    it { expect(request!.code).to eq('200') }

    it 'shows all rooms' do
			rooms_amount_in_response = JSON.parse(request!.body).dig('data').count
      
      expect(Room.count).to eq rooms_amount_in_response
    end
  end
  
  context 'when type is private' do
    let(:type) { 'private' }
    
    it { expect(request!.code).to eq('200') }

    it 'show rooms where user left at least one message' do
      rooms_ids_in_response = JSON.parse(request!.body).dig('data').map { |x| x.id }.sort
      rooms_ids_in_database = Message.where(user_id: current_user.id).pluck(:room_id).uniq.sort
      
      expect(rooms_ids_in_response).to eq rooms_ids_in_database
  	end
  end
  
  context 'when type is wrong' do
    let(:type) { 'trololoshka' }
    
    it { expect(request!.code).to eq('200') }

    it 'show all rooms' do
			rooms_amount_in_response = JSON.parse(request!.body).dig('data').count
      
      expect(Room.count).to eq rooms_amount_in_response
  	end
  end
end
