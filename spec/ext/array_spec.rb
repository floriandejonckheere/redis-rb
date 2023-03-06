# frozen_string_literal: true

RSpec.describe Array do
  subject(:type) { described_class.new(value) }

  let(:value) { ["hello", "world"] }

  let(:pipes) { IO.pipe }

  let(:read_connection) { Rediss::Connection.new(pipes.first) }
  let(:write_connection) { pipes.last }

  let(:parser) { Rediss::TypeParser.new(read_connection) }

  describe "#deep_flatten" do
    let(:value) { ["hello", { "world" => "!" }, "goodbye", ["cruel", { "world" => "!" }]] }

    it "deep flattens the array" do
      expect(type.deep_flatten).to eq ["hello", ["world", "!"], "goodbye", ["cruel", ["world", "!"]]]
    end
  end

  describe "#to_resp3" do
    it "serializes the type" do
      expect(type.to_resp3).to eq "*2\r\n$5\r\nhello\r\n$5\r\nworld\r\n"
    end
  end

  describe "#to_pretty_s" do
    it "pretty prints the type" do
      expect(type.to_pretty_s).to eq "1) \"hello\"\n2) \"world\""
    end

    context "when the array is empty" do
      it "pretty prints the type" do
        expect(described_class.new.to_pretty_s).to eq "(empty array)"
      end
    end

    context "when the indent is non-zero" do
      let(:value) { ["hello", "world"] }

      it "indents the values" do
        expect(type.to_pretty_s(indent: 2)).to eq "    1) \"hello\"\n    2) \"world\""
      end
    end

    context "when the array contains a lot of elements" do
      let(:value) { ["hello"] * 11 }

      it "right justifies the values" do
        expect(type.to_pretty_s).to eq " 1) \"hello\"\n 2) \"hello\"\n 3) \"hello\"\n 4) \"hello\"\n 5) \"hello\"\n 6) \"hello\"\n 7) \"hello\"\n 8) \"hello\"\n 9) \"hello\"\n10) \"hello\"\n11) \"hello\""
      end

      context "when the indent is non-zero" do
        it "right justifies the values" do
          expect(type.to_pretty_s(indent: 2)).to eq "     1) \"hello\"\n     2) \"hello\"\n     3) \"hello\"\n     4) \"hello\"\n     5) \"hello\"\n     6) \"hello\"\n     7) \"hello\"\n     8) \"hello\"\n     9) \"hello\"\n    10) \"hello\"\n    11) \"hello\""
        end
      end
    end

    context "when the array contains nested arrays" do
      let(:value) { ["hello", ["world"]] }

      it "pretty prints the type" do
        expect(type.to_pretty_s).to eq "1) \"hello\"\n2) 1) \"world\""
      end

      context "when the indent is non-zero" do
        it "indents the values" do
          expect(type.to_pretty_s(indent: 2)).to eq "    1) \"hello\"\n    2) 1) \"world\""
        end
      end

      context "when the nested array contains a lots of elements" do
        let(:value) { ["hello", ["world"] * 11] }

        it "pretty prints the type" do
          expect(type.to_pretty_s).to eq "1) \"hello\"\n2)  1) \"world\"\n    2) \"world\"\n    3) \"world\"\n    4) \"world\"\n    5) \"world\"\n    6) \"world\"\n    7) \"world\"\n    8) \"world\"\n    9) \"world\"\n   10) \"world\"\n   11) \"world\""
        end

        context "when the indent is non-zero" do
          it "indents the values" do
            expect(type.to_pretty_s(indent: 2)).to eq "    1) \"hello\"\n    2)  1) \"world\"\n        2) \"world\"\n        3) \"world\"\n        4) \"world\"\n        5) \"world\"\n        6) \"world\"\n        7) \"world\"\n        8) \"world\"\n        9) \"world\"\n       10) \"world\"\n       11) \"world\""
          end
        end
      end
    end
  end

  describe ".from_resp3" do
    it "deserializes the type" do
      write_connection.write("2\r\n$5\r\nhello\r\n$5\r\nworld\r\n")

      type = described_class.from_resp3("*", read_connection) { parser.read }

      expect(type).to eq ["hello", "world"]
    end
  end
end
