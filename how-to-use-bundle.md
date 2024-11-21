# Como configurar o Bundler localmente

Este guia explica como configurar e usar o Bundler localmente em seu projeto Ruby.

## 1. Instalar as dependências locais

Para instalar as dependências do seu projeto localmente, execute o seguinte comando:

```bash
bundle install --path vendor/bundle
```

## 2. Usando o Bundler local

Para rodar comandos com o Bundler, sempre utilize o comando bundle exec. Por exemplo, para rodar o rake:

```bash
bundle exec rake db:migrate
```

Isso garante que o Bundler execute o comando com as dependências definidas no seu Gemfile, evitando conflitos de versão.

## 3. Verificar dependências

Para verificar se todas as gems estão instaladas corretamente, você pode rodar o seguinte comando:

```bash
bundle check
```

Se todas as dependências estiverem instaladas corretamente, o Bundler informará que tudo está pronto. Caso contrário, ele sugerirá o que deve ser feito.