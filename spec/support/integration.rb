# frozen_string_literal: true

def compare_rediss_with_redis(&block)
  [
    $rediss.with(&block),
    $redis.with(&block),
  ]
end
