#Область ПрограммныйИнтерфейс

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// АПК: 142-выкл обратная совместимость

// Функция возвращает список подключенного в справочнике ПО
//
// Параметры:
//  ТипыПО - Структура, Массив, Строка - тип оборудования для выбора устройства.
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование - подключаемое устройство.
//  РабочееМесто - СправочникСсылка.РабочиеМеста.
//  СетевоеОборудование - Булево - использовать сетевое оборудование при подключении.
//  СерверноеОборудование - Булево.
//  ТолькоАвтоматическаяФискализация - Булево.
//
// Возвращаемое значение:
//  Массив.
//
Функция ОборудованиеПоПараметрам(ТипыПО = Неопределено, Идентификатор = Неопределено, 
	РабочееМесто = Неопределено, СетевоеОборудование = Ложь, СерверноеОборудование = Ложь, ТолькоАвтоматическаяФискализация = Ложь) Экспорт
	
	ТекущийПользовательИБ = Строка(ПользователиИнформационнойБазы.ТекущийПользователь());
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ПодключаемоеОборудование.Ссылка КАК Ссылка,
	|	ПодключаемоеОборудование.Наименование КАК Наименование,
	|	ПодключаемоеОборудование.ТипОборудования КАК ТипОборудования,
	|	ПодключаемоеОборудование.ДрайверОборудования КАК ДрайверОборудования,  
	|	ПодключаемоеОборудование.ДрайверОборудования.ИмяПредопределенныхДанных КАК ДрайверОборудованияИмя, 
	|	ПодключаемоеОборудование.ДрайверОборудования.Предопределенный          КАК ВСоставеКонфигурации,
	|	ПодключаемоеОборудование.ДрайверОборудования.ИдентификаторОбъекта      КАК ИдентификаторОбъекта,
	|	ПодключаемоеОборудование.ДрайверОборудования.СнятСПоддержки            КАК СнятСПоддержки,
	|	ПодключаемоеОборудование.ДрайверОборудования.ВерсияДрайвера            КАК ВерсияДрайвера,
	|	ПодключаемоеОборудование.ДрайверОборудования.ИмяМакетаДрайвера         КАК ИмяМакетаДрайвера,
	|	ПодключаемоеОборудование.ДрайверОборудования.СпособПодключения         КАК СпособПодключения,
	|	ПодключаемоеОборудование.ДрайверОборудования.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
	|	ПодключаемоеОборудование.ТипПодключения КАК ТипПодключения,
	|	ПодключаемоеОборудование.РабочееМесто   КАК РабочееМесто,
	|	ПодключаемоеОборудование.ТребуетсяПереустановка КАК ТребуетсяПереустановка,
	|	ПодключаемоеОборудование.ТребуетсяУстановка КАК ТребуетсяУстановка,
		|	ПодключаемоеОборудование.ОграничениеДоступа.(
	|		Пользователь КАК Пользователь,
	|		Ссылка КАК Ссылка
	|	) КАК ОграничениеДоступа,
	|	ПодключаемоеОборудование.Параметры КАК Параметры
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|"; 
	                                                                       
	Если Идентификатор = Неопределено Тогда
		ТекстЗапроса = ТекстЗапроса + "НЕ ПодключаемоеОборудование.ПометкаУдаления И ПодключаемоеОборудование.УстройствоИспользуется" + Символы.ПС;
		Если СетевоеОборудование Тогда
			// Оборудование, подключенное к конкретному рабочему месту и сетевое оборудование.
			ТекстЗапроса = ТекстЗапроса 
				+ " И (ПодключаемоеОборудование.РабочееМесто = &РабочееМесто"
				+ " ИЛИ ПодключаемоеОборудование.ТипПодключения = ЗНАЧЕНИЕ(Перечисление.ТипыПодключенияОборудования.ОбщийДоступ))";
		Иначе
			// Оборудование подключенное только к конкретному рабочему месту.
			ТекстЗапроса = ТекстЗапроса + " И (ПодключаемоеОборудование.РабочееМесто = &РабочееМесто)";
		КонецЕсли;
		
		Если ТипыПО <> Неопределено Тогда
			ТекстЗапроса = ТекстЗапроса + " И (ПодключаемоеОборудование.ТипОборудования  В (&ТипОборудования))"
		КонецЕсли;
	Иначе
		ТекстЗапроса = ТекстЗапроса + " (ПодключаемоеОборудование.Ссылка = &Идентификатор)";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
		|УПОРЯДОЧИТЬ ПО
		|	Наименование;";
		
	Запрос = Новый Запрос(ТекстЗапроса);
	
	// Установим параметры запроса (фильтрующие выборку значения)
	Если Идентификатор = Неопределено Тогда
		
		Если НЕ ЗначениеЗаполнено(РабочееМесто) Тогда
			// Если РМ не задано в параметрах, то всегда текущее из параметров сеанса.
			РабочееМесто = МенеджерОборудованияВызовСервера.РабочееМестоКлиента();
		КонецЕсли;
		Запрос.УстановитьПараметр("РабочееМесто", РабочееМесто);
		
		// Фильтр по типам оборудования
		Если ТипыПО <> Неопределено Тогда
			// Подготовка перечислений типов ТО для запроса
			МассивТиповПО = Новый Массив();
			Если ТипЗнч(ТипыПО) = Тип("Структура") Тогда
				Для Каждого ТипПО Из ТипыПО Цикл
					МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипПО.Ключ]);
				КонецЦикла;
			ИначеЕсли ТипЗнч(ТипыПО) = Тип("Массив") Тогда
				Для Каждого ТипПО Из ТипыПО Цикл
					МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипПО]);
				КонецЦикла;
			Иначе
				МассивТиповПО.Добавить(Перечисления.ТипыПодключаемогоОборудования[ТипыПО]);
			КонецЕсли;
			Запрос.УстановитьПараметр("ТипОборудования", МассивТиповПО);
		КонецЕсли;
		
	Иначе // Фильтр по конкретному устройству
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Перебирая выборку составляем список устройств
	СписокОборудования = Новый Массив();
	Пока Выборка.Следующий() Цикл
		
		// Заполним структуру данных устройства
		ДанныеУстройства = Новый Структура();
		ДанныеУстройства.Вставить("Ссылка"                    , Выборка.Ссылка);
		ДанныеУстройства.Вставить("ТипОборудования"           , XMLСтрока(Выборка.ТипОборудования));
		ДанныеУстройства.Вставить("Наименование"              , Выборка.Наименование);
		ДанныеУстройства.Вставить("Параметры"                 , Выборка.Параметры.Получить());
		ДанныеУстройства.Вставить("ДрайверОборудования"       , Выборка.ДрайверОборудования);
		ДанныеУстройства.Вставить("ВСоставеКонфигурации"      , Выборка.ВСоставеКонфигурации);
		ДанныеУстройства.Вставить("ИдентификаторОбъекта"      , Выборка.ИдентификаторОбъекта);
		ДанныеУстройства.Вставить("СнятСПоддержки"            , Выборка.СнятСПоддержки);
		ДанныеУстройства.Вставить("ВерсияДрайвера"            , Выборка.ВерсияДрайвера);
		ДанныеУстройства.Вставить("СетевоеОборудование"       , Выборка.ТипПодключения = Перечисления.ТипыПодключенияОборудования.ОбщийДоступ);
		
		СпособПодключения = Выборка.СпособПодключения;
		ПодключениеИзМакета = СпособПодключения = Перечисления.СпособПодключенияДрайвера.ИзМакета;
		ПодключениеЛокальноПоИдентификатору = СпособПодключения = Перечисления.СпособПодключенияДрайвера.ЛокальноПоИдентификатору;
		ПодключениеНеТребуется = СпособПодключения = Перечисления.СпособПодключенияДрайвера.ПодключениеНеТребуется;
		
		Если ПодключениеИзМакета Тогда
			Если ПустаяСтрока(Выборка.ИмяМакетаДрайвера) Тогда
				ИмяМакетаДрайвера = Выборка.ИмяПредопределенныхДанных
			Иначе
				ИмяМакетаДрайвера = Выборка.ИмяМакетаДрайвера
			КонецЕсли;
			МакетДоступен = Метаданные.ОбщиеМакеты.Найти(ИмяМакетаДрайвера) <> Неопределено;
			ИмяМакетаДрайвера = "ОбщийМакет." + ИмяМакетаДрайвера;
		Иначе
			МакетДоступен = Ложь;
			ИмяМакетаДрайвера = "";
		КонецЕсли;
		
		ДанныеУстройства.Вставить("СпособПодключения"        , СпособПодключения);
		ДанныеУстройства.Вставить("ПодключениеНеТребуется"      , ПодключениеНеТребуется);
		ДанныеУстройства.Вставить("ПодключениеИзМакета"      , ПодключениеИзМакета);
		ДанныеУстройства.Вставить("ПодключениеЛокальноПоИдентификатору", ПодключениеЛокальноПоИдентификатору);
		ДанныеУстройства.Вставить("ИмяМакетаДрайвера"  , ИмяМакетаДрайвера);
		ДанныеУстройства.Вставить("МакетДоступен"      , МакетДоступен);
		ДанныеУстройства.Вставить("ТребуетсяПереустановка"    , Выборка.ТребуетсяПереустановка);
		ДанныеУстройства.Вставить("ТребуетсяУстановка"        , Выборка.ТребуетсяУстановка);
		
		// Ограничение доступа
		ОграничениеДоступа = Новый Массив();
		ВыборкаОграничениеДоступа = Выборка.ОграничениеДоступа.Выбрать(); 
		Пока ВыборкаОграничениеДоступа.Следующий() Цикл
			ОграничениеДоступа.Добавить(Строка(ВыборкаОграничениеДоступа.Пользователь));
		КонецЦикла;
		ДанныеУстройства.Вставить("ОграничениеДоступа", ОграничениеДоступа);
		Если ОграничениеДоступа.Количество() > 0 Тогда
			ДоступноТекущемуПользователю = ОграничениеДоступа.Найти(ТекущийПользовательИБ) <> Неопределено;
		Иначе
			ДоступноТекущемуПользователю = Истина;
		КонецЕсли;
		ДанныеУстройства.Вставить("ДоступноТекущемуПользователю", ДоступноТекущемуПользователю);
		
		Если Выборка.ТипОборудования = Перечисления.ТипыПодключаемогоОборудования.ККТ 
			И МенеджерОборудованияВызовСервера.ИспользуетсяЧекопечатающиеУстройства() Тогда
				МодульОборудованиеЧекопечатающиеУстройстваВызовСервера = ОбщегоНазначения.ОбщийМодуль("ОборудованиеЧекопечатающиеУстройстваВызовСервера");
				ПараметрыРегистрации = МодульОборудованиеЧекопечатающиеУстройстваВызовСервера.ПараметрыРегистрацииУстройства(Выборка.Ссылка);
		Иначе
			ПараметрыРегистрации = Новый Структура();
		КонецЕсли;
		
		ДанныеУстройства.Вставить("ПараметрыРегистрации", ПараметрыРегистрации);
		
		СписокОборудования.Добавить(ДанныеУстройства);
	КонецЦикла;
	
	// Возвращаем полученный список с данными всех найденных устройств
	Возврат СписокОборудования;
	
