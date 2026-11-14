buhrmi = User.where(handle: "buhrmi").first_or_create!(
  email: "stefan@shitcoinsociety.com",
  password: "password",
  name: "Stefan Buhrmester",
  bio: "Better to be wrong about everything than to be right about nothing."
)

unless buhrmi.profile_image.attached?
  buhrmi.profile_image.attach(
    io: File.open(Rails.root.join("db/seeds/buhrmi.jpg")),
    filename: "buhrmi.jpg",
    content_type: "image/jpeg"
  )
end
