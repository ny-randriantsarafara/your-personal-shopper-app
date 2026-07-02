# Spécification fonctionnelle — MVP Personal Shopper Madagascar

## 1. Objectif

Créer une application permettant à un client situé à Madagascar de commander un produit disponible à l’étranger.

Le parcours principal est :

```text
Demande de produit
→ Création du devis
→ Paiement Mobile Money
→ Achat du produit
→ Réception à l’entrepôt
→ Expédition vers Madagascar
→ Livraison au client
```

L’application remplace les échanges dispersés sur Facebook, Messenger, WhatsApp, Mobile Money et Excel.

---

# 2. Architecture générale du produit

## Application unique

Une seule application Flutter est publiée sur :

* Android ;
* iOS ;
* Web responsive si nécessaire.

L’application adapte son interface et ses fonctionnalités selon le rôle de l’utilisateur.

## Espaces disponibles

```text
Application Flutter
├── Espace Client
├── Espace Shopper
├── Espace Logistique
└── Espace Administration
```

Un utilisateur peut posséder plusieurs rôles.

Exemple :

```text
Client + Shopper
Shopper + Agent logistique
Administrateur + Shopper
```

Dans ce cas, il peut changer d’espace depuis son profil.

---

# 3. Rôles

## Client

Le client peut :

* créer une demande d’achat ;
* recevoir et consulter un devis ;
* accepter ou refuser un devis ;
* payer avec MVola, Orange Money ou Airtel Money ;
* suivre sa commande ;
* échanger avec le shopper ;
* consulter les documents et preuves ;
* confirmer la réception de son colis ;
* signaler un problème.

## Shopper

Le shopper peut :

* consulter les demandes qui lui sont attribuées ;
* vérifier la disponibilité d’un produit ;
* créer un devis ;
* modifier un devis avant acceptation ;
* signaler une variation de prix ;
* confirmer l’achat ;
* ajouter une facture ;
* ajouter un numéro de suivi marchand ;
* signaler une rupture de stock ou une annulation ;
* échanger avec le client.

## Agent logistique

L’agent logistique peut :

* consulter les colis attendus ;
* rechercher une commande ;
* scanner un QR code ;
* confirmer la réception du colis ;
* ajouter des photos ;
* renseigner le poids ;
* confirmer l’expédition ;
* confirmer l’arrivée à Madagascar ;
* confirmer la remise ou la livraison.

## Administrateur

L’administrateur peut :

* gérer les utilisateurs ;
* attribuer les rôles ;
* gérer les demandes ;
* attribuer une demande à un shopper ;
* modifier ou annuler un devis ;
* consulter et vérifier les paiements ;
* suivre les commandes ;
* modifier les statuts ;
* configurer les taux de change ;
* configurer les commissions ;
* gérer les opérateurs Mobile Money ;
* effectuer ou superviser les remboursements ;
* consulter les journaux d’audit ;
* exporter les données.

---

# 4. Authentification

## Connexion

L’utilisateur s’authentifie avec :

* son numéro de téléphone ;
* un code OTP.

## Informations du compte

Le profil contient :

* nom ;
* prénom ;
* numéro de téléphone ;
* adresse e-mail facultative ;
* rôles ;
* adresse principale ;
* langue ;
* statut du compte.

## Gestion des rôles

Le backend retourne :

```json
{
  "userId": "usr_123",
  "roles": [
    "customer",
    "shopper"
  ],
  "permissions": [
    "request.create",
    "quote.create",
    "purchase.confirm"
  ]
}
```

L’application utilise des permissions et non uniquement des noms de rôles.

Exemples :

```text
request.create
request.assign
quote.create
quote.approve
payment.read
payment.refund
purchase.confirm
parcel.receive
shipment.confirm
delivery.confirm
user.manage
```

La sécurité est contrôlée par le backend.

Masquer un bouton dans Flutter ne suffit pas à protéger une action.

---

# 5. Parcours client

## 5.1 Création d’une demande

Le client peut créer une demande à partir de :