КонецФункции

// АПК: 142-вкл

// Функция возвращает по идентификатору устройства его параметры
//
// Параметры:
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПараметрыУстройства(Идентификатор) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПодключаемоеОборудование.Параметры
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
	|ГДЕ
	|	ПодключаемоеОборудование.Ссылка = &Идентификатор");
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Результат = Выборка.Параметры.Получить();
	Возврат Результат;
	
КонецФункции

// Процедура предназначена для сохранения параметров устройства
// в реквизит Параметры типа хранилище значения в элементе справочника.
//
// Параметры:
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование.
//  Параметры - Структура - параметры устройства.
//
// Возвращаемое значение:
//  Булево.
//
Функция СохранитьПараметрыУстройства(Идентификатор, Параметры) Экспорт
	
	Попытка
		Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	ПодключаемоеОборудование.Ссылка
		|ИЗ
		|	Справочник.ПодключаемоеОборудование КАК ПодключаемоеОборудование
		|ГДЕ
		|	ПодключаемоеОборудование.Ссылка = &Идентификатор");
		
		Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
		ТаблицаРезультатов = Запрос.Выполнить().Выгрузить();
		ОбъектСправочника = ТаблицаРезультатов[0].Ссылка.ПолучитьОбъект();
		ОбъектСправочника.Заблокировать();
		ОбъектСправочника.Параметры = Новый ХранилищеЗначения(Параметры);
		ОбъектСправочника.Записать();
		Результат = Истина;
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Функция возвращает структуру с данными устройства
//
// Параметры:
//  Идентификатор - СправочникСсылка.ПодключаемоеОборудование.
//
// Возвращаемое значение:
//  Структура.
//
Функция ДанныеУстройства(Идентификатор) Экспорт
	
	СписокОборудования = ОборудованиеПоПараметрам(, Идентификатор);
	
	Если СписокОборудования.Количество() > 0 Тогда
		Результат = СписокОборудования[0]
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// СтандартныеПодсистемы.УправлениеДоступом
// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
//
// Параметры:
//  Ограничение - Структура:
//    * Текст                             - Строка - ограничение доступа для пользователей.
//                                          Если пустая строка, значит, доступ разрешен.
//    * ТекстДляВнешнихПользователей      - Строка - ограничение доступа для внешних пользователей.
//                                          Если пустая строка, значит, доступ запрещен.
//    * ПоВладельцуБезЗаписиКлючейДоступа - Неопределено - определить автоматически.
//                                        - Булево - если Ложь, то всегда записывать ключи доступа,
//                                          если Истина, тогда не записывать ключи доступа,
//                                          а использовать ключи доступа владельца (требуется,
//                                          чтобы ограничение было строго по объекту-владельцу).
//   * ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей - Неопределено, Булево - также
//                                          как у параметра ПоВладельцуБезЗаписиКлючейДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Менеджер = "Справочник.ПодключаемоеОборудование";
	МенеджерОборудованияВызовСервераПереопределяемый.ПриЗаполненииОграниченияДоступа(Менеджер, Ограничение);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецЕсли

#КонецОбласти