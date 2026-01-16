/**
 * Script Node.js pour peupler Firestore avec les espèces de créatures
 * 
 * Installation:
 *   cd scripts
 *   npm install firebase-admin
 * 
 * Configuration:
 *   1. Allez dans Firebase Console > Project Settings > Service Accounts
 *   2. Cliquez "Generate new private key"
 *   3. Sauvegardez le fichier JSON comme "serviceAccountKey.json" dans ce dossier
 * 
 * Images:
 *   Placez vos images dans le dossier "images/" avec le format:
 *   - {speciesId}.png pour l'image principale
 *   - {speciesId}_parc.png pour l'image du parc
 * 
 * Usage:
 *   node seed_creatures.js
 */

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// ═══════════════════════════════════════════
// CONFIGURATION GITHUB POUR LES IMAGES
// ═══════════════════════════════════════════

// Ces valeurs peuvent être surchargées via les variables d'environnement :
// GITHUB_OWNER, GITHUB_REPO, GITHUB_BRANCH, GITHUB_IMAGE_PATH
const GITHUB_CONFIG = {
    owner: process.env.GITHUB_OWNER || 'EdouardSence',        // Ton username GitHub
    repo: process.env.GITHUB_REPO || 'MOONGO',               // Nom du repo
    branch: process.env.GITHUB_BRANCH || 'master',             // Branche
    imagePath: process.env.GITHUB_IMAGE_PATH || 'scripts/images'   // Chemin vers les images dans le repo
};

// Génère l'URL raw GitHub pour une image
function getGitHubImageUrl(filename) {
    return `https://raw.githubusercontent.com/${GITHUB_CONFIG.owner}/${GITHUB_CONFIG.repo}/${GITHUB_CONFIG.branch}/${GITHUB_CONFIG.imagePath}/${filename}`;
}

// ═══════════════════════════════════════════
// INITIALISATION FIREBASE
// ═══════════════════════════════════════════

const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');

if (!fs.existsSync(serviceAccountPath)) {
    console.error('❌ Error / Erreur: serviceAccountKey.json not found / non trouvé!');
    console.log('');
    console.log('To get this file / Pour obtenir ce fichier:');
    console.log('1. Go to Firebase Console > Project Settings > Service Accounts');
    console.log('   Allez dans Firebase Console > Project Settings > Service Accounts');
    console.log('2. Click "Generate new private key"');
    console.log('   Cliquez "Generate new private key"');
    console.log('3. Save the JSON file as "serviceAccountKey.json" in the scripts/ folder');
    console.log('   Sauvegardez le fichier JSON comme "serviceAccountKey.json" dans le dossier scripts/');
    process.exit(1);
}

const serviceAccount = require(serviceAccountPath);

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// ═══════════════════════════════════════════
// DÉTECTION DES IMAGES LOCALES
// ═══════════════════════════════════════════

function detectImages() {
    const imagesDir = path.join(__dirname, 'images');
    const imageMap = {};

    if (!fs.existsSync(imagesDir)) {
        console.log('⚠️  Dossier images/ non trouvé. Les URLs d\'images seront vides.');
        return imageMap;
    }

    const files = fs.readdirSync(imagesDir);

    for (const file of files) {
        const ext = path.extname(file).toLowerCase();
        if (!['.png', '.jpg', '.jpeg', '.webp', '.gif'].includes(ext)) continue;

        const basename = path.basename(file, ext);

        // Détecter si c'est une image parc (se termine par _parc)
        if (basename.endsWith('_parc')) {
            const speciesId = basename.replace('_parc', '');
            if (!imageMap[speciesId]) imageMap[speciesId] = {};
            imageMap[speciesId].parcPicture = file;
        } else {
            const speciesId = basename;
            if (!imageMap[speciesId]) imageMap[speciesId] = {};
            imageMap[speciesId].basePicture = file;
        }
    }

    return imageMap;
}

// ═══════════════════════════════════════════
// SEED FIRESTORE
// ═══════════════════════════════════════════

async function seedCreatures() {
    console.log('🚀 Connexion à Firestore...');
    console.log('');

    // Détecter les images locales
    console.log('🖼️  Détection des images...');
    const imageMap = detectImages();
    const imagesFound = Object.keys(imageMap).length;

    if (imagesFound > 0) {
        console.log(`   ✓ ${imagesFound} espèces avec images trouvées`);
        for (const [speciesId, images] of Object.entries(imageMap)) {
            const parts = [];
            if (images.basePicture) parts.push('base');
            if (images.parcPicture) parts.push('parc');
            console.log(`     - ${speciesId}: ${parts.join(', ')}`);
        }
    } else {
        console.log('   ⚠️  Aucune image trouvée dans images/');
    }
    console.log('');

    // Charger les espèces depuis le fichier JSON
    const speciesData = require('./creature_species.json');

    const batch = db.batch();
    let count = 0;

    console.log('📦 Ajout des espèces à Firestore...');

    for (const [speciesId, data] of Object.entries(speciesData)) {
        // Ajouter les URLs d'images si disponibles
        const speciesImages = imageMap[speciesId] || {};

        const documentData = {
            ...data,
            basePicture: speciesImages.basePicture
                ? getGitHubImageUrl(speciesImages.basePicture)
                : data.basePicture || '',
            parcPicture: speciesImages.parcPicture
                ? getGitHubImageUrl(speciesImages.parcPicture)
                : data.parcPicture || '',
        };

        const docRef = db.collection('creature_species').doc(speciesId);
        batch.set(docRef, documentData);

        // Afficher le status
        const hasBase = documentData.basePicture ? '🖼️' : '  ';
        const hasParc = documentData.parcPicture ? '🏞️' : '  ';
        console.log(`  ${hasBase}${hasParc} ${speciesId} (${data.baseRarity})`);
        count++;
    }

    await batch.commit();

    console.log('');
    console.log(`✅ ${count} espèces ajoutées avec succès!`);
    console.log('');

    // Résumé par rareté
    const rarityCount = {};
    for (const data of Object.values(speciesData)) {
        rarityCount[data.baseRarity] = (rarityCount[data.baseRarity] || 0) + 1;
    }

    console.log('📊 Résumé par rareté:');
    const emojis = { common: '⚪', rare: '🔵', epic: '🟣', legendary: '🟡' };
    for (const [rarity, count] of Object.entries(rarityCount)) {
        console.log(`   ${emojis[rarity] || '❓'} ${rarity}: ${count}`);
    }

    // Résumé des images
    const withImages = Object.keys(imageMap).length;
    const total = Object.keys(speciesData).length;
    console.log('');
    console.log('🖼️  Images:');
    console.log(`   ${withImages}/${total} espèces avec images`);

    if (withImages < total) {
        console.log('');
        console.log('💡 Pour ajouter des images:');
        console.log('   1. Placez vos fichiers PNG dans scripts/images/');
        console.log('   2. Nommez-les: {speciesId}.png et {speciesId}_parc.png');
        console.log('   3. Commitez et pushez sur GitHub');
        console.log('   4. Relancez ce script');
    }

    process.exit(0);
}

seedCreatures().catch((error) => {
    console.error('❌ Erreur:', error);
    process.exit(1);
});
