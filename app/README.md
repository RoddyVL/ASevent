Voici un résumé sous forme de tutoriel étape par étape pour mettre en place un workflow utilisant Turbo Frames dans une application Ruby on Rails (Rails 7.1.5) avec Hotwire. Ce tutoriel suit le workflow que vous m'avez partagé et vous permettra de permettre à un utilisateur de sélectionner un photobooth, choisir un package, puis de réserver via un formulaire dynamique avec Turbo, sans recharger la page.

Objectif du workflow
L'utilisateur arrive sur l'index des photobooths.
Lorsqu'il clique sur un photobooth, il voit les détails et les packages associés.
En cliquant sur un package, un formulaire de réservation s'affiche, sans recharger la page, grâce à Turbo Frames.
Après la soumission du formulaire de réservation, l'utilisateur est redirigé vers la page de show du booking créé.
Prérequis
Ruby on Rails 7.1.5
Turbo et Stimulus via Hotwire
Vous utilisez un modèle Photobooth, avec des relations has_many :packages, et chaque Package a un formulaire de réservation qui sera créé via un modèle Booking.
Étape 1 : Assurez-vous que Hotwire est installé
Avant de commencer, assurez-vous que vous avez Hotwire (Turbo + Stimulus) installé dans votre application Rails.

Installer Hotwire dans votre Gemfile :
ruby
Copier le code
gem 'hotwire-rails'
Exécutez bundle install pour installer le gem.

Ensuite, ajoutez les importmap pour Turbo et Stimulus si ce n’est pas déjà fait :

bash
Copier le code
bin/rails turbo:install stimulus:install
Cela mettra en place les fichiers nécessaires pour Turbo et Stimulus dans app/javascript.

Étape 2 : Créer l'index des photobooths
Dans le fichier app/views/photobooths/index.html.erb, affichez les photobooths disponibles. Utilisez Turbo Frames pour rendre la page plus dynamique.

erb
Copier le code
<div class="container mt-5">
  <h1 class="display-4 text-center">Choisissez votre photobooth</h1>

  <div class="row">
    <% @photobooths.each do |photobooth| %>
      <div class="col-md-4">
        <div class="card mb-4">
          <%= image_tag(photobooth.image_url, class: "card-img-top", alt: photobooth.name) %>
          <div class="card-body">
            <h5 class="card-title"><%= photobooth.name %></h5>
            <p class="card-text"><%= photobooth.description %></p>
            <%= link_to "Voir plus", photobooth_path(photobooth), data: { turbo_frame: "photobooth_details_#{photobooth.id}" }, class: "btn btn-primary" %>
          </div>
        </div>
      </div>
    <% end %>
  </div>
</div>
Chaque photobooth est affiché avec un bouton qui charge ses détails dans un Turbo Frame.
Étape 3 : Créer la page show du photobooth avec les packages
Dans app/views/photobooths/show.html.erb, affichez les détails du photobooth et les packages disponibles. Utilisez un Turbo Frame pour charger le formulaire de réservation sans recharger la page.

erb
Copier le code
<div class="container mt-5">
  <h1><%= @photobooth.name %></h1>
  <p><%= @photobooth.description %></p>

  <div class="row">
    <% @photobooth.packages.each do |package| %>
      <div class="col-md-4">
        <div class="card mb-3">
          <div class="card-body">
            <h5 class="card-title"><%= package.name %></h5>
            <p class="card-text"><%= humanized_money_with_symbol(package.price) %></p>
            <%= link_to "Réserver", new_photobooth_package_booking_path(@photobooth, package), data: { turbo_frame: "new_booking" }, class: "btn btn-primary" %>
          </div>
        </div>
      </div>
    <% end %>
  </div>
</div>
Lorsque l'utilisateur clique sur un package, un Turbo Frame "new_booking" est activé pour afficher un formulaire de réservation.
Étape 4 : Créer le formulaire de réservation avec Turbo Frame
Dans le fichier app/views/bookings/new.html.erb, vous créez le formulaire de réservation. Ce formulaire est chargé dans le Turbo Frame "new_booking" lorsque l'utilisateur clique sur un package.

erb
Copier le code
<%= turbo_frame_tag "new_booking" do %>
  <div class="card shadow-lg p-4">
    <div class="card-body">
      <%= simple_form_for @booking, url: photobooth_package_bookings_path(@photobooth, @package), method: :post do |f| %>
        <div class="mb-3">
          <%= f.input :address, label: "Adresse de l'événement", placeholder: "Entrez l'adresse", input_html: { class: "form-control" } %>
        </div>

        <div class="row g-3">
          <div class="col-md-6">
            <%= f.input :date, as: :string, input_html: { data: {controller: "datepickr"}} %>
          </div>
          <div class="col-md-6">
            <%= f.input :time, label: "Heure de l'événement", as: :time, input_html: { class: "form-control" } %>
          </div>
        </div>

        <%= f.input :package_id, as: :hidden, value: @package.id %>

        <div class="text-center mt-4">
          <%= f.submit "Réserver ce forfait", class: "btn btn-primary btn-lg px-5" %>
        </div>
      <% end %>
    </div>
  </div>
<% end %>
L'utilisation du Turbo Frame pour le formulaire permet de le charger sans recharger la page.
Vous soumettez le formulaire en POST à l'URL de création d'une réservation.
Étape 5 : Gérer la soumission du formulaire et la redirection
Dans le contrôleur des bookings (app/controllers/bookings_controller.rb), après la soumission du formulaire, vous gérez la redirection vers la page show du booking créé.

