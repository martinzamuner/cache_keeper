class Recording < ApplicationRecord
  caches :slow_method, expires_in: 1.hour

  def slow_method
    42
  end

  def another_method
    number
  end

  def unsupported_method(parameter)
    parameter * 2
  end
end
