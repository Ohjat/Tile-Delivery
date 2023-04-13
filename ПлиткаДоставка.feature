﻿@tree
@ДокументыЗаказКлиента

Функционал: Заказа клиента, вид номенклатуры - плитка, доставка
Как менеджер по продажам я хочу
оформить заказ клиента на усмотрение транспортной службы
чтобы отгрузить товар


Сценарий: создание заказа клиента для плитки на усмотрение транспортной службы от ТК ВОГ
* подключаю сеанс
	Дано я подключаю TestClient "Менеджер по продажам ТК ВОГ" логин "Менеджер по продажам ТК ВОГ" пароль ""
	И я закрыл все окна клиентского приложения
* объявляю глобальные переменные
	И я удаляю переменную '$$Склад$$'
	И я запоминаю строку "ВГ_ПСС основной" в переменную "$$Склад$$"
	И я удаляю переменную '$$Организация$$'
	И я запоминаю строку "ТК ВОГ" в переменную "$$Организация$$"
	И я удаляю переменную '$$ОсобыеУсловияПеревозки$$'
* создаю заказ номенклатуры - плитка, доставка - на усмотрение транспортной службы
	И Я создаю Заказ клиента для клиента "Русплитка (СтройМаркет Новорязанское ш, пав. 138Г-65Д)" у которого контрагент "РУСПЛИТКА ООО (НОВЫЙ)" по соглашению "ВГ Оптовая цена (РУСПЛИТКА ООО (НОВЫЙ)) (Плитка)" с номером соглашения "ДП/00268" со складом соглашения "ВГ_ПСС" с договором "Договор поставки № ДП/00268 от 01.01.2021 (Плитка)" и самовывоз "Нет"
* заполняю ТЧ
	И Я добавляю в табличную часть номенклатуры "C-YA4M302D" в количестве "94,050" упаковок "м2"
	И Я добавляю в табличную часть номенклатуры "KTL051D-60" в количестве "68,750" упаковок "м2"
	И Я добавляю в табличную часть номенклатуры "NV2F072DT" в количестве "6,000" упаковок "шт"
	И Я добавляю в табличную часть номенклатуры "16328" в количестве "100,890" упаковок "м2"
Тогда открылось окно "Заказ клиента*"
	И я удаляю переменную '$$Масса$$'
	И я удаляю переменную '$$ОбъемОкругленный$$'
	И я удаляю переменную '$$ДатаОтгрузки$$'
	И я запоминаю значение поля с именем 'ГруппаПодвалвогГруппаВГХвогМасса' как '$МассаНеОкругленная$'
	И я запоминаю значение выражения 'Строка(Окр($МассаНеОкругленная$))' в переменную '$$Масса$$'
	И я запоминаю значение поля с именем 'ГруппаПодвалвогГруппаВГХвогОбъем' как 'Объем'
	И я запоминаю значение выражения 'Строка(Окр($Объем$, 1))' в переменную '$$ОбъемОкругленный$$'
	И я запоминаю значение выражения 'Формат(Дата($$ДатаЗавтра$$),"ДФ=dd.MM.yyyy")' в переменную '$$ДатаОтгрузки$$'
	И я перехожу к закладке с именем "СтраницаДоставка"
	И я устанавливаю флаг с именем 'ОсобыеУсловияПеревозки'
* проверяю что поле ОсобыеУсловияПеревозкиОписание не заполняется по статистике (ERP-2087)
	И элемент формы с именем 'ОсобыеУсловияПеревозкиОписание' стал равен ''
	И в поле с именем 'ОсобыеУсловияПеревозкиОписание' я ввожу текст 'Особая информация'
	И я запоминаю строку "Особая информация" в переменную "$$ОсобыеУсловияПеревозки$$"
	И я перехожу к закладке с именем "ГруппаТовары"		
И я провожу заказ клиента

* запускаю систему под менеджером по закупкам	
	Дано я подключаю TestClient "Менеджер по закупкам ТК ВОГ" логин "Менеджер по закупкам ТК ВОГ" пароль ""
	И я закрыл все окна клиентского приложения
