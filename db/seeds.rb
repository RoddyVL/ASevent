# Suppression des anciennes données dans le bon ordre
Booking.destroy_all
Package.destroy_all
Photobooth.destroy_all

# Création des photobooths
photobooth1 = Photobooth.create!(
  name: "Photobooth",
  description: "Photobooth – Capturez l'instant avec style et simplicité ! Ajoutez une touche de fun...",
  image_url: "photobooth.jpg",
  review: "4 stars"
)

photobooth2 = Photobooth.create!(
  name: "360booth",
  description: "Photobooth 360 : L’expérience immersive ultime !",
  image_url: "p360.jpg",
  review: "4 stars"
)

photobooth3 = Photobooth.create!(
  name: "Miroir",
  description: "Miroir Photobooth – Une expérience interactive inédite pour vos événements...",
  image_url: "miroir.jpg",
  review: "4 stars"
)

# Packages pour photobooth
packages_photobooth = [
  { hour: "2h", price: 250 },
  { hour: "3h", price: 180 },
  { hour: "5h", price: 400 }
]

packages_photobooth.each do |pkg|
  photobooth1.packages.create!(pkg)
end

# Packages pour 360booth
packages_360 = [
  { hour: "2h", price: 250 },
  { hour: "3h", price: 400 },
  { hour: "5h", price: 500 }
]

packages_360.each do |pkg|
  photobooth2.packages.create!(pkg)
end

# Packages pour Miroir
packages_miroir = [
  { hour: "2h", price: 400 },
  { hour: "3h", price: 450 },
  { hour: "5h", price: 550 }
]

packages_miroir.each do |pkg|
  photobooth3.packages.create!(pkg)
end

# Création des clients
# clients = [
#   { first_name: "John", last_name: "Doe", email: "john.doe@example.com", phone_number: "+1234567890" },
#   { first_name: "Jane", last_name: "Smith", email: "jane.smith@example.com", phone_number: "+0987654321" }
# ]

# clients.each { |client| Client.create!(client) }

# Création des bookings
# Booking.create!(
#   address: "123 Rue de Paris, 75001 Paris",
#   date: Date.today + 1,
#   time: "14:00",
#   status: 0,
#   paiement_status: "paid",
#   booking_status: "confirmed",
#   client: Client.first,
#   package: photobooth1.packages.first
# )

# Booking.create!(
#   address: "456 Avenue des Champs, 75008 Paris",
#   date: Date.today + 2,
#   time: "16:00",
#   status: 1,
#   paiement_status: "pending",
#   booking_status: "cancelled",
#   client: Client.last,
#   package: photobooth2.packages.second
# )
