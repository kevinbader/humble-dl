defmodule HumbleDl do
  def main(args) do
    Optimus.new!(
      name: "humble-dl",
      description: "Download all files of a Humble Bundle.",
      author: "Kevin Bader (@KevnBadr, github.com/kevinbader)",
      allow_unknown_args: false,
      parse_double_dash: true,
      args: [
        url: [
          value_name: "URL",
          help:
            ~s|Either the URL to the website (if not "claimed"), or the path to the downloaded HTML.|,
          required: true,
          parser: :string
        ]
      ],
      options: [
        dest_dir: [
          value_name: "DEST_DIR",
          short: "-d",
          long: "--dest_dir",
          help: "The downloaded files will be saved to this directory.",
          parser: fn s ->
            path = Path.expand(s)

            case File.dir?(path) do
              true -> {:ok, path}
              false -> {:error, ~s|"#{s}" is not a directory|}
            end
          end,
          default: "."
        ]
      ]
    )
    |> Optimus.parse!(args)
    |> do_run()
  end

  defp do_run(%{args: %{url: url}, options: %{dest_dir: dest_dir}}) do
    url
    |> get_html()
    |> extract_links()
    |> Enum.map(fn link -> download(link, dest_dir) end)
  end

  defp get_html("http" <> _ = url), do: HTTPoison.get!(url).body
  defp get_html(url), do: File.read!(url)

  defp extract_links(html) do
    html
    |> Floki.find(".download-buttons .js-start-download a")
    |> Floki.attribute("href")
  end

  defp download(link, dest_dir) do
    path =
      dest_dir
      |> Path.join("./" <> URI.parse(link).path)
      |> Path.expand()

    IO.puts("++ #{link}\n=> #{path}\n")
    content = HTTPoison.get!(link).body
    File.write!(path, content, [:write, :raw, :binary, :delayed_write])
  end
end
