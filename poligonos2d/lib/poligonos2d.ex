defmodule SD do
  defmodule Ponto do
    defstruct [:nome, :x, :y]
  end

  defmodule Poligono do
    defstruct [:nome, :pontos]

    def novo(nome, qtd_pontos) do
      pontos = criar_pontos(qtd_pontos)
      %Poligono{nome: nome, pontos: pontos}
    end

    def criar_pontos(qtd_pontos) do
      Enum.map(1..qtd_pontos, fn n ->
        xponto = String.trim(IO.gets("Insira o X do #{n}º ponto: ")) |> String.to_integer()
        yponto = String.trim(IO.gets("Insira o Y do #{n}º ponto: ")) |> String.to_integer()
        %Ponto{nome: "Ponto #{n}", x: xponto, y: yponto}
      end)
    end

    def translacao_temporaria(poligono, dx, dy) do
      pontos_transladados = Enum.map(poligono.pontos, fn ponto ->
        %Ponto{ponto | x: ponto.x + dx, y: ponto.y + dy}
      end)

      %Poligono{poligono | pontos: pontos_transladados}
    end

    def adicionar_translacao(poligono) do
      IO.puts("Digite os valores para a translação:")
      dx = String.trim(IO.gets("Valor de deslocamento em X: ")) |> String.to_integer()
      dy = String.trim(IO.gets("Valor de deslocamento em Y: ")) |> String.to_integer()

      poligono_transladado = translacao_temporaria(poligono, dx, dy)

      IO.puts("Polígono transladado temporariamente:")
      IO.inspect(poligono_transladado)

      poligono
    end

    def adicionar_reflexao(poligono) do
      poligono_refletido = reflexao_temporaria(poligono)

      IO.puts("Plígono refletido temporáriamente?")
      IO.inspect(poligono_refletido)

      poligono_refletido
    end

  end

  def poligono_interativo do
    loop(nil)
  end

  defp loop(poligono) do
    IO.puts("Escolha uma opção:")
    IO.puts("1. Novo polígono")
    IO.puts("2. Adicionar movimentos")
    IO.puts("3. Sair")

    case String.trim(IO.gets("> ")) do
      "1" ->
        nome = String.trim(IO.gets("Digite um nome para o polígono: "))
        qtd_pontos = String.trim(IO.gets("Insira a quantidade de pontos existentes no polígono: ")) |> String.to_integer()
        poligono = Poligono.novo(nome, qtd_pontos)
        IO.puts("Polígono #{poligono.nome} criado com sucesso.")
        loop(poligono)

      "2" ->
        if poligono != nil do
          IO.puts("Escolha um movimento:")
          IO.puts("1. Translação")
          IO.puts("2. Voltar")

          case String.trim(IO.gets("> ")) do
            "1" ->
              poligono = Poligono.adicionar_translacao(poligono)
              loop(poligono)

            "2" ->
             poligono = Poligono.adicionar_reflexao(poligono)
              loop(poligono)

            "3" ->
              loop(poligono)

            _ ->
              IO.puts("Opção inválida. Tente novamente.")
              loop(poligono)
          end
        else
          IO.puts("Crie um polígono antes de adicionar movimentos.")
          loop(poligono)
        end

      "3" ->
        IO.puts("Saindo...")
        :ok

      _ ->
        IO.puts("Opção inválida. Tente novamente.")
        loop(poligono)
    end
  end
end

# Chame SD.poligono_interativo()
