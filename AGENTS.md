# AGENTS.md

Guide de référence pour les agents IA travaillant sur **Practice Room**.

---

## 1. Le projet

Practice Room est une plateforme communautaire open source permettant de suivre et partager ses routines de pratique. S'adresse aux musiciens, sportifs, artistes et tout passionné qui souhaite structurer son entraînement au quotidien.

- **URL** : https://practice-room.websylvain.com
- **Repo** : https://github.com/syl-p/practice-room-rails
- **Discord** : https://discord.gg/8vCbhQUK7M

---

## 2. Stack technique

| Couche | Technologie |
|--------|-------------|
| Langage | Ruby 3.2 |
| Framework | Rails 8.0 |
| Base de données | SQLite3 (Solid Suite pour cache/queue/cable) |
| Frontend | Hotwire (Turbo + Stimulus) + Importmap |
| CSS | Tailwind CSS 3.3 |
| Composants UI | ViewComponent ~> 3.23 |
| Rich text | Trix + ActionText |
| Authentification | Custom (bcrypt, sessions cookie signées) |
| Authorization | Policies custom style Pundit |
| Tests | Minitest + FactoryBot + Capybara |
| Linting | RuboCop (Omakase) + Brakeman |
| Déploiement | Kamal (Docker) |
| Assets | Propshaft |

---

## 3. Conventions de code

### Ruby / Rails

- Suivre le style **RuboCop Omakase** (pas de deviations sans raison).
- Models : singular, snake_case (`Practice`, `PracticeEntry`).
- Controllers : plural, snake_case (`PracticesController`).
- Controllers imbriqués : namespace par le parent (`Practices::ActivitiesController`).
- Partials : prefixe `_` (`_form.html.erb`, `_dropdown.html.erb`).
- Concerns dans `app/controllers/concerns/` et `app/models/concerns/`.
- Services dans `app/services/`, namespace par domaine (`Practices::ActivitiesService`).
- Jobs dans `app/jobs/`, namespace par domaine (`Comments::NotificationsJob`).
- Routes en français quand c'est public (`a-propos`, `contact`).
- Pas de Devise, pas de gems d'auth tierces — le système d'auth est custom.

### Vues

- ERB uniquement (pas de HAML/Slim).
- Layouts : `application` (connecté), `marketing` (public), `guest` (auth).
- Composants ViewComponent pour les éléments UI réutilisables.
- Utiliser `ui_action_to` depuis `TailwindHelper` pour tous les boutons/CTA.
- Turbo Frames et Turbo Streams pour les interactions dynamiques.
- `<html lang="fr">` — le projet est en français par défaut.

### Tests

- Minitest, pas RSpec.
- Factories FactoryBot dans `test/factories/`.
- Helper `sign_in(user)` disponible dans `test/test_helper.rb`.
- Tests de composants dans `test/components/`.
- Lancer les tests avant de valider un changement : `bin/rails test`.

---

## 4. Design system

### Palette de couleurs

Le thème est défini via des CSS custom properties HSL dans `app/assets/stylesheets/application.tailwind.css`.

| Token | Rôle | Valeur (light) |
|-------|------|----------------|
| `--primary` | Boutons, accents, hero | Dark navy (`240 5.9% 10%`) |
| `--primary-foreground` | Texte sur primary | Near-white (`0 0% 98%`) |
| `--secondary` | Cartes, fonds alternés | Light gray (`240 4.8% 95.9%`) |
| `--background` | Fond de page | Blanc |
| `--foreground` | Texte principal | Near-black |
| `--muted-foreground` | Texte secondaire | Mid-gray |
| `--destructive` | Erreurs, suppressions | Rouge |
| `--border` | Bordures | Light gray |

### Typographie

- Font : **Inter var** (`font-sans`)
- Classes composées : `.h1` (4xl bold), `.h2` (2xl semibold), `.h3` (lg bold), `.h4` (base semibold)
- Headings : toujours `tracking-tight`

### Composants UI

Utiliser `ui_action_to` pour tous les boutons :

```erb
<%= ui_action_to "Label", path, as: :link, variant: :primary %>
<%= ui_action_to "Label", path, as: :button, variant: :secondary %>
```

Variantes disponibles : `:primary`, `:secondary`, `:outline`, `:ghost`, `:destructive`.

### Layout marketing

Les pages publiques (home non connecté, à propos, contact, blog) utilisent le layout `marketing.html.erb` avec :
- Nav publique (`shared/_marketing_nav.html.erb`)
- Footer dark primary (`shared/_footer.html.erb`)
- Hero `bg-primary text-primary-foreground` avec badge + titre + sous-titre

