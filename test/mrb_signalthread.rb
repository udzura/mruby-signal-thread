assert('SignalThread#trap') do
  a = 1
  th1 = SignalThread.trap(:HUP) do
    a = 2
  end

  th2 = SignalThread.trap(:USR1) do
    a = 3
  end

  th1.kill :HUP
  usleep 1000
  assert_true a == 2

  th2.kill :USR1
  usleep 1000
  assert_true a == 3
end

assert('SignalThread#trap with RTSignal') do
  begin
    a = 0
    t = SignalThread.trap(:RT1) do
      a = 10
    end
    t.kill :RT1
    usleep 1000
    assert_true a == 10
  rescue ArgumentError => e
    assert_equal "unsupported signal", e.message
  end
end

assert('SignalThread#trap_once') do
  a = 1
  t = SignalThread.trap_once(:USR1) do
    a = 4
  end

  t.kill :USR1
  usleep 1000
  assert_equal 4, a
  assert_false t.alive?
end

assert('SignalThread#trap, detailed: true') do
  name = 'SigInfo'
  t = SignalThread.trap(:USR2, detailed: true) do |info|
    name = info.class.to_s
  end

  t.kill :USR2
  usleep 1000
  assert_equal "Hash", name
end

assert('SignalThread#thread_id') do
  a = 1
  th = SignalThread.trap(:HUP) do
    a = 2
  end

  SignalThread.kill_by_thread_id th.thread_id, :HUP
  usleep 1000
  assert_true a == 2
end