* l’URL d’un produit ;
* une ou plusieurs captures d’écran ;
* une photo ;
* une description libre.

## Informations demandées

* lien du produit ;
* nom ou description ;
* boutique ;
* taille ;
* couleur ;
* variante ;
* quantité ;
* prix affiché facultatif ;
* devise facultative ;
* budget maximum facultatif ;
* commentaire ;
* date souhaitée facultative.

## Extraction des liens

Dans le MVP, aucune extraction automatique n’est obligatoire.

Le lien est stocké et consulté manuellement par le shopper.

Une extraction automatique pourra être ajoutée ultérieurement derrière une interface dédiée.

---

## 5.2 Liste des demandes

Le client peut consulter :

* les demandes en attente ;
* les demandes en cours de traitement ;
* les devis reçus ;
* les demandes refusées ;
* les demandes transformées en commande.

---

## 5.3 Consultation du devis

Le devis présente :

* prix du produit ;
* devise d’origine ;
* taux de change ;
* frais du marchand ;
* commission du service ;
* transport estimé ;
* frais de livraison locale ;
* autres frais éventuels ;
* montant total en ariary ;
* délai estimé ;
* durée de validité ;
* acompte ou paiement intégral.

## Actions disponibles

Le client peut :

* accepter le devis ;
* refuser le devis ;
* demander une modification ;
* poser une question.

Une fois accepté, le devis devient immuable.

Toute modification importante nécessite une nouvelle version du devis.

---

## 5.4 Paiement

Après acceptation du devis, le client choisit :

* MVola ;
* Orange Money ;
* Airtel Money.

Il saisit ou confirme :

* le numéro à débiter ;
* le montant ;
* l’opérateur ;
* la commande concernée.

L’application affiche ensuite le parcours adapté à l’opérateur :

* validation sur le téléphone ;
* saisie d’un OTP ;
* redirection ;
* instruction USSD ;
* attente de confirmation.

La commande n’est jamais marquée comme payée uniquement après l’envoi de la demande de paiement.

Le paiement doit être confirmé côté serveur.

---

## 5.5 Suivi de commande

Les statuts visibles par le client sont :

```text
Demande envoyée
Devis en préparation
Devis disponible
Paiement en attente
Paiement confirmé
Achat en cours
Produit acheté
En livraison vers l’entrepôt
Reçu à l’entrepôt
Expédié vers Madagascar
Arrivé à Madagascar
Prêt à être livré
En cours de livraison
Livré
```

## Statuts exceptionnels

```text
Modification requise
Prix modifié
Rupture de stock
Commande annulée
Paiement échoué
Paiement expiré
Remboursement en cours
Remboursé
Problème signalé
```

Chaque changement de statut peut contenir :

* une date ;
* une description ;
* une photo ;
* un numéro de suivi ;
* un document ;
* une action demandée au client.

---

## 5.6 Messagerie

Une conversation est automatiquement créée pour chaque demande.

La messagerie prend en charge :

* texte ;
* photos ;
* documents ;
* messages système ;
* accusé de lecture facultatif.

Les notes vocales, appels audio et appels vidéo sont hors MVP.

---

## 5.7 Réception

Le client peut :

* consulter les informations de livraison ;
* afficher son code de remise ;
* confirmer la réception ;
* signaler un problème.

La livraison peut être validée par :

* un code OTP ;
* une confirmation de l’agent ;
* une photo facultative.

---

# 6. Parcours shopper

## 6.1 Tableau de bord

Le shopper voit :

* les nouvelles demandes ;
* les devis à préparer ;
* les devis en attente du client ;
* les commandes payées à acheter ;
* les produits en attente de réception ;
* les commandes problématiques ;
* les messages non lus.

---

## 6.2 Traitement d’une demande

Le shopper peut :

* ouvrir le lien ;
* consulter les images ;
* vérifier les variantes ;
* ajouter une note interne ;
* demander des informations au client ;
* refuser la demande ;
* signaler un produit interdit ;
* préparer un devis.

---

## 6.3 Création du devis

