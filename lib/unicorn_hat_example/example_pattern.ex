defmodule UnicornHatExample.ExamplePattern do

  use GenServer
  alias UnicornHat.Display

  @cols 17
  @rows 7

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(_opts) do
    :timer.send_interval(200, :tick)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:tick, state) do
    Enum.map(Range.new(1, @rows), fn y ->
      Enum.map(Range.new(1, @cols), fn x ->
        hue = :os.system_time(:seconds) / 4.0 + x / (@cols * 2) + y / @rows
        {rx, gx, bx} = hsv_to_rgb(hue, 1.0, 1.0)

        {r, g, b} =
          {round(Float.floor(rx * 255)), round(Float.floor(gx * 255)),
           round(Float.floor(bx * 255))}

        Display.set_pixel(x, y, r, g, b)
      end)
    end)

    Display.show()
    {:noreply, state}
  end

  defp hsv_to_rgb(h, s, v) do
    if s == 0.0 do
      {v, v, v}
    else
      x = Float.floor(h * 6.0)
      f = h * 6.0 - x
      p = v * (1.0 - s)
      q = v * (1.0 - s * f)
      t = v * (1.0 - s * (1.0 - f))
      i = x |> round |> rem(6)

      case i do
        0 -> {v, t, p}
        1 -> {q, v, p}
        2 -> {p, v, t}
        3 -> {p, q, v}
        4 -> {t, p, v}
        5 -> {v, p, q}
      end
    end
  end
end
