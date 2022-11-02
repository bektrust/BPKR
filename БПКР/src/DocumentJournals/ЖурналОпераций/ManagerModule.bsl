#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список документов, которые регистрируются в журнале.
//
// Возвращаемое значение:
//   Массив      - доступные объекты метаданных.
//
Функция СоставДокументов() Экспорт

	СписокДокументов = Новый Массив;
	
	ДокументыЖурнала = Метаданные.ЖурналыДокументов.ЖурналОпераций.РегистрируемыеДокументы;
	
	Для Каждого РегистрируемыйДокумент Из ДокументыЖурнала Цикл
			
		Если ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(РегистрируемыйДокумент) Тогда
			СписокДокументов.Добавить(РегистрируемыйДокумент);
		КонецЕсли;
			
	КонецЦикла;
	
	Возврат СписокДокументов;
	
КонецФункции

// Возвращает дату первого проведенного документа
//
// Параметры:
// Организация - СправочникСсылка.Организация
//
// Возвращаемое значение:
// Дата или Неопределено, если нет ни одного проведенного документа
//
Функция ДатаПервогоПроведенногоДокумента(Организация) Экспорт
	
	ДоступныеОрганизации = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(ложь);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		
		Если ДоступныеОрганизации.Найти(Организация) = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ДоступныеОрганизации = Новый Массив;
		ДоступныеОрганизации.Добавить(Организация);
		
	КонецЕсли;
	
	ДатаПервогоДокумента = Неопределено;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ДоступнаяОрганизация Из ДоступныеОрганизации Цикл
		
		ДатаПервогоДокументаОрганизации = ДатаПервогоПроведенногоДокументаОрганизации(ДоступнаяОрганизация);
		Если Не ЗначениеЗаполнено(ДатаПервогоДокументаОрганизации) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ДатаПервогоДокумента = Неопределено
			Или ДатаПервогоДокументаОрганизации < ДатаПервогоДокумента Тогда
			ДатаПервогоДокумента = ДатаПервогоДокументаОрганизации;
		КонецЕсли;
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ДатаПервогоДокумента;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Реестр";
	КомандаПечати.Представление = НСтр("ru = 'Реестр документов'");
	КомандаПечати.ЗаголовокФормы= НСтр("ru = 'Реестр документов'");
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм    = "ФормаСписка";
	КомандаПечати.Порядок       = 100;
	
КонецПроцедуры

Функция ДатаПервогоПроведенногоДокументаОрганизации(Организация)
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЖурналОпераций.Дата КАК Дата
		|ИЗ
		|	ЖурналДокументов.ЖурналОпераций КАК ЖурналОпераций
		|ГДЕ
		|	ЖурналОпераций.Организация = &Организация
		|	И ЖурналОпераций.Проведен
		|	И НЕ ЖурналОпераций.Ссылка ССЫЛКА Документ.ВводНачальныхОстатков
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЖурналОпераций.Дата";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Дата;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли