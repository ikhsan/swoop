require 'spec_helper'

describe Swoop::Report do
  subject { described_class.new(entities) }

  context "Given JSON" do
    let(:entities) {[
      double(Swoop::Entity, { 'name' => 'Position', 'language' => 'swift', 'type' => 'struct' })
    ]}

    # it "" do
    # end
  end

end
