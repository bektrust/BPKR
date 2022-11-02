

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если Копирование Тогда 
		Возврат;
	КонецЕсли;	
	
	Отказ = Истина;
	
	ВопросПодобратьИзСервиса();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПодборИзКлассификатора(Команда)
	ПодобратьИзКлассификатора();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Асинх Процедура ВопросПодобратьИзСервиса()
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать из сервиса.
		|Подобрать?'");
	
	Ответ = Ждать ВопросАсинх(ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30);
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ПодобратьИзКлассификатора();
	Иначе
		ОткрытьФорму("Справочник.ВидыМатериаловСтенНалогНаИмущество.Форма.ФормаЭлемента",, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьИзКлассификатора()
	ОбщегоНазначенияБПКлиент.ОткрытьФормуПодбораИзКлассификатора(
		"ВидыМатериаловСтенНалогНаИмущество", 
		"wallmaterialGetService", 
		НСтр("ru = 'Виды материалов стен (налог на имущество)'"), 
		ЭтаФорма,
		,
		,
		"Справочники.ВидыМатериаловСтенНалогНаИмущество.ЗаполнитьСтавкиВидовМатериаловСтен");
КонецПроцедуры

#КонецОбласти
