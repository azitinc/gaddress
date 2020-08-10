# frozen_string_literal: true
RSpec.describe Gaddress::AddressType do
  describe '#from_string' do
    it '"postal_code"に対しては、POSTAL_CODEの値がかえってくる' do
      expect(Gaddress::AddressType.from_string("postal_code")).to eq Gaddress::AddressType::POSTAL_CODE
    end

    it '"building"に対しては、BUILDINGの値がかえってくる' do
      expect(Gaddress::AddressType.from_string("building")).to eq Gaddress::AddressType::BUILDING
    end
  end

  describe "#finest_type" do
    it "BUILDINGがかえってくる" do
      expect(Gaddress::AddressType.finest_type).to eq Gaddress::AddressType::BUILDING
    end
  end

  describe "#least_type" do
    it "POSTAL_CODEがかえってくる" do
      expect(Gaddress::AddressType.least_type).to eq Gaddress::AddressType::POSTAL_CODE
    end
  end
end
