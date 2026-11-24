%w[
  networks
  assets
].each do |seed|
  load Rails.root.join("db/seeds/#{seed}.rb")
end

buhrmi = User.where(handle: "buhrmi").first_or_create!(
  email: "stefan@shitcoinsociety.com",
  name: "Stefan Buhrmester"
)

buhrmi.update!(
  description: "Lead Developer & Investor",
  social_links: {
    github: "buhrmi"
  }
)

unless buhrmi.profile_image.attached?
  buhrmi.profile_image.attach(
    io: File.open(Rails.root.join("db/seeds/buhrmi.jpg")),
    filename: "buhrmi.jpg",
    content_type: "image/jpeg"
  )
end
