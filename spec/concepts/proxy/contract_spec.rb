require 'rails_helper'

RSpec.describe Proxy::Contract, type: :model do
  describe 'Validations' do
    subject { described_class.new(build(:proxy)) }
    it { is_expected.to validate_presence_of(:ip) }
    it { is_expected.to validate_presence_of(:port) }
  end
end
