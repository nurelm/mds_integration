module MDS
  module Responses
    class ShippingSKUAck
      attr_accessor :body

      def initialize(body)
        @body = body.to_h
      end

      def success?
        true
      end

      def message
        "#{objects.size} shipments were received."
      end

      def objects
        orders = body['Order'].is_a?(Hash) ? [body['Order']] : body['Order']

        orders.to_a.sort_by { |o| o["TrackingNumber"] }.inject({}) do |h, order|
          h[order["OrderID"]] = {
            id: order["OrderID"],
            status: "shipped",
            tracking: order["TrackingNumber"],
            shipped_at: parse_date(order["OrderShipDate"])
          }

          h
        end.values
      end

      def parse_date(date)
        month, day, year = date.split("/")

        DateTime.new year.to_i, month.to_i, day.to_i
      end
    end
  end
end
