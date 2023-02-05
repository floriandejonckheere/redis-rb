# frozen_string_literal: true

FactoryBot.define do
  factory :simple_string, class: "Redis::Types::SimpleString" do
    initialize_with { new(message) }

    message { "hello world" }
  end

  factory :simple_error, class: "Redis::Types::SimpleError" do
    initialize_with { new(message) }

    message { "hello world" }
  end
end