Le shopper renseigne :

* prix du produit ;
* devise ;
* quantité ;
* frais du marchand ;
* taux de change applicable ;
* commission ;
* transport estimé ;
* livraison locale ;
* autres frais ;
* délai estimé ;
* durée de validité ;
* type de paiement.

Le système calcule :

* sous-total ;
* conversion en ariary ;
* total des frais ;
* montant final ;
* montant à payer.

---

## 6.4 Achat

Lorsque le paiement est confirmé, le shopper peut :

* passer la commande auprès du marchand ;
* enregistrer le montant réel ;
* enregistrer le numéro de commande marchand ;
* ajouter la facture ;
* ajouter le numéro de suivi ;
* renseigner la date d’achat ;
* renseigner la date estimée de réception.

## Incidents possibles

Le shopper peut déclarer :

* produit indisponible ;
* hausse de prix ;
* mauvaise variante ;
* annulation du vendeur ;
* remboursement du marchand ;
* commande partiellement disponible.

---

# 7. Parcours logistique

## 7.1 Réception à l’entrepôt

L’agent peut rechercher une commande avec :

* son numéro ;
* le nom du client ;
* le numéro marchand ;
* le numéro de suivi ;
* un QR code.

Il peut ensuite :

* confirmer la réception ;
* ajouter des photos ;
* renseigner le poids réel ;
* renseigner l’état du colis ;
* ajouter un commentaire ;
* signaler un produit manquant ou endommagé.

---

## 7.2 Expédition

L’agent peut :

* sélectionner une ou plusieurs commandes ;
* enregistrer une référence d’expédition ;
* renseigner la date de départ ;
* renseigner la date estimée d’arrivée ;
* confirmer l’expédition vers Madagascar.

La gestion avancée du regroupement est hors MVP.

---

## 7.3 Arrivée à Madagascar

L’agent peut :

* confirmer l’arrivée ;
* signaler un blocage ;
* affecter une livraison ;
* indiquer que le colis est prêt au retrait.

---

## 7.4 Livraison

L’agent peut :

* consulter l’adresse ;
* appeler le client ;
* saisir le code de livraison ;
* confirmer la remise ;
* ajouter une preuve facultative ;
* signaler un échec de livraison.

---

# 8. Paiement Mobile Money

## 8.1 Principes

Les opérateurs intégrés dans le MVP sont :

* MVola ;
* Orange Money ;
* Airtel Money.

L’intégration doit être totalement agnostique.

Le reste du système ne doit contenir aucune logique métier propre à un opérateur.

```text
Application Flutter
        ↓
API interne
        ↓
Payment Orchestrator
 ├── MVola Adapter
 ├── Orange Money Adapter
 └── Airtel Money Adapter
```

Flutter ne communique jamais directement avec les opérateurs.

---

## 8.2 Interface commune

Chaque fournisseur implémente une interface commune :

```text
PaymentProvider
- createPayment()
- getPaymentStatus()
- cancelPayment()
- refundPayment()
- verifyWebhook()
- normalizeWebhook()
- getCapabilities()
```

---

## 8.3 Capacités des fournisseurs

Chaque adapter déclare ses capacités :

```text
supportsCollection
supportsRefund
supportsPartialRefund
supportsCancellation
supportsWebhook
supportsPolling
supportsRedirect
supportsOtp
supportsPushConfirmation
```

L’application adapte son interface aux capacités disponibles.

---

## 8.4 Payment Intent

Le `PaymentIntent` représente le montant que la plateforme veut encaisser.

```text
PaymentIntent
- id
- orderId
- customerId
- amount
- currency
- purpose
- status
- expiresAt
- createdAt
- updatedAt
```

Un `PaymentIntent` est indépendant de l’opérateur.

---

## 8.5 Payment Attempt

Chaque tentative est enregistrée séparément.

```text
PaymentAttempt
- id
- paymentIntentId
- provider
- phoneNumber
- providerTransactionId
- providerReference
- status
- failureCode
- failureMessage
- initiatedAt
- completedAt
```

