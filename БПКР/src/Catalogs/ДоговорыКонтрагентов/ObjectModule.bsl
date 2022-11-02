#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

// Процедура - обработчик события ОбработкаЗаполнения объекта.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда 
		Если ДанныеЗаполнения.Свойство("Организация") Тогда 
			Организация = ДанныеЗаполнения.Организация;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда 		
		Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	ВалютаРасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Контрагенты") Тогда
		// Программное заполнение по методу Заполнить()
		СтандартнаяОбработка = Ложь;
		
		Владелец = ДанныеЗаполнения;
		ВидДоговора = ?(ЗначениеЗаполнено(ДанныеЗаполнения.ВидОсновногоДоговора), ДанныеЗаполнения.ВидОсновногоДоговора, Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
		
		ВалютаРасчетов = ДанныеЗаполнения.ВалютаДоговора;
		
		Если ДанныеЗаполнения.ВидОсновногоДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда  
			СуммаВключаетНалоги = Истина;
		КонецЕсли;
		
		КодПоставкиНДС = Справочники.КодыПоставокНДС.НайтиПоКоду("100"); // Облагаемые по ставке 12 процентов.		
		СтавкаНДС = Справочники.СтавкиНДС.Стандарт;
	КонецЕсли;
	
	Наименование = Справочники.ДоговорыКонтрагентов.НаименованиеДоговора(ВалютаРасчетов);
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком
		Или ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее Тогда	
		МассивНепроверяемыхРеквизитов.Добавить("СтавкаНДС");		
	КонецЕсли;
	
	ОбщегоНазначенияБПСервер.ДобавитьНепроверяемыеРеквизитыПоПараметрамФункциональныхОпций(МассивНепроверяемыхРеквизитов, Организация, ТекущаяДатаСеанса());
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);	
	
	// Предварительный контроль.
	ВыполнитьПредварительныйКонтроль(Отказ);	
КонецПроцедуры

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Предварительная очистка.
	Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком
		Или ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее Тогда	
		СтавкаНДС = Справочники.СтавкиНДС.ПустаяСсылка();
		ТипЦен = Справочники.ТипыЦенНоменклатуры.ПустаяСсылка();
		КодПоставкиНДС = Справочники.КодыПоставокНДС.ПустаяСсылка();
		СуммаВключаетНалоги = Ложь;
	КонецЕсли;
	
	Если ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.Прочее Тогда 
		УстановленСрокОплаты = Ложь;
		СрокОплаты = 0;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТипЦен) Тогда 
		СуммаВключаетНалоги = ТипЦен.ЦенаВключаетНалоги;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ВалютаРасчетов) Тогда 
		ВалютаРасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	КонецЕсли;	
КонецПроцедуры

// Процедура - обработчик события ПриЗаписи.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Если текущий договор был ранее назначен основным,
	// но изменился вид договора- очищаем запись.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОсновныеДоговорыКонтрагента.ВидДоговора КАК ВидДоговора
		|ИЗ
		|	РегистрСведений.ОсновныеДоговорыКонтрагента КАК ОсновныеДоговорыКонтрагента
		|ГДЕ
		|	ОсновныеДоговорыКонтрагента.Организация = &Организация
		|	И ОсновныеДоговорыКонтрагента.Контрагент = &Контрагент
		|	И ОсновныеДоговорыКонтрагента.Договор = &Договор
		|	И НЕ ОсновныеДоговорыКонтрагента.ВидДоговора = &ВидДоговора";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Владелец);
	Запрос.УстановитьПараметр("Договор", Ссылка);
	Запрос.УстановитьПараметр("ВидДоговора", ВидДоговора);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		НаборЗаписей = РегистрыСведений.ОсновныеДоговорыКонтрагента.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Организация);
		НаборЗаписей.Отбор.ВидДоговора.Установить(ВыборкаДетальныеЗаписи.ВидДоговора);
		НаборЗаписей.Отбор.Контрагент.Установить(Владелец);
		НаборЗаписей.Прочитать();
		НаборЗаписей.Очистить();
		
		Попытка
			НаборЗаписей.Записать(Истина);
		Исключение
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить очистку записей регистра сведений ""Основные договоры контрагента"" по причине: %1'"), 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		КонецПопытки;
	КонецЕсли;	
	
	// Установка основного договора по указанному виду договора,
	// если по установленному виду договора нет записей.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОсновныеДоговорыКонтрагента.Договор КАК Договор
		|ИЗ
		|	РегистрСведений.ОсновныеДоговорыКонтрагента КАК ОсновныеДоговорыКонтрагента
		|ГДЕ
		|	ОсновныеДоговорыКонтрагента.Организация = &Организация
		|	И ОсновныеДоговорыКонтрагента.Контрагент = &Контрагент
		|	И ОсновныеДоговорыКонтрагента.ВидДоговора = &ВидДоговора
		|	И НЕ ОсновныеДоговорыКонтрагента.Договор = &Договор";
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Владелец);
	Запрос.УстановитьПараметр("ВидДоговора", ВидДоговора);
	Запрос.УстановитьПараметр("Договор", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		МенеджерЗаписи = РегистрыСведений.ОсновныеДоговорыКонтрагента.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Организация = Организация;
		МенеджерЗаписи.Контрагент = Владелец;
		МенеджерЗаписи.ВидДоговора = ВидДоговора;
		МенеджерЗаписи.Договор = Ссылка;
		
		Попытка
			МенеджерЗаписи.Записать();
		Исключение
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось завершить установку основного договора по причине: %1'"), 
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Ошибка'"), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		КонецПопытки;
	КонецЕсли;	
	
КонецПроцедуры // ПриЗаписи()

// Процедура - обработчик события ПередУдалением.
//
Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ОсновныеДоговорыКонтрагента.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Организация);
	НаборЗаписей.Отбор.ВидДоговора.Установить(ВидДоговора);
	НаборЗаписей.Отбор.Контрагент.Установить(Владелец);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запись = НаборЗаписей[0];
	Если Запись.Договор = Ссылка Тогда
		НаборЗаписей.Очистить();
		НаборЗаписей.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура выполняет контроль противоречий.
//
Процедура ВыполнитьПредварительныйКонтроль(Отказ)
	
	// Контроль дублей наименования.
	// Не может быть договора с одинаковым Владельцем, Видом договора и Наименованием.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ДоговорыКонтрагентов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	НЕ ДоговорыКонтрагентов.ПометкаУдаления
		|	И НЕ ДоговорыКонтрагентов.Ссылка = &Ссылка
		|	И ДоговорыКонтрагентов.Владелец = &Владелец
		|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора
		|	И ДоговорыКонтрагентов.Наименование = &Наименование"); 
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Параметры.Вставить("Владелец", Владелец);
	Запрос.Параметры.Вставить("ВидДоговора", ВидДоговора);
	Запрос.Параметры.Вставить("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда  
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "КОРРЕКТНОСТЬ", НСтр("ru = 'Наименование'"),,,
			НСтр("ru = 'У Контрагента существует договор с таким же Видом договора и Наименованием. Введите другое Наименование.'"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "Объект.Наименование",,Отказ);		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти


#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли