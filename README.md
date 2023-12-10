# QulixTest

## В двух словах про решение

по условию нужно было выполнить задание с использованием UiKit, которым я особо не пользовался, поэтому некоторые решения скорее всего не совсем оптимальные, например при добавлении новых данных обновляется вся таблица, а не только новые данные.
из реализованного: получение с помощью отдельного класса от сервиса Giphy данных по поисовым завпрсам, отвтеы хранятся в виде структур, парсинг с реализацией Codable протокола через JSONDecoder. пагинация автоматическая после достижения конца списка.
также реализован отдельный класс для загрузки изображений с сервера, с кэшированием их в памяти для отрисовки и в Core Data для долговременного хранения. также реализовна возможность очистки кэша.
приложение состоит из основной страницы, расположенной в NavigtionView, с которой при помощи Push Segue можно попасть на страницу настроек, а также модального окна, открывающегося с помощью present() sheetPresentationController  или же modalPresentationStyle  в зависимости от версии iOS.
вторую кстати не получилось протестировать, так как на актуальной версии xcode можно загрузить симуляторы ios версии 15 и выше. в данном можальном окне можно увидеть не только само изображение и его название, а также даты импорта, загрузки и обновления изображения, а также его автора (если он есть) 
также на данной странце можно поделится этим изображением со ссылкой на оригинал 
![image](https://github.com/vasilevsky007/QulixTest/assets/72131827/55effb9b-d960-4ae3-9d10-5171d62923c9) ![image](https://github.com/vasilevsky007/QulixTest/assets/72131827/c0cf517a-20f8-489c-9e31-beb6eeaf2547) ![image](https://github.com/vasilevsky007/QulixTest/assets/72131827/6ae32bb6-18e3-43ba-9b2e-9d4292e5a8ac) ![image](https://github.com/vasilevsky007/QulixTest/assets/72131827/ea131413-dfde-4b41-9780-a8d12be7f73a)



