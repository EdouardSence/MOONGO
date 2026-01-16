import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

  @override
  Widget builder(
      BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Message de bienvenue
            Text(
              viewModel.loginMode
                  ? 'Bienvenue sur Moongo !\nVeuillez vous connecter.'
                  : 'Bienvenue sur Moongo !\nVeuillez créer un compte.',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            // Champ Email
            TextField(
              onChanged: viewModel.setEmail,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'exemple@email.com',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Champ Mot de passe
            TextField(
              onChanged: viewModel.setPassword,
              obscureText: viewModel.isPasswordVisible ? false : true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                hintText: 'Entrez votre mot de passe',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    viewModel.isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    viewModel.togglePasswordVisibility();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Affichage des erreurs
            if (viewModel.errorMessage != null)
              Text(
                viewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            // Bouton Login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () => viewModel.runLoginLogic(),
                child: viewModel.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        viewModel.loginMode
                            ? 'Se connecter'
                            : 'Créer un compte',
                      ),
              ),
            ),
            Row(
              children: [
                Text(
                  viewModel.loginMode
                      ? 'Pas encore de compte ?'
                      : 'Déjà un compte ?',
                ),
                TextButton(
                  onPressed: () {
                    viewModel.toggleLoginMode();
                  },
                  child: Text(
                    viewModel.loginMode ? 'Inscription' : 'Connexion',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(BuildContext context) => LoginViewModel();
}
