# frozen_string_literal: true 

require 'rails_helper'

describe RoomsController, type: :controller do 
  context 'when user is not authorized' do
    let(:request!) { get :index }

    it 'respond with 302 HTTP code' do 
      expect(request!.code).to eq('302')
    end
  end

  context 'when user is authorized' do
    before do
      @user = User.create(email: 'example@example.com', password: 'password')
      sign_in @user
    end

    it 'render to rooms list' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
