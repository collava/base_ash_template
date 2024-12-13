# More info in the Dialyxir README:
# https://github.com/jeremyjh/dialyxir#elixir-term-format
# to Update this file run mix dialyzer --format ignore_file
[
  {"test/support/conn_case.ex", :unknown_function},
  {"test/support/data_case.ex", :unknown_function},
  # backpex throws a lot of false positives
  {"lib/collava_web/router.ex", :unknown_function}
]
