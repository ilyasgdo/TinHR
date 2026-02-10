# 📊 PROGRESSION — FlashJob MVP

> Dernière mise à jour : **2026-02-10**

---

| Étape | Nom | Statut | Progression |
|-------|-----|--------|-------------|
| 0 | [Setup & Credentials](etapes/ETAPE_0_SETUP.md) | ✅ Complété | 100% |
| 1 | [Auth & Onboarding](etapes/ETAPE_1_AUTH.md) | ✅ Complété | 100% |
| 2 | [Feed & Swipe](etapes/ETAPE_2_FEED_SWIPE.md) | ✅ Complété | 100% |
| 3 | [Matching](etapes/ETAPE_3_MATCHING.md) | ⬜ Non commencé | 0% |
| 4 | [Messagerie](etapes/ETAPE_4_MESSAGERIE.md) | ⬜ Non commencé | 0% |
| 5 | [Polish & Deploy](etapes/ETAPE_5_POLISH.md) | ⬜ Non commencé | 0% |

---

## Avancement global : 50% (3/6 étapes)

### 🏗️ Architecture actuelle
```
flashjob/lib/
├── core/
│   └── theme.dart                          ✅
├── models/
│   ├── profile.dart                        ✅
│   └── nearby_profile.dart                 ✅ NEW
├── services/
│   ├── auth_service.dart                   ✅
│   ├── profile_service.dart                ✅
│   ├── feed_service.dart                   ✅ NEW
│   └── swipe_service.dart                  ✅ NEW
├── viewmodels/
│   ├── auth_viewmodel.dart                 ✅
│   ├── profile_viewmodel.dart              ✅
│   └── feed_viewmodel.dart                 ✅ NEW
├── views/
│   ├── screens/
│   │   ├── splash_screen.dart              ✅
│   │   ├── login_screen.dart               ✅
│   │   ├── register_screen.dart            ✅
│   │   ├── role_selection_screen.dart       ✅
│   │   ├── onboarding_candidat_screen.dart  ✅
│   │   ├── onboarding_recruteur_screen.dart ✅
│   │   └── home_screen.dart                ✅ UPDATED
│   └── widgets/
│       ├── swipe_card.dart                 ✅ NEW
│       └── card_stack.dart                 ✅ NEW
└── main.dart                               ✅ UPDATED
```
