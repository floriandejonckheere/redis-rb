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
      expect(type.to_pretty_s).to eq "1) \"hello\"\n2) \"world\""
    end

    context "when the set is empty" do
      it "pretty prints the type" do
        expect(described_class.new.to_pretty_s).to eq "(empty set)"
      end
    end

    context "when the indent is non-zero" do
      let(:value) { ["hello", "world"] }

      it "indents the values" do
        expect(type.to_pretty_s(indent: 2)).to eq "    1) \"hello\"\n    2) \"world\""
      end
    end

    context "when the set contains a lot of elements" do
      let(:value) { ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"] }

      it "right justifies the values" do
        expect(type.to_pretty_s).to eq " 1) \"a\"\n 2) \"b\"\n 3) \"c\"\n 4) \"d\"\n 5) \"e\"\n 6) \"f\"\n 7) \"g\"\n 8) \"h\"\n 9) \"i\"\n10) \"j\"\n11) \"k\""
      end

      context "when the indent is non-zero" do
        it "right justifies the values" do
          expect(type.to_pretty_s(indent: 2)).to eq "     1) \"a\"\n     2) \"b\"\n     3) \"c\"\n     4) \"d\"\n     5) \"e\"\n     6) \"f\"\n     7) \"g\"\n     8) \"h\"\n     9) \"i\"\n    10) \"j\"\n    11) \"k\""
        end
      end
    end

    context "when the array contains nested sets" do
      let(:value) { ["hello", described_class.new(["world"])] }

      it "pretty prints the type" do
        expect(type.to_pretty_s).to eq "1) \"hello\"\n2) 1) \"world\""
      end

      context "when the indent is non-zero" do
        it "indents the values" do
          expect(type.to_pretty_s(indent: 2)).to eq "    1) \"hello\"\n    2) 1) \"world\""
        end
      end

      context "when the nested set contains a lots of elements" do
        let(:value) { ["hello", described_class.new(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"])] }

        it "pretty prints the type" do
          expect(type.to_pretty_s).to eq "1) \"hello\"\n2)  1) \"a\"\n    2) \"b\"\n    3) \"c\"\n    4) \"d\"\n    5) \"e\"\n    6) \"f\"\n    7) \"g\"\n    8) \"h\"\n    9) \"i\"\n   10) \"j\"\n   11) \"k\""
        end

        context "when the indent is non-zero" do
          it "indents the values" do
            expect(type.to_pretty_s(indent: 2)).to eq "    1) \"hello\"\n    2)  1) \"a\"\n        2) \"b\"\n        3) \"c\"\n        4) \"d\"\n        5) \"e\"\n        6) \"f\"\n        7) \"g\"\n        8) \"h\"\n        9) \"i\"\n       10) \"j\"\n       11) \"k\""
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
