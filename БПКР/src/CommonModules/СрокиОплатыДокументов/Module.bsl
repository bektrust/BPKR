#Область ПрограммныйИнтерфейс

// Возвращает срок оплаты для документа, срок должен содержаться в регистре
//   Параметры:
//   Организация - СправочникСсылка.Организации - Организация по которой нужны данные
//   Ссылка      - ДокументСсылка.* - документ, для которого нужно получить срок оплаты
//
// Возвращаемое значение:
//   СрокОплаты - Дата - если срока нет в регистре, то возвращается Неопределено
//
Функция УстановленныйСрокОплаты(Ссылка, Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Документ",    Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СрокиОплатыДокументов.СрокОплаты
	|ИЗ
	|	РегистрСведений.СрокиОплатыДокументов КАК СрокиОплатыДокументов
	|ГДЕ
	|	СрокиОплатыДокументов.Организация = &Организация
	|	И СрокиОплатыДокументов.Документ = &Документ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.СрокОплаты;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

// Возвращает таблицу с просроченной задолженностью поставщикам
// Параметры:
//   Организация - СправочникСсылка.Организации - отбор по организации (может быть пустой).
//   ДатаЗадолженности - Дата - на какую дату будет получена задолженность.
//
// Возвращаемое значение:
//   ТаблицаЗначений - см. ПросроченнаяЗадолженность().
//
Функция ПросроченнаяЗадолженностьПоставщикам(Организация, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги = Ложь) Экспорт
	
	Возврат ПросроченнаяЗадолженность(
				2,
				Организация,
				ДатаЗадолженности,
				РазрешеноИспользоватьТекущиеИтоги);

КонецФункции

// Возвращает таблицу с просроченной задолженностью покупателей
// Параметры:
//   Организация - СправочникСсылка.Организации - отбор по организации (может быть пустой).
//   ДатаЗадолженности - Дата - на какую дату будет получена задолженность.
//   РазрешеноИспользоватьТекущиеИтоги - Булево - Если Истина, то при совпадении даты задолженности с текущим днем, 
//				будут использованы текущие итоги регистра бухгалтерии.
//   РазрешеноИспользоватьТекущиеИтоги - Булево - Если Истина, то при совпадении даты задолженности с текущим днем, 
//				будут использованы текущие итоги регистра бухгалтерии.
//
// Возвращаемое значение:
//   ТаблицаЗначений - см. ПросроченнаяЗадолженность().
//
Функция ПросроченнаяЗадолженностьПокупателей(Организация, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги = Ложь) Экспорт
	
	Возврат ПросроченнаяЗадолженность(
				1,
				Организация,
				ДатаЗадолженности,
				РазрешеноИспользоватьТекущиеИтоги);
	
КонецФункции

// Возвращает таблицу с просроченной задолженностью поставщикам
// Параметры:
//   Тип         - Число - определяет для кого надо получить данные: 1 - покупатель, 2 - поставщик
//   Организация - СправочникСсылка.Организации - отбор по организации (может быть пустой).
//   ДатаЗадолженности - Дата - на какую дату будет получена задолженность
//   РазрешеноИспользоватьТекущиеИтоги - Булево - Если Истина, то при совпадении даты задолженности с текущим днем, 
//				будут использованы текущие итоги регистра бухгалтерии.
//
// Возвращаемое значение:
//   ТаблицаЗначений
//     *Организация                    - СправочникСсылка.Организации
//     *Контрагент                     - СправочникСсылка.Контрагенты
//     *Договор                        - СправочникСсылка.ДоговорыКонтрагентов
//     *Документ                       - Документ расчетов с контрагентом
//     *ПросроченнаяЗадолженность      - Число
//
Функция ПросроченнаяЗадолженность(Тип, Организация, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги)
	
	СписокОрганизаций = БухгалтерскиеОтчеты.СписокДоступныхОрганизаций(Организация);
	
	Запрос = НовыйЗапросПросроченнаяЗадолженность(Тип, СписокОрганизаций, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги);
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	//ПросроченнаяЗадолженность = РезультатЗапроса[3].Выгрузить(); // учтены сроки оплаты документов
	
	СрокиОплаты = РезультатЗапроса[2].Выгрузить().ВыгрузитьКолонку("СрокОплаты"); // сроки оплаты долгов без документов
	
	// Не для всех задолженностей можно определить документ расчетов, и, как следствие - дату возникновения долга.
	// Поэтому для долгов без документов используется следующая методика:
	// Получаем сумму долга на дату задолженности, из этой суммы вычитаем сумму увеличения долга за период отсрочки.
	// Например, долг, который был вчера, это долг, который есть сегодня, минус увеличение долга за этот один день.
	// Таким образом, получаем сумму просроченной задолженностью.
	Если СрокиОплаты.Количество() > 0 Тогда
		
		ДлинаСуток = 86400;
		ТекстЗапросаУвеличениеДолга = "";
		
		Для Индекс = 0 По СрокиОплаты.ВГраница() Цикл
			
			СрокОплаты             = СрокиОплаты[Индекс];
			ДатаНачалаИнтервала    = НачалоДня(ДатаЗадолженности - ДлинаСуток * СрокОплаты);
			ГраницаНачалаИнтервала = Новый Граница(ДатаНачалаИнтервала, ВидГраницы.Включая);
			
			Запрос.УстановитьПараметр("НачалоИнтервала" + (Индекс+1), ГраницаНачалаИнтервала);
			Запрос.УстановитьПараметр("СрокОплаты"      + (Индекс+1), СрокОплаты);
			
			Если НЕ ПустаяСтрока(ТекстЗапросаУвеличениеДолга) Тогда
				ТекстЗапросаУвеличениеДолга = ТекстЗапросаУвеличениеДолга + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ" + Символы.ПС;
			КонецЕсли;
			
			ТекстЗапросаУвеличениеДолга = ТекстЗапросаУвеличениеДолга + ТекстЗапросаУвеличениеДолгаЗаПериодСрока(Тип, Индекс+1);
			
		КонецЦикла;
		
		Запрос.Текст = ТекстЗапросаУвеличениеДолга + ОбщегоНазначения.РазделительПакетаЗапросов()
					 + ТекстЗапросаПодсчетПросроченногоДолгаБезДокументов();
		
		ПросроченнаяЗадолженность = Запрос.Выполнить().Выгрузить();
		//ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ОстальнаяПросроченнаяЗадолженность, ПросроченнаяЗадолженность);
		
	КонецЕсли;
	
	Возврат ПросроченнаяЗадолженность;
	
КонецФункции

Функция ПредставлениеСрокаОплаты(СрокОплаты) Экспорт
	
	ТекстСрокОплаты = НСтр("ru = 'Срок %1'");
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСрокОплаты, Формат(СрокОплаты, "ДФ=dd.MM.yyyy"));
	
