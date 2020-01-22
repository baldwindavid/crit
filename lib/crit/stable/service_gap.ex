defmodule Crit.Stable.ServiceGap do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crit.Stable.Animal

  schema "service_gaps" do
    field :starts_at, :utc_datetime
    field :ends_at, :utc_datetime
    field :reason, :string
    belongs_to :animal, Animal
    timestamps()
  end

  def changeset(service_gap, attrs) do
    service_gap
    |> cast(attrs, [:starts_at, :ends_at, :reason])
    |> validate_required([:starts_at, :ends_at, :reason])
  end
end
