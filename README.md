# 🛠️ Shell Utils

Coleção modular de scripts para personalização e automação do ambiente de terminal (Bash/Zsh).

---

## 📦 Estrutura

```
📁 config/              # Configurações de cada ferramenta (carregado por último pelo projeto)
📁 core/
   ⌞📄 alias.sh        # Alias globais para terminal
   ⌞📄 functions.sh    # Funções utilitárias reutilizáveis
📁 modules/             # Funções e aliases para ferramentas
📄 init.sh           # Script principal de inicialização, carrega os módulos e configs
```

---

## 🚀 Como usar

1. Clone ou copie este repositório.
2. No seu `.zshrc` ou `.bashrc`, adicione:

```sh
source /caminho/para/o/projeto/init.sh
```

3. Abra um novo terminal e aproveite os utilitários.

---

## 🔧 Personalização

Você pode ativar/desativar módulos ou adicionar seus próprios scripts nos diretórios `modules/` ou `core/`.  
O arquivo `init.sh` será responsável por carregar todos os módulos de forma automática.

---

## 📌 Requisitos

- `bash` ou `zsh`
- Permissões de leitura nos arquivos

---

## ✨ Exemplo de Prompt com Branch Git

Se o seu terminal estiver dentro de um repositório Git, a branch será exibida automaticamente:

```sh
📁 meu-projeto (main) $
```

---

## 📄 Licença

Uso pessoal e livre modificação.  
Sinta-se à vontade para adaptar para seu ambiente e compartilhar melhorias!