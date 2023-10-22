class Recording < ApplicationRecord
  caches :slow_method, expires_in: 1.hour

  def slow_method
    sleep 2

    42
  end

  def another_method
    number
  end
end
