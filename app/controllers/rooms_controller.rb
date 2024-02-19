class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    form     = Rooms::Forms::Index.new.call(params.permit('type').to_h)
    scenario = Rooms::Scenarios::Index.new

    if form.success?
      render json: {data: scenario.call(user: current_user, type: form.to_h[:type]) }
    else
      render json: {errors: form.errors.to_h}, status: 400 
    end
  end

  def show
    @single_room = Room.find(params[:id])
    @room = Room.new
    @rooms = Room.public_rooms

    @message = Message.new
    @messages = @single_room.messages.order(created_at: :asc)

    @users = User.all_except(current_user)
    render 'index'
  end

  def create
    @room = Room.create(name: params['room']['name'])
  end
end
