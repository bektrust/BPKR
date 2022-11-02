#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	// Выделение основного элемента	
	БухгалтерскийУчетСервер.ВыделитьЖирнымОсновнойЭлемент(БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойСклад"), Список);
	Список.Параметры.УстановитьЗначениеПараметра("ОсновнойСклад", БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнойСклад"));

	// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Склады);
	Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = МожноРедактировать;
	// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьКакОсновной(Команда)
		
	ВыбранныйЭлемент = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ВыбранныйЭлемент)
		И ВыбранныйЭлемент <> БухгалтерскийУчетВызовСервера.ПолучитьЗначениеПоУмолчанию("ОсновнойСклад") Тогда
		ИспользоватьКакОсновнойНаСервере(ВыбранныйЭлемент);	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИспользоватьКакОсновнойНаСервере(ВыбранныйЭлемент)
	
	ОбновитьПовторноИспользуемыеЗначения();
	ОбщегоНазначенияБПСервер.УстановитьЗначениеПоУмолчанию("ОсновнойСклад", ВыбранныйЭлемент);
	БухгалтерскийУчетСервер.ВыделитьЖирнымОсновнойЭлемент(ВыбранныйЭлемент, Список);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов
&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

#КонецОбласти
