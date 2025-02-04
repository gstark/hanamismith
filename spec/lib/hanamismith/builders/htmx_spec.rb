# frozen_string_literal: true

require "spec_helper"

RSpec.describe Hanamismith::Builders::HTMX do
  using Refinements::Structs

  subject(:builder) { described_class.new configuration.minimize }

  include_context "with application dependencies"

  it_behaves_like "a builder"

  describe "#call" do
    before { builder.call }

    it "add library" do
      expect(temp_dir.join("test/public/javascript/htmx.min.js").exist?).to be(true)
    end
  end
end
