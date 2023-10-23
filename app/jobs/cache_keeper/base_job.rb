class CacheKeeper::BaseJob < ActiveJob::Base
  discard_on StandardError

  private

  # Monkey patch ActiveJob::Core#serialize_arguments to use CacheKeeper::WhateverSerializer
  # in case there's no serializer for the argument. I'm doing it this way because I don't
  # want to register the serializer as it would affect the whole application.
  def serialize_arguments(arguments)
    arguments.map do |argument|
      ActiveJob::Arguments.send :serialize_argument, argument
    rescue ActiveJob::SerializationError
      CacheKeeper::WhateverSerializer.serialize argument
    end
  end
end
