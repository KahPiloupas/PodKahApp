#PodKahApp

##Desafio de Programação - iMusica
Este é o projeto desenvolvido como parte do processo seletivo para a vaga de desenvolvimento na iMusica. A aplicação é uma interface para podcasts, permitindo ao usuário inserir uma URL de um RSS de podcast e navegar pelos episódios, com a possibilidade de reproduzi-los diretamente. 


##Descrição da Aplicação
A aplicação possui três telas principais: 

##Tela 1 - Fonte de RSS
A tela inicial permite que o usuário insira uma URL de um feed RSS de um podcast público. Ao inserir a URL, o sistema recupera e exibe informações sobre o podcast e seus episódios.
* Campo de texto para inserir a URL do feed RSS.
* Botão de ação para carregar os detalhes do podcast.

##Tela 2 - Detalhes do Podcast
Após inserir a URL do RSS, o usuário será redirecionado para a tela de detalhes do podcast. Nesta tela, são apresentadas informações relevantes sobre o podcast e seus episódios.
Informações exibidas:
* Título do podcast
* Imagem do podcast
* Descrição detalhada do podcast
* Autores
* Duração média dos episódios
* Gênero do podcast
Além disso, o usuário pode visualizar e selecionar qualquer episódio para iniciar sua reprodução. 

##Tela 3 - Player
Na tela de player, o usuário pode ouvir o episódio selecionado. A interface do player exibe os metadados essenciais do episódio em reprodução e oferece controle de navegação.


##Funcionalidades disponíveis:
* Barra de progresso para visualizar o andamento da reprodução.
* Botão Play/Pause para controlar a reprodução do episódio.
* Botões de navegação para o próximo e o episódio anterior. 


##Tecnologias Utilizadas
* Linguagem de Programação: Swift
* Frameworks: UIKit, AVFoundation (para reprodução de áudio)
* Player de Áudio: AVPlayer (para controlar a reprodução do áudio) 


##Como funciona:
* Na Tela 1, insira a URL de um feed RSS de podcast e clique no botão para adicionar o Podcast a lista.
* Na Tela 2, selecione um episódio da lista de Podcast e veja as informações sobre o podcast.
* Na Tela 3, controle a reprodução do episódio utilizando os controles de Play/Pause e navegue entre os episódios.


##Estrutura do Projeto
* Model: Arquivos que definem as estruturas de dados (Podcast).

* ViewControllers: Controladores das telas da aplicação:
* RSSViewController como tela inicial de input do usuário com endereço da RSS
* PodCastDetailsViewController como tela exibindo uma lista de episódios de Podcast
* PodcastPlayerViewController como tela de reprodução do episódio.

* Services Camada de serviço (requisições da aplicação): 
* PodcastService é responsável por buscar e processar feeds RSS de podcasts. Ela usa o XMLParser para extrair informações dos podcasts e episódios, como título, descrição, duração e URLs de áudio e imagem. Após o parsing, ela organiza essas informações em objetos Podcast e Episode, retornando-os através de um callback para a aplicação.
* ImageCache é responsável por gerenciar o cache de imagens. Ela armazena imagens em memória usando um NSCache e permite recuperar ou salvar imagens associadas a uma chave específica. A classe é implementada como um singleton, garantindo uma única instância acessível globalmente.

* ViewModels: Camada responsável por alocar a lógica da aplicação
* PodcastListViewModel gerencia a lógica de obtenção de podcasts. Ela utiliza o PodcastService para buscar podcasts de uma URL e, ao receber os dados, retorna o resultado por meio de um callback, indicando sucesso ou falha (caso não haja dados).
* PodcastDetailViewModel armazena e fornece os detalhes de um podcast específico. Ela recebe um objeto Podcast no momento da inicialização e permite acessar essas informações através do método getPodcastDetails().
* PlayerViewModel gerencia a reprodução de episódios de podcast, controlando o player de áudio (AVPlayer). Ela permite reproduzir, pausar, avançar, retroceder, e buscar a posição de reprodução. Além disso, mantém o progresso da reprodução e atualiza a interface com a posição atual e o progresso do áudio.


##Como executar o projeto
Passo 1 : Clonar o repositório através do link git@github.com:KahPiloupas/PodKahApp.git via terminal

Passo 2 : Abrir a pasta PodKahApp e executar o projeto através do arquivo PodKahApp.xcodeproj