---

## 5. Ton et voix

### Principes

Practice Room s'adresse à des gens qui pratiquent sérieusement mais qui veulent un outil sans prise de tête. Le ton doit être :

- **Chaleureux** — on parle à des gens, pas à des utilisateurs.
- **Direct** — pas de jargon marketing, pas de formulations creuses.
- **Décontracté** — vouvoiement chaleureux, phrases courtes, ponctuation vivante.
- **Encourageant** — on motive sans être infantilisant.

### Règles concrètes

| Faire | Ne pas faire |
|-------|-------------|
| "On reprend ?" | "Bienvenue sur votre tableau de bord" |
| "C'est gratuit, c'est open source" | "Notre plateforme 100% gratuite et open source" |
| "Vos fichiers avec vous" | "Gérez vos ressources multimédias" |
| "On vous montre ?" | "Découvrez notre processus en 3 étapes" |
| "Rien de superflu" | "Une interface épurée et intuitive" |
| "Notez ce que vous avez fait" | "Enregistrez vos sessions de pratique" |
| Vouvoiement chaleureux, direct | Vouvoiement froid, corporate |
| Phrases courtes | Paragraphes longs |

### Exemples de formulations

**Hero connecté :**
> "On reprend ? Vos pratiques vous attendent. Sélectionnez-en une pour reprendre exactement là où vous en étiez."

**Hero marketing :**
> "Votre progression mérite mieux qu'un carnet sous la poussière."

**CTA :**
> "Envie de tester ? C'est gratuit, c'est open source, et ça s'installe en quelques secondes. On vous attend."

**Section valeurs :**
> "Pas de dashboards compliqués, pas de menus à rallonge. Juste ce qu'il faut pour pratiquer, suivre, repartir."

### Label de sections

Les labels au-dessus des titres de section utilisent :
- Texte uppercase + `tracking-wider` + `text-sm font-semibold text-primary`
- Exemples : "Ce qu'on met entre vos mains", "C'est facile", "Ce à quoi on tient"

---

## 6. Structure des pages marketing

### Pattern de page

```
Hero (bg-primary, white text, badge + titre + sous-titre + CTA)
  ↓
Section 1 (fond secondary/50 ou blanc)
  ↓
Section 2 (fond alterné)
  ↓
CTA final (bg-primary)
```

### Layout desktop

- Container : `mx-auto` avec `max-w-5xl` ou `max-w-4xl`
- Grilles : `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3`
- Sections deux colonnes : `lg:grid-cols-5` (2/5 titre + 3/5 contenu)
- Footer : `lg:grid-cols-4` (4 colonnes)

### Règles d'espacement

- Sections : `py-16 px-4` ou `py-20 px-4`
- Entre sections : pas de marge, le padding suffit
- Container : toujours `container mx-auto`

---

## 7. SEO

Chaque page publique doit définir :

```erb
<% content_for :title, "Titre de la page - Practice Room" %>
<% content_for :description, "Description pour les moteurs de recherche (150-160 caractères)" %>
```

Les meta tags OG et canonical sont injectés automatiquement via `shared/_head.html.erb`.

---

## 8. Fichiers importants

| Fichier | Rôle |
|---------|------|
| `config/routes.rb` | Toutes les routes |
| `app/controllers/pages_controller.rb` | Pages marketing (home, about, contact) |
| `app/controllers/application_controller.rb` | Base controller, layout par défaut |
| `app/controllers/concerns/authentication.rb` | Système d'authentification |
| `app/helpers/tailwind_helper.rb` | `ui_action_to` et constantes de style |
| `app/views/shared/_head.html.erb` | SEO meta tags |
| `app/views/shared/_marketing_nav.html.erb` | Nav des pages publiques |
| `app/views/shared/_footer.html.erb` | Footer marketing |
| `app/views/layouts/marketing.html.erb` | Layout pages publiques |
| `app/assets/stylesheets/application.tailwind.css` | Thème couleurs + composants CSS |
| `config/tailwind.config.js` | Config Tailwind |

---

## 9. Commandes utiles

```shell
bin/rails test                  # Lancer les tests
bin/rails routes | grepXXX      # Vérifier une route
bin/rails console               # Console Rails
bin/dev                         # Serveur de dev ( Rails + Tailwind )
bundle exec rubocop             # Linter le code Ruby
bundle exec brakeman            # Audit de sécurité
```
