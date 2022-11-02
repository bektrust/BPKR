#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// КонтрольБазовойВерсии
	Если ВРег(Метаданные.Имя) = ВРег("БухгалтерияДляКыргызстанаБазовая")
		И ЭтоНовый() Тогда
		Запрос = Новый Запрос();
		Запрос.Текст =
			"ВЫБРАТЬ
			|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Организации.Ссылка) КАК КоличествоОрганизаций
			|ИЗ
			|	Справочник.Организации КАК Организации";
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			Если Выборка.КоличествоОрганизаций >= 1 Тогда
				Отказ = Истина;
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Ограничение базовой версии. В информационной базе может быть введена только одна организация.'"));
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	// Конец КонтрольБазовойВерсии
	
	// 1. Действия, выполняемые всегда, в том числе и при обмене данными
	
	Если ЭтоНовый() Тогда
		
		// Свойство "Ссылка" заведомо не заполнено.
		// Но в ходе обмена ссылка может быть передана.
		
		СсылкаНового = ПолучитьСсылкуНового();
		Если СсылкаНового.Пустая() Тогда
			УстановитьСсылкуНового(Справочники.Организации.ПолучитьСсылку());
		КонецЕсли;
		
	КонецЕсли;
	
	// Не выполнять дальнейшие действия при обмене данными
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// 2. Дальнейшие действия не выполняются в случае, когда запись инициирована механизмом обмена данными
	
	// Проверим возможность внесения изменений
	Если ЭтоНовый() И Не ПолучитьФункциональнуюОпцию("УчетПоНесколькимОрганизациям") Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'В программе отключен учет по нескольким организациям.'"));
		Отказ = Истина;
	КонецЕсли;
	
	// Не выполнять дальнейшие действия при отказе в записи
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(Ссылка) И ЗначениеЗаполнено(КонтрагентГНС) Тогда
		ТекстСообщения = НСтр("ru = 'Новая организация записывается без указания контрагета, затем ему можно будет указать.'");
		БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "Объект.КонтрагентГНС", Отказ);
		
	ИначеЕсли ЗначениеЗаполнено(КонтрагентГНС) Тогда	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ОсновныеДоговорыКонтрагента.Договор КАК Договор
			|ИЗ
			|	РегистрСведений.ОсновныеДоговорыКонтрагента КАК ОсновныеДоговорыКонтрагента
			|ГДЕ
			|	ОсновныеДоговорыКонтрагента.Организация = &Ссылка
			|	И ОсновныеДоговорыКонтрагента.Контрагент = &Контрагент
			|	И ОсновныеДоговорыКонтрагента.ВидДоговора = ЗНАЧЕНИЕ(Перечисление.ВидыДоговоровКонтрагентов.Прочее)";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Контрагент", КонтрагентГНС);
		
		НетДоговора = Запрос.Выполнить().Пустой();
		
		Если НетДоговора Тогда
			ТекстСообщения = НСтр("ru = 'У контрагента ГНС нет основного договора с видом ""Прочее"".'");
			БухгалтерскийУчетСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,, "Объект.КонтрагентГНС", Отказ);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли