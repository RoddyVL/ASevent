# Suppression des anciennes données dans le bon ordre
Message.destroy_all
Chat.destroy_all
Booking.destroy_all
Package.destroy_all
Photo.destroy_all
Photobooth.destroy_all

# Création des photobooths
photobooth1 = Photobooth.create!(
  name: "Photobooth",
  description: "Photobooth – Capturez l'instant avec style et simplicité ! Ajoutez une touche de fun...",
  review: "4 stars"
)

photobooth2 = Photobooth.create!(
  name: "360booth",
  description: "Photobooth 360 : L’expérience immersive ultime !",
  review: "4 stars"
)

photobooth3 = Photobooth.create!(
  name: "Miroir",
  description: "Miroir Photobooth – Une expérience interactive inédite pour vos événements...",
  review: "4 stars"
)

# Ajout des photos associées
photobooth1.photos.create!([
  { image_url: "photobooth1.jpg" },
  { image_url: "photobooth2.jpg" },
  { image_url: "photobooth3.jpg" }
])

photobooth2.photos.create!([
  { image_url: "p360_1.jpg" },
  { image_url: "p360_2.jpg" },
  { image_url: "p360_3.jpg" }
])

photobooth3.photos.create!([
  { image_url: "miroir1.jpg" },
  { image_url: "miroir2.jpg" },
  { image_url: "miroir3.jpg" }
])

# Packages pour photobooth
packages_photobooth = [
  { hour: "2h", price: 180 },
  { hour: "3h", price: 250 },
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

# Création de l'utilisateur admin
admin_user = User.create!(
  email: 'admin@example.com',
  password: '123456',  # Remplacez par un mot de passe sécurisé
  password_confirmation: '123456', # Assurez-vous que la confirmation du mot de passe est correcte
  admin: true
)

puts "Admin user created with email: #{admin_user.email}"
