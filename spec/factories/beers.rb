FactoryBot.define do
  factory :beer do
    name          { "Buzz" }
    tagline       { "A Real Bitter Experience." }
    description   { "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once." }
    abv           { 4.5 }
  end

  factory :corona, class: Beer do
    name          { "Corona" }
    tagline       { "A Mexican Experience." }
    description   { "A light, crisp and bitter IPA brewed with English and Mexican hops. A small batch brewed only once." }
    abv           { 4.0 }
  end

end
