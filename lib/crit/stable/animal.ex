defmodule Crit.Stable.Animal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Crit.Stable.ServiceGap

  schema "animals" do
    field :name, :string
    has_many :service_gaps, ServiceGap
    timestamps()
  end

  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
