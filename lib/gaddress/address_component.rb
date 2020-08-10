# frozen_string_literal: true
module Gaddress
  # GoogleのAPIからかえってくる、住所の丁目等の一部分を表現するクラス
  class AddressComponent
    # @param [String] long_name
    # @param [String] short_name
    # @param [Array<String>] types
    def initialize(long_name:, short_name:, types:)
      @types = types
      @raw_long_name = long_name
      @raw_short_name = short_name
    end

    # 最も詳細なレベルのAddress Typeを返す
    # @return [Integer]
    def main_type
      address_types = types.map { |t| AddressType.from_string(t) }.compact
      return nil if address_types.empty?

      address_types.max
    end

    # 整形されたlong_name
    # @return [String]
    def long_name
      format_name(raw_long_name)
    end

    # 整形されたshort_name
    # @return [String]
    def short_name
      format_name(raw_short_name)
    end

    private

    attr_reader :types, :raw_long_name, :raw_short_name

    def format_name(name)
      formated_name = name.tr("０-９", "0-9")
      formated_name = formated_name.gsub(/-/, '') if main_type == AddressType::POSTAL_CODE
      formated_name
    end
  end
end