Un même paiement peut avoir plusieurs tentatives.

```text
PaymentIntent PI-001
├── MVola : échec
└── Orange Money : succès
```

---

## 8.6 Statuts internes

```text
CREATED
PENDING
PROCESSING
SUCCEEDED
FAILED
EXPIRED
CANCELLED
STATUS_UNKNOWN
REFUND_PENDING
PARTIALLY_REFUNDED
REFUNDED
```

Chaque adapter traduit les statuts propres à l’opérateur vers ces statuts internes.

---

## 8.7 Confirmation du paiement

Un paiement peut être confirmé à partir :

* d’un webhook valide ;
* d’une interrogation serveur du statut ;
* d’une réconciliation automatique.

La plateforme doit gérer :

* les webhooks reçus plusieurs fois ;
* les webhooks reçus dans le désordre ;
* les délais de réponse ;
* les statuts inconnus ;
* les erreurs temporaires ;
* les paiements réussis après expiration apparente.

---

## 8.8 Idempotence

Chaque création de paiement utilise une clé d’idempotence.

Une répétition d’une même requête ne doit jamais créer deux débits.

Exemple :

```text
Idempotency-Key:
payment-intent-pi_001-attempt-01
```

Les webhooks doivent également être traités de façon idempotente.

---

## 8.9 Bascule entre opérateurs

Lorsqu’un opérateur est indisponible :

* il peut être désactivé depuis l’administration ;
* il n’est plus proposé au client ;
* les autres opérateurs restent disponibles ;
* les paiements en cours continuent d’être suivis ;
* aucune modification du code métier principal n’est nécessaire.

---

## 8.10 Remboursements

Le système permet :

* remboursement total ;
* remboursement partiel si supporté ;
* remboursement manuel si l’API ne le permet pas.

Tout remboursement exige :

* un motif ;
* un opérateur ;
* un montant ;
* une validation administrateur ;
* une trace d’audit.

---

## 8.11 Réconciliation

Une tâche planifiée vérifie régulièrement les paiements :

```text
PENDING
PROCESSING
STATUS_UNKNOWN
```

Elle interroge l’opérateur et corrige le statut interne si nécessaire.

Une commande ne peut être marquée payée qu’une seule fois.

---

# 9. Gestion des fournisseurs externes

## Abstraction obligatoire

Les dépendances externes doivent être isolées derrière des interfaces.

Cela concerne :

* Mobile Money ;
* notifications SMS ;
* notifications push ;
* stockage de fichiers ;
* e-mail ;
* éventuels services d’intelligence artificielle.

## Intelligence artificielle

Aucune fonctionnalité critique du MVP ne dépend d’une IA.

Le MVP doit fonctionner entièrement sans abonnement ou fournisseur d’IA.

Une IA pourra être utilisée ultérieurement pour :

* extraire des informations depuis un lien ;
* reconnaître un produit depuis une capture ;
* suggérer une catégorie ;
* aider le support ;
* détecter des anomalies.

Toute fonctionnalité IA devra passer par une interface commune :

```text
AIProvider
- extractProductData()
- classifyProduct()
- summarizeConversation()
```

Adapters possibles :

```text
OpenAIAdapter
AnthropicAdapter
GeminiAdapter
LocalModelAdapter
NoAIAdapter
```

En cas de suppression de l’abonnement ou de changement de fournisseur, les workflows principaux restent fonctionnels.

---

# 10. Back-office dans l’application unique

L’espace administrateur est disponible principalement sur Flutter Web.

## Dashboard

Il affiche :

* nouvelles demandes ;
* devis en attente ;
* paiements en attente ;
* paiements échoués ;
* commandes à acheter ;
* colis attendus ;
* commandes en transit ;
* commandes en retard ;
* commandes livrées ;
* remboursements en attente.

## Gestion des demandes

L’administrateur peut :

* consulter toutes les demandes ;
* attribuer un shopper ;
* changer le statut ;
* consulter les messages ;
* annuler une demande.

## Gestion des paiements

L’administrateur peut :

* consulter les Payment Intents ;
* consulter les tentatives ;
* afficher la réponse normalisée ;
* consulter les événements opérateurs ;
* relancer une vérification ;
* désactiver un opérateur ;
* déclencher un remboursement ;
* enregistrer un remboursement manuel.

## Paramètres

* taux de change ;
* commissions ;
* frais fixes ;
* frais de livraison ;
* durée de validité des devis ;
* opérateurs actifs ;
* limites de paiement ;
* produits interdits ;
* textes de notification.

---

# 11. Notifications

## Canaux du MVP

* notifications push ;
* notifications dans l’application ;
* SMS pour les événements critiques.

## Événements

* compte créé ;
* devis disponible ;
* devis bientôt expiré ;
* paiement demandé ;
* paiement confirmé ;
* paiement échoué ;
* produit acheté ;
* colis reçu ;
* colis expédié ;
* colis arrivé ;
* livraison disponible ;
* commande livrée ;
* remboursement effectué ;
* nouveau message.

---

# 12. Modèle de données

## User

```text
id
phoneNumber
email
firstName
lastName
status
createdAt
updatedAt
```

## UserRole

```text
userId
role
createdAt
```

## Address

```text
id
userId
recipientName
phoneNumber
city
district
street
instructions
latitude
longitude
```

## ProductRequest

```text
id
customerId
assignedShopperId
sourceUrl
storeName
title
description
quantity
variant
displayedPrice
displayedCurrency
budgetLimit
status
createdAt
updatedAt
```

## ProductRequestMedia

```text
id
productRequestId
type
url
createdAt
```

## Quote

```text
id
productRequestId
version
productAmount
sourceCurrency
exchangeRate
merchantFees
serviceFee
estimatedTransport
localDeliveryFee
otherFees
totalAmountMGA
paymentType
expiresAt
status
createdBy
createdAt
```

## Order

```text
id
orderNumber
customerId
shopperId
quoteId
totalAmount
paidAmount
status
createdAt
updatedAt
```

## Purchase

```text
id
orderId
merchantName
merchantOrderNumber
actualAmount
currency
receiptUrl
trackingNumber
purchasedAt
estimatedWarehouseArrival
status
```

## PaymentIntent

```text
id
orderId
customerId
amount
currency
purpose
status
expiresAt
createdAt
updatedAt
```

## PaymentAttempt

```text
id
paymentIntentId
provider
phoneNumber
externalTransactionId
externalReference
status
failureCode
failureMessage
createdAt
completedAt
```

## PaymentEvent

```text
id
paymentAttemptId
provider
externalEventId
eventType
normalizedStatus
sanitizedPayload
receivedAt
processedAt
```

## TrackingEvent

```text
id
orderId
status
description
location
isVisibleToCustomer
createdBy
createdAt
```

## Message

```text
id
productRequestId
senderId
type
content
attachmentUrl
createdAt
readAt
```

## AuditLog

```text
id
actorId
action
entityType
entityId
oldValue
newValue
ipAddress
createdAt
```

---

# 13. Statuts métier

## ProductRequest

```text
DRAFT
SUBMITTED
ASSIGNED
QUOTE_PREPARING
QUOTE_AVAILABLE
QUOTE_ACCEPTED
QUOTE_REJECTED
QUOTE_EXPIRED
CANCELLED
```

## Order

```text
PAYMENT_PENDING
PAID
PURCHASE_IN_PROGRESS
PURCHASED
MERCHANT_SHIPPING
WAREHOUSE_RECEIVED
INTERNATIONAL_TRANSIT
ARRIVED_IN_MADAGASCAR
READY_FOR_DELIVERY
OUT_FOR_DELIVERY
DELIVERED
CANCELLED
REFUND_PENDING
REFUNDED
ISSUE_REPORTED
```

Les transitions sont contrôlées par le backend.

---

# 14. Écrans du MVP

## Écrans communs

1. Splash screen
2. Connexion
3. Vérification OTP
4. Création du profil
5. Sélection de l’espace
6. Notifications
7. Profil
8. Paramètres

## Espace client

1. Accueil
2. Nouvelle demande
3. Ajout des détails
4. Ajout des images
5. Liste des demandes
6. Détail de la demande
7. Consultation du devis
8. Choix du moyen de paiement
9. Paiement en cours
10. Résultat du paiement
11. Liste des commandes
12. Suivi de commande
13. Messagerie
14. Adresse de livraison
15. Confirmation de réception
16. Signalement d’un problème

## Espace shopper

1. Dashboard
2. Demandes attribuées
3. Détail d’une demande
4. Création du devis
5. Modification du devis
6. Commandes à acheter
7. Confirmation de l’achat
8. Ajout de facture
9. Mise à jour du suivi
10. Messagerie

## Espace logistique

1. Dashboard
2. Colis attendus
3. Recherche et scan
4. Détail du colis
5. Confirmation de réception
6. Saisie du poids
7. Confirmation d’expédition
8. Confirmation d’arrivée
9. Livraison
10. Preuve de livraison

## Espace administrateur

1. Dashboard
2. Demandes
3. Devis
4. Commandes
5. Paiements
6. Détail d’un paiement
7. Remboursements
8. Utilisateurs
9. Attribution des rôles
10. Taux de change
11. Commissions
12. Configuration des opérateurs
13. Journaux d’audit
14. Exports

---

# 15. Architecture Flutter

## Structure

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── bootstrap/
│
├── core/
│   ├── auth/
│   ├── networking/
│   ├── storage/
│   ├── permissions/
│   ├── errors/
│   └── configuration/
│
├── shared/
│   ├── design_system/
│   ├── widgets/
│   ├── models/
│   └── localization/
│
├── features/
│   ├── authentication/
│   ├── product_requests/
│   ├── quotations/
│   ├── orders/
│   ├── payments/
│   ├── purchases/
│   ├── tracking/
│   ├── messaging/
│   ├── logistics/
│   └── notifications/
│
└── spaces/
    ├── customer/
    ├── shopper/
    ├── logistics/
    └── admin/
