# frozen_string_literal: true

module Rooms
  module Scenarios 
    class Index
      def call(user:, type: nil)
        return Room.all if type == 'all'
                       
        Room.left_joins(:messages).where(messages: { user_id: user.id })
      end
    end
  end
end
