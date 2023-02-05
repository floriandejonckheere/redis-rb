# frozen_string_literal: true

FactoryBot.define do
  factory :type, class: "Redis::Type" do
    initialize_with { new(value) }

    factory :simple_string, class: "Redis::Types::SimpleString" do
      value { "hello world" }
    end

    factory :simple_error, class: "Redis::Types::SimpleError" do
      value { "hello world" }
    end

    factory :array, class: "Redis::Types::Array" do
      value { [build(:simple_string), build(:simple_error)] }
    end
  end
end