```

## Technologies

* Flutter ;
* Dart ;
* Riverpod ;
* GoRouter ;
* Dio ;
* Freezed ;
* json_serializable ;
* Flutter Secure Storage ;
* Drift pour le cache local ;
* Firebase Cloud Messaging ;
* Sentry ;
* intl.

---

# 16. Backend

## Stack recommandée

```text
NestJS
PostgreSQL
Redis
Stockage S3
WebSocket
Worker de tâches
Firebase Cloud Messaging
```

## Modules backend

```text
Auth Module
Users Module
Permissions Module
Product Requests Module
Quotes Module
Orders Module
Payments Module
Purchases Module
Logistics Module
Messaging Module
Notifications Module
Audit Module
```

## Module paiement

```text
Payments
├── Domain
├── Application
├── Infrastructure
│   ├── MVola Adapter
│   ├── Orange Money Adapter
│   └── Airtel Money Adapter
└── Webhooks
```

---

# 17. API principales

## Authentification

```text
POST /auth/request-otp
POST /auth/verify-otp
POST /auth/refresh
POST /auth/logout
GET  /me
```

## Demandes

```text
POST  /product-requests
GET   /product-requests
GET   /product-requests/{id}
PATCH /product-requests/{id}
POST  /product-requests/{id}/media
POST  /product-requests/{id}/assign
```

## Devis

```text
POST /product-requests/{id}/quotes
GET  /quotes/{id}
POST /quotes/{id}/accept
POST /quotes/{id}/reject
POST /quotes/{id}/revise
```

## Commandes

```text
GET  /orders
GET  /orders/{id}
POST /orders/{id}/cancel
POST /orders/{id}/tracking-events
```

## Paiements

```text
POST /payment-intents
GET  /payment-intents/{id}
POST /payment-intents/{id}/attempts
GET  /payment-attempts/{id}
POST /payment-attempts/{id}/refresh
POST /payments/{id}/refund
```

## Webhooks

```text
POST /webhooks/mvola
POST /webhooks/orange-money
POST /webhooks/airtel-money
```

## Achats

```text
POST /orders/{id}/purchase
PATCH /purchases/{id}
POST /purchases/{id}/receipt
```

## Logistique

```text
POST /orders/{id}/warehouse-receipt
POST /orders/{id}/shipment
POST /orders/{id}/arrival
POST /orders/{id}/delivery
```

## Messagerie

```text
GET  /product-requests/{id}/messages
POST /product-requests/{id}/messages
```

---

# 18. Sécurité

Le MVP doit inclure :

* authentification OTP ;
* contrôle des permissions côté backend ;
* access tokens courts ;
* refresh tokens rotatifs ;
* chiffrement des secrets ;
* secrets opérateurs uniquement côté serveur ;
* vérification des signatures de webhook ;
* idempotence ;
* limitation des requêtes ;
* journal d’audit ;
* protection contre les doublons de paiement ;
* validation des fichiers envoyés ;
* masquage des données sensibles ;
* sauvegardes automatiques ;
* double validation des remboursements importants.

---

# 19. Contraintes non fonctionnelles

## Disponibilité

L’indisponibilité d’un opérateur ne doit pas empêcher les autres moyens de paiement de fonctionner.

## Performance

* affichage initial inférieur à 3 secondes dans des conditions normales ;
* pagination des listes ;
* compression des images ;
* cache local ;
* chargement progressif.

## Réseau instable

L’application doit :

* conserver les dernières données consultées ;
* reprendre un upload interrompu ;
* afficher clairement les erreurs réseau ;
* permettre de réessayer une action ;
* empêcher les doubles soumissions.

## Traçabilité

Toutes les actions importantes doivent être historisées :

* création ou modification d’un devis ;
* changement de statut ;
* confirmation de paiement ;
* remboursement ;
* attribution d’un rôle ;
* validation d’une livraison.

---

# 20. Hors périmètre du MVP

Ne font pas partie du MVP :

* catalogue de produits ;
* marketplace ouverte de shoppers ;
* notation publique ;
* avis clients ;
* fidélité ;
* coupons ;
* cashback ;
* parrainage ;
* portefeuille interne ;
* paiement en plusieurs fois ;
* regroupement avancé de colis ;
* gestion de plusieurs entrepôts ;
* tracking automatique de tous les transporteurs ;
* calcul automatique de la douane ;
* comparaison automatique des boutiques ;
* extraction obligatoire par IA ;
* appels audio ou vidéo ;
* abonnement premium ;
* crédit client ;
* comptabilité complète ;
* application séparée pour chaque rôle.

---

# 21. Critères de validation du MVP

Le MVP est validé lorsque :

1. un client peut créer une demande avec un lien et des photos ;
2. un shopper peut créer un devis ;
3. le client peut accepter le devis ;
4. le client peut payer par MVola, Orange Money ou Airtel Money ;
5. le backend peut confirmer le statut réel du paiement ;
6. un échec chez un opérateur n’empêche pas l’utilisation des autres ;
7. le shopper peut confirmer l’achat ;
8. l’agent logistique peut confirmer la réception ;
9. l’agent peut enregistrer l’expédition vers Madagascar ;
10. le client peut suivre la commande ;
11. l’agent peut confirmer la livraison ;
12. toutes les actions sensibles sont journalisées ;
13. chaque rôle ne peut accéder qu’à ses fonctionnalités autorisées ;
14. le produit reste utilisable sans aucun fournisseur d’IA ;
15. un opérateur de paiement peut être remplacé sans modifier le domaine métier principal.

---

# 22. Résumé du MVP

```text
Une seule application Flutter
Quatre espaces selon les rôles
Un backend unique
Trois opérateurs Mobile Money
Une couche de paiement agnostique
Aucune dépendance métier critique à une IA
Un workflow centré sur :
Demande → Devis → Paiement → Achat → Transport → Livraison
```
