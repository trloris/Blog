defmodule Blog.DateFormatter do
  def format_date(date) do
    elem(Ecto.DateTime.dump(date), 1)
    |> Timex.Date.from
    |> Timex.DateFormat.format!("%B %e, %Y", :strftime)
  end
end