* проверка обеспечения потребностей по заказу клиента, создание заказа поставщику при необходимости	
	И Я формирую заказ поставщику по потребностям ранее созданного заказа клиента с поставщиком "Ровезе Рус" с соглашением поставщика "ВГ Входная цена (Церсанит Москва)" и договором "Договор поставки № ЦЛТ004404 от 01.02.21"  и видом номенклатуры "Плитка"

Сценарий: проверка обеспечения заказа клиента и создание отгрузочных документов для плитки на усмотрение транспортной службы от ТК ВОГ
* Если требуется обеспечение и был создан заказ поставщику, то создадим приходный ордер и ПТУ		
Если "$$ТребуетсяОбеспечение$$" Тогда
	* запускаю систему под бухгалтером
		И я подключаю TestClient "Бухгалтер ТК ВОГ" логин "Бухгалтер ТК ВОГ" пароль ""
		И я закрыл все окна клиентского приложения
	* формирую накладную под ролью бухгалтера
		И Я создаю накладную Приобретение товаров и услуг по заказу поставщика
	* запускаю систему под ролю работника склада  
		И я подключаю TestClient "Работник склада ТК ВОГ" логин "Работник склада ТК ВОГ" пароль ""
		И я закрыл все окна клиентского приложения	
	* формирую приходный ордер как работник склада
		И Я создаю Приходный ордер на склад по заказу поставщика
* бухгалтер создает поступление безналичных ДС
	И я подключаю TestClient "Бухгалтер ТК ВОГ" логин "Бухгалтер ТК ВОГ" пароль ""
	И я закрываю все окна клиентского приложения
	И я создаю Поступление безналичных ДС где плательщик "РУСПЛИТКА ООО (НОВЫЙ)" договор расчетов "Договор поставки № ДП/00268 от 01.01.2021 (Плитка)" сумма "236440,85" на счет "АО \"РАЙФФАЙЗЕНБАНК\" (Расчетный)" по организации "ТК ВОГ"			
* менеджер проверяет обеспечение заказа
	Дано я активизирую TestClient "Менеджер по продажам ТК ВОГ"
	И я закрываю все окна клиентского приложения
	И Я проверяю обеспечение заказа клиента
	Если появилось предупреждение в течение 10 секунд тогда
		И я вызываю исключение "Не удалось провести документ"
* создаю документ расходный ордер на товары
	И Я создаю Расходный ордер для отгрузки со склада

* запускаю систему под ролю менеджер по доставке 
	И я подключаю TestClient "Менеджер по доставке ТК ВОГ" логин "Менеджер по доставке ТК ВОГ" пароль ""
	И я закрыл все окна клиентского приложения
* формирую задание на доставку
	И Я создаю задание на перевозку "С нашего склада" клиенту для заказа "$$НомерЗаказаКлиента$$" где дата поступления "$$ДатаОтгрузки$$" вес "$$Масса$$" объем "$$ОбъемОкругленный$$" экспедитор2 "АйСиТи-Логистика ООО" перевозчик "Саньков А.В.ИП"
* проверяю что нельзя перевести в статус К погрузке не выполнив распределение затрат (ERP-979)
	Дано Я открываю навигационную ссылку "e1cib/list/Документ.ЗаданиеНаПеревозку"
	И в таблице "Список" я перехожу к строке содержащей подстроки
    	| 'Номер'                       |
        | '$$НомерЗаданияНаПеревозку$$' |
	И в таблице "Список" я выбираю текущую строку
	Тогда открылось окно 'Задание на перевозку *'
	И из выпадающего списка с именем "Статус" я выбираю точное значение 'К погрузке'
	И я нажимаю на кнопку с именем 'ФормаПровести'
	Затем я жду, что в сообщениях пользователю будет подстрока 'Поле "Сумма затрат" не заполнено' в течение 10 секунд
	Когда открылось окно 'Задание на перевозку *'
	И из выпадающего списка с именем "Статус" я выбираю точное значение 'Формируется'
	И в поле с именем 'ГруппаПравовогСуммаЗатрат' я ввожу текст '2,00'
	И я нажимаю на кнопку с именем 'ФормаПровести'
	И я перехожу к закладке с именем "ГруппаСтраницывогРаспределениеЗатрат"
	И в таблице "ГруппаСтраницывогРаспределениеЗатратвогРаспределениеЗатрат" количество строк "равно" 1
	И в таблице "ГруппаСтраницывогРаспределениеЗатратвогРаспределениеЗатрат" я нажимаю на кнопку с именем 'ГруппаСтраницывогРаспределениеЗатратвогРаспределениеЗатратКоманднаяПанельРаспределитьЗатраты'
	И из выпадающего списка с именем "Статус" я выбираю точное значение 'К погрузке'
	И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'
	* проверяю проведение документа
	Если в текущем окне есть сообщения пользователю Тогда
		И я вызываю исключение с текстом сообщения
