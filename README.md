# Application de Photobooth
Essayez la démo ici : https://blooming-wildwood-33447-07029ae732ab.herokuapp.com

## Description
Cette application de photobooth simplifie l’organisation d’événements en offrant une solution intuitive pour réserver et gérer des photobooths. Les utilisateurs peuvent choisir parmi une variété de photobooths et de forfaits, tout en bénéficiant d’un assistant virtuel et d’un support client en temps réel.

## Fonctionnalités Clés
- **Choix de Photobooth** : Sélectionnez parmi différents modèles adaptés à vos besoins.
- **Forfaits Flexibles** : Configurez vos réservations selon la durée souhaitée.
- **Réservation Sécurisée** : Créez un compte ou connectez-vous pour réserver en toute confiance.
- **Paiement en Ligne** : Paiements faciles et sécurisés grâce à l'intégration avec Stripe.
- **Support en Temps Réel** : Chat intégré avec notifications instantanées (WebSocket via Solid Cable).
- **Assistant Virtuel** : Un chatbot interactif basé sur l’API OpenAI pour guider les utilisateurs.
- **Gestion Simplifiée** : Suivez et modifiez vos réservations via un tableau de bord intuitif.


## Technologies et Outils
## backend
- **Ruby on Rails**: Framework principal de l’application.
- **PostgreSQL**: Base de données relationnelle pour une gestion robuste des données.
- **Devise**: Authentification sécurisée des utilisateurs.
- **Solid Queue**: Gestion des files d’attente pour le traitement asynchrone des tâches.
- **Money-Rails**: Gestion des devises pour les paiements.

## Frontend
- **Bootstrap 5.2** : Mise en page responsive et design moderne.
- **Font Awesome** : Icônes élégantes pour une meilleure expérience utilisateur.
- **Stimulus** : Framework léger pour une interactivité accrue.
- **Turbo Streams** : Mises à jour dynamiques en temps réel sans rechargement de page.

## Paiements et APIs
- **Stripe** : Gestion des paiements en ligne sécurisés.
- **Ruby-OpenAI** : Assistant virtuel intelligent pour répondre aux questions des utilisateurs.
- **Neighbor** : Vectorisation des informations pour une recherche optimisée.

## Installation

1. Clonez le dépôt :
    ```
    git clone https://github.com/roddyvl/asevent.git
    cd asevent
    ```

2. Installez les dépendances :
    ```
    bundle install
    ```

3. Configurez la base de données :
    ```
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. Lancez le serveur :
    ```
    rails server
    ```

## Utilisation

- Accédez à l'application via `http://localhost:3000`.
- Choisissez un photobooth et un forfait, puis effectuez une réservation.
- Payez en ligne ou gérez vos réservations via le tableau de bord

## Contribution

Les contributions sont les bienvenues ! Veuillez soumettre une pull request ou ouvrir une issue pour discuter des modifications que vous souhaitez apporter.
