///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список организаций по таблице отбора (см "ПредставлениеОтбораИнтерактивнойВыгрузки").
// Также используется из демонстрационной формы "НастройкаВыгрузки" этого плана обмена.
//
// Параметры:
//   ТаблицаОтбора - ТаблицаЗначений - содержит строки с описанием подробных отборов по сценарию узла:
//     * ПолноеИмяМетаданных - Строка
//     * ВыборПериода        - Булево
//     * Период              - СтандартныйПериод
//     * Отбор               - ОтборКомпоновкиДанных
//
// Возвращаемое значение:
//     СписокЗначений - значение - ссылка на организацию, представление - наименование.
//
Функция ОрганизацииОтбораИнтерактивнойВыгрузки(Знач ТаблицаОтбора) Экспорт 
	
	Результат = Новый СписокЗначений;
	
	Если ТаблицаОтбора.Количество() = 0 Тогда
		// Нет данных отбора
		Возврат Результат;
	КонецЕсли;
	
	СтрокаТаблицыОтбора = ТаблицаОтбора.Получить(0);
	
	Если СтрокаТаблицыОтбора.Отбор.Элементы.Количество() = 0 Тогда
		// Нет данных отбора
		Возврат Результат;
	КонецЕсли;
		
	// Мы знаем состав отбора, так как помещали туда сами - или из "НастроитьИнтерактивнуюВыгрузку"
	// или как результат редактирования в форме.
	
	СтрокаДанных = СтрокаТаблицыОтбора.Отбор.Элементы[0];
	Отобранные   = СтрокаДанных.ПравоеЗначение;
	
	Если ТипЗнч(Отобранные) = Тип("СписокЗначений") Тогда
		Для Каждого Элемент Из Отобранные Цикл
			ДобавитьСписокОрганизаций(Результат, Элемент.Значение);
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Отобранные) = Тип("Массив") Тогда
		ДобавитьСписокОрганизаций(Результат, Отобранные);
		 
	ИначеЕсли ТипЗнч(Отобранные) = Тип("СправочникСсылка.Организации") Тогда
		Если Результат.НайтиПоЗначению(Отобранные) = Неопределено Тогда
			Результат.Добавить(Отобранные, ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отобранные, "Наименование"));
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	// В демонстрационной конфигурации значение хранится в константе
	// ИмяКонфигурацииВОбменеСБиблиотекойСтандартныхПодсистем.
	// Это связано с необходимостью настройки обмена между идентичными конфигурациями "БСП-БСП".
	// Для настройки обмена между различными конфигурациями функция должна возвращать константное значение.
	ИмяКонфигурацииИсточника = "";
	Настройки.ИмяКонфигурацииИсточника = ?(ПустаяСтрока(ИмяКонфигурацииИсточника),
		Метаданные.Имя, ИмяКонфигурацииИсточника);
		
	Настройки.ЭтоПланОбменаXDTO = Истина;
	Настройки.ФорматОбмена = "http://v8.1c.ru/edi/edi_stnd/EnterpriseData";
	
	ВерсииФормата = Новый Соответствие;
	ВерсииФормата.Вставить("1.7", МенеджерОбменаЧерезУниверсальныйФормат);
	ВерсииФормата.Вставить("1.8", МенеджерОбменаЧерезУниверсальныйФормат);
	
	Настройки.ВерсииФорматаОбмена = ВерсииФормата;
	
	//Настройки.РасширенияФорматаОбмена.Вставить("http://v8.1c.ru/edi/edi_stnd/_DemoEnterpriseDataExt/1.1", "1.8");
	
	Настройки.ПланОбменаИспользуетсяВМоделиСервиса = Истина;
	
	Настройки.Алгоритмы.ПриПолученииВариантовНастроекОбмена   = Истина;
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	
	Настройки.Алгоритмы.ПредставлениеОтбораИнтерактивнойВыгрузки = Истина;
	Настройки.Алгоритмы.НастроитьИнтерактивнуюВыгрузку           = Истина;
	
	//Настройки.Алгоритмы.ОбработчикПроверкиПараметровУчета           = Истина;
	//Настройки.Алгоритмы.ОбработчикПроверкиОграниченийПередачиДанных = Истина;
	//Настройки.Алгоритмы.ОбработчикПроверкиЗначенийПоУмолчанию       = Истина;
	//
	//Настройки.Алгоритмы.ПриПодключенииККорреспонденту     = Истина;
	//
	//Настройки.Алгоритмы.ПриОпределенииПоддерживаемыхОбъектовФормата = Истина;
	//Настройки.Алгоритмы.ПриОпределенииПоддерживаемыхКорреспондентомОбъектовФормата = Истина;
	//
	//Настройки.Алгоритмы.ПередНастройкойСинхронизацииДанных = Истина;
	
