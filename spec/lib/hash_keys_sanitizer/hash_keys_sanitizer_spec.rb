require 'spec_helper'
require 'hash_keys_sanitizer'

describe HashKeysSanitizer do

  let(:whitelist) { [:name, address: [:street, :city, email: [:type]]] }
  let(:sanitizer) { described_class.new(whitelist: whitelist) }

  describe "#sanitize" do

    context "unknown names given" do
      let(:raw_hash) {
        { name: 'John', unknown: 'dummy', address: { street: "John Street", unknown: "BANG",
                                                     email: { type: 'job', unknown: 'BANG' } } }
      }

      it "filters out hash keys" do
        filtered_params = sanitizer.sanitize(raw_hash)
        expect(filtered_params).to eq(name: 'John', address: { street: "John Street", email: { type: 'job' } })
      end

      it "does not modify original hash" do
        filtered_params = sanitizer.sanitize(raw_hash)
        expect(raw_hash).to eq(name: 'John', unknown: 'dummy', address: { street: "John Street", unknown: "BANG",
                                                                            email: { type: 'job', unknown: 'BANG' } })
      end

      it "accepts stringified hash keys" do
        filtered_params = sanitizer.sanitize('name' => 'John', 'unknown' => 'dummy',
                                             'address' => { 'street' => "John Street", 'unknown' => "BANG",
                                                            'email' => { 'type' => 'job', 'unknown' => 'BANG' } })
        expect(filtered_params).to eq(name: 'John', address: { street: "John Street", email: { type: 'job' } })
      end

      it "accepts stringified whitelist" do
        sanitizer = described_class.new(whitelist: ['name', 'address' => ['street', 'city', 'email' => ['type']]])

        filtered_params = sanitizer.sanitize(raw_hash)
        expect(filtered_params).to eq(name: 'John', address: { street: "John Street", email: { type: 'job' } })
      end

      it "accepts stringified hash keys and whitelist" do
        sanitizer = described_class.new(whitelist: ['name', 'address' => ['street', 'city', 'email' => ['type']]])

        filtered_params = sanitizer.sanitize('name' => 'John', 'unknown' => 'dummy',
                                             'address' => { 'street' => "John Street", 'unknown' => "BANG",
                                                            'email' => { 'type' => 'job', 'unknown' => 'BANG' } })
        expect(filtered_params).to eq(name: 'John', address: { street: "John Street", email: { type: 'job' } })
      end
    end

    context "valid names given" do
      it "does not sanitize hash" do
        raw_hash = { name: 'John Doe', address: { street: 'John Street', city: 'London', email: { type: 'job' } } }

        expect(sanitizer.sanitize(raw_hash)).to eq(raw_hash)
      end
    end

  end

end