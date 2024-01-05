defmodule SD do
  defmodule Ponto do
    defstruct [:x, :y]
  end

  defmodule Poligono do
    defstruct [:nome, :pontos]

    def novo(nome, qtd_pontos) do
      if qtd_pontos < 3 do
        IO.puts("Um polígono deve ter no mínimo 3 pontos.")
        {:error, nil}
      else
        pontos = criar_pontos(qtd_pontos)
        %Poligono{nome: nome, pontos: pontos}
      end
    end

    def criar_pontos(qtd_pontos) do
      for _ <- 1..qtd_pontos do
        x = String.trim(IO.gets("Insira o X do ponto: ")) |> String.to_integer()
        y = String.trim(IO.gets("Insira o Y do ponto: ")) |> String.to_integer()
        %Ponto{x: x, y: y}
      end
    end

    def listar_poligonos(poligonos) do
      IO.puts("Polígonos cadastrados:")
      Enum.each(poligonos, fn poligono ->
        IO.puts("#{poligono.nome} - Pontos: #{length(poligono.pontos)}")
      end)
    end

    def editar_poligono(poligonos) do
      IO.puts("Escolha o polígono para editar:")
      Enum.each(poligonos, fn poligono ->
        IO.puts("#{poligono.nome}")
      end)
      escolhido = String.trim(IO.gets("Digite o nome do polígono desejado: "))
      editar_poligono_interno(poligonos, escolhido)
    end

    def editar_poligono_interno(poligonos, escolhido) do
      poligono =
        Enum.find_value(poligonos, fn p ->
          p.nome == escolhido
        end)

      case poligono do
        nil ->
          IO.puts("Polígono não encontrado.")
          poligonos
        _ ->
          IO.puts("Edição de pontos:")
          novo_pontos = criar_pontos(length(poligono.pontos))
          %{poligono | pontos: novo_pontos}
      end
    end

    def deletar_poligono(poligonos) do
      IO.puts("Escolha o polígono para deletar:")
      Enum.each(poligonos, fn poligono ->
        IO.puts("#{poligono.nome}")
      end)
      escolhido = String.trim(IO.gets("Digite o nome do polígono a ser deletado: "))
      Enum.filter(poligonos, fn p -> p.nome != escolhido end)
    end
  end

  def poligono_interativo do
    loop([])
  end

  defp loop(poligonos) do
    IO.puts("Escolha uma opção:")
    IO.puts("1. Novo polígono")
    IO.puts("2. Listar polígonos")
    IO.puts("3. Editar polígonos")
    IO.puts("4. Deletar polígonos")
    IO.puts("5. Sair")

    case String.trim(IO.gets("> ")) do
      "1" ->
        nome = String.trim(IO.gets("Digite um nome para o polígono: "))
        qtd_pontos = String.trim(IO.gets("Insira a quantidade de pontos existentes no polígono (mínimo 3): ")) |> String.to_integer()
        case Poligono.novo(nome, qtd_pontos) do
          {:error, _} ->
            IO.puts("Erro ao criar polígono. Certifique-se de que o polígono tenha pelo menos 3 pontos.")
            loop(poligonos)
          poligono ->
            IO.puts("Polígono #{poligono.nome} criado com sucesso.")
            loop([poligono | poligonos])
        end

      "2" ->
        Poligono.listar_poligonos(poligonos)
        loop(poligonos)

      "3" ->
        if poligonos != [] do
          poligonos = Poligono.editar_poligono(poligonos)
          loop(poligonos)
        else
          IO.puts("Crie um polígono antes de editar.")
          loop(poligonos)
        end

      "4" ->
        if poligonos != [] do
          poligonos = Poligono.deletar_poligono(poligonos)
          loop(poligonos)
        else
          IO.puts("Crie um polígono antes de deletar.")
          loop(poligonos)
        end

      "5" ->
        IO.puts("Saindo...")
        :ok

      _ ->
        IO.puts("Opção inválida. Tente novamente.")
        loop(poligonos)
    end
  end
end

# Chame SD.poligono_interativo()
