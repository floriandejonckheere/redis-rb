# frozen_string_literal: true

FactoryBot.define do
  factory :type, class: "Redis::Type" do
    initialize_with { new(value) }

    factory :blob_string, class: "Redis::Types::BlobString" do
      value { "hello world" }
    end

    factory :simple_string, class: "Redis::Types::SimpleString" do
      value { "hello world" }
    end

    factory :simple_error, class: "Redis::Types::SimpleError" do
      value { "hello world" }
    end

    factory :number, class: "Redis::Types::Number" do
      value { 1 }
    end

    factory :array, class: "Redis::Types::Array" do
      value { [build(:simple_string), build(:simple_error)] }
    end

    factory :map, class: "Redis::Types::Map" do
      value { { build(:simple_string) => build(:simple_error) } }
    end
  end
end
