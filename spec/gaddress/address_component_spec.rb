# frozen_string_literal: true
RSpec.describe Gaddress::AddressComponent do
  describe "new" do
    it "long_name, short_name, typesで初期化できる" do
      expect(Gaddress::AddressComponent.new(
               long_name: "long_name",
               short_name: "short_name",
               types: []
             )).not_to be nil
    end
  end

  describe "main_type" do
    describe "もっとも詳細なタイプがかえってくる" do
      it "postal_codeとcountryでは、countryの方がかえってくる" do
        _postal_code_type = Gaddress::AddressType.from_string("postal_code")
        country_type = Gaddress::AddressType.from_string("country")
        comp = Gaddress::AddressComponent.new(
          long_name: "long_name",
          short_name: "short_name",
          types: %w[postal_code country]
        )
        expect(comp.main_type).to eq country_type
      end

      it "postal_codeしか無い時はそのまま返ってくる" do
        postal_code_type = Gaddress::AddressType.from_string("postal_code")
        comp = Gaddress::AddressComponent.new(
          long_name: "long_name",
          short_name: "short_name",
          types: %w[postal_code]
        )
        expect(comp.main_type).to eq postal_code_type
      end

      it "typesが空の時はnilがかえってくる" do
        comp = Gaddress::AddressComponent.new(
          long_name: "long_name",
          short_name: "short_name",
          types: []
        )
        expect(comp.main_type).to be nil
      end
    end
  end

  describe "long_name" do
    describe "郵便番号のハイフンが削除される" do
      it 'main_typeがpostal_codeで、-が含まれた場合削除される' do
        comp = Gaddress::AddressComponent.new(
          long_name: "123-456",
          short_name: "short_name",
          types: ["postal_code"]
        )
        expect(comp.long_name).to eq "123456"
      end

      it 'main_typeがcountryの場合-は削除されない' do
        comp = Gaddress::AddressComponent.new(
          long_name: "J-apan",
          short_name: "short_name",
          types: ["country"]
        )
        expect(comp.long_name).to eq "J-apan"
      end
    end

    describe "全角の数字は半角に置換される" do
      it '０をわたすと0になる' do
        comp = Gaddress::AddressComponent.new(
          long_name: "０",
          short_name: "short_name",
          types: []
        )
        expect(comp.long_name).to eq "0"
      end

      it '９をわたすと9になる' do
        comp = Gaddress::AddressComponent.new(
          long_name: "９",
          short_name: "short_name",
          types: []
        )
        expect(comp.long_name).to eq "9"
      end

      it '123をわたすと123のまま' do
        comp = Gaddress::AddressComponent.new(
          long_name: "123",
          short_name: "short_name",
          types: []
        )
        expect(comp.long_name).to eq "123"
      end
    end
  end

  describe "short_name" do
    describe "郵便番号のハイフンが削除される" do
      it 'main_typeがpostal_codeで、-が含まれた場合削除される' do
        comp = Gaddress::AddressComponent.new(
          long_name: "long_name",
          short_name: "123-456",
          types: ["postal_code"]
        )
        expect(comp.short_name).to eq "123456"
      end

      it 'main_typeがcountryの場合-は削除されない' do
        comp = Gaddress::AddressComponent.new(
          long_name: "long_name",
          short_name: "J-P",
          types: ["country"]
        )
        expect(comp.short_name).to eq "J-P"
      end
    end

    describe "全角の数字は半角に置換される" do
      it '０をわたすと0になる' do
        comp = Gaddress::AddressComponent.new(
          long_name: "long_name",
          short_name: "０",
          types: []
        )
        expect(comp.short_name).to eq "0"
      end

      it '９をわたすと9になる' do
        comp = Gaddress::AddressComponent.new(
          long_name: "long_name",
          short_name: "９",
          types: []
        )
        expect(comp.short_name).to eq "9"
      end

      it '123をわたすと123のまま' do
        comp = Gaddress::AddressComponent.new(
          long_name: "long_name",
          short_name: "123",
          types: []
        )
        expect(comp.short_name).to eq "123"
      end
    end
  end
end
