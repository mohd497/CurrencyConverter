# frozen_string_literal: true

require_relative "currency_convert/version"

module CurrencyConvert
  class Error < StandardError; end

  def initialize(amount, currency_type)
    @amount = amount
    @currency_type = currency_type
  end
end

class Money
  include CurrencyConvert

  @@currency = "EUR" #default
  @@convertion_rates = {} #default

  def initialize(amount, currency_type)
    super
  end

  def self.stored_conversion_rates
    @@convertion_rates
  end

  def self.stored_currency_type
    @@currency
  end

  def self.conversion_rates(currency, convertion_rates)
    @@currency = currency
    @@convertion_rates = convertion_rates
  end

  def amount
    @amount
  end

  def currency
    @currency_type
  end

  def inspect
    ('%.2f' % [(@amount.to_f * 100).round / 100.0]).to_s + " " + @currency_type
  end

  def convert_to(currency)
    @currency_type = currency
    @amount = @@convertion_rates[currency] * @amount
    Money.new(@amount, @currency_type)
  end

  def +(instance_class)
    result = dup
    add_values(result, instance_class)
  end

  def -(instance_class)
    result = dup
    subtract_values(result, instance_class)
  end

  def /(number)
    result = dup
    inspect_result(result.amount / number, result.currency)
  end

  def *(number)
    result = dup
    inspect_result(result.amount * number, result.currency)
  end

  def ==(instance_class)
    result = dup
    check_type(result) == check_type(instance_class)
  end

  def >(instance_class)
    result = dup
    check_type(result) > check_type(instance_class)
  end

  def <(instance_class)
    result = dup
    check_type(result) < check_type(instance_class)
  end

  def inspect_result(amount, currency)
    ('%.2f' % [(amount.to_f * 100).round / 100.0]).to_s + " " + currency
  end

  def add_values(obj1, obj2)
    if obj1.currency == obj2.currency
      inspect_result(obj1.amount + obj2.amount, obj1.currency)
    else
      inspect_result(obj1.amount + convert_to_base_currency(obj2.amount, obj2.currency), obj1.currency)
    end
  end

  def subtract_values(obj1, obj2)
    if obj1.currency == obj2.currency
      inspect_result(obj1.amount - obj2.amount, obj1.currency)
    else
      inspect_result(obj1.amount - convert_to_base_currency(obj2.amount, obj2.currency), obj1.currency)
    end
  end

  def check_type(obj)
    if obj.instance_of? Money
      check_currency_type(obj)
    else
      obj
    end
  end

  def check_currency_type(obj)
    if @@convertion_rates[obj.currency]
      convert_to_base_currency(obj.amount, obj.currency)
    else
      obj.amount
    end
  end

  def convert_to_base_currency(amount, currency)
    @@convertion_rates[currency] * amount
  end
end
