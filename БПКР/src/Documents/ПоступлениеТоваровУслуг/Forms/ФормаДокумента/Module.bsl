
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокумент(Команда)
	
	СтрокаТаблицы = Элементы.СписокВидовОпераций.ТекущиеДанные;
	
	Если НЕ СтрокаТаблицы = Неопределено Тогда
		
		ОткрытьДокументВида(СтрокаТаблицы.Значение);
		
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	Если Параметры.Свойство("ЗначениеКопирования") Тогда
		ЗначениеКопирования = Параметры.ЗначениеКопирования;
	КонецЕсли;
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения  = Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	Если Параметры.Свойство("Основание") Тогда
		Основание           = Параметры.Основание;
	КонецЕсли;
	Если Параметры.Свойство("Ключ") Тогда
		Ключ           		= Параметры.Ключ;
	КонецЕсли;
	Если Параметры.Свойство("ИзменитьВидОперации") Тогда
		ИзменитьВидОперации = Истина;
	КонецЕсли;
	
	ФормыДокумента   = Новый ФиксированноеСоответствие(
		Документы.ПоступлениеТоваровУслуг.ПолучитьСоответствиеВидовОперацийФормам());
		
	ВидыОпераций = ПолучитьСписокВидовОпераций();
	Для Каждого ВидОперации Из ВидыОпераций Цикл
		НоваяОперация = СписокВидовОпераций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяОперация, ВидОперации);
	КонецЦикла;
	
	Если Параметры.Свойство("ВидОперации") Тогда
		ВидОперацииПриОткрытии = Параметры.ВидОперации;
		ВыделенныйЭлементСписка = СписокВидовОпераций.НайтиПоЗначению(ВидОперацииПриОткрытии);
		Если ВыделенныйЭлементСписка <> Неопределено Тогда
			Элементы.СписокВидовОпераций.ТекущаяСтрока = ВыделенныйЭлементСписка.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокВидовОпераций()

	СписокВидовОпераций = Новый СписокЗначений;
	
	ВсеВидыОпераций = Перечисления.ВидыОперацийПоступлениеТоваровУслуг;
	
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.Товары, ВсеВидыОпераций.Товары);
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.Услуги, ВсеВидыОпераций.Услуги);
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.ОсновныеСредства, ВсеВидыОпераций.ОсновныеСредства);
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.Покупка, ВсеВидыОпераций.Покупка);
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.РасходыБудущихПериодов, ВсеВидыОпераций.РасходыБудущихПериодов);
	СписокВидовОпераций.Добавить(ВсеВидыОпераций.ЗакупочныйАкт, ВсеВидыОпераций.ЗакупочныйАкт);
	
	Возврат СписокВидовОпераций;

КонецФункции

&НаКлиенте
Процедура СписокВидовОперацийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтрокаТаблицы = СписокВидовОпераций.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОткрытьДокументВида(СтрокаТаблицы.Значение);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокументВида(ВыбранныйВидОперации)
	
	Если ТипЗнч(ЗначенияЗаполнения) <> Тип("Структура") Тогда
		ЗначенияЗаполнения = Новый Структура();
	КонецЕсли;

	ЗначенияЗаполнения.Вставить("ВидОперации", ВыбранныйВидОперации);
	Если ЗначениеЗаполнено(Основание) Тогда
		ЗначенияЗаполнения.Вставить("Основание", Основание);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ключ",                Ключ);
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СтруктураПараметров.Вставить("ЗначениеКопирования", ЗначениеКопирования);
	КонецЕсли;
	СтруктураПараметров.Вставить("ЗначенияЗаполнения",  ЗначенияЗаполнения);
	
	Если ИзменитьВидОперации И ВыбранныйВидОперации <> ВидОперацииПриОткрытии Тогда
		СтруктураПараметров.Вставить("ИзменитьВидОперации", ИзменитьВидОперации);
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть();
	
	ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма." + ФормыДокумента[ВыбранныйВидОперации], СтруктураПараметров, ВладелецФормы);
	
КонецПроцедуры

#КонецОбласти

