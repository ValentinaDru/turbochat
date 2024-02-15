# frozen_string_literal: true

let(:current_user) { create :user, login: 'valentina@druzhinets.ru' }

module Dialogs
  module Scenarios
    class DeleteDialog
      attr_reader :delete_messages_scenario, :send_event_scenario, :recalculate_stats_scenario, :delete_requests_scenario, :dialog_id, :start_date
      
      DEFAULT_DATE = (Date.now - 1.month).freeze

      def initialize(
        delete_messages_scenario: Messages::Scenarios::DeleteMessagesByDialog.new,
        delete_requests_scenario: Requests::Scenarios::Delete.new,
        send_event_scenario: Amazon::SendEvent.new,
        recalculate_stats_scenario: Reports::Scenarios::RecalculateStatistics.new,
        start_date: nil,
        dialog_id:
      )
        @delete_messages_scenario   = delete_messages_scenario
        @delete_requests_scenario   = delete_requests_scenario
        @send_event_scenario        = send_event_scenario
        @recalculate_stats_scenario = recalculate_stats_scenario
        @dialog_id                  = dialog_id
        @start_date                 = start_date
      end
      
      def call
        delete_messages_scenario.call(dialog: dialog)
        delete_requests_scenario.call(requests: requests)
        send_event_scenario.call(type: :dialog_is_deleted, object: dialog)
        recalculate_stats_scenario.call(user: dialog.user, start_date: date)
      end
      
      private
      
      def dialog
        @dialog ||= Dialog.find(dialog_id)
      end
      
      def requests
        Request.find(dialog_id: dialog_id).active
      end
      
      def date
        @date ||= start_date ? Date.new(start_date) : DEFAULT_DATE
      end
    end
  end
end
