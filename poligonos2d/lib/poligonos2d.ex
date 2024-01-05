defmodule SD do
  defmodule Ponto do
    defstruct [:nome, :x, :y]
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
      for n <- 1..qtd_pontos do
        xponto = String.trim(IO.gets("Insira o X: ")) |> String.to_integer()
        yponto = String.trim(IO.gets("Insira o Y: ")) |> String.to_integer()
        %Ponto{nome: "Ponto #{n}", x: xponto, y: yponto}
      end
    end

    def reflexao_temporaria(poligono) do
      # Implemente a lógica de reflexão aqui
      # Certifique-se de retornar um novo polígono refletido
      IO.puts("Função de reflexão a ser implementada.")
      poligono
    end

    def adicionar_translacao(poligono) do
      IO.puts("Digite os valores para a translação: ")
      dx = String.trim(IO.gets("Valor de deslocamento em X: ")) |> String.to_integer()
      dy = String.trim(IO.gets("Valor de deslocamento em Y: ")) |> String.to_integer()
      poligono_transladado = translacao_temporaria(poligono, dx, dy)
      IO.puts("Poligono transladado temporariamente: ")
      IO.inspect(poligono_transladado)

      poligono_transladado
    end

    defp translacao_temporaria(poligono, dx, dy) do
      pontos_atualizados = Enum.map(poligono.pontos, fn ponto ->
        %Ponto{x: ponto.x + dx, y: ponto.y + dy}
      end)

<<<<<<< HEAD
      IO.puts("Polígono refletido temporariamente:")
      IO.inspect(poligono_refletido)

      poligono_refletido
=======
      %Poligono{poligono | pontos: pontos_atualizados}
>>>>>>> 381cd7e (commit)
    end

    def listar_poligonos(poligonos) do
      IO.puts("Poligonos cadastrados: ")
      Enum.each(poligonos, fn poligono ->
        IO.puts("#{poligono.nome} - Pontos: #{length(poligono.pontos)}")
      end)
    end
  end

  def poligono_interativo do
    loop([])
  end

  defp loop(poligonos) do
    IO.puts("Escolha uma opção:")
    IO.puts("1. Novo polígono")
    IO.puts("2. Listar Poligonos")
    IO.puts("3. Editar Poligonos")
    IO.puts("4. Adicionar movimentos")
    IO.puts("5. Sair")

    case String.trim(IO.gets("> ")) do
      "1" ->
        nome = String.trim(IO.gets("Digite um nome para o polígono: "))
        qtd_pontos = String.trim(IO.gets("Insira a quantidade de pontos existentes no polígono (mínimo 3): ")) |> String.to_integer()
        case SD.Poligono.novo(nome, qtd_pontos) do
          {:error, _} ->
            IO.puts("Erro ao criar polígono. Certifique-se de que o polígono tenha pelo menos 3 pontos.")
            loop(poligonos)
          poligono ->
            IO.puts("Polígono #{poligono.nome} criado com sucesso.")
            loop([poligono | poligonos])
        end

      "2" ->
        SD.Poligono.listar_poligonos(poligonos)
        loop(poligonos)

      "3" ->
        if poligonos != [] do
          poligonos = SD.Poligono.editar_poligono(poligonos)
          loop(poligonos)
        else
          IO.puts("Crie um polígono antes de editar.")
          loop(poligonos)
        end

      "4" ->
        if poligonos != [] do
          IO.puts("Escolha um movimento:")
          IO.puts("1. Translação")
          IO.puts("2. Reflexão")
          IO.puts("3. Voltar")

          case String.trim(IO.gets("> ")) do
            "1" ->
              loop(SD.Poligono.adicionar_translacao(poligonos))
            "2" ->
<<<<<<< HEAD
              poligono = Poligono.adicionar_reflexao(poligono)
              loop(poligono)

=======
              loop(SD.Poligono.adicionar_reflexao(poligonos))
>>>>>>> 381cd7e (commit)
            "3" ->
              loop(poligonos)
            _ ->
              IO.puts("Opção inválida. Tente novamente.")
              loop(poligonos)
          end
        else
          IO.puts("Crie um polígono antes de adicionar movimentos.")
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