* проверяю что заказ клиента открывается из задания на перевозку под менеджером по доставке (ERP-1348)
	Дано Я открываю навигационную ссылку "e1cib/list/Документ.ЗаданиеНаПеревозку"
	И в таблице "Список" я перехожу к строке содержащей подстроки
    	| 'Номер'                       |
        | '$$НомерЗаданияНаПеревозку$$' |
	И в таблице "Список" я выбираю текущую строку
	Когда открылось окно 'Задание на перевозку *'
	И я перехожу к закладке с именем "СтраницаМаршрут"
	И в таблице "Маршрут" я перехожу к первой строке
	И в таблице "Маршрут" я активизирую поле с именем "МаршрутПолучателиОтправители"
	И в таблице "Маршрут" я выбираю текущую строку
	Когда открылось окно 'Распоряжения по пункту маршрута'
	И в таблице "Распоряжения" я активизирую поле с именем "РаспоряженияРаспоряжение"
	И в таблице "Распоряжения" я выбираю текущую строку	
	Тогда открылось окно 'Заказ клиента *'


* Формирую печатные документы Заявка на доставка и Поручения экспедитору из задания на перевозку в статусе К погрузке
	И я подключаю TestClient "Менеджер по доставке ТК ВОГ" логин "Менеджер по доставке ТК ВОГ" пароль ""
	И я закрыл все окна клиентского приложения
	и Я открываю навигационную ссылку "e1cib/list/Документ.ЗаданиеНаПеревозку"
	Тогда открылось окно 'Задания на перевозку'
	И в таблице "Список" я перехожу к строке содержащей подстроки
		| 'Номер'                       |
		| '$$НомерЗаданияНаПеревозку$$' |
	И в таблице "Список" я выбираю текущую строку
	Когда открылось окно 'Задание на перевозку *'	
* проверяю печать Входящее поручение экспедитору 
	И я нажимаю на кнопку с именем 'ПодменюПечатьОбычное_ВходящееПоручениеЭкспедитору'
	Тогда открылось окно 'Печать документа'
	И Табличный документ "ПечатнаяФорма1" равен макету "Шаблоны/Шаблон_ВходящееПоручениеЭкспедитору_Плитка" по шаблону
	И я закрываю текущее окно
* проверяю печать Исходящее поручение экспедитору
	И В панели открытых я выбираю 'Задание на перевозку *'
	Тогда открылось окно 'Задание на перевозку *'
	И я нажимаю на кнопку с именем 'ПодменюПечатьОбычное_ИсходящееПоручениеЭкспедитору'
	Тогда открылось окно 'Печать документа'
	И Табличный документ "ТекущаяПечатнаяФорма" равен макету "Шаблоны/Шаблон_ИсходящееПоручениеЭкспедитору_Плитка" по шаблону
	И я закрываю текущее окно
* проверяю печать ЗаявкаНаПеревозку
	И В панели открытых я выбираю 'Задание на перевозку *'
	Тогда открылось окно 'Задание на перевозку *'
	И я нажимаю на кнопку с именем 'ПодменюПечатьОбычное_ЗаявкаНаПеревозку'
	Тогда открылось окно 'Печать документа'
	И Табличный документ "ТекущаяПечатнаяФорма" равен макету "Шаблоны/Шаблон_ЗаявкаНаПеревозку_Плитка" по шаблону
	И я закрываю текущее окно	
	И я закрыл все окна клиентского приложения

* запускаю систему под ролю работника склада
	И я подключаю TestClient "Работник склада ТК ВОГ" логин "Работник склада ТК ВОГ" пароль ""
	И я закрыл все окна клиентского приложения
