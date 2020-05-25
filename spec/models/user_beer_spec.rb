require 'rails_helper'

describe UserBeer do
  context 'with valid attributes' do
    subject(:user_beer) { create :user_beer }
    before { is_expected.to be_valid }

    it 'belongs to a user' do
      expect(subject.user).to be_a User
      expect(subject.user).to be_present
    end

    it 'belongs to a beer' do
      expect(subject.beer).to be_a Beer
      expect(subject.beer).to be_present
    end
  end

  context 'with nil attributes' do
    subject(:user_beer) { UserBeer.new }
    before { is_expected.to be_invalid }

    it('has user "must exist" error') { expect(subject.errors[:user]).to include "must exist" }
    it('has beer "must exist" error') { expect(subject.errors[:beer]).to include "must exist" }
  end
end

describe UserBeer, '.search' do
  let!(:user)         { create :user }
  let!(:buzz)         { create :beer }
  let!(:corona)       { create :corona }
  let!(:user_buzz)    { create :user_beer, user: user, beer: buzz }
  let!(:user_corona)  { create :user_beer, user: user, beer: corona }

  context 'when searching beer name' do
    subject { UserBeer.search(buzz.name) }

    it 'returns the correct user_beer' do
      is_expected.to include user_buzz
      is_expected.not_to include user_corona
    end
  end

  context 'when searching beer floating abv' do
    subject { UserBeer.search(buzz.abv) }

    it 'returns the correct user_beer' do
      is_expected.to include user_buzz
      is_expected.not_to include user_corona
    end
  end

  context 'when searching nil object' do
    subject { UserBeer.search(nil) }

    it 'returns the all user_beers' do
      is_expected.to include user_buzz
      is_expected.to include user_corona
    end
  end

  context 'when searching blank string' do
    subject { UserBeer.search('') }

    it 'returns the all user_beers' do
      is_expected.to include user_buzz
      is_expected.to include user_corona
    end
  end
end