defmodule AshBaseTemplate.MoneyTest do
  use ExUnit.Case, async: true

  alias AshMoney.Types.Money, as: MoneyType

  test "formats money with the configured English locale" do
    assert Money.to_string(Money.new(:USD, "1234.56")) == {:ok, "$1,234.56"}
  end

  test "round trips the Ash money type through composite SQL storage" do
    assert {:ok, money} = MoneyType.cast_input(%{"currency" => "USD", "amount" => "12.34"}, [])
    assert {:ok, stored} = MoneyType.dump_to_native(money, [])
    assert {:ok, restored} = MoneyType.cast_stored(stored, [])
    assert Money.equal?(money, restored)
  end

  test "round trips the Ash money type through map storage" do
    constraints = [storage_type: :map]
    money = Money.new(:EUR, "12.34")
    assert {:ok, stored} = MoneyType.dump_to_native(money, constraints)
    assert {:ok, restored} = MoneyType.cast_stored(stored, constraints)
    assert Money.equal?(money, restored)
  end
end
