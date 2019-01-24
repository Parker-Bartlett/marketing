defmodule CbusElixirWeb.MeetingController do
  use CbusElixirWeb, :controller

  alias CbusElixir.App.Meeting
  alias CbusElixir.App.Meetings
  alias CbusElixir.Repo
  alias CbusElixir.Pagination

  def index(conn, params) do
    page = params["page"] || 1
    per_page = params["per_page"] || 5
    
    #meetings = Pagination.paginate(Meetings.meetings_for_page_query(), page, per_page)
    meetings = Meetings.meetings_for_page_query |> Repo.all()

    render(conn, "index.html", meetings: meetings)
  end

  def show(conn, %{"id" => id}) do
    attendees = Meetings.attendees_for_meeting(id)

    render(conn, "show.html", attendees: attendees)
  end
end