КонецФункции

// Возвращает срок оплаты выставленного счета по умолчанию
// Возвращаемое значение:
//   СрокОплаты - Число
//
Функция СрокОплатыСчетаПокупателюПоУмолчанию() Экспорт
	
	Возврат 3;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйЗапросПросроченнаяЗадолженность(Тип, СписокОрганизаций, ДатаЗадолженности, РазрешеноИспользоватьТекущиеИтоги)
	
	Если Тип = 1 Тогда
		
		ВидыДоговоров            = БухгалтерскиеОтчеты.ВидыДоговоровПокупателей();
		СчетаУчетаРасчетов       = МониторРуководителя.СчетаРасчетовСКонтрагентами(1);
		СрокОплатыПараметрыУчета = Константы.СрокОплатыПокупателей.Получить();
		ИспользуютсяСрокиОплаты  = СрокОплатыПараметрыУчета > 0;
		
	ИначеЕсли Тип = 2 Тогда
		
		ВидыДоговоров            = БухгалтерскиеОтчеты.ВидыДоговоровПоставщиков();
		СчетаУчетаРасчетов       = МониторРуководителя.СчетаРасчетовСКонтрагентами(2);
		СрокОплатыПараметрыУчета = Константы.СрокОплатыПоставщикам.Получить();
		ИспользуютсяСрокиОплаты  = СрокОплатыПараметрыУчета > 0;
		
	КонецЕсли;
	
	ВидСубконтоКонтрагенты = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты;
	ВидСубконтоДоговоры    = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры;
	
	ВидыСубконтоКД = Новый СписокЗначений;
	ВидыСубконтоКД.Добавить(ВидСубконтоКонтрагенты);
	ВидыСубконтоКД.Добавить(ВидСубконтоДоговоры);
	
	//ВидыСубконтоКДД = Новый СписокЗначений;
	//ВидыСубконтоКДД.Добавить(ВидСубконтоКонтрагенты);
	//ВидыСубконтоКДД.Добавить(ВидСубконтоДоговоры);
	//ВидыСубконтоКДД.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("СписокОрганизаций",         СписокОрганизаций);
	Запрос.УстановитьПараметр("ВидыДоговоров",             ВидыДоговоров);
	Запрос.УстановитьПараметр("КонецИнтервала",            КонецДня(ДатаЗадолженности));
	Запрос.УстановитьПараметр("ВидыСубконтоКД",            ВидыСубконтоКД);
	//Запрос.УстановитьПараметр("ВидыСубконтоКДД",           ВидыСубконтоКДД);
	Если РазрешеноИспользоватьТекущиеИтоги И КонецДня(ДатаЗадолженности) = КонецДня(ТекущаяДатаСеанса()) Тогда
		// Если остатки получаются "на сегодня", то обращаемся к текущим итогам регистра.
		Запрос.УстановитьПараметр("ГраницаОстатков",       Неопределено);
	Иначе
		Запрос.УстановитьПараметр("ГраницаОстатков",       Новый Граница(КонецДня(ДатаЗадолженности), ВидГраницы.Включая));
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаЗадолженности",         НачалоДня(ДатаЗадолженности));
	Запрос.УстановитьПараметр("СтандартныйСрокОплаты",     СрокОплатыПараметрыУчета);
	//Запрос.УстановитьПараметр("СчетаСДокументомРасчетов",  СчетаУчетаРасчетов.СчетаСДокументомРасчетов);
	Запрос.УстановитьПараметр("СчетаБезДокументаРасчетов", СчетаУчетаРасчетов);
	//Запрос.УстановитьПараметр("ИспользуютсяСрокиОплаты",   ИспользуютсяСрокиОплаты);
	
	Запрос.Текст = ТекстЗапросСрокиДолговБезДокументов(Тип);
	
	Возврат Запрос;
	
