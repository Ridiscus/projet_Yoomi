# 🚀 Projet de Gestion de Projets (NestJS + Flutter)

Ce projet est une application complète composée d’un backend en NestJS et d’un frontend mobile en Flutter, permettant de gérer des projets avec création, mise à jour, suppression et affichage.

---

## 📂 Structure du projet

. ├── backend/           # API NestJS │   ├── src/ │   │   ├── projects/  # Module projet (CRUD) │   │   ├── app.module.ts │   │   └── main.ts │   ├── test/          # Tests unitaires │   ├── package.json │   └── README.md │ ├── frontend/          # Application mobile Flutter │   ├── lib/ │   │   ├── models/    # Modèles de données │   │   ├── providers/ # State management avec Riverpod │   │   ├── repo/      # Communication avec l’API │   │   └── screens/   # Interfaces utilisateur │   ├── pubspec.yaml │   └── README.md │ └── README.md          # Ce fichier (documentation générale)


➡️ L’API est accessible sur : http://localhost:5555/projects


---
## 🚀 Installation de Git vers votre machine local
`bash(cmd)
git clone https://github.com/Ridiscus/projet_Yoomi.git




## ⚙️ Installation et exécution
2️⃣ Frontend (Flutter)
bash(cmd)
cd projet_Yoomi
cd frontend
flutter pub get
flutter run (veuillez le lancer sur un emulateur ou appareil android)


---
### 1️⃣ Backend (NestJS)
`bash
cd projet_Yoomi
cd backend
npm install
npx prisma generate (lancer cette commande pour generer le client prisma)
npm run start:dev
npx prisma db seed (veuillez utilisez un second CMD puis mettez vous dans le repertoire du backend encore une fois de plus[cd backend] et executez la commande elle permettra automatiquement de peupler la base de données avec des données de test.
npx prisma studio (cette commande vous permettra d'acceder a l'interface graphique web de prisma afin d'interagir avec la base de données).



➡️ L’application consomme directement l’API exposée par NestJS.
⚠️ Assurez-vous de mettre à jour la BASE_URL dans services/project_repository.dart avec l’IP de votre machine (exemple : http://192.168.1.69:5555/projects).

pour determiner l'IP de votre machine : ouvrez le CMD sur windows en admin et tapez ipconfig ensuite cherchez l'adresse IPV4 de votre machine connecté au réseau WiFi le mien est : 192.168.1.69  (pour tester le front-end assurez-vous que votre telephone partage le même réseau WiFi que votre machine Windows)




🔑 Endpoints principaux

GET /projects : Récupérer tous les projets

POST /projects : Créer un projet

PUT /projects/:id : Mettre à jour un projet

DELETE /projects/:id : Supprimer un projet




✅ Fonctionnalités

📌 Backend (NestJS)

Création d’un projet

Mise à jour d’un projet

Suppression d’un projet

Récupération de la liste des projets

Stockage en mémoire (ou DB si ajoutée)





📱 Frontend (Flutter)

Liste des projets

Ajout d’un projet

Modification d’un projet

Suppression d’un projet

Gestion de l’état avec Riverpod

UI responsive et simple




---

🛠️ Technologies utilisées

Backend : NestJS, TypeScript

Frontend : Flutter, Dart, Riverpod

Communication : REST API (HTTP)

Gestion de version : Git & GitHub



---

👨‍💻 Déploiement

1. Push du code sur GitHub :



git add .
git commit -m "Initial commit"
git push origin main


📜 Licence

Projet éducatif pour test technique. Libre d’utilisation et d’adaptation.


---

✨ Auteurs

TOE SID HAMED ROBINSON – Développeur Backend & Frontend
