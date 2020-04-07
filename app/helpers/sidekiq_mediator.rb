module SidekiqMediator
  def perform_async(klass, *args)
    args.push(current_user.id)
    klass.send(:perform_async, *args)
  end
end
