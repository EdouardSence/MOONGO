import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moongo/ui/common/app_theme.dart';
import 'package:stacked/stacked.dart';

import '_widgets/profile_widgets.dart';
import 'profile_viewmodel.dart';

/// Profile View avec esthétique "Carte d'Aventurier" - Style parchemin héroïque
class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({super.key});

  @override
  Widget builder(
      BuildContext context, ProfileViewModel viewModel, Widget? child) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final birthDateText = viewModel.user?.birthDate == null
        ? null
        : viewModel.formatDate(viewModel.user!.birthDate!);
    final memberSinceText =
        viewModel.formatMemberSince(viewModel.user?.createdAt);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Fond avec texture parchemin
          ProfileBackground(isDark: isDark),

          // Contenu
          viewModel.isBusy
              ? const LoadingState(
                  emoji: '📜',
                  message: 'Consultation du grimoire...',
                )
              : CustomScrollView(
                  slivers: [
                    // En-tête héroïque
                    SliverToBoxAdapter(
                      child: ProfileHeroHeader(
                        viewModel: viewModel,
                        onSettingsTap: () =>
                            _showSettingsSheet(context, viewModel),
                        onAvatarTap: () =>
                            _showAvatarPicker(context, viewModel),
                        birthDateText: birthDateText,
                      ),
                    ),

                    // Carte de flamme (streak)
                    SliverToBoxAdapter(
                      child: FlameCard(
                        currentStreak: viewModel.user?.currentStreak ?? 0,
                        longestStreak: viewModel.user?.longestStreak ?? 0,
                      ),
                    ),

                    // Statistiques d'aventurier
                    SliverToBoxAdapter(
                      child: StatsSection(
                        viewModel: viewModel,
                        memberSinceText: memberSinceText,
                      ),
                    ),

                    // Actions
                    SliverToBoxAdapter(
                      child: ActionsSection(
                        onLogout: viewModel.logout,
                        isDark: isDark,
                      ),
                    ),

                    // Espace en bas
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 120),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  /// Sélecteur d'avatar
  void _showAvatarPicker(BuildContext context, ProfileViewModel viewModel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.grey.withValues(alpha: 0.6)
                      : Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('✨', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Text(
                    'Choisis ton emblème',
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: viewModel.availableAvatars.length,
                  itemBuilder: (context, index) {
                    final avatar = viewModel.availableAvatars[index];
                    final isSelected = avatar == viewModel.user?.avatarUrl;
                    return GestureDetector(
                      onTap: () {
                        viewModel.updateAvatar(avatar);
                        Navigator.pop(ctx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent.withValues(alpha: 0.15)
                              : (isDark
                                  ? AppColors.darkBackground
                                  : AppColors.lightBackground),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.transparent,
                            width: 2.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color:
                                        AppColors.accent.withValues(alpha: 0.3),
                                    blurRadius: 12,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(avatar,
                              style: const TextStyle(fontSize: 30)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  /// Sheet des paramètres
  void _showSettingsSheet(BuildContext context, ProfileViewModel viewModel) {
    final nameController =
        TextEditingController(text: viewModel.user?.displayName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final sheetIsDark = viewModel.isDarkMode;
          return Container(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
            decoration: BoxDecoration(
              color: sheetIsDark ? AppColors.darkSurface : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: sheetIsDark
                            ? Colors.grey.withValues(alpha: 0.6)
                            : Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Titre
                  Row(
                    children: [
                      const Text('⚙️', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Text(
                        'Paramètres',
                        style: GoogleFonts.fraunces(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: sheetIsDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Thème
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: sheetIsDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        Text(
                          sheetIsDark ? '🌙' : '☀️',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Thème',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: sheetIsDark
                                  ? AppColors.darkTextPrimary
                                      .withValues(alpha: 1)
                                  : AppColors.lightTextPrimary
                                      .withValues(alpha: 1),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: sheetIsDark
                                ? AppColors.darkSurface
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  viewModel.setDarkMode(false);
                                  setSheetState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: !sheetIsDark
                                        ? AppColors.tertiary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.light_mode_rounded,
                                    size: 20,
                                    color: !sheetIsDark
                                        ? Colors.white
                                        : Colors.grey.withValues(alpha: 1),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  viewModel.setDarkMode(true);
                                  setSheetState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: sheetIsDark
                                        ? AppColors.accent
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.dark_mode_rounded,
                                    size: 20,
                                    color: sheetIsDark
                                        ? Colors.white
                                        : Colors.grey.withValues(alpha: 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nom
                  TextField(
                    controller: nameController,
                    style: GoogleFonts.dmSans(
                      color: sheetIsDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nom d\'aventurier',
                      labelStyle: GoogleFonts.dmSans(
                        color: sheetIsDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      filled: true,
                      fillColor: sheetIsDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: AppColors.accent, width: 2),
                      ),
                      prefixIcon:
                          Icon(Icons.person_rounded, color: AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date de naissance
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate:
                            viewModel.user?.birthDate ?? DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: AppColors.accent,
                                onPrimary: Colors.white,
                                surface: sheetIsDark
                                    ? AppColors.darkSurface
                                    : Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        viewModel.updateBirthDate(date);
                        setSheetState(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: sheetIsDark
                            ? AppColors.darkBackground
                            : AppColors.lightBackground,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.cake_rounded, color: AppColors.tertiary),
                          const SizedBox(width: 14),
                          Text(
                            viewModel.user?.birthDate != null
                                ? viewModel
                                    .formatDate(viewModel.user!.birthDate!)
                                : 'Ajouter date de naissance',
                            style: GoogleFonts.dmSans(
                              color: viewModel.user?.birthDate != null
                                  ? (sheetIsDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary)
                                  : (sheetIsDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: sheetIsDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Sauvegarder
                  GestureDetector(
                    onTap: () {
                      viewModel.updateDisplayName(nameController.text);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.85)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('✨', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Text(
                            'Sauvegarder',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Supprimer compte
                  Center(
                    child: GestureDetector(
                      onTap: () => _showDeleteAccountDialog(ctx, viewModel),
                      child: Text(
                        'Supprimer mon compte',
                        style: GoogleFonts.dmSans(
                          color: Colors.red[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Dialogue de suppression de compte
  void _showDeleteAccountDialog(
      BuildContext context, ProfileViewModel viewModel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              'Supprimer le compte',
              style: GoogleFonts.fraunces(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer votre compte ?\n\nCette action est irréversible. Toutes vos données seront perdues.',
          style: GoogleFonts.dmSans(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: GoogleFonts.dmSans(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              viewModel.deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Supprimer',
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(BuildContext context) => ProfileViewModel();

  @override
  void onViewModelReady(ProfileViewModel viewModel) => viewModel.init();
}
