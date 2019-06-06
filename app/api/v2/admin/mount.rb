# frozen_string_literal: true

module API
  module V2
    module Admin
      class Mount < Grape::API

        before { authenticate! }
        before { trading_must_be_permitted! }

        mount Admin::Orders
        mount Admin::Withdraws

      end
    end
  end
end
