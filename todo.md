# migrations
need to figure out migrations

will need to keep 'serialized migrations model' so know how to add remove tables, etc.

mix swagger_phoenix.gen.json User users name:string age:integer sex:string

parse swagger yaml

figure out models

Single name
plural name
fields name:type

keep history

determine if it already exists?

look at each column and determine if it is an add/delete
an alter should not be supported

should it actually generate the migrations?

migrations only? what about others? those would be nice to keep as AST?

# worflow thoughts

app starts

if no "processed yaml" auto generate

otherwise check for changes and warn

to process yaml (2nd time) will require mix task to accept changes, generate migrations etc.

should we keep a history of non migrations?

shoudl be do AST? or actually generate files?

can we do AST with injectable overrides?

how far should we deviate from rest?

should we remove actions? for example deletes?

always 200's?


1. swagger migrate create .migration files
1. current state is used for both creating new diffs, and running the generation at compile time.
1. current_state prevents having to apply entire history of migrations to generate
