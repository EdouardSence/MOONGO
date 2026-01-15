import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:moongo/models/creature_model.dart';

/// Cache manager personnalisé pour les images de créatures
/// - Durée de cache : 7 jours
/// - Vérifie les mises à jour après 1 jour (stale-while-revalidate)
class CreatureImageCacheManager {
  static const key = 'creatureImageCache';

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7), // Garde en cache 7 jours
      maxNrOfCacheObjects: 100, // Max 100 images en cache
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

/// Widget pour afficher l'image d'une créature avec fallback sur l'emoji
class CreatureImage extends StatelessWidget {
  final CreatureModel creature;
  final double size;
  final bool useParcImage; // true = petite image, false = grande image
  final BoxFit fit;

  const CreatureImage({
    super.key,
    required this.creature,
    this.size = 60,
    this.useParcImage = false,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        useParcImage ? creature.parcPictureUrl : creature.basePictureUrl;

    // Vérifier que l'URL est valide (non vide et commence par http)
    final hasValidUrl = imageUrl != null &&
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    if (hasValidUrl) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        cacheManager: CreatureImageCacheManager.instance,
        cacheKey: '${creature.speciesId}_${useParcImage ? 'parc' : 'base'}',
        width: size,
        height: size,
        fit: fit,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) {
          return _buildFallbackEmoji();
        },
      );
    }

    return _buildFallbackEmoji();
  }

  Widget _buildPlaceholder() {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: SizedBox(
          width: size * 0.4,
          height: size * 0.4,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackEmoji() {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          creature.emoji,
          style: TextStyle(fontSize: size * 0.55),
        ),
      ),
    );
  }
}

/// Version avec container décoré (cercle avec glow)
class CreatureImageWithGlow extends StatelessWidget {
  final CreatureModel creature;
  final double size;
  final bool useParcImage;

  const CreatureImageWithGlow({
    super.key,
    required this.creature,
    this.size = 60,
    this.useParcImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = CreatureModel.rarityColors[creature.rarity]!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl =
        useParcImage ? creature.parcPictureUrl : creature.basePictureUrl;

    // Vérifier que l'URL est valide (non vide et commence par http)
    final hasValidUrl = imageUrl != null &&
        imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDark ? 0.15 : 0.5),
        shape: BoxShape.circle,
        border: Border.all(
          color: Color(colors[0]).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(colors[0]).withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipOval(
        child: hasValidUrl
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                cacheManager: CreatureImageCacheManager.instance,
                cacheKey:
                    '${creature.speciesId}_${useParcImage ? 'parc' : 'base'}',
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPlaceholder(),
                errorWidget: (context, url, error) => _buildFallbackEmoji(),
              )
            : _buildFallbackEmoji(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: SizedBox(
        width: size * 0.4,
        height: size * 0.4,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white54),
        ),
      ),
    );
  }

  Widget _buildFallbackEmoji() {
    return Center(
      child: Text(
        creature.emoji,
        style: TextStyle(fontSize: size * 0.55),
      ),
    );
  }
}