КонецФункции

Функция ТекстЗапросСрокиДолговБезДокументов(Тип)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВзаиморасчетыОстатки.Организация КАК Организация,
	|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто1 КАК Справочник.Контрагенты) КАК Контрагент,
	|	ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов) КАК Договор,
	|	ВЫБОР
	|		КОГДА ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).УстановленСрокОплаты
	|			ТОГДА ВЫРАЗИТЬ(ВзаиморасчетыОстатки.Субконто2 КАК Справочник.ДоговорыКонтрагентов).СрокОплаты
	|		ИНАЧЕ &СтандартныйСрокОплаты
	|	КОНЕЦ КАК СрокОплаты,
	|	ВзаиморасчетыОстатки.СуммаРазвернутыйОстатокДт КАК ОстатокДолга
	|ПОМЕСТИТЬ ОстаткиДолгаБезДокументовБезГруппировки
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(
	|			&ГраницаОстатков,
	|			Счет В (&СчетаБезДокументаРасчетов),
	|			&ВидыСубконтоКД,
	|			ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).ВидДоговора В (&ВидыДоговоров)
	|				И Организация В (&СписокОрганизаций)) КАК ВзаиморасчетыОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиДолгаБезДокументовБезГруппировки.Организация КАК Организация,
	|	ОстаткиДолгаБезДокументовБезГруппировки.Контрагент КАК Контрагент,
	|	ОстаткиДолгаБезДокументовБезГруппировки.Договор КАК Договор,
	|	ОстаткиДолгаБезДокументовБезГруппировки.СрокОплаты КАК СрокОплаты,
	|	СУММА(ОстаткиДолгаБезДокументовБезГруппировки.ОстатокДолга) КАК ОстатокДолга
	|ПОМЕСТИТЬ ОстаткиДолгаБезДокументов
	|ИЗ
	|	ОстаткиДолгаБезДокументовБезГруппировки КАК ОстаткиДолгаБезДокументовБезГруппировки
	|
	|СГРУППИРОВАТЬ ПО
	|	ОстаткиДолгаБезДокументовБезГруппировки.Договор,
	|	ОстаткиДолгаБезДокументовБезГруппировки.Организация,
	|	ОстаткиДолгаБезДокументовБезГруппировки.Контрагент,
	|	ОстаткиДолгаБезДокументовБезГруппировки.СрокОплаты
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОстаткиДолгаБезДокументов.СрокОплаты КАК СрокОплаты
	|ИЗ
	|	ОстаткиДолгаБезДокументов КАК ОстаткиДолгаБезДокументов";
	
	Если Тип = 2 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СуммаРазвернутыйОстатокДт", "СуммаРазвернутыйОстатокКт");
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаУвеличениеДолгаЗаПериодСрока(Тип, Индекс)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВзаиморасчетыОбороты.Организация КАК Организация,
	|	ВзаиморасчетыОбороты.Субконто1 КАК Контрагент,
	|	ВзаиморасчетыОбороты.Субконто2 КАК Договор,
	|	&ПолеУвеличениеДолга КАК УвеличениеДолга"
	+
	?(Индекс = 1, Символы.ПС + "ПОМЕСТИТЬ УвеличениеДолгаБезГруппировки" + Символы.ПС, Символы.ПС)
	+
	"ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Обороты(
	|			&НачалоИнтервала0,
	|			&ГраницаОстатков,
	|			,
	|			Счет В (&СчетаБезДокументаРасчетов),
	|			&ВидыСубконтоКД,
	|			ВЫБОР
	|					КОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).УстановленСрокОплаты
	|						ТОГДА ВЫРАЗИТЬ(Субконто2 КАК Справочник.ДоговорыКонтрагентов).СрокОплаты
	|					ИНАЧЕ &СтандартныйСрокОплаты
	|				КОНЕЦ = &СрокОплаты0
	|				И Организация В(&СписокОрганизаций),
	|			,
	|			) КАК ВзаиморасчетыОбороты";
	
	Если Тип = 1 Тогда
		ТекстПоляУвеличениеДолга = 
		"ВЫБОР
		|	КОГДА ВзаиморасчетыОбороты.СуммаОборотДт > 0
		|		ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
		|	ИНАЧЕ 0
		|КОНЕЦ - ВЫБОР
		|	КОГДА ВзаиморасчетыОбороты.СуммаОборотДт < 0
		|		ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
		|	ИНАЧЕ 0
		|КОНЕЦ";
	ИначеЕсли Тип = 2 Тогда
		ТекстПоляУвеличениеДолга = 
		"ВЫБОР
		|	КОГДА ВзаиморасчетыОбороты.СуммаОборотКт > 0
		|		ТОГДА ВзаиморасчетыОбороты.СуммаОборотКт
		|	ИНАЧЕ 0
		|КОНЕЦ - ВЫБОР
		|	КОГДА ВзаиморасчетыОбороты.СуммаОборотДт < 0
		|		ТОГДА ВзаиморасчетыОбороты.СуммаОборотДт
		|	ИНАЧЕ 0
		|КОНЕЦ";
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеУвеличениеДолга", ТекстПоляУвеличениеДолга);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "НачалоИнтервала0"    , "НачалоИнтервала" + Индекс);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СрокОплаты0"         , "СрокОплаты"      + Индекс);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПодсчетПросроченногоДолгаБезДокументов()
	
	Возврат
	"ВЫБРАТЬ
	|	УвеличениеДолгаБезГруппировки.Организация КАК Организация,
	|	УвеличениеДолгаБезГруппировки.Контрагент КАК Контрагент,
	|	УвеличениеДолгаБезГруппировки.Договор КАК Договор,
	|	СУММА(УвеличениеДолгаБезГруппировки.УвеличениеДолга) КАК УвеличениеДолга
	|ПОМЕСТИТЬ УвеличениеДолгаДляВсехСроков
	|ИЗ
	|	УвеличениеДолгаБезГруппировки КАК УвеличениеДолгаБезГруппировки
	|
	|СГРУППИРОВАТЬ ПО
	|	УвеличениеДолгаБезГруппировки.Договор,
	|	УвеличениеДолгаБезГруппировки.Организация,
	|	УвеличениеДолгаБезГруппировки.Контрагент
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Контрагент,
	|	Договор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОстаткиДолгаБезДокументов.Организация,
	|	ОстаткиДолгаБезДокументов.Контрагент,
	|	ОстаткиДолгаБезДокументов.Договор,
	|	ВЫБОР
	|		КОГДА ОстаткиДолгаБезДокументов.ОстатокДолга > ЕСТЬNULL(УвеличениеДолгаДляВсехСроков.УвеличениеДолга, 0)
	|			ТОГДА ОстаткиДолгаБезДокументов.ОстатокДолга - ЕСТЬNULL(УвеличениеДолгаДляВсехСроков.УвеличениеДолга, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПросроченнаяЗадолженность
	|ИЗ
	|	ОстаткиДолгаБезДокументов КАК ОстаткиДолгаБезДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ УвеличениеДолгаДляВсехСроков КАК УвеличениеДолгаДляВсехСроков
	|		ПО ОстаткиДолгаБезДокументов.Организация = УвеличениеДолгаДляВсехСроков.Организация
	|			И ОстаткиДолгаБезДокументов.Контрагент = УвеличениеДолгаДляВсехСроков.Контрагент
	|			И ОстаткиДолгаБезДокументов.Договор = УвеличениеДолгаДляВсехСроков.Договор";
	
КонецФункции

#Область ПроцедурыОбновленияИБ

//// Заполняет начальные наcтройки ИБ
////
//Процедура УстановитьСрокиОплатыСчетов() Экспорт 
//	
//	Константы.СрокОплатыСчетовПокупателю.Установить(СрокОплатыСчетаПокупателюПоУмолчанию());
//	
//КонецПроцедуры

#КонецОбласти

#КонецОбласти