ruby
Copier le code
class BookingsController < ApplicationController
  def new
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = @photobooth.packages.find(params[:package_id])
    @booking = @package.bookings.new
  end

  def create
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = @photobooth.packages.find(params[:package_id])
    @booking = @package.bookings.new(booking_params)
    @booking.user = current_user # Assurez-vous que l'utilisateur est connecté

    if @booking.save
      redirect_to photobooth_package_booking_path(@photobooth, @package, @booking) # Redirection après réservation
    else
      render :new
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:address, :date, :time, :package_id)
  end
end
Étape 6 : Vérifier et tester
Assurez-vous que toutes les routes sont correctement configurées dans config/routes.rb.

Testez le comportement en visitant la page d'index des photobooths. Vous devez pouvoir cliquer sur un photobooth pour afficher ses détails et ses packages, puis cliquer sur un package pour afficher le formulaire de réservation sans recharger la page.

Après soumission, vous devriez être redirigé vers la page show de la réservation créée.

Conclusion
Vous avez mis en place un workflow complet utilisant Turbo Frames pour charger dynamiquement les détails d'un photobooth et un formulaire de réservation, sans recharger complètement la page. La redirection après soumission fonctionne comme prévu, et l'expérience utilisateur est améliorée grâce à l'interactivité offerte par Turbo et Hotwire.

Étapes supplémentaires : Gestion des erreurs avec data: { turbo: false }
Nous allons ajouter des validations côté serveur et des contrôles côté client pour s'assurer que l'utilisateur voit les erreurs de manière fluide sans que la page soit rechargée.

1. Empêcher Turbo de gérer la soumission en cas d'erreur
Lorsque vous soumettez un formulaire et que des erreurs sont générées (par exemple, des validations échouées), vous devez empêcher Turbo de gérer la réponse automatiquement. Pour cela, vous pouvez utiliser data: { turbo: false } sur la balise <form>, et gérer les erreurs manuellement.

a. Mise à jour du formulaire de réservation (new.html.erb)
Dans votre formulaire, ajoutez data: { turbo: false } à la balise <%= simple_form_for %>. Cela désactive le comportement par défaut de Turbo, qui tenterait de charger la réponse dans le Turbo Frame.

erb
Copier le code
<%= turbo_frame_tag "new_booking" do %>
  <div class="card shadow-lg p-4">
    <div class="card-body">
      <%= simple_form_for @booking, url: photobooth_package_bookings_path(@photobooth, @package), method: :post, html: { data: { turbo: false } } do |f| %>
        <div class="mb-3">
          <%= f.input :address, label: "Adresse de l'événement", placeholder: "Entrez l'adresse", input_html: { class: "form-control" } %>
        </div>

        <div class="row g-3">
          <div class="col-md-6">
            <%= f.input :date, as: :string, input_html: { data: {controller: "datepickr"}} %>
          </div>
          <div class="col-md-6">
            <%= f.input :time, label: "Heure de l'événement", as: :time, input_html: { class: "form-control" } %>
          </div>
        </div>

        <%= f.input :package_id, as: :hidden, value: @package.id %>

        <div class="text-center mt-4">
          <%= f.submit "Réserver ce forfait", class: "btn btn-primary btn-lg px-5" %>
        </div>
      <% end %>
    </div>
  </div>
<% end %>
data: { turbo: false } : Cette ligne empêche Turbo de prendre en charge la réponse du formulaire, permettant ainsi de gérer manuellement les erreurs sans que la page soit rechargée.
2. Ajouter la gestion des erreurs dans le contrôleur
Dans votre contrôleur BookingsController, modifiez la méthode create pour renvoyer les erreurs si la validation échoue. Si la création du booking échoue, vous pouvez simplement renvoyer la vue new avec les erreurs et les afficher dans le formulaire.

ruby
Copier le code
class BookingsController < ApplicationController
  def new
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = @photobooth.packages.find(params[:package_id])
    @booking = @package.bookings.new
  end

  def create
    @photobooth = Photobooth.find(params[:photobooth_id])
    @package = @photobooth.packages.find(params[:package_id])
    @booking = @package.bookings.new(booking_params)
    @booking.user = current_user # Assurez-vous que l'utilisateur est connecté

    if @booking.save
      # Si tout va bien, redirigez vers la page de réservation
      redirect_to photobooth_package_booking_path(@photobooth, @package, @booking)
    else
      # En cas d'échec, renvoyer au formulaire avec les erreurs
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:address, :date, :time, :package_id)
  end
end
Si la validation échoue, render :new renverra la même vue avec les erreurs.
3. Afficher les erreurs dans le formulaire
Dans la vue new.html.erb, affichez les erreurs de validation si elles existent. Rails fournit une méthode simple pour afficher les erreurs de formulaire.

Ajoutez ceci au début du formulaire pour afficher les erreurs :

erb
Copier le code
<% if @booking.errors.any? %>
  <div class="alert alert-danger">
    <ul>
      <% @booking.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  </div>
<% end %>
Cette section vérifiera si des erreurs existent pour l'objet @booking et les affichera en haut du formulaire.
4. Vérification
Testez le formulaire :

Si un champ obligatoire est laissé vide, le formulaire doit afficher un message d'erreur.
Les erreurs doivent être visibles en haut du formulaire, et le reste de la page ne doit pas être rechargé.
Soumission avec erreurs :

Si l'utilisateur soumet un formulaire avec des erreurs, Turbo désactivera le comportement par défaut de rechargement, et les erreurs seront affichées, tout en gardant la même vue.
Conclusion
En suivant ces étapes supplémentaires, vous avez réussi à intégrer une gestion des erreurs de validation dans le formulaire sans recharger la page. L'utilisation de data: { turbo: false } empêche Turbo de gérer la soumission et permet de contrôler manuellement la réponse en cas d'erreur, ce qui garantit une meilleure expérience utilisateur.<
