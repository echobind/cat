class NullWorker
  include Sidekiq::Worker
  def perform
    # NOOP
  end
end