* нахожу и открываю документ расходный товарный ордер
	И Я открываю навигационную ссылку "e1cib/list/ЖурналДокументов.СкладскиеОрдера"
	Когда открылось окно 'Складские ордера'
	И я нажимаю кнопку выбора у поля с именем "Склад"
	Тогда открылось окно 'Склады и магазины'
	И в таблице "Список" я перехожу к строке:
		| 'Наименование'     |
		| '$$Склад$$'       |
	И в таблице "Список" я выбираю текущую строку		
	И в таблице "ЖурналОрдеров" я перехожу к строке содержащей подстроки
		| 'Номер'       | 'Тип документа'             |
		| '$$НомерРО$$' | 'Расходный ордер на товары' |
	И в таблице "ЖурналОрдеров" я выбираю текущую строку
	Тогда открылось окно 'Расходный ордер на товары *'
* Перевожу РО в статус К отгрузке
	И из выпадающего списка с именем "Статус" я выбираю точное значение 'К отгрузке'
	И я нажимаю на кнопку с именем 'ФормаПровестиИЗакрыть'

* Формирую документы из задания на перевозку
	И я подключаю TestClient "Работник склада ТК ВОГ" логин "Работник склада ТК ВОГ" пароль ""
	И я закрыл все окна клиентского приложения
	И Я формирую документы из задания на перевозку

* проверяю печать ТТН из задания на перевозку
	И я подключаю TestClient "Работник склада ТК ВОГ" логин "Работник склада ТК ВОГ" пароль ""
	И я закрыл все окна клиентского приложения
	Дано Я открываю навигационную ссылку "e1cib/list/Документ.ЗаданиеНаПеревозку"
	Тогда открылось окно 'Задания на перевозку'
	И в таблице "Список" я перехожу к строке содержащей подстроки
		| 'Номер'                       |
		| '$$НомерЗаданияНаПеревозку$$' |
	И в таблице "Список" я выбираю текущую строку
	Когда открылось окно 'Задание на перевозку *'	
	И я нажимаю на кнопку с именем 'ПодменюПечатьОбычное_ТранспортнаяНакладная'
	Тогда открылось окно 'Транспортная накладная *'
	Дано Табличный документ "ПечатнаяФорма1" равен макету "Шаблоны/ПечатнаяФормаТТН_Плитка" по шаблону
	И я закрываю текущее окно
* проверяю печать УПД из задания на перевозку
	Когда открылось окно 'Задание на перевозку *'	
	И я нажимаю на кнопку с именем 'ПодменюПечатьОбычное_КомплектДокументов'
	И я нажимаю на кнопку 'Единый комплект'
	//дописать
	Тогда открылось окно 'Транспортная накладная *' 
	Дано Табличный документ "ПечатнаяФорма1" равен макету "Шаблоны/ПечатнаяФормаТТН_Плитка" по шаблону
	И я закрываю текущее окно
	
* запускаю систему под ролю работника склада
	И я подключаю TestClient "Менеджер по доставке ТК ВОГ" логин "Менеджер по доставке ТК ВОГ" пароль ""
	И я закрыл все окна клиентского приложения
* нахожу и открываю документ расходный товарный ордер
	И Я открываю навигационную ссылку "e1cib/list/ЖурналДокументов.СкладскиеОрдера"
	Когда открылось окно 'Складские ордера'
	И я нажимаю кнопку выбора у поля с именем "Склад"
	Тогда открылось окно 'Склады и магазины'
	И в таблице "Список" я перехожу к строке:
		| 'Наименование'    |
		| '$$Склад$$'       |
	И в таблице "Список" я выбираю текущую строку		
	И в таблице "ЖурналОрдеров" я перехожу к строке содержащей подстроки
		| 'Номер'       | 'Тип документа'             |
		| '$$НомерРО$$' | 'Расходный ордер на товары' |
	И в таблице "ЖурналОрдеров" я выбираю текущую строку
	Тогда открылось окно 'Расходный ордер на товары *'
	* проверяю расчет мест в РО при изменении паллетированной отгрузки (ERP-1583) 
	И элемент формы "Паллетированная отгрузка" стал равен "Да"
	И элемент формы 'Количество коробок' стал равен '0'
	И элемент формы 'Количество паллет' стал равен '5'
	И элемент формы 'Всего в ордере' стал равен '5'
	