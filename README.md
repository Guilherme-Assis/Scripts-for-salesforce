# Scripts-for-salesforce

Dependence: https://www.anaconda.com/distribution/

# API REST em Salesforce com Apex

Este repositório contém um exemplo de como criar uma API REST usando Apex no Salesforce.

## Índice

- [Introdução](#introdução)
- [Pré-requisitos](#pré-requisitos)
- [Passo a Passo](#passo-a-passo)
  - [1. Criar a Classe Apex](#1-criar-a-classe-apex)
  - [2. Configurar Permissões](#2-configurar-permissões)
    - [2.1 Perfil de Usuário](#21-perfil-de-usuário)
    - [2.2 Sites](#22-sites)
  - [3. Testar a API](#3-testar-a-api)
- [Dicas Adicionais](#dicas-adicionais)
- [Considerações Finais](#considerações-finais)

## Introdução

Este projeto demonstra como criar uma API REST em Salesforce utilizando Apex. A API permite manipulação de dados através dos métodos HTTP GET, POST, PUT e DELETE.

## Pré-requisitos

- Conta no Salesforce com permissões de administrador.
- Conhecimento básico de Apex e Salesforce.
- Ferramentas para testar APIs, como Postman ou cURL.

## Passo a Passo

### 1. Criar a Classe Apex

Crie uma nova classe Apex no Salesforce com o seguinte código:

```apex
@RestResource(urlMapping='/meuRecurso/*')
global with sharing class MeuServicoRest {

    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String param = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        res.responseBody = Blob.valueOf('Requisição GET recebida. Parâmetro: ' + param);
        return null;
    }

    @HttpPost
    global static String doPost(String nome) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        res.responseBody = Blob.valueOf('Requisição POST recebida. Nome: ' + nome);
        return null;
    }

    @HttpPut
    global static String doPut(String id, String nome) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        res.responseBody = Blob.valueOf('Requisição PUT recebida. ID: ' + id + ', Nome: ' + nome);
        return null;
    }

    @HttpDelete
    global static String doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String param = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        res.responseBody = Blob.valueOf('Requisição DELETE recebida. Parâmetro: ' + param);
        return null;
    }
}
```

2. Configurar Permissões
2.1 Perfil de Usuário
Vá para Configuração > Gerenciamento de Usuários > Perfis.
Selecione o perfil desejado.
Em "Autorização da Classe Apex", adicione permissões para a classe MeuServicoRest.
2.2 Sites
Vá para Configuração > Desenvolvedor > Sites.
Crie um novo site e configure a URL conforme necessário.
Configure as permissões do site para permitir acesso à classe Apex.
3. Testar a API
Use ferramentas como Postman ou cURL para testar seus endpoints. Por exemplo, para testar o método GET:

sh
Copy code
curl -X GET https://[your-salesforce-instance]/services/apexrest/meuRecurso/123
Substitua [your-salesforce-instance] pela sua instância do Salesforce, como na1.salesforce.com.

Dicas Adicionais
Manipulação de Erros: Adicione tratamento de erros adequado para retornar mensagens de erro claras.
Autenticação: Use OAuth para autenticação segura de suas APIs.
Documentação: Documente sua API para facilitar o uso por outros desenvolvedores.
Considerações Finais
Criar uma API RESTful em Salesforce com Apex é uma maneira poderosa de expor funcionalidades de sua organização Salesforce para integração com outros sistemas. Siga as melhores práticas de segurança e documentação para garantir que sua API seja robusta e fácil de usar.

Exemplo Completo de Teste
Testando com Postman
GET Request:

URL: https://[your-salesforce-instance]/services/apexrest/meuRecurso/123
Método: GET
Resposta esperada: Requisição GET recebida. Parâmetro: 123
POST Request:

URL: https://[your-salesforce-instance]/services/apexrest/meuRecurso/
Método: POST
Body: { "nome": "John Doe" }
Resposta esperada: Requisição POST recebida. Nome: John Doe
PUT Request:

URL: https://[your-salesforce-instance]/services/apexrest/meuRecurso/
Método: PUT
Body: { "id": "123", "nome": "Jane Doe" }
Resposta esperada: Requisição PUT recebida. ID: 123, Nome: Jane Doe
DELETE Request:

URL: https://[your-salesforce-instance]/services/apexrest/meuRecurso/123
Método: DELETE
Resposta esperada: Requisição DELETE recebida. Parâmetro: 123
Lembre-se de configurar o cabeçalho de autenticação no Postman com um token de acesso válido.
