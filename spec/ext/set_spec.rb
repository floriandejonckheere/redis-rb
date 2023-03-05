# frozen_string_literal: true

RSpec.describe Set do
  subject(:type) { described_class.new(value) }

  let(:value) { ["hello", "world"] }

  let(:pipes) { IO.pipe }

  let(:rsocket) { Rediss::Socket.new(pipes.first) }
  let(:wsocket) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(rsocket) }

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "~2\r\n$5\r\nhello\r\n$5\r\nworld\r\n"
    end
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "0) hello\n1) world"
    end

    context "when the array is empty" do
      it "pretty prints the type" do
        expect(described_class.new.to_pretty_s).to eq "(empty set)"
      end
    end

    context "when the indent is non-zero" do
      let(:value) { ["hello", "world"] }

      it "indents the values" do
        expect(type.to_pretty_s(indent: 2)).to eq "    0) hello\n    1) world"
      end
    end

    context "when the array contains a lot of elements" do
      let(:value) { ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"] }

      it "right justifies the values" do
        expect(type.to_pretty_s).to eq " 0) a\n 1) b\n 2) c\n 3) d\n 4) e\n 5) f\n 6) g\n 7) h\n 8) i\n 9) j\n10) k"
      end

      context "when the indent is non-zero" do
        it "right justifies the values" do
          expect(type.to_pretty_s(indent: 2)).to eq "     0) a\n     1) b\n     2) c\n     3) d\n     4) e\n     5) f\n     6) g\n     7) h\n     8) i\n     9) j\n    10) k"
        end
      end
    end

    context "when the array contains nested arrays" do
      let(:value) { ["hello", ["world"]] }

      it "pretty prints the type" do
        expect(type.to_pretty_s).to eq "0) hello\n1) 0) world"
      end

      context "when the indent is non-zero" do
        it "indents the values" do
          expect(type.to_pretty_s(indent: 2)).to eq "    0) hello\n    1) 0) world"
        end
      end

      context "when the nested array contains a lots of elements" do
        let(:value) { ["hello", ["world"] * 11] }

        it "pretty prints the type" do
          expect(type.to_pretty_s).to eq "0) hello\n1)  0) world\n    1) world\n    2) world\n    3) world\n    4) world\n    5) world\n    6) world\n    7) world\n    8) world\n    9) world\n   10) world"
        end

        context "when the indent is non-zero" do
          it "indents the values" do
            expect(type.to_pretty_s(indent: 2)).to eq "    0) hello\n    1)  0) world\n        1) world\n        2) world\n        3) world\n        4) world\n        5) world\n        6) world\n        7) world\n        8) world\n        9) world\n       10) world"
          end
        end
      end
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      wsocket.write("2\r\n$5\r\nhello\r\n$5\r\nworld\r\n")

      type = described_class.from_resp3("~", rsocket) { parser.read }

      expect(type).to eq described_class.new(["hello", "world"])
    end
  end
end
