# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

tag_pool = FactoryBot.create_list(:tag, 10)
users = FactoryBot.create_list(:user, 5, :with_practices, tag_pool: tag_pool)
FactoryBot.create_list(:activity, 10, :public, tag_pool: tag_pool)

# Un vrai article, en français, plutôt que du texte factice : c'est ce qui permet
# de voir d'un coup d'œil le rendu de Trix, de la cover, des métadonnées SEO et
# de la section commentaires. find_or_initialize_by + new_record garde le seed
# idempotent : le contenu n'est écrit qu'à la première création.
example_post = Post.find_or_initialize_by(slug: "trente-jours-de-pratique-la-routine-qui-a-tenu")

if example_post.new_record?
  example_post.assign_attributes(
    user: users.first,
    title: "Trente jours de pratique d'affilée : la routine qui a tenu",
    excerpt: "On a tous abandonné au jour douze. Voici la routine minimaliste qui m'a fait tenir des années d'affilée, et les trois trucs qui ont vraiment fait la différence.",
    meta_description: "On a tous abandonné au jour douze. Voici la routine minimaliste qui fait tenir une pratique régulière, et les trois ajustements qui ont tout changé.",
    content: <<~HTML,
      <div>J'ai abandonné la pratique régulière au moins douze fois. Chaque fois au même endroit : la bonne volonté du dimanche soir, puis le trou de mercredi, puis le silence.</div>
      <div>Ce qui a changé, ce n'était pas la motivation. C'était la taille de la routine.</div>
      <h2>La règle des vingt minutes</h2>
      <div>Je ne pratique plus « une heure ». Je pratique vingt minutes, tous les jours, même le jour où je n'ai aucune envie. Le seuil doit être assez bas pour qu'ajouter la séance dans Practice Room ne demande aucune décision : pas de question à se poser, pas de négociation.</div>
      <blockquote>Si vous avez besoin de vous motiver pour commencer, c'est que le rendez-vous est trop gros.</blockquote>
      <h2>Trois choses qui font vraiment la différence</h2>
      <ol>
        <li><strong>Noter à la fin, pas au début.</strong> Une ligne suffit : ce que j'ai joué, et si ça a plu. Le carnet devient une trace, pas une corvée.</li>
        <li><strong>Un seul objectif par jour.</strong> Trois objectifs valent zéro objectif.</li>
        <li><strong>Un rattrapage sans dette.</strong> Le jour où je rate, j'enchaîne juste sur les vingt minutes suivantes. Pas de double séance, pas de « je me remets dimanche ».</li>
      </ol>
      <h2>Ce que ça ne change pas</h2>
      <div>Je ne suis pas plus rapide qu'avant. Mais après six mois je sais exactement où j'en suis — et c'est surtout ça qui m'a fait rester.</div>
    HTML
    status: :published,
    published_at: 3.days.ago
  )
  example_post.cover.attach(
    io: Rails.root.join("app/assets/images/marketing/hero-home.jpg").open,
    filename: "hero-home.jpg",
    content_type: "image/jpeg"
  )
  example_post.save!

  comments = [
    "Le rattrapage sans dette, c'est exactement ce qui me manquait. Je ne peux plus accumuler de retard à moins de le vouloir.",
    "J'ai commencé il y a une semaine avec les vingt minutes. C'est ridicule, mais c'est la première fois que je tiens plus de dix jours d'affilée."
  ]

  users[1, comments.size].zip(comments) do |user, content|
    Comment.create!(user: user, commentable: example_post, content: content)
  end
end
