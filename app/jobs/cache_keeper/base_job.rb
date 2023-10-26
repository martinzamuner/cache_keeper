class CacheKeeper::BaseJob < CacheKeeper::ActiveJobParentClass
  discard_on StandardError

  private

  # Monkey patch ActiveJob::Core#serialize_arguments to use our custom serializers
  # in case the `serializer` option is present. I'm doing it this way because I don't
  # want to register the serializer as it would affect the whole application.
  def serialize_arguments(arguments)
    arguments.map do |argument|
      ActiveJob::Arguments.send :serialize_argument, argument
    rescue ActiveJob::SerializationError => e
      if arguments.first.serialize_target?
        arguments.first.serialize_target argument
      else
        raise e
      end
    end
  end
end
