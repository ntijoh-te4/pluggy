defmodule Pluggy.Template do
  # def srender(file, data \\ [], layout \\ true) do
  #   {:ok, template} = File.read("templates/#{file}.slime")

  #   case layout do
  #     true ->
  #       {:ok, layout} = File.read("templates/layout.slime")
  #       Slime.render(layout, template: Slime.render(template, data))

  #     false ->
  #       Slime.render(template, data)
  #   end
  # end

  # Templates are read from disk and evaluated on every request. That is slow and would not
  # work in a release, but it means you can edit a template and just reload the page, no
  # recompile needed. It is also why the app must be started from the project root: the
  # paths below are relative to the current working directory.
  def render(file, data \\ [], layout \\ true) do
    case layout do
      true -> eval("templates/layout.eex", template: eval("templates/#{file}.eex", data))
      false -> eval("templates/#{file}.eex", data)
    end
  end

  # Same as EEx.eval_file, but with html_escape/1 imported so templates can write
  # <%= html_escape(fruit.name) %> instead of <%= Plug.HTML.html_escape(fruit.name) %>
  defp eval(path, bindings) do
    {:ok, env} = Macro.Env.define_import(__ENV__, [], Plug.HTML, only: [html_escape: 1])
    {result, _bindings} = Code.eval_quoted(EEx.compile_file(path), bindings, env)
    result
  end
end
