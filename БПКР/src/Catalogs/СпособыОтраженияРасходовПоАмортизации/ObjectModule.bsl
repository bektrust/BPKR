#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Предварительный контроль
	ВыполнитьПредварительныйКонтроль(Отказ);
	
	Если Способы.Итог("Коэффициент") > 0 
		И НЕ Способы.Итог("Коэффициент") = 1 Тогда
		ТекстСообщения = НСтр("ru = 'Сумма коэффициентов должна быть равна 1.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,,,Отказ)		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;		
	КонецЕсли;

	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;	
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВременнаяТаблицаСпособы.НомерСтроки,
		|	ВременнаяТаблицаСпособы.СчетЗатрат,
		|	ВременнаяТаблицаСпособы.Субконто1,
		|	ВременнаяТаблицаСпособы.Субконто2,
		|	ВременнаяТаблицаСпособы.Субконто3
		|ПОМЕСТИТЬ ВременнаяТаблицаСпособы
		|ИЗ
		|	&ВременнаяТаблицаСпособы КАК ВременнаяТаблицаСпособы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТаблицаСпособыДублиСтрок.НомерСтроки) КАК НомерСтроки,
		|	ТаблицаСпособыДублиСтрок.СчетЗатрат,
		|	ТаблицаСпособыДублиСтрок.Субконто1,
		|	ТаблицаСпособыДублиСтрок.Субконто2,
		|	ТаблицаСпособыДублиСтрок.Субконто3
		|ИЗ
		|	ВременнаяТаблицаСпособы КАК ВременнаяТаблицаСпособы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаСпособы КАК ТаблицаСпособыДублиСтрок
		|		ПО ВременнаяТаблицаСпособы.НомерСтроки <> ТаблицаСпособыДублиСтрок.НомерСтроки
		|			И ВременнаяТаблицаСпособы.СчетЗатрат = ТаблицаСпособыДублиСтрок.СчетЗатрат
		|			И ВременнаяТаблицаСпособы.Субконто1 = ТаблицаСпособыДублиСтрок.Субконто1
		|			И ВременнаяТаблицаСпособы.Субконто2 = ТаблицаСпособыДублиСтрок.Субконто2
		|			И ВременнаяТаблицаСпособы.Субконто3 = ТаблицаСпособыДублиСтрок.Субконто3
		|
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаСпособыДублиСтрок.СчетЗатрат,
		|	ТаблицаСпособыДублиСтрок.Субконто1,
		|	ТаблицаСпособыДублиСтрок.Субконто2,
		|	ТаблицаСпособыДублиСтрок.Субконто3
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
	Запрос.УстановитьПараметр("ВременнаяТаблицаСпособы", Способы.Выгрузить());
	РезультатЗапроса = Запрос.Выполнить();
	
	МассивРезультатов = Запрос.ВыполнитьПакет();		
	
	// Дубли строк.
	Если НЕ МассивРезультатов[1].Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Строка %1 с данными счетом и субконто уже создана.'"), 
							ВыборкаИзРезультатаЗапроса.НомерСтроки);
			БухгалтерскийУчетСервер.СообщитьОбОшибке(
				ЭтотОбъект,
				ТекстСообщения,
				"Способы",
				ВыборкаИзРезультатаЗапроса.НомерСтроки,
				"НомерСтроки",
				Отказ);
		КонецЦикла;
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли