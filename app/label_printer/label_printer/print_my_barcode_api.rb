# frozen_string_literal: true

require 'json_api_client'

module LabelPrinter
  # for classes/objects created from PrintMyBarcode responses using json api client
  # initializer is in config/initializers/print_my_barcode_api.rb
  module PrintMyBarcodeApi
    class Base < JsonApiClient::Resource
    end

    # Print My Barcode LabelType
    class LabelType < Base
      has_many :label_templates
    end

    # Print My Barcode LabelTemplate
    class LabelTemplate < Base
      has_many :labels
    end

    # Print My Barcode Label
    class Label < Base
      has_many :bitmaps
      has_many :barcodes
    end

    class Bitmap < Base
    end

    class Barcode < Base
    end

    class PrintJob < Base
    end

    # Print My Barcode Printer
    class Printer < Base
      def self.names
        all.map(&:name)
      rescue JsonApiClient::Errors::ConnectionError
        []
      end
    end
  end
end
