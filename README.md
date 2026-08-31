# Practice Room

Plateforme communautaire open source pour suivre et partager vos routines de pratique.

## C'est quoi ?

Practice Room s'adresse à tous ceux qui pratiquent — musiciens, sportifs, artistes, passionnés — et qui veulent un outil simple pour structurer leur entraînement au quotidien.

Pas de dashboards compliqués, pas de menus à rallonge. Juste ce qu'il faut pour pratiquer, suivre, repartir.

## Ce qu'on met entre vos mains

- **Journal de pratique** — Notez ce que vous avez fait, combien de temps, et regardez vos stats s'accumuler.
- **Exercices** — Créez les vôtres ou piochez dans ceux de la communauté. Ajoutez des fichiers, définissez des objectifs.
- **Communauté** — Découvrez ce que les autres pratiquent, échangez, partagez les vôtres.
- **Notifications** — Abonnez-vous à vos amis pratiquants, recevez des alertes sur leurs nouvelles séances.
- **Médias** — Vidéos, partitions, MP3, photos… attachez tout à vos exercices.

## Stack technique

| Couche | Technologie |
|--------|-------------|
| Langage | Ruby 3.2 |
| Framework | Rails 8.0 |
| Base de données | SQLite3 (Solid Suite pour cache/queue/cable) |
| Frontend | Hotwire (Turbo + Stimulus) + Importmap |
| CSS | Tailwind CSS 3.3 |
| Composants UI | ViewComponent |
| Authentification | Custom (bcrypt, sessions cookie signées) |
| Tests | Minitest + FactoryBot + Capybara |
| Déploiement | Kamal (Docker) |

## Pour lancer le projet en local

```shell
bundle install
bin/rails db:create db:migrate db:seed
bin/dev
```

## Communauté

Rejoignez notre Discord, que vous soyez membre actif ou que vous souhaitiez participer au développement.

> [Lien d'invitation au serveur Discord](https://discord.gg/8vCbhQUK7M)

## Roadmap

Suivez notre progression sur [l'onglet "projects"](https://github.com/users/syl-p/projects/13/views/1).

## Licence

Projet open source. Le code est sur GitHub, à portée de clic. Vous pouvez le lire, le modifier, le forker. Pas de portes closes ici.
