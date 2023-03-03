# frozen_string_literal: true

RSpec.describe Rediss::Command do
  subject(:command) { command_class.new(arguments) }

  let(:command_class) do
    Class.new(described_class) do
      command "TEST"
    end
  end

  let(:subcommand_class) do
    Class.new(command_class) do
      command "SUBTEST"
    end
  end

  let(:arguments) { [] }

  describe ".command" do
    it "registers the command as a subcommand of the parent class" do
      expect(described_class.subcommands)
        .to include "TEST" => command_class

      expect(command_class.subcommands)
        .to include "SUBTEST" => subcommand_class
    end

    it "sets the command name" do
      expect(command_class.command_name).to eq "TEST"
    end
  end

  describe "#validate" do
    context "when arity is 1" do
      before { command.arity = 1 }

      context "when no arguments are passed" do
        let(:arguments) { [] }

        it "does not raise an error" do
          expect { command.validate }.not_to raise_error
        end
      end

      context "when an argument is passed" do
        let(:arguments) { ["foo"] }

        it "raises an error" do
          expect { command.validate }.to raise_error ArgumentError
        end
      end

      context "when multiple arguments are passed" do
        let(:arguments) { ["foo", "bar"] }

        it "raises an error" do
          expect { command.validate }.to raise_error ArgumentError
        end
      end
    end

    context "when arity is -1" do
      before { command.arity = -1 }

      context "when no arguments are passed" do
        let(:arguments) { [] }

        it "does not raise an error" do
          expect { command.validate }.not_to raise_error
        end
      end

      context "when an argument is passed" do
        let(:arguments) { ["foo"] }

        it "does not raise an error" do
          expect { command.validate }.not_to raise_error
        end
      end

      context "when multiple arguments are passed" do
        let(:arguments) { ["foo", "bar"] }

        it "does not raise an error" do
          expect { command.validate }.not_to raise_error
        end
      end
    end

    context "when arity is 3" do
      before { command.arity = 3 }

      context "when the exact number of arguments are passed" do
        let(:arguments) { ["foo", "bar"] }

        it "does not raise an error" do
          expect { command.validate }.not_to raise_error
        end
      end

      context "when fewer arguments are passed" do
        let(:arguments) { ["foo"] }

        it "raises an error" do
          expect { command.validate }.to raise_error ArgumentError
        end
      end

      context "when more arguments are passed" do
        let(:arguments) { ["foo", "bar", "baz"] }

        it "raises an error" do
          expect { command.validate }.to raise_error ArgumentError
        end
      end
    end

    context "when arity is -3" do
      before { command.arity = -3 }

      context "when the exact number of arguments are passed" do
        let(:arguments) { ["foo", "bar"] }

        it "does not raise an error" do
          expect { command.validate }.not_to raise_error
        end
      end

      context "when fewer arguments are passed" do
        let(:arguments) { ["foo"] }

        it "raises an error" do
          expect { command.validate }.to raise_error ArgumentError
        end
      end

      context "when more arguments are passed" do
        let(:arguments) { ["foo", "bar", "baz"] }

        it "does not raise an error" do
          expect { command.validate }.not_to raise_error
        end
      end
    end
  end
end
