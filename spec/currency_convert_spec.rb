# frozen_string_literal: true

RSpec.describe CurrencyConvert do
  it "has a version number" do
    expect(CurrencyConvert::VERSION).not_to be nil
  end

  describe "Money" do
    before(:all) do
      @fifty_eur = Money.new(50, 'EUR')
    end

    it "should be able to return amount" do
      expect(@fifty_eur.amount).to eq(50)
    end

    it "should be able to return currency type" do
      expect(@fifty_eur.currency).to eq('EUR')
    end

    it "should be able to return formatted currency" do
      expect(@fifty_eur.inspect).to eq('50.00 EUR')
    end
  end

  describe "Money" do
    before(:all) do
      Money.conversion_rates('EUR', {
        'USD'     => 1.11,
        'Bitcoin' => 0.0047
      })
    end

    it "should store conversion rates and be able to show main currency type" do
      expect(Money.stored_currency_type).to eq('EUR')
    end

    it "should store conversion rates and be able to show conversion rates" do
      expect(Money.stored_conversion_rates).to eq({
                                                    'USD'     => 1.11,
                                                    'Bitcoin' => 0.0047
                                                  })
    end

    it "should be able to convert currency and return an instance" do
      @fifty_eur = Money.new(50, 'EUR')
      expect(@fifty_eur.convert_to('USD')).to be_a Money
    end
  end

  describe "Money arithmetics" do
    before(:all) do
      Money.conversion_rates('EUR', {
        'USD'     => 1.11,
        'Bitcoin' => 0.0047
      })
      @fifty_eur = Money.new(50, 'EUR')
      @twenty_dollars = Money.new(20, 'USD')
    end

    it "should be able to add two types of currencies" do
      expect(@fifty_eur + @twenty_dollars).to eq("72.20 EUR")
    end

    it "should be able to subtract two types of currencies" do
      expect(@fifty_eur - @twenty_dollars).to eq("27.80 EUR")
    end

    it "should be able to divide currency" do
      expect(@fifty_eur / 2).to eq("25.00 EUR")
    end

    it "should be able to multiply currency" do
      expect(@fifty_eur * 5).to eq("250.00 EUR")
    end

    it "should be able to compare two types of currencies" do
      expect(@fifty_eur == @twenty_dollars).to eq(false)
    end

    it "should be able to compare two types of currencies of same value" do
      expect(@twenty_dollars == Money.new(20, 'USD')).to eq(true)
    end

    it "should be able to compare two same currencies of different value" do
      expect(@twenty_dollars == Money.new(30, 'USD')).to eq(false)
    end

    it "should be able to compare two types of currencies of different value" do
      expect(@twenty_dollars == @fifty_eur.convert_to('USD')).to eq(false)
    end

    it "should be able to compare two types of currencies for greater" do
      expect(@fifty_eur > @twenty_dollars).to eq(true)
    end

    it "should be able to compare two types of currencies for less" do
      expect(@fifty_eur < @twenty_dollars).to eq(false)
    end
  end
end
