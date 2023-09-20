defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header>
     <%= @brightness_level  %>

    </.header>
    <.main>
    <section class="flex gap-4 items-center">
      <.button
        phx-click="down"
        phx-disable-with="Decreasing..."
        phx-disable-with-target="self"
      >Decrease</.button>
      <meter
        min="0"
        max="100"
        value={@brightness}
      ></meter>

      <.button
        phx-click="up"
        phx-disable-with="Increasing..."
        phx-disable-with-target="self"
      >Increase</.button>
    </section>

    <section>
      <svg xmlns="http://www.w3.org/2000/svg" width="100" height="200" viewBox="0 0 100 200">
      <!-- Bulb filament -->
      <ellipse cx="50" cy="80" rx="15" ry="40" fill="grey" />

      <!-- Bulb body -->
      <circle cx="50" cy="50" r="40" fill={@brightness_color} />

      <!-- Bulb base -->
      <rect x="45" y="100" width="10" height="15" fill="#333" />

      <!-- Screw -->
      <circle cx="50" cy="120" r="5" fill="#333" />
      </svg>
    </section>

    </.main>
    """
  end

  def mount(_params, _session, socket) do
    brightness = 50
    brightness_color = calculate_brightness_color(brightness)

    socket =
      socket
      |> assign(:brightness, brightness)
      |> assign(:brightness_level, "Light level")
      |> assign(:brightness_color, brightness_color)

    {:ok, socket}
  end

  def handle_event("down", _, socket) do
    brightness = socket.assigns.brightness - 10
    brightness_color = calculate_brightness_color(brightness)

    socket =
      socket
      |> assign(:brightness, brightness)
      |> assign(:brightness_level, "Lower Light")
      |> assign(:brightness_color, brightness_color)

    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    brightness = socket.assigns.brightness + 10
    brightness_color = calculate_brightness_color(brightness)

    socket =
      socket
      |> assign(:brightness, brightness)
      |> assign(:brightness_level, "Brighter Light")
      |> assign(:brightness_color, brightness_color)

    {:noreply, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, nil, _params) do
    socket
    |> assign(:page_title, "Brightness level of porch light")
  end

  defp calculate_brightness_color(brightness) do
    "HSL(56, 80%, #{brightness - 10}%)"
  end
end
