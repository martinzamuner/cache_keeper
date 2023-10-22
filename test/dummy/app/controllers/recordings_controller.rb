class RecordingsController < ActionController::Base
  def index
    @recordings = Recording.all
  end
end
