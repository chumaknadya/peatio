# encoding: UTF-8
# frozen_string_literal: true

module API
  module V2
    module Admin
      class OrderBooks < Grape::API
        helpers ::API::V2::Admin::NamedParams

      end
    end
  end
end
