# encoding: UTF-8
# frozen_string_literal: true

module API
  module V2
    module Admin
      module NamedParams
        extend ::Grape::API::Helpers

        params :withdraws_param do
          optional :currency,
                   type: String,
                   values: -> { Currency.codes(bothcase: true) },
                   desc: 'The currency code.'
          optional :amount,
                   type: BigDecimal,
                   desc: 'The amount to withdraw.'
          optional :state,
                   type: String,
                   values: -> { Withdraw::STATES.map(&:to_s) },
                   desc: 'The state to filter by.'
          optional :email,
                    type: String,
                    desc: -> { V2::Entities::Member.documentation[:email] }
          optional :uid,
                   type: String,
                   desc: -> { V2::Entities::Member.documentation[:uid] }
          optional :limit,
                   type: { value: Integer, message: 'market.order.non_integer_limit' },
                   values: { value: 1..1000, message: 'market.order.invalid_limit' },
                   default: 100,
                   desc: 'Limit the number of returned orders. Default to 100.'
          optional :page,
                   type: { value: Integer, message: 'market.order.non_integer_page' },
                   allow_blank: false,
                   default: 1,
                   desc: 'Specify the page of paginated results.'
          optional :time_from,
                   type: { value: Integer, message: 'market.order.non_integer_time_from' },
                   allow_blank: { value: false, message: 'market.order.empty_time_from' },
                   desc: "An integer represents the seconds elapsed since Unix epoch."\
                         "If set, only orders executed after the time will be returned."
          optional :time_to,
                   type: { value: Integer, message: 'market.order.non_integer_time_to' },
                   allow_blank: { value: false, message: 'market.order.empty_time_to' },
                   desc: "An integer represents the seconds elapsed since Unix epoch."\
                         "If set, only orders executed before the time will be returned."
          optional :order_by,
                   type: String,
                   values: { value: %w(asc desc), message: 'market.order.invalid_order_by' },
                   default: 'desc',
                   desc: "If set, returned orders will be sorted in specific order, default to 'desc'."
        end

        params :orders_param do
          optional :market,
                   type: String,
                   values: { value: -> { ::Market.enabled.ids }, message: 'market.market.doesnt_exist' },
                   desc: -> { V2::Entities::Market.documentation[:id] }
          optional :state,
                   type: String,
                   values: { value: -> { Order.state.values }, message: 'market.order.invalid_state' },
                   desc: 'Filter order by state.'
          optional :ord_type,
                   type: String,
                   values: { value: Order::TYPES, message: 'market.order.invalid_ord_type' },
                   desc: 'Filter order by ord_type.'
          optional :price,
                   type: { value: BigDecimal, message: 'market.order.non_decimal_price' },
                   values: { value: -> (p){ p.try(:positive?) }, message: 'market.order.non_positive_price' },
                   desc: -> { V2::Admin::Entities::Order.documentation[:price] }
          optional :origin_volume,
                   type: { value: BigDecimal, message: 'market.order.non_decimal_price' },
                   values: { value: -> (p){ p.try(:positive?) }, message: 'market.order.non_positive_price' },
                   desc: -> { V2::Admin::Entities::Order.documentation[:origin_volume] }
          optional :type,
                   type: String,
                   values: { value: %w(buy sell), message: 'market.order.invalid_type' },
                   desc: 'Filter order by type.'
          optional :email,
                   type: String,
                   desc: -> { V2::Entities::Member.documentation[:email] }
          optional :uid,
                   type: String,
                   desc: -> { V2::Entities::Member.documentation[:uid] }
          optional :limit,
                   type: { value: Integer, message: 'market.order.non_integer_limit' },
                   values: { value: 1..1000, message: 'market.order.invalid_limit' },
                   default: 100,
                   desc: 'Limit the number of returned orders. Default to 100.'
          optional :page,
                   type: { value: Integer, message: 'market.order.non_integer_page' },
                   allow_blank: false,
                   default: 1,
                   desc: 'Specify the page of paginated results.'
          optional :time_from,
                   type: { value: Integer, message: 'market.order.non_integer_time_from' },
                   allow_blank: { value: false, message: 'market.order.empty_time_from' },
                   desc: "An integer represents the seconds elapsed since Unix epoch."\
                         "If set, only orders executed after the time will be returned."
          optional :time_to,
                   type: { value: Integer, message: 'market.order.non_integer_time_to' },
                   allow_blank: { value: false, message: 'market.order.empty_time_to' },
                   desc: "An integer represents the seconds elapsed since Unix epoch."\
                         "If set, only orders executed before the time will be returned."
          optional :order_by,
                   type: String,
                   values: { value: %w(asc desc), message: 'market.order.invalid_order_by' },
                   default: 'desc',
                   desc: "If set, returned orders will be sorted in specific order, default to 'desc'."
        end
      end
    end
  end
end
