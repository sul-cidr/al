# app/views/authors/show.json.jbuilder

json.author do
  json.author_id
  json.prefname
  json.surname
  json.viaf_id
  json.wiki_id
  json.birth_year
  json.death_year
  json.categories
end
