# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Server.Repo.insert!(%Server.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias Server.Accounts
alias Server.Content

Accounts.create_user(%{"username" => "CryptoBuyer", "password" => "secret"})
Accounts.create_user(%{"username" => "Zipparrott", "password" => "secret"})
Accounts.create_user(%{"username" => "Fencelegato", "password" => "secret"})

Content.create_comment(%{"user_id" => 3, "body" => "Blockchain technology, of which bitcoin is the first application, eliminates the need for a third-party intermediary by creating rapid, permanent transaction records. Bitcoin itself has surged more than 1,700 percent this year to above $19,000."})
Content.create_comment(%{"user_id" => 1, "body" => "A cryptocurrency is a digital asset designed to work as a medium of exchange that uses cryptography to secure its transactions, to control the creation of additional units, and to verify the transfer of assets."})
Content.create_comment(%{"comment_id" => 2, "user_id" => 2, "body" => "Cryptos rule!"})
Content.create_comment(%{"comment_id" => 3, "user_id" => 1, "body" => "Yes they do."})
Content.create_comment(%{"comment_id" => 1, "user_id" => 1, "body" => "Test reply."})


