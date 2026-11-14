buhrmi = User.where(handle: "buhrmi").first_or_create!(
  email: "stefan@shitcoinsociety.com",
  password: "password",
  name: "Stefan Buhrmester",
  bio: "It's better to be wrong about everything than to be right about nothing."
)