КонецПроцедуры

// Заполняет коллекцию вариантов настроек, предусмотренных для плана обмена.
// 
// Параметры:
//  ВариантыНастроекОбмена - см. ОбменДаннымиСервер.КоллекцияВариантовНастроекОбмена
//  ПараметрыКонтекста     - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияВариантовНастроек
//
Процедура ПриПолученииВариантовНастроекОбмена(ВариантыНастроекОбмена, ПараметрыКонтекста) Экспорт
	
	//Если Не ЗначениеЗаполнено(ПараметрыКонтекста.ИмяКорреспондента)
	//	Или ПараметрыКонтекста.ИмяКорреспондента = "БиблиотекаСтандартныхПодсистемДемо" Тогда
	//	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	//	ВариантНастройки.ИдентификаторНастройки        = "БСП";
	//	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	//	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	//	
	//	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	//	ВариантНастройки.ИдентификаторНастройки        = "БСПБезСопоставления";
	//	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	//	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
	//КонецЕсли;
	
	Если ПараметрыКонтекста.ИмяКорреспондента = "Розница"
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыКонтекста.ИмяКорреспондента) Тогда
		
		ВариантНастройки = ВариантыНастроекОбмена.Добавить();
		ВариантНастройки.ИдентификаторНастройки        = "ОбменРозница";
		ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
		ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
		
	КонецЕсли;
	
	Если ПараметрыКонтекста.ИмяКорреспондента = "ОбменМК"
		ИЛИ НЕ ЗначениеЗаполнено(ПараметрыКонтекста.ИмяКорреспондента) Тогда
		
		ВариантНастройки = ВариантыНастроекОбмена.Добавить();
		ВариантНастройки.ИдентификаторНастройки        = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой();
		ВариантНастройки.КорреспондентВМоделиСервиса   = Ложь;
		ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;
		
	КонецЕсли;
	
	ВариантНастройки = ВариантыНастроекОбмена.Добавить();
	ВариантНастройки.ИдентификаторНастройки        = "ОбменУниверсальный";
	ВариантНастройки.КорреспондентВМоделиСервиса   = Истина;
	ВариантНастройки.КорреспондентВЛокальномРежиме = Истина;

КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию
//  ИдентификаторНастройки - Строка - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	ПоддерживаетсяСопоставлениеДанных = Истина;
	
	КраткаяИнформацияПоОбмену = "";
	ИмяКонфигурацииКорреспондента = "";
	НаименованиеКонфигурацииКорреспондента = "";
	
	ЗаголовокКоманды   = НСтр("ru = 'Синхронизация данных через универсальный формат'");
	ЗаголовокПомощника = "";
	ЗаголовокУзла      = "";
	
	Если ИдентификаторНастройки = "ОбменРозница" Тогда
		ИмяКонфигурацииКорреспондента = "РозницаДляКыргызстана";
		НаименованиеКонфигурацииКорреспондента = НСтр("ru = '1С:Розница для Кыргызстана, редакция 2.3'");
		
		КраткаяИнформацияПоОбмену = НСтр("ru = 'Данная настройка позволит синхронизировать данные между программами ""Бухгалтерия для Кыргызстана, редакция 3""
		|и ""Розница для Кыргызстана, редакция 2.3"". В синхронизации участвуют документы и нормативно-справочная информация.'");
		
		ЗаголовокКоманды = НСтр("ru = '1С:Розница для Кыргызстана, редакция 2.3'");
		ЗаголовокПомощника = НСтр("ru = 'Настройка синхронизации с программой ""1С:Розница для Кыргызстана, редакция 2.3""'");
		ЗаголовокУзла = НСтр("ru = 'Синхронизация с программой ""1С:Розница для Кыргызстана, редакция 2.3""'");

	ИначеЕсли ИдентификаторНастройки = ИдентификаторОбменаСМобильнойКассой() Тогда
		ИмяКонфигурацииКорреспондента = "МобильнаяКасса";
		НаименованиеКонфигурацииКорреспондента = НСтр("ru = '1С:Мобильная касса для Кыргызстана'");

		КраткаяИнформацияПоОбмену = НСтр("ru = 'Данная настройка позволит синхронизировать данные между программами ""Бухгалтерия для Кыргызстана, редакция 3""
		|и ""1С:Мобильная касса для Кыргызстана"". В синхронизации участвуют документы и нормативно-справочная информация.'");

		ЗаголовокКоманды = НСтр("ru = '1С:Мобильная касса для Кыргызстана'");
		ЗаголовокПомощника = НСтр("ru = 'Настройка синхронизации с программой ""1С:Мобильная касса для Кыргызстана""'");
		ЗаголовокУзла = НСтр("ru = 'Синхронизация с программой ""1С:Мобильная касса для Кыргызстана""'");
		
		ОписаниеВарианта.ИспользуемыеТранспортыСообщенийОбмена.Добавить(
			Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Иначе
		// Другая программа.
		ИмяКонфигурацииКорреспондента          = "";
		НаименованиеКонфигурацииКорреспондента = НСтр("ru = 'Другая программа'");
		
		КраткаяИнформацияПоОбмену = НСтр("ru = 'Позволяет синхронизировать данные с любой программой, поддерживающей универсальный формат обмена ""Enterprise Data"".
		|В синхронизации данных участвуют следующие типы данных:
		| - справочники (например, Организации),
		| - документы (например, Реализация товаров).'");
	КонецЕсли;
	
	ПодробнаяИнформацияПоОбмену = "ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.ПодробнаяИнформация";
	
	ОписаниеВарианта.ПоддерживаетсяСопоставлениеДанных = ПоддерживаетсяСопоставлениеДанных;
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену;
	
	ОписаниеВарианта.ИмяКонфигурацииКорреспондента          = ИмяКонфигурацииКорреспондента;
	ОписаниеВарианта.НаименованиеКонфигурацииКорреспондента = НаименованиеКонфигурацииКорреспондента;
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника           = НСтр("ru = 'Синхронизация данных через универсальный формат'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = ЗаголовокКоманды;
	ОписаниеВарианта.ЗаголовокПомощникаСозданияОбмена               = ЗаголовокПомощника;
	ОписаниеВарианта.ЗаголовокУзлаПланаОбмена                       = ЗаголовокУзла;
	
	//ПояснениеДляНастройкиПараметровУчета = НСтр("ru = 'Требуется указать ответственных для организаций.
	//|Для этого перейдите в раздел ""Синхронизация данных"" и выберите команду ""Ответственные лица организаций"".'");
	//ОписаниеВарианта.ПояснениеДляНастройкиПараметровУчета = ПояснениеДляНастройкиПараметровУчета;

КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку".
//
// Параметры:
//     Получатель - ПланОбменаСсылка - узел, для которого определяется представление отбора.
//     Параметры  - Структура        - характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию
//                                                        узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка.
//                                                               Например "Документ.ПоступлениеТоваров". Могут
//                                                               быть использованы специальные  значения "ВсеДокументы"
//                                                               и "ВсеСправочники" для отбора соответственно всех
//                                                               документов и всех справочников, регистрирующихся на
//                                                               узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим
//                                                               периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с
//                                                               общим правилами формирования полей компоновки.
//                                                               Например, для указания отбора по реквизиту документа
//                                                               "Организация", будет использовано поле
//                                                               "Ссылка.Организация".
//
// Возвращаемое значение: 
//     Строка - описание отбора.
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	
	Если Параметры.ИспользоватьПериодОтбора Тогда
		Если ЗначениеЗаполнено(Параметры.ПериодОтбора) Тогда
			ОписаниеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'за период: %1'"), НРег(Параметры.ПериодОтбора));
		Иначе
			ДатаНачалаВыгрузки = Получатель.ДатаНачалаВыгрузкиДокументов;
			Если ЗначениеЗаполнено(ДатаНачалаВыгрузки) Тогда
				ОписаниеПериода = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'начиная с даты начала отправки документов: %1'"), Формат(ДатаНачалаВыгрузки, "ДЛФ=DD"));
			Иначе
				ОписаниеПериода = НСтр("ru = 'за весь период учета'");
			КонецЕсли;
		КонецЕсли;
	Иначе
		ОписаниеПериода = "";
	КонецЕсли;
	
	СписокОрганизаций = ОрганизацииОтбораИнтерактивнойВыгрузки(Параметры.Отбор);
	Если СписокОрганизаций.Количество()=0 Тогда
		ОписаниеОтбораОрганизации = НСтр("ru = 'по всем организациям'");
	Иначе
		ОписаниеОтбораОрганизации = "";
		Для Каждого Элемент Из СписокОрганизаций Цикл
			ОписаниеОтбораОрганизации = ОписаниеОтбораОрганизации+ ", " + Элемент.Представление;
		КонецЦикла;
		ОписаниеОтбораОрганизации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'по организациям: %1'"), СокрЛП(Сред(ОписаниеОтбораОрганизации, 2)));
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Будут отправлены все документы %1,
		         |%2'"),
		ОписаниеПериода,  ОписаниеОтбораОрганизации);
КонецФункции

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Параметры:
//   Получатель - ПланОбменаСсылка - узел, для которого производится настройка.
//   Параметры  - см. ОбменДаннымиСервер.ОписаниеСтандартныхВариантовДополненияВыгрузки
//
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	ВариантНастройки = "";
	Если ЗначениеЗаполнено(Получатель) 
		И ОбщегоНазначения.СсылкаСуществует(Получатель) Тогда
		ВариантНастройки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель, "ВариантНастройки");
	КонецЕсли;
	
	Если Получатель.РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать
		И Получатель.РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		
		Параметры.ВариантВсеДокументы.Использование      = Ложь;
		Параметры.ВариантБезДополнения.Использование     = Ложь;
		Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
		Параметры.ВариантДополнительно.Использование     = Ложь;
	ИначеЕсли ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСКассой()
		Или ВариантНастройки = ПланыОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.ИдентификаторОбменаСМобильнойКассой() Тогда
		
		// Для 1С:Кассы проводим синхронизацию в тихом режиме, без дополнительных сценариев.
		Параметры.ВариантВсеДокументы.Использование      = Ложь;
		Параметры.ВариантБезДополнения.Использование     = Ложь;
		Параметры.ВариантПроизвольныйОтбор.Использование = Ложь;
		Параметры.ВариантДополнительно.Использование     = Ложь;
		
	Иначе
		
		//Отключаем вариант "ВариантВсеДокументы"
		
		Параметры.ВариантВсеДокументы.Использование      = Ложь;
		
		//Настраиваем вариант "Без дополнения" 
		Параметры.ВариантБезДополнения.Использование = Истина;
		Параметры.ВариантБезДополнения.Порядок       = 3;
		Параметры.ВариантБезДополнения.Заголовок     = НСтр("ru = 'Не добавлять документы к отправке'") 
			+ Символы.ПС 
			+ "Отправлять только нормативно-справочную информацию, измененную с момента последней отправки.";
		
		//Настраиваем вариант "Произвольный отбор" 
		Параметры.ВариантПроизвольныйОтбор.Использование = Истина;
		Параметры.ВариантПроизвольныйОтбор.Порядок       = 2;
		
		Если Получатель.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
			Параметры.ВариантПроизвольныйОтбор.Заголовок = НСтр("ru = 'Добавить справочники'");
		Иначе
			Параметры.ВариантПроизвольныйОтбор.Заголовок = НСтр("ru = 'Добавить произвольные справочники и документы'");
		КонецЕсли;
		
		Если Не Получатель.ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
			// Вычисляем и устанавливаем параметры сценария
			ПараметрыПоУмолчанию = ПараметрыВыгрузкиПоУмолчанию(Получатель);
			
			// Настраиваем вариант "Дополнительно" по сценарию узла
			Параметры.ВариантДополнительно.Использование            = Истина;
			Параметры.ВариантДополнительно.Порядок                  = 1;
			Параметры.ВариантДополнительно.Заголовок                = НСтр("ru='Отправить все документы'");
			Параметры.ВариантДополнительно.ИмяФормыОтбора           = "ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Форма.НастройкаВыгрузки";
			
			Параметры.ВариантДополнительно.ЗаголовокКомандыФормы    = НСтр("ru='Выбрать организации для отбора'");
			Параметры.ВариантДополнительно.ИспользоватьПериодОтбора = Истина;
			Параметры.ВариантДополнительно.ПериодОтбора             = ПараметрыПоУмолчанию.Период;
			
			// Добавляем строка настройки отбора 
			СтрокаОтбора = Параметры.ВариантДополнительно.Отбор.Добавить();
			СтрокаОтбора.ПолноеИмяМетаданных = "ВсеДокументы";
			СтрокаОтбора.ВыборПериода = Истина;
			СтрокаОтбора.Период       = ПараметрыПоУмолчанию.Период;
			СтрокаОтбора.Отбор        = ПараметрыПоУмолчанию.Отбор;
		Иначе
			Параметры.ВариантДополнительно.Использование            = Ложь;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбменДанными

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Расчет параметров выгрузки по умолчанию.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - узел, для которого производится настройка.
//
// Возвращаемое значение - Структура:
//     ПредставлениеОтбора - Строка - текстовое описание отбора по умолчанию.
//     Период              - СтандартныйПериод     - значение периода общего отбора по умолчанию.
//     Отбор               - ОтборКомпоновкиДанных - отбор.
//
Функция ПараметрыВыгрузкиПоУмолчанию(Получатель)
	
	Результат = Новый Структура;
	
	// Период по умолчанию
	Результат.Вставить("Период", Новый СтандартныйПериод);
	Результат.Период.Вариант = ВариантСтандартногоПериода.ПрошлыйМесяц;
	
	// Отбор по умолчанию и его представление.
	КомпоновщикОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	Результат.Вставить("Отбор", КомпоновщикОтбора.Настройки.Отбор);
	
	ОтборПоОрганизации = Результат.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборПоОрганизации.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ссылка.Организация");
	ОтборПоОрганизации.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборПоОрганизации.Использование  = Истина;
	ОтборПоОрганизации.ПравоеЗначение = Новый Массив;
	
	// Элементы, предлагаемые первый раз по умолчанию, считываем из настроек узла.
	Если Получатель.ИспользоватьОтборПоОрганизациям Тогда
		// Организации из табличной части.
		ЗапросИсточника = Новый Запрос("
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОрганизацииПланаОбмена.Организация              КАК Организация,
			|	ОрганизацииПланаОбмена.Организация.Наименование КАК Наименование
			|ИЗ
			|	ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Организации КАК ОрганизацииПланаОбмена
			|ГДЕ
			|	ОрганизацииПланаОбмена.Ссылка = &Получатель
			|");
		ЗапросИсточника.УстановитьПараметр("Получатель", Получатель);
	Иначе
		// Все доступные организации
		ЗапросИсточника = Новый Запрос("
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Организации.Ссылка       КАК Организация,
			|	Организации.Наименование КАК Наименование
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	НЕ Организации.ПометкаУдаления
			|");
	КонецЕсли;
		
	ОтборПоОрганизацииСтрокой = "";
	Выборка = ЗапросИсточника.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ФильтрОрганизации = ОтборПоОрганизации.ПравоеЗначение; // Массив из СправочникСсылка.Организации
		ФильтрОрганизации.Добавить(Выборка.Организация);
		ОтборПоОрганизацииСтрокой = ОтборПоОрганизацииСтрокой + ", " + Выборка.Наименование;
	КонецЦикла;
	ОтборПоОрганизацииСтрокой = СокрЛП(Сред(ОтборПоОрганизацииСтрокой, 2));
	
	// Общее представление, период не включаем, так как в этом сценарии поле периода будет редактироваться отдельно.
	Результат.Вставить("ПредставлениеОтбора", СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Будут отправлены все документы по организациям:
		         |%1'"),
		ОтборПоОрганизацииСтрокой));
	
	Возврат Результат;
КонецФункции

// Добавляет в список организаций выбранную коллекцию.
//
// Параметры:
//     Список      - СписокЗначений - дополняемый список.
//     Организации - Массив из СправочникСсылка.Организации
// 
Процедура ДобавитьСписокОрганизаций(Список, Знач Организации)
	Для Каждого Организация Из Организации Цикл
		
		Если ТипЗнч(Организация) = Тип("Массив") Тогда
			ДобавитьСписокОрганизаций(Список, Организация);
			Продолжить;
		КонецЕсли;
		
		Если Список.НайтиПоЗначению(Организация) = Неопределено Тогда
			Список.Добавить(Организация, Организация.Наименование);
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбменСКассой

Функция ИдентификаторОбменаСКассой() Экспорт
	Возврат "ОбменКассаБухгалтерия";
КонецФункции

Функция ИдентификаторОбменаСМобильнойКассой() Экспорт
	Возврат "ОбменМК";
КонецФункции

Функция РозничныеСкладыПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Склады.ТипЦенРозничнойТорговли,
	|	Склады.Ссылка КАК Склад
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	//|	Склады.ТипСклада = ЗНАЧЕНИЕ(Перечисление.ТипыСкладов.РозничныйМагазин)
	|	Склады.ПометкаУдаления = ЛОЖЬ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	РозничныеСклады = НовыйОписаниеСкладов();
	
	ТипЦены = Неопределено;
	Пока Выборка.Следующий() Цикл
		
		Если ТипЦены <> Неопределено
			И ТипЦены <> Выборка.ТипЦенРозничнойТорговли Тогда
			// Есть склад с другим типом цены
			Возврат НовыйОписаниеСкладов();
		КонецЕсли;
		
		ТипЦены = Выборка.ТипЦенРозничнойТорговли;
		
		РозничныеСклады.Склады.Добавить(Выборка.Склад);
		РозничныеСклады.ТипЦенДляИзмененияЦен = ТипЦены;
		
	КонецЦикла;
	
	Возврат РозничныеСклады;
	
КонецФункции

Функция НовыйОписаниеСкладов()
	
	ОписаниеСкладов = Новый Структура;
	ОписаниеСкладов.Вставить("Склады", Новый Массив);
	ОписаниеСкладов.Вставить("ТипЦенДляИзмененияЦен", Справочники.ТипыЦенНоменклатуры.ПустаяСсылка());
	Возврат ОписаниеСкладов;
	
КонецФункции

#КонецОбласти

#КонецЕсли