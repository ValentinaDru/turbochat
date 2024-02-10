import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  /** On start */
  connect() {
    console.log("Connected");
    const messages = document.getElementById("messages");
    const observer = new MutationObserver(this.resetScroll.bind(this));
    observer.observe(messages, { childList: true });
    this.resetScroll();
  }

  /** On stop */
  disconnect() {
    console.log("Disconnected");
  }

  /** Custom function  */
  resetScroll() {
    const messages = document.getElementById("messages");
    messages.scrollTop = messages.scrollHeight - messages.clientHeight;
  }
}

/* 
connect(): Это метод контроллера, который вызывается при подключении (связывании) элемента к контроллеру. 
В данном случае, метод connect() выполняет инициализацию контроллера.

console.log("Connected");: Этот вызов выводит сообщение в консоль браузера при подключении элемента к контроллеру. 
Это помогает отслеживать процесс инициализации.

const messages = document.getElementById("messages");: Эта строка получает ссылку на DOM-элемент 
с идентификатором "messages". Этот элемент, вероятно, представляет собой контейнер для сообщений чата.

messages.addEventListener("DOMNodeInserted", this.resetScroll);: Этот код добавляет обработчик события "DOMNodeInserted" 
к элементу "messages". Это событие происходит, когда в контейнере сообщений добавляется новый DOM-узел 
(например, когда добавляется новое сообщение).

this.resetScroll(messages);: Этот вызов метода resetScroll() выполняется сразу после добавления 
обработчика события. Вероятно, этот метод предназначен для сброса прокрутки контейнера сообщений вниз, 
чтобы новые сообщения были видны в чате.
*/
