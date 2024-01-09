defmodule SD do
  @menu """
  _______________________
  1. Novo polígono
  2. Listar polígonos
  3. Editar polígonos
  4. Deletar poligonos
  5. Interagir com um polígono
  6. Sair
  _______________________
  """

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
      for i <- 1..qtd_pontos do
        x = String.trim(IO.gets("Insira o X do #{i}º ponto: ")) |> String.to_integer()
        y = String.trim(IO.gets("Insira o Y do #{i}º ponto: ")) |> String.to_integer()
        %Ponto{x: x, y: y}
      end
    end

    def listar_poligonos(poligonos) do
      IO.puts("Polígonos cadastrados:")
      Enum.each(poligonos, fn poligono ->
        IO.puts("#{poligono.nome} - Pontos: #{length(poligono.pontos)}")
        IO.puts("  Coordenadas dos Pontos:")
        Enum.each(poligono.pontos, fn ponto ->
          IO.puts("    X: #{ponto.x}, Y: #{ponto.y}")
        end)
      end)
    end

    def editar_poligono(poligonos) do
      IO.puts("Escolha o polígono para editar (ou 'voltar' para retornar ao menu): ")
      Enum.each(poligonos, fn poligono ->
        IO.puts("#{poligono.nome}")
      end)
      escolhido = String.trim(IO.gets("Digite: "))

      case escolhido do
        "voltar" ->
          poligonos
        _ ->
          editar_poligono_interno(poligonos, escolhido)
      end
    end

    def editar_poligono_interno(poligonos, escolhido) do
      case Enum.find(poligonos, &(&1.nome == escolhido)) do
        nil ->
          IO.puts("Polígono não encontrado.")
          poligonos
        poligono ->
          IO.puts("Edição de pontos para o polígono #{poligono.nome}: ")
          qtd_pontos = length(poligono.pontos || [])
          novo_pontos = criar_pontos(qtd_pontos)
          Enum.map(poligonos, fn p ->
            if p.nome == escolhido, do: %{p | pontos: novo_pontos}, else: p
          end)
      end
    end

    def deletar_poligono(poligonos) do
      IO.puts("Escolha o polígono para deletar (ou 'voltar' para retornar ao menu):")
      Enum.each(poligonos, fn poligono ->
        IO.puts("#{poligono.nome}")
      end)
      escolhido = String.trim(IO.gets("Digite o nome do polígono a ser deletado (ou 'voltar' para retornar ao menu): "))

      case escolhido do
        "voltar" ->
          poligonos
        _ ->
          Enum.filter(poligonos, fn p -> p.nome != escolhido end)
      end
    end

    def interagir_com_poligono(poligonos) do
      IO.puts("Escolha o polígono para interagir (ou 'voltar' para retornar ao menu): ")
      Enum.each(poligonos, fn poligono ->
        IO.puts("#{poligono.nome}")
      end)
      escolhido = String.trim(IO.gets("Digite: "))

      case escolhido do
        "voltar" ->
          poligonos
        _ ->
          interagir_com_poligono_interno(poligonos, escolhido)
      end
    end

    def interagir_com_poligono_interno(poligonos, escolhido) do
      case Enum.find(poligonos, &(&1.nome == escolhido)) do
        nil ->
          IO.puts("Polígono não encontrado.")
          poligonos
        poligono ->
          IO.puts("Escolha uma opção para interagir com o polígono #{poligono.nome}: ")
          IO.puts("1. Adicionar Translação")
          IO.puts("2. Adicionar Reflexão")
          IO.puts("3. Voltar")

          case String.trim(IO.gets("> ")) do
            "1" ->
              poligonos_atualizados = adicionar_translacao(poligonos, poligono)
              interagir_com_poligono(poligonos_atualizados)
            "2" ->
              poligonos_atualizados = adicionar_reflexao(poligonos, poligono)
              interagir_com_poligono(poligonos_atualizados)
            "3" ->
              poligonos
            _ ->
              IO.puts("Opção inválida. Tente novamente.")
              interagir_com_poligono(poligonos)
          end
      end
    end

    def adicionar_translacao(poligonos, poligono) do
      IO.puts("Digite os valores para a translação: ")
      dx = String.trim(IO.gets("Valor de deslocamento em X: ")) |> String.to_integer()
      dy = String.trim(IO.gets("Valor de deslocamento em Y: ")) |> String.to_integer()
      poligono_transladado = translacao_temporaria(poligono, dx, dy)
      apresentar_poligono("Polígono transladado", poligono_transladado)
      poligonos
    end

    def adicionar_reflexao(poligonos, poligono) do
      IO.puts("Escolha os eixos para a reflexão:")
      IO.puts("1. Inverter o eixo X")
      IO.puts("2. Inverter o eixo Y")
      IO.puts("3. Inverter ambos os eixos")
      IO.puts("4. Voltar")

      case String.trim(IO.gets("> ")) do
        "1" ->
          poligono_refletido = reflexao(poligono, %{x: -1, y: 1})
          apresentar_poligono("Polígono refletido em relação ao eixo X", poligono_refletido)
          poligonos
        "2" ->
          poligono_refletido = reflexao(poligono, %{x: 1, y: -1})
          apresentar_poligono("Polígono refletido em relação ao eixo Y", poligono_refletido)
          poligonos
        "3" ->
          poligono_refletido = reflexao(poligono, %{x: -1, y: -1})
          apresentar_poligono("Polígono refletido em relação a ambos os eixos", poligono_refletido)
          poligonos
        "4" ->
          poligonos
        _ ->
          IO.puts("Opção inválida. Tente novamente.")
          adicionar_reflexao(poligonos, poligono)
      end
    end

    defp translacao_temporaria(poligono, dx, dy) do
      pontos_atualizados = Enum.map(poligono.pontos, fn ponto ->
        %Ponto{x: ponto.x + dx, y: ponto.y + dy}
      end)

      %Poligono{poligono | pontos: pontos_atualizados}
    end

    defp reflexao(poligono, %{x: x_factor, y: y_factor}) do
      pontos_refletidos = Enum.map(poligono.pontos, fn ponto ->
        %Ponto{x: ponto.x * x_factor, y: ponto.y * y_factor}
      end)

      %Poligono{poligono | pontos: pontos_refletidos}
    end

    defp apresentar_poligono(titulo, poligono) do
      IO.puts("#{titulo}:")
      IO.puts("#{poligono.nome} - Pontos: #{length(poligono.pontos)}")
      IO.puts("  Coordenadas dos Pontos:")
      Enum.each(poligono.pontos, fn ponto ->
        IO.puts("    X: #{ponto.x}, Y: #{ponto.y}")
      end)
    end
  end

  def poligono_interativo do
    loop([])
  end

  defp loop(poligonos) do
    IO.puts(@menu)

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
        if poligonos != [] do
          poligonos = Poligono.interagir_com_poligono(poligonos)
          loop(poligonos)
        else
          IO.puts("Crie um polígono antes de interagir.")
          loop(poligonos)
        end

      "6" ->
        IO.puts("Saindo...")
        :ok

      _ ->
        IO.puts("Opção inválida. Tente novamente.")
        loop(poligonos)
    end
  end
end

# Chame SD.poligono_interativo()
