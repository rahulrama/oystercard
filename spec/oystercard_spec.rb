require 'oystercard'

describe Oystercard do

  	subject(:oystercard){ described_class.new }
    let (:card_max) { Oystercard::MAXIMUM_BALANCE }
    let (:min_fare) { Oystercard::MINIMUM_FARE }
    let (:starting_station) { double :station }
    let (:ending_station) { double :station }
    let (:journey) { {starting_station: starting_station, ending_station: ending_station} }

    describe "#initialization" do
    	it 'has a default balance of 0 on initialization' do
        expect(oystercard.balance).to eq 0
  	  end
	  end

    describe '#top_up' do
      it 'tops up the balance' do
        expect{ oystercard.top_up(card_max) }.to change{oystercard.balance}.by card_max
  	  end
      it "raises an error when the maximum balance is exceeded" do
  		  oystercard.top_up(card_max)
  		  expect {oystercard.top_up(1)}.to raise_error "maximum balance of #{card_max} exceeded"
	    end
    end

  context 'when in journey' do
    before(:each) do
      oystercard.top_up(card_max)
      oystercard.touch_in(starting_station)
    end
    it "prevents journey if oystercard doesn't have minimum balance" do #should we consider moving this elsewhere?
      oystercard.top_up(-card_max)
      expect { oystercard.touch_in(starting_station) }.to raise_error "Insufficient balance for journey"
    end
  end

  context 'when journey is complete' do
    before do
      oystercard.top_up(card_max)
      oystercard.touch_in(starting_station)
    end
    it "deducts the correct journey fare from my card when touching out" do
      expect { oystercard.touch_out(ending_station) }.to change { oystercard.balance }.by -(min_fare)
    end
  end
end
