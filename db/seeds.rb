# Suppression des anciennes données dans le bon ordre
Booking.destroy_all
Package.destroy_all
Photobooth.destroy_all
Client.destroy_all

# Création des photobooths
photobooth1 = Photobooth.create!(
  name: "Photobooth Luxe",
  description: "Photobooth élégant pour les mariages et événements VIP.",
  image_url: "https://example.com/images/luxe.jpg",
  review: "5 stars"
)

photobooth2 = Photobooth.create!(
  name: "Photobooth Standard",
  description: "Photobooth pour tous types d'événements.",
  image_url: "https://example.com/images/standard.jpg",
  review: "4 stars"
)

# Création des packages
package1 = Package.create!(
  hour: Time.parse("01:00"),  # Utilisation de Time.parse pour un format valide
  price: 100,
  overtime: Time.parse("00:30"),
  photobooth_id: photobooth1.id
)

package2 = Package.create!(
  hour: Time.parse("02:00"),
  price: 180,
  overtime: Time.parse("01:00"),
  photobooth_id: photobooth2.id
)

# Création des clients
client1 = Client.create!(
  first_name: "John",
  last_name: "Doe",
  email: "john.doe@example.com",
  phone_number: "+1234567890"
)

client2 = Client.create!(
  first_name: "Jane",
  last_name: "Smith",
  email: "jane.smith@example.com",
  phone_number: "+0987654321"
)

# Création des bookings
Booking.create!(
  address: "123 Rue de Paris, 75001 Paris",
  date: Date.today + 1,
  time: Time.parse('14:00'),
  status: 0,  # pending
  paiement_status: 1,  # paid
  booking_status: 0,  # confirmed
  client_id: client1.id,
  package_id: package1.id
)

Booking.create!(
  address: "456 Avenue des Champs, 75008 Paris",
  date: Date.today + 2,
  time: Time.parse('16:00'),
  status: 1,  # paid
  paiement_status: 0,  # pending
  booking_status: 1,  # cancelled
  client_id: client2.id,
  package_id: package2.id
)
