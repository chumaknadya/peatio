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
          member   = Member.find_by!(uid: params[:uid]) if params[:uid].present?
          member   = Member.find_by!(email: params[:email]) if params[:email].present?

          Order.all.order(updated_at: params[:order_by])
               .includes(:member)
               .tap { |q| q.where!(member: member) if member }
               .tap { |q| q.where!(market: params[:market]) if params[:market] }
               .tap { |q| q.where!(state: params[:state]) if params[:state] }
               .tap { |q| q.where!(ord_type: params[:ord_type]) if params[:ord_type] }
               .tap { |q| q.where!(price: params[:price]) if params[:price] }
               .tap { |q| q.where!(origin_volume: params[:origin_volume]) if params[:origin_volume] }
               .tap { |q| q.where!(type: (params[:type] == 'buy' ? 'OrderBid' : 'OrderAsk')) if params[:type] }
               .tap { |q| q.where!('created_at >= ?', Time.at(params[:time_from])) if params[:time_from] }
               .tap { |q| q.where!('created_at < ?', Time.at(params[:time_to])) if params[:time_to] }
               .tap { |q| present paginate(q), with: API::V2::Admin::Entities::Order }
        end
      end
    end
  end
end
