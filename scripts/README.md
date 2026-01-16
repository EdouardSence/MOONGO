# Scripts MOONGO

## Peupler Firestore avec les créatures

### 1. Installation

```bash
cd scripts
npm install firebase-admin
```

### 2. Configuration Firebase

1. Allez dans [Firebase Console](https://console.firebase.google.com)
2. **Project Settings** > **Service Accounts**
3. Cliquez **"Generate new private key"**
4. Sauvegardez le fichier comme `scripts/serviceAccountKey.json`

⚠️ **IMPORTANT**: Ne commitez JAMAIS ce fichier ! Il est dans le `.gitignore`.

### 3. Ajouter des images (optionnel)

Placez vos images dans le dossier `scripts/images/` :

```
images/
├── moongo.png          # Image principale de Moongo
├── moongo_parc.png     # Image parc de Moongo (petite)
├── seedling.png
├── seedling_parc.png
├── dragon.png
├── dragon_parc.png
└── ...
```

**Convention de nommage:**

- `{speciesId}.png` → Image principale (grande)
- `{speciesId}_parc.png` → Image du parc (petite)

Les URLs seront générées automatiquement depuis GitHub Raw.

### 4. Exécuter le script

```bash
node seed_creatures.js
```

**Sortie attendue:**

```
🚀 Connexion à Firestore...

🖼️  Détection des images...
   ✓ 3 espèces avec images trouvées
     - moongo: base, parc
     - dragon: base
     - phoenix: base, parc

📦 Ajout des espèces à Firestore...
  🖼️🏞️ moongo (common)
      seedling (common)
  🖼️   dragon (legendary)
  ...

✅ 16 espèces ajoutées avec succès!

📊 Résumé par rareté:
   ⚪ common: 5
   🔵 rare: 4
   🟣 epic: 3
   🟡 legendary: 4

🖼️  Images:
   3/16 espèces avec images
```

### 5. Workflow complet

1. **Ajouter/modifier** `creature_species.json`
2. **Ajouter des images** dans `images/`
3. **Commit & Push** sur GitHub
4. **Exécuter** `node seed_creatures.js`

Les images seront accessibles via:

```
https://raw.githubusercontent.com/EdouardSence/MOONGO/master/scripts/images/{filename}
```

## Structure Firestore

```
creature_species/
├── moongo/
│   ├── speciesId: "moongo"
│   ├── evolutionNames: ["Moongo", "Ivy", "Daisy"]
│   ├── evolutionLevels: [10, 25]
│   ├── evolutionEmojis: ["🌱", "🌿", "🌸"]
│   ├── baseLevel: 1
│   ├── basePicture: "https://raw.githubusercontent.com/..."
│   ├── parcPicture: "https://raw.githubusercontent.com/..."
│   └── baseRarity: "common"
```
