# encoding: UTF-8
# frozen_string_literal: true

module API
  module V2
    module Admin
      class Withdraws < Grape::API
        helpers ::API::V2::Admin::NamedParams

        desc 'Get all withdraws, results is paginated.',
          is_array: true,
          success: API::V2::Admin::Entities::Withdraw
        params do
          use :withdraws_param
        end
        get '/withdraws' do
          currency = Currency.find(params[:currency]) if params[:currency].present?
          member   = Member.find_by!(uid: params[:uid]) if params[:uid].present?
          member   = Member.find_by!(email: params[:email]) if params[:email].present?

          Withdraw.all.order(updated_at: params[:order_by])
               .includes(:member, :currency)
               .tap { |q| q.where!(currency: currency) if currency }
               .tap { |q| q.where!(member: member) if member }
               .tap { |q| q.where!(aasm_state: params[:state]) if params[:state] }
               .tap { |q| q.where!('created_at >= ?', Time.at(params[:time_from])) if params[:time_from] }
               .tap { |q| q.where!('created_at < ?', Time.at(params[:time_to])) if params[:time_to] }
               .tap { |q| present paginate(q), with: API::V2::Admin::Entities::Withdraw }
        end

        desc 'Returns withdraw by ID.' do
          @settings[:scope] = :read_withdraws
          success API::V2::Admin::Entities::Withdraw
        end
        params do
          requires :tid, type: String, desc: 'The shared transaction ID.'
        end
        post '/withdraws/get' do
          present Withdraw.find_by!(params.slice(:tid)), with: API::V2::Admin::Entities::Withdraw
        end


        desc 'Performs action on withdraw.' do
          @settings[:scope] = :write_withdraws
          detail '«process» – system will lock the money, check for suspected activity, validate recipient address, and initiate the processing of the withdraw. ' \
                '«cancel»  – system will mark withdraw as «canceled», and unlock the money.'
          success API::V2::Admin::Entities::Withdraw
        end
        params do
          requires :tid,    type: String, desc: 'The shared transaction ID.'
          requires :action, type: String, values: %w[process cancel], desc: 'The action to perform.'
        end
        put '/withdraws/action' do
          record = Withdraw.find_by!(params.slice(:tid))
          perform_action(record, params[:action])
          present record, with: API::V2::Admin::Entities::Withdraw
        end
      end
    end
  end
end
