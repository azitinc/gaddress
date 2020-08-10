# frozen_string_literal: true
RSpec.describe Gaddress::Address do
  describe '#component' do
    describe 'main_typeがつかないコンポーネントは削除される' do
      it 'typesが空のコンポーネントは削除される' do
        address = Gaddress::Address.new(
          [
            Gaddress::AddressComponent.new(
              long_name: "",
              short_name: "",
              types: []
            ),
          ]
        )

        expect(address.components.size).to eq 0
      end

      it 'typesがunsupportedなコンポーネントは削除される' do
        address = Gaddress::Address.new(
          [
            Gaddress::AddressComponent.new(
              long_name: "",
              short_name: "",
              types: ["unsupported"]
            ),
          ]
        )

        expect(address.components.size).to eq 0
      end

      it 'typesがpostal_codeなコンポーネントは残る' do
        address = Gaddress::Address.new(
          [
            Gaddress::AddressComponent.new(
              long_name: "",
              short_name: "",
              types: ["postal_code"]
            ),
          ]
        )

        expect(address.components.size).to eq 1
      end

      it 'typesがpostal_codeとunsupportedなコンポーネントは残る' do
        address = Gaddress::Address.new(
          [
            Gaddress::AddressComponent.new(
              long_name: "",
              short_name: "",
              types: %w[postal_code unsupported]
            ),
          ]
        )

        expect(address.components.size).to eq 1
      end
    end
  end

  describe '#format_address' do
    let!(:address) do
      Gaddress::Address.new(
        [
          Gaddress::AddressComponent.new(
            long_name: "日本",
            short_name: "日本",
            types: %w[country]
          ),
          Gaddress::AddressComponent.new(
            long_name: "渋谷区",
            short_name: "渋谷",
            types: %w[locality]
          ),
          Gaddress::AddressComponent.new(
            long_name: "1丁目",
            short_name: "1丁目",
            types: %w[sublocality_level_1]
          ),
          Gaddress::AddressComponent.new(
            long_name: "2",
            short_name: "2",
            types: %w[sublocality_level_2]
          ),
        ]
      )
    end

    it '範囲を指定しなければ全てのコンポーネントが含まれる' do
      expect(address.format_address).to eq "日本 渋谷区 1丁目 2"
    end

    describe 'min_levelで曖昧度の下限を指定できる' do
      it 'min_typeにLOCを指定するとLocality以上のコンポーネントだけがのこる' do
        expect(address.format_address(min_type: Gaddress::AddressType::LOC)).to eq "渋谷区 1丁目 2"
      end

      it 'min_typeにSUB_L3を指定すると空文字列になる' do
        expect(address.format_address(min_type: Gaddress::AddressType::SUB_L3)).to eq ""
      end
    end

    describe 'max_levelで曖昧度の上限を指定できる' do
      it 'max_typeにLOCを指定するとLocality以下のコンポーネントだけがのこる' do
        expect(address.format_address(max_type: Gaddress::AddressType::LOC)).to eq "日本 渋谷区"
      end

      it 'max_typeにPOSTAL_CODEを指定すると空文字列になる' do
        expect(address.format_address(max_type: Gaddress::AddressType::POSTAL_CODE)).to eq ""
      end
    end

    describe 'delimiterでコンポーネントを結合する文字列を指定できる' do
      it '@を指定すると@で結合される' do
        expect(address.format_address(delimiter: '@')).to eq "日本@渋谷区@1丁目@2"
      end

      it '指定をしないと半角スペースで結合される' do
        expect(address.format_address).to eq "日本 渋谷区 1丁目 2"
      end

      describe '数字のコンポーネントの間は強制的に-で結合される' do
        it 'delimiterを指定していない時に数字のコンポーネントの間は-で結合される' do
          addr = Gaddress::Address.new(
            [
              Gaddress::AddressComponent.new(
                long_name: "日本",
                short_name: "日本",
                types: %w[country]
              ),
              Gaddress::AddressComponent.new(
                long_name: "1",
                short_name: "1",
                types: %w[sublocality_level_2]
              ),
              Gaddress::AddressComponent.new(
                long_name: "2",
                short_name: "2",
                types: %w[sublocality_level_3]
              ),
            ]
          )
          expect(addr.format_address).to eq "日本 1-2"
        end

        it 'delimiterを指定しても-で結合される' do
          addr = Gaddress::Address.new(
            [
              Gaddress::AddressComponent.new(
                long_name: "日本",
                short_name: "日本",
                types: %w[country]
              ),
              Gaddress::AddressComponent.new(
                long_name: "1",
                short_name: "1",
                types: %w[sublocality_level_2]
              ),
              Gaddress::AddressComponent.new(
                long_name: "2",
                short_name: "2",
                types: %w[sublocality_level_3]
              ),
            ]
          )
          expect(addr.format_address(delimiter: "@")).to eq "日本@1-2"
        end
      end
    end
  end
end
