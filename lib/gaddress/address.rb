# frozen_string_literal: true

module Gaddress
  # Googleから返ってきたAdresss Componentをまとめて処理する集約
  class Address
    DEFAULT_DELIMITER = ' '
    private_constant :DEFAULT_DELIMITER

    attr_reader :components

    # @param [Array<Gaddress::AddressComponent>] raw_components
    def initialize(raw_components)
      @raw_components = raw_components
      set_components
    end

    # 住所をフォーマットする
    # @param [Integer] min_level 範囲をしぼる最も曖昧なAddressType
    # @param [Integer] max_level 範囲をしぼる最も詳細なAddressType
    # @param [String] delimiter 住所コンポーネントを結合する時に使う文字列
    # @return [String]
    def format_address(min_type: AddressType.least_type,
                       max_type: AddressType.finest_type,
                       delimiter: DEFAULT_DELIMITER)
      # 指定された詳細度の範囲に入っているコンポーネントを抽出
      limited_components = components.select do |c|
        t = c.main_type
        min_type <= t && t <= max_type
      end

      # コンポーネントを結合していくが、数字と数字の間はハイフンで結合する
      strs = limited_components.map(&:long_name)
      seps = []
      strs.each_cons(2) do |a, b|
        seps << if a.num_str? && b.num_str?
                  "-"
                else
                  delimiter.to_s
                end
      end

      strs.zip(seps).flatten.join
    end

    private

    attr_reader :raw_components

    # サポートしていない形式のAddress Componenが返ってくる事があるので除去
    # @return [Array<Gaddress::AddressComponent>]
    def supported_components
      raw_components.reject { |c| c.main_type.nil? }
    end

    # 市区町村レベルのコンポーネント
    # @return [Gaddress::AddressComponent, nil]
    def locality_component
      supported_components.find { |c| c.main_type == AddressType::LOC }
    end

    # 市区町村より一つだけ下のレベルのコンポーネント
    # @return [Gaddress::AddressComponent, nil]
    def sublocality_level_1_component
      supported_components.find { |c| c.main_type == AddressType::SUB_L1 }
    end

    # Google APIから返ってくる事があるイレギュラーなcomponentを修正する
    # サポートしていない形式のAddress Componenが返ってくる事があるので除去
    # 市区町村と、その一つ下の階層に重複したデータがかえってくる事があるので削除
    # @param [Array<Gaddress::AddressComponent>] raw_components
    def set_components
      components = supported_components
      if locality_component&.long_name == sublocality_level_1_component&.long_name
        components.delete(sublocality_level_1_component)
      end

      @components = components.sort_by(&:main_type)
    end
  end
end

class String
  # 数字を表現している文字列かどうか
  def num_str?
    Float(tr('０-９', '0-9'))
    true
  rescue ArgumentError
    false
  end
end
