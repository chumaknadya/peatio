# encoding: UTF-8
# frozen_string_literal: true

module API
  module V2
    module Admin
      class Orders < Grape::API
        helpers ::API::V2::Admin::NamedParams

        desc 'Get all orders, results is paginated.',
          is_array: true,
          success: API::V2::Admin::Entities::Order
        params do
          use :orders_param
        end
        get '/orders' do
          ransack_params = {
            price_eq: params[:price].present? ? params[:price] : nil,
            origin_volume_eq: params[:origin_volume].present? ? params[:origin_volume] : nil,
            ord_type_eq: params[:ord_type].present? ? params[:ord_type] : nil,
            state_eq: params[:state].present? ? params[:state] : nil,
            market_id_eq: params[:market].present? ? params[:market] : nil,
            type_eq: params[:type].present? ? params[:type] == 'buy' ? 'OrderBid' : 'OrderAsk' : nil,
            member_uid_eq: params[:uid].present? ? params[:uid] : nil,
            member_email_eq: params[:email].present? ? params[:email] : nil
          }

          collection = Order.ransack(ransack_params).result
          present paginate(collection), with: API::V2::Admin::Entities::Order
          #      .tap { |q| q.where!('created_at >= ?', Time.at(params[:time_from])) if params[:time_from] }
          #      .tap { |q| q.where!('created_at < ?', Time.at(params[:time_to])) if params[:time_to] }
          #  .tap { |q| present paginate(q), with: API::V2::Admin::Entities::Order }
        end
      end
    end
  end
end
