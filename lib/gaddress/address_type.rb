# frozen_string_literal: true
module Gaddress
  # Google APIからかえってくる type の詳細度を表現する定数をまとめたモジュール
  # 数字が大きいほど詳細
  module AddressType
    POSTAL_CODE = 0
    COUNTRY = 1
    ADMINI_L1 = 2
    ADMINI_L2 = 3
    ADMINI_L3 = 4
    ADMINI_L4 = 5
    ADMINI_L5 = 6
    LOC = 7
    WARD = 8
    SUB_L1 = 9
    SUB_L2 = 10
    SUB_L3 = 11
    SUB_L4 = 12
    SUB_L5 = 13
    PREMISE = 14
    SUBPREMISE = 15
    BUILDING = 16

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
  end
end
