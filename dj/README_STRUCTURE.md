# Restructuration Responsive - Mobile & Web

## 📁 Nouvelle Architecture

```
lib/
│
├── layouts/                          # Layouts spécifiques par plateforme
│   ├── mobile/                       # Layout MOBILE
│   │   ├── pages/
│   │   │   ├── mobile_homepage.dart
│   │   │   ├── mobile_cart.dart
│   │   │   ├── mobile_profile.dart
│   │   │   └── ...
│   │   └── widgets/
│   │       ├── mobile_app_bar.dart
│   │       └── ...
│   │
│   └── web/                          # Layout WEB
│       ├── pages/
│       │   ├── web_homepage.dart
│       │   ├── web_cart.dart
│       │   ├── web_profile.dart
│       │   └── ...
│       └── widgets/
│           ├── web_navigation.dart
│           └── ...
│
├── shared/                           # Code partagé
│   ├── responsive_layout.dart        # Widget responsive
│   ├── app_router.dart               # Routes et navigation
│   ├── app_config.dart               # Constantes et configs
│   └── constants.dart                # Constantes globales
│
├── services/                         # Services
│   ├── responsive_service.dart       # Détection d'appareil
│   └── ...
│
├── widgets/                          # Widgets réutilisables
│   ├── category_card.dart
│   ├── product_card.dart
│   └── ...
│
└── main.dart                         # Point d'entrée
```

## 🚀 Démarrage Rapide

### 1. Utiliser le ResponsiveLayout

```dart
import 'package:dj/shared/responsive_layout.dart';
import 'package:dj/layouts/mobile/pages/mobile_homepage.dart';
import 'package:dj/layouts/web/pages/web_homepage.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: const MobileHomepage(),
      tablet: const MobileHomepage(), // Optionnel
      web: const WebHomepage(),
    );
  }
}
```

### 2. Utiliser les Extensions de Context

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (context.isMobile)
          const Padding(padding: EdgeInsets.all(16), child: Text('Mobile')),
        if (context.isDesktop)
          const Padding(padding: EdgeInsets.all(32), child: Text('Web')),
        Text('Largeur: ${context.screenWidth}'),
      ],
    );
  }
}
```

### 3. Utiliser ResponsiveService

```dart
import 'package:dj/services/responsive_service.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveService.isMobile(context);
    final width = ResponsiveService.getScreenWidth(context);
    
    return Container(
      width: isMobile ? width - 32 : width / 2,
      child: Text(isMobile ? 'Mobile Layout' : 'Web Layout'),
    );
  }
}
```

## 📱 Breakpoints Prédéfinis

| Type | Largeur | Colonnes Grid |
|------|---------|---------------|
| Mobile | < 768px | 2 |
| Tablet | 768px - 1023px | 3 |
| Desktop | ≥ 1024px | 6 |

## 🎨 Styles et Constantes

Tous les breakpoints et constantes sont centralisés dans `shared/app_config.dart` :

```dart
const int MOBILE_BREAKPOINT = 768;
const int TABLET_BREAKPOINT = 1024;

const double paddingMobile = 16.0;
const double paddingWeb = 32.0;

const int gridColumnsMobile = 2;
const int gridColumnsWeb = 6;
```

## 🔄 Navigation Responsive

Deux approches selon vos besoins :

### Approche 1: Composant Simple (Pas de Router)

```dart
// main_new.dart
import 'package:dj/shared/responsive_layout.dart';

home: ResponsiveLayout(
  mobile: const MobileHomepage(),
  web: const WebHomepage(),
)
```

### Approche 2: Router Complet (Recommandé)

```dart
// main_with_router.dart
MaterialApp(
  onGenerateRoute: AppRouter.generateRoute,
  initialRoute: '/',
)
```

Puis utiliser la navigation :

```dart
// Navigation avec extensions
context.goToCart();
context.goToProfile();
Navigator.pushNamed(context, AppRoutes.home);
```

## 📦 Fichiers Disponibles

### Services et Utilitaires

✅ **responsive_service.dart** - Détection d'appareil
✅ **responsive_layout.dart** - Widget ResponsiveLayout
✅ **app_router.dart** - Système de routing
✅ **app_config.dart** - Constantes centralisées

### Pages Exemples

✅ **mobile_homepage.dart** - Homepage mobile avec 2 colonnes
✅ **web_homepage.dart** - Homepage web avec 6 colonnes
✅ **mobile_cart.dart** - Panier mobile (style card)
✅ **web_cart.dart** - Panier web (style table)

### Main Files

✅ **main_new.dart** - Version simple avec ResponsiveLayout
✅ **main_with_router.dart** - Version complète avec routing

## 📋 Checklist de Migration

Pour migrer votre projet existant :

- [ ] Copier la structure `layouts/` mobile et web
- [ ] Créer les versions mobiles et web de chaque page
  - [ ] Homepage
  - [ ] Cart
  - [ ] Profile
  - [ ] Categories
  - [ ] My Orders
  - [ ] ... (autres pages)
- [ ] Mettre à jour `main.dart` avec ResponsiveLayout ou AppRouter
- [ ] Supprimer les anciens fichiers de pages dans `lib/pages/`
- [ ] Tester sur différentes tailles d'écran
- [ ] Adapter les constantes dans `app_config.dart`

## 🧪 Test Responsive

Dans Android Studio / VS Code :

1. **Configuration > Device Manager** ou **View > Tool Windows > Device Manager**
2. Lancer un appareil virtuel
3. Utiliser **Device Preview** (extension Flutter) pour tester plusieurs dispositifs
4. Redimensionner la fenêtre pour tester les breakpoints

## 💡 Bonnes Pratiques

✅ Gardez le code partagé dans `shared/`
✅ Utilisez `app_config.dart` pour toutes les constantes
✅ Créez des widgets petits et réutilisables
✅ Testez sur mobile, tablet, et desktop
✅ Utilisez `ResponsiveLayout` plutôt que `if (isMobile)`
✅ Centralisez la navigation avec `AppRouter`
✅ Maintenez les deux versions (mobile et web) synchronisées

## 🔗 Références

- [Flutter Responsive Design](https://flutter.dev/docs/development/ui/layout/adaptive-and-responsive)
- [MediaQuery Documentation](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)
- [LayoutBuilder](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)

## ❓ Questions ?

Consultez le fichier `MIGRATION_GUIDE.md` pour des exemples détaillés.
