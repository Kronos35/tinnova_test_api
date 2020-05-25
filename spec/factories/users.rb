FactoryBot.define do
  factory :user, aliases: %W[han] do
    name        { "Han" }
    last_name   { "Solo" }
    email       { "han@corelia.com" }
    username    { 'hsolo35' }
    password    { "Falcon1000" }
  end

  factory :chewie, class: User do
    name        { "Chewie" }
    last_name   { "Wookie" }
    email       { "chewie@kashyyk.com" }
    username    { 'chewie1977' }
    password    { "Falcon1000" }
  end
end
