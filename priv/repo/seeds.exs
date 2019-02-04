# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CbusElixir.Repo.insert!(%CbusElixir.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias CbusElixir.Repo
alias CbusElixir.App.Meeting

start_date = ~N[2018-03-01T00:00:00]

speakers = [
  %{
    name: "Uncle Bob",
    url: "https://blog.cleancoder.com/",
    email: "test@example.com"
  },
  %{
    name: "Gary Berhhardt",
    url: "https://twitter.com/garybernhardt",
    email: "test@example.com"

  },
  %{
    name: "Joe Armstrong",
    url: "https://twitter.com/joeer",
    email: "test@example.com"
  }
]

Enum.each(0..100, fn x ->
  date = Timex.shift(start_date, months: x)
  days = Enum.find(0..6, fn d -> Timex.shift(date, days: d) |> Date.day_of_week() == 2 end)
  meeting_date = Timex.shift(date, days: days)

  m = %Meeting{}
  |> Meeting.changeset(%{date: meeting_date})
  |> Repo.insert!()

  Enum.each(1..3, fn s ->
    %Speaker{}
    |> Map.merge(Enum.random(speakers))
    |> Speaker.changeset(%{
      meeting_id: m.id,
      title: :crypto.strong_rand_bytes(30) |> Base.url_encode64()
    })
    |> Repo.insert!()
  end)
end)
