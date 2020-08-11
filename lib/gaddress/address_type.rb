# frozen_string_literal: true
module Gaddress
  # Google APIからかえってくる type
  class AddressType
    include Comparable

    # @api private
    def initialize(level)
      @level = level
    end

    private_class_method :new

    # @!macro [attach] address_type
    #   @!parse $1 = Gaddress::AddressType
    def self.define_address_type(name, level)
      const_set(name.upcase, new(level))
    end
    private_class_method :define_address_type

    define_address_type "POSTAL_CODE", 0
    define_address_type "COUNTRY", 1
    define_address_type "ADMINI_L1", 2
    define_address_type "ADMINI_L2", 3
    define_address_type "ADMINI_L3", 4
    define_address_type "ADMINI_L4", 5
    define_address_type "ADMINI_L5", 6
    define_address_type "LOC", 7
    define_address_type "WARD", 8
    define_address_type "SUB_L1", 9
    define_address_type "SUB_L2", 10
    define_address_type "SUB_L3", 11
    define_address_type "SUB_L4", 12
    define_address_type "SUB_L5", 13
    define_address_type "PREMISE", 14
    define_address_type "SUBPREMISE", 15
    define_address_type "BUILDING", 16

    class << self
      # 最も詳細なタイプ
      # @return [Integer]
      def finest_type
        BUILDING
      end

      # 最も曖昧なタイプ
      # @return [Integer]
      def least_type
        POSTAL_CODE
      end

      # Google APIからかえってくる文字列からの変換
      # @param [String] str GoogleのAPIからかえってきた文字列
      # @return [Integer]
      def from_string(str)
        mapping = {
          postal_code: POSTAL_CODE,
          country: COUNTRY,
          administrative_area_level_1: ADMINI_L1,
          administrative_area_level_2: ADMINI_L2,
          administrative_area_level_3: ADMINI_L3,
          administrative_area_level_4: ADMINI_L4,
          administrative_area_level_5: ADMINI_L5,
          locality: LOC,
          ward: WARD,
          sublocality_level_1: SUB_L1,
          sublocality_level_2: SUB_L2,
          sublocality_level_3: SUB_L3,
          sublocality_level_4: SUB_L4,
          sublocality_level_5: SUB_L5,
          premise: PREMISE,
          subpremise: SUBPREMISE,
          building: BUILDING,
        }
        mapping[str.to_sym]
      end
    end

    def <=>(other)
      level - other.level
    end

    protected

    attr_reader :level
  end
